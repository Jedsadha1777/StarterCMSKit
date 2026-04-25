import json
from datetime import datetime
from flask import request, jsonify, send_file, g
from flask_jwt_extended import jwt_required
from admin_api import admin_bp
from extensions import db
from sqlalchemy.orm import joinedload
from models import Customer, ImportHistory
from decorators import admin_required, company_required
from utils import paginate_query, apply_filters, apply_sorting, format_paginated, load_schema, get_or_404_scoped, check_unique
from schemas import CustomerCreateSchema, CustomerUpdateSchema, CustomerResponseSchema, ImportHistoryResponseSchema
from services.import_export import parse_excel, validate_row, export_to_excel, save_import_history, get_history_or_404
from config import IMPORT_DIR
import os

RESOURCE_TYPE = 'customers'
EXPORT_COLUMNS = ['customer_id', 'name', 'address', 'tel', 'fax', 'created_by_name', 'created_at', 'updated_at']
IMPORT_COLUMNS = ['customer_id', 'name', 'address', 'tel', 'fax']
REQUIRED_COLUMNS = ['customer_id', 'name']
COMPARE_FIELDS = ['customer_id', 'name', 'address', 'tel', 'fax']


# ── CRUD ──

@admin_bp.route('/customers', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def get_customers(admin):
    query = Customer.query.options(joinedload(Customer.creator)).filter(Customer.company_id == g.active_company.id)

    filters = {
        'customer_id': {'type': 'fuzzy'},
        'name': {'type': 'fuzzy'},
        'address': {'type': 'fuzzy'},
        'created_at': {'type': 'range', 'cast': lambda x: datetime.fromisoformat(x)},
    }

    query = apply_filters(query, Customer, filters, search_logic='AND')
    query = apply_sorting(query, Customer, sortable_fields=['customer_id', 'name', 'created_at', 'updated_at'], default_sort='-created_at')
    result = paginate_query(query, default_per_page=10)

    return format_paginated('customers', result, schema=CustomerResponseSchema())


@admin_bp.route('/customers', methods=['POST'])
@jwt_required()
@admin_required
@company_required
def create_customer(admin):
    if not admin.has_permission('customers', 'create'):
        return jsonify({'message': 'Permission denied'}), 403

    current_count = Customer.query.filter(Customer.company_id == g.active_company.id).count()
    if not admin.check_limit('customers', current_count):
        return jsonify({'message': 'Customer limit reached for your package'}), 403

    data, err = load_schema(CustomerCreateSchema)
    if err: return err

    err = check_unique(Customer, 'customer_id', data['customer_id'], company_id=g.active_company.id)
    if err: return err

    customer = Customer(
        customer_id=data['customer_id'],
        name=data['name'],
        address=data.get('address', ''),
        tel=data.get('tel', ''),
        fax=data.get('fax', ''),
        company_id=g.active_company.id,
        created_by=admin.id,
    )

    db.session.add(customer)
    db.session.commit()

    return jsonify(CustomerResponseSchema().dump(customer)), 201


@admin_bp.route('/customers/<customer_public_id>', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def get_customer(admin, customer_public_id):
    customer, err = get_or_404_scoped(Customer, customer_public_id, g.active_company)
    if err: return err
    return jsonify(CustomerResponseSchema().dump(customer)), 200


@admin_bp.route('/customers/<customer_public_id>', methods=['PUT'])
@jwt_required()
@admin_required
@company_required
def update_customer(admin, customer_public_id):
    if not admin.has_permission('customers', 'edit'):
        return jsonify({'message': 'Permission denied'}), 403

    customer, err = get_or_404_scoped(Customer, customer_public_id, g.active_company)
    if err: return err

    data, err = load_schema(CustomerUpdateSchema)
    if err: return err

    if data.get('customer_id'):
        err = check_unique(Customer, 'customer_id', data['customer_id'], exclude_id=customer.id, company_id=g.active_company.id)
        if err: return err
        customer.customer_id = data['customer_id']

    if data.get('name'):
        customer.name = data['name']

    if 'address' in data:
        customer.address = data['address']

    if 'tel' in data:
        customer.tel = data['tel']

    if 'fax' in data:
        customer.fax = data['fax']

    db.session.commit()

    return jsonify(CustomerResponseSchema().dump(customer)), 200


@admin_bp.route('/customers/<customer_public_id>', methods=['DELETE'])
@jwt_required()
@admin_required
@company_required
def delete_customer(admin, customer_public_id):
    if not admin.has_permission('customers', 'delete'):
        return jsonify({'message': 'Permission denied'}), 403

    customer, err = get_or_404_scoped(Customer, customer_public_id, g.active_company)
    if err: return err

    db.session.delete(customer)
    db.session.commit()

    return jsonify({'message': 'Customer deleted successfully'}), 200


# ── Export ──

@admin_bp.route('/customers/export', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def export_customers(admin):
    items = Customer.query.options(joinedload(Customer.creator)) \
        .filter(Customer.company_id == g.active_company.id) \
        .order_by(Customer.created_at.desc()).all()

    def row_mapper(c):
        return [
            c.customer_id, c.name, c.address or '', c.tel or '', c.fax or '',
            c.creator.name if c.creator else '',
            c.created_at.isoformat() if c.created_at else '',
            c.updated_at.isoformat() if c.updated_at else '',
        ]

    return export_to_excel(items, EXPORT_COLUMNS, row_mapper, 'Customers', 'customers.xlsx')


# ── Import ──

@admin_bp.route('/customers/import/preview', methods=['POST'])
@jwt_required()
@admin_required
@company_required
def import_preview(admin):
    if not admin.has_permission('customers', 'create') or not admin.has_permission('customers', 'edit'):
        return jsonify({'message': 'Permission denied'}), 403

    file = request.files.get('file')
    if not file or not file.filename:
        return jsonify({'message': 'No file provided'}), 400

    rows, err = parse_excel(file, REQUIRED_COLUMNS, IMPORT_COLUMNS)
    if err:
        return jsonify({'message': err}), 400

    customer_ids = [r['customer_id'] for r in rows if r.get('customer_id')]
    existing = Customer.query.filter(Customer.customer_id.in_(customer_ids), Customer.company_id == g.active_company.id).all() if customer_ids else []
    existing_map = {c.customer_id: c for c in existing}

    preview_rows = []
    summary = {'total': len(rows), 'new': 0, 'replace': 0, 'unchanged': 0, 'error': 0}

    for data in rows:
        status, errors, ex = validate_row(data, existing_map, 'customer_id', REQUIRED_COLUMNS, COMPARE_FIELDS)
        summary[status] += 1

        row_result = {
            'row': data['_row'],
            'customer_id': data.get('customer_id', ''),
            'name': data.get('name', ''),
            'address': data.get('address', ''),
            'tel': data.get('tel', ''),
            'fax': data.get('fax', ''),
            'status': status,
            'errors': errors,
        }
        if status == 'replace' and ex:
            row_result['existing'] = {
                'name': ex.name,
                'address': ex.address or '',
                'tel': ex.tel or '',
                'fax': ex.fax or '',
            }
        preview_rows.append(row_result)

    return jsonify({'rows': preview_rows, 'summary': summary}), 200


@admin_bp.route('/customers/import/confirm', methods=['POST'])
@jwt_required()
@admin_required
@company_required
def import_confirm(admin):
    if not admin.has_permission('customers', 'create') or not admin.has_permission('customers', 'edit'):
        return jsonify({'message': 'Permission denied'}), 403

    file = request.files.get('file')
    data = request.form.get('rows')
    if not data:
        return jsonify({'message': 'No rows provided'}), 400

    try:
        selected_rows = json.loads(data)
    except (json.JSONDecodeError, TypeError):
        return jsonify({'message': 'Invalid rows data'}), 400

    if not selected_rows:
        return jsonify({'message': 'No rows selected'}), 400

    customer_ids = [r['customer_id'] for r in selected_rows]
    existing = Customer.query.filter(Customer.customer_id.in_(customer_ids), Customer.company_id == g.active_company.id).all()
    existing_map = {c.customer_id: c for c in existing}

    created = 0
    updated = 0

    for row in selected_rows:
        ex = existing_map.get(row['customer_id'])
        if ex:
            ex.name = row['name']
            ex.address = row.get('address', '')
            ex.tel = row.get('tel', '')
            ex.fax = row.get('fax', '')
            updated += 1
        else:
            db.session.add(Customer(
                customer_id=row['customer_id'], name=row['name'],
                address=row.get('address', ''), tel=row.get('tel', ''), fax=row.get('fax', ''),
                company_id=g.active_company.id, created_by=admin.id,
            ))
            created += 1

    save_import_history(file, RESOURCE_TYPE, g.active_company.id, admin.id)
    db.session.commit()

    return jsonify({'created': created, 'updated': updated}), 200


# ── Import History ──

@admin_bp.route('/customers/import/history', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def get_import_history(admin):
    query = ImportHistory.query.options(joinedload(ImportHistory.importer)) \
        .filter(ImportHistory.company_id == g.active_company.id, ImportHistory.resource_type == RESOURCE_TYPE) \
        .order_by(ImportHistory.created_at.desc())
    result = paginate_query(query, default_per_page=10)
    return format_paginated('histories', result, schema=ImportHistoryResponseSchema())


@admin_bp.route('/customers/import/history/<history_id>/download', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def download_import_file(admin, history_id):
    history, err = get_history_or_404(history_id, RESOURCE_TYPE, g.active_company)
    if err: return err

    filepath = os.path.join(IMPORT_DIR, history.stored_filename)
    if not os.path.exists(filepath):
        return jsonify({'message': 'File not found'}), 404

    return send_file(filepath, mimetype='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                     as_attachment=True, download_name=history.original_filename)


@admin_bp.route('/customers/import/history/<history_id>', methods=['DELETE'])
@jwt_required()
@admin_required
@company_required
def delete_import_history(admin, history_id):
    if not admin.has_permission('customers', 'delete'):
        return jsonify({'message': 'Permission denied'}), 403

    history, err = get_history_or_404(history_id, RESOURCE_TYPE, g.active_company)
    if err: return err

    filepath = os.path.join(IMPORT_DIR, history.stored_filename)
    if os.path.exists(filepath):
        os.remove(filepath)

    db.session.delete(history)
    db.session.commit()

    return jsonify({'message': 'Import history deleted successfully'}), 200
