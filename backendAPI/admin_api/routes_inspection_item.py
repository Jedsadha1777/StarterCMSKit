import json
from datetime import datetime
from flask import request, jsonify, send_file, g
from flask_jwt_extended import jwt_required
from admin_api import admin_bp
from extensions import db
from sqlalchemy.orm import joinedload
from models import InspectionItem, ImportHistory
from decorators import admin_required, company_required
from utils import paginate_query, apply_filters, apply_sorting, format_paginated, load_schema, get_or_404_scoped, check_unique
from schemas import InspectionItemCreateSchema, InspectionItemUpdateSchema, InspectionItemResponseSchema, ImportHistoryResponseSchema
from services.import_export import parse_excel, validate_row, export_to_excel, save_import_history, get_history_or_404
from config import IMPORT_DIR
import os

RESOURCE_TYPE = 'inspection_items'
EXPORT_COLUMNS = ['item_code', 'item_name', 'spec', 'created_by_name', 'created_at', 'updated_at']
IMPORT_COLUMNS = ['item_code', 'item_name', 'spec']
REQUIRED_COLUMNS = ['item_code', 'item_name']
COMPARE_FIELDS = ['item_code', 'item_name', 'spec']


# ── CRUD ──

@admin_bp.route('/inspection-items', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def get_inspection_items(admin):
    query = InspectionItem.query.options(joinedload(InspectionItem.creator)).filter(InspectionItem.company_id == g.active_company.id)

    filters = {
        'item_code': {'type': 'fuzzy'},
        'item_name': {'type': 'fuzzy'},
        'spec': {'type': 'fuzzy'},
        'created_at': {'type': 'range', 'cast': lambda x: datetime.fromisoformat(x)},
    }

    query = apply_filters(query, InspectionItem, filters, search_logic='AND')
    query = apply_sorting(query, InspectionItem, sortable_fields=['item_code', 'item_name', 'created_at', 'updated_at'], default_sort='-created_at')
    result = paginate_query(query, default_per_page=10)

    return format_paginated('inspection_items', result, schema=InspectionItemResponseSchema())


@admin_bp.route('/inspection-items', methods=['POST'])
@jwt_required()
@admin_required
@company_required
def create_inspection_item(admin):
    if not admin.has_permission('inspection_items', 'create'):
        return jsonify({'message': 'Permission denied'}), 403

    data, err = load_schema(InspectionItemCreateSchema)
    if err: return err

    err = check_unique(InspectionItem, 'item_code', data['item_code'], company_id=g.active_company.id)
    if err: return err

    item = InspectionItem(
        item_code=data['item_code'],
        item_name=data['item_name'],
        spec=data.get('spec', ''),
        company_id=g.active_company.id,
        created_by=admin.id,
    )

    db.session.add(item)
    db.session.commit()

    return jsonify(InspectionItemResponseSchema().dump(item)), 201


@admin_bp.route('/inspection-items/<item_public_id>', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def get_inspection_item(admin, item_public_id):
    item, err = get_or_404_scoped(InspectionItem, item_public_id, g.active_company)
    if err: return err
    return jsonify(InspectionItemResponseSchema().dump(item)), 200


@admin_bp.route('/inspection-items/<item_public_id>', methods=['PUT'])
@jwt_required()
@admin_required
@company_required
def update_inspection_item(admin, item_public_id):
    if not admin.has_permission('inspection_items', 'edit'):
        return jsonify({'message': 'Permission denied'}), 403

    item, err = get_or_404_scoped(InspectionItem, item_public_id, g.active_company)
    if err: return err

    data, err = load_schema(InspectionItemUpdateSchema)
    if err: return err

    if data.get('item_code'):
        err = check_unique(InspectionItem, 'item_code', data['item_code'], exclude_id=item.id, company_id=g.active_company.id)
        if err: return err
        item.item_code = data['item_code']

    if data.get('item_name'):
        item.item_name = data['item_name']

    if 'spec' in data:
        item.spec = data['spec']

    db.session.commit()

    return jsonify(InspectionItemResponseSchema().dump(item)), 200


@admin_bp.route('/inspection-items/<item_public_id>', methods=['DELETE'])
@jwt_required()
@admin_required
@company_required
def delete_inspection_item(admin, item_public_id):
    if not admin.has_permission('inspection_items', 'delete'):
        return jsonify({'message': 'Permission denied'}), 403

    item, err = get_or_404_scoped(InspectionItem, item_public_id, g.active_company)
    if err: return err

    db.session.delete(item)
    db.session.commit()

    return jsonify({'message': 'Inspection item deleted successfully'}), 200


# ── Export ──

@admin_bp.route('/inspection-items/export', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def export_inspection_items(admin):
    items = InspectionItem.query.options(joinedload(InspectionItem.creator)) \
        .filter(InspectionItem.company_id == g.active_company.id) \
        .order_by(InspectionItem.created_at.desc()).all()

    def row_mapper(item):
        return [
            item.item_code, item.item_name, item.spec or '',
            item.creator.name if item.creator else '',
            item.created_at.isoformat() if item.created_at else '',
            item.updated_at.isoformat() if item.updated_at else '',
        ]

    return export_to_excel(items, EXPORT_COLUMNS, row_mapper, 'Inspection Items', 'inspection_items.xlsx')


# ── Import ──

@admin_bp.route('/inspection-items/import/preview', methods=['POST'])
@jwt_required()
@admin_required
@company_required
def import_inspection_preview(admin):
    if not admin.has_permission('inspection_items', 'create') or not admin.has_permission('inspection_items', 'edit'):
        return jsonify({'message': 'Permission denied'}), 403

    file = request.files.get('file')
    if not file or not file.filename:
        return jsonify({'message': 'No file provided'}), 400

    rows, err = parse_excel(file, REQUIRED_COLUMNS, IMPORT_COLUMNS)
    if err:
        return jsonify({'message': err}), 400

    item_codes = [r['item_code'] for r in rows if r.get('item_code')]
    existing = InspectionItem.query.filter(InspectionItem.item_code.in_(item_codes), InspectionItem.company_id == g.active_company.id).all() if item_codes else []
    existing_map = {i.item_code: i for i in existing}

    preview_rows = []
    summary = {'total': len(rows), 'new': 0, 'replace': 0, 'unchanged': 0, 'error': 0}

    for data in rows:
        status, errors, ex = validate_row(data, existing_map, 'item_code', REQUIRED_COLUMNS, COMPARE_FIELDS)
        summary[status] += 1

        row_result = {
            'row': data['_row'],
            'item_code': data.get('item_code', ''),
            'item_name': data.get('item_name', ''),
            'spec': data.get('spec', ''),
            'status': status,
            'errors': errors,
        }
        if status == 'replace' and ex:
            row_result['existing'] = {'item_name': ex.item_name, 'spec': ex.spec or ''}
        preview_rows.append(row_result)

    return jsonify({'rows': preview_rows, 'summary': summary}), 200


@admin_bp.route('/inspection-items/import/confirm', methods=['POST'])
@jwt_required()
@admin_required
@company_required
def import_inspection_confirm(admin):
    if not admin.has_permission('inspection_items', 'create') or not admin.has_permission('inspection_items', 'edit'):
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

    item_codes = [r['item_code'] for r in selected_rows]
    existing = InspectionItem.query.filter(InspectionItem.item_code.in_(item_codes), InspectionItem.company_id == g.active_company.id).all()
    existing_map = {i.item_code: i for i in existing}

    created = 0
    updated = 0

    for row in selected_rows:
        ex = existing_map.get(row['item_code'])
        if ex:
            ex.item_name = row['item_name']
            ex.spec = row.get('spec', '')
            updated += 1
        else:
            db.session.add(InspectionItem(
                item_code=row['item_code'], item_name=row['item_name'], spec=row.get('spec', ''),
                company_id=g.active_company.id, created_by=admin.id,
            ))
            created += 1

    save_import_history(file, RESOURCE_TYPE, g.active_company.id, admin.id)
    db.session.commit()

    return jsonify({'created': created, 'updated': updated}), 200


# ── Import History ──

@admin_bp.route('/inspection-items/import/history', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def get_inspection_import_history(admin):
    query = ImportHistory.query.options(joinedload(ImportHistory.importer)) \
        .filter(ImportHistory.company_id == g.active_company.id, ImportHistory.resource_type == RESOURCE_TYPE) \
        .order_by(ImportHistory.created_at.desc())
    result = paginate_query(query, default_per_page=10)
    return format_paginated('histories', result, schema=ImportHistoryResponseSchema())


@admin_bp.route('/inspection-items/import/history/<history_id>/download', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def download_inspection_import_file(admin, history_id):
    history, err = get_history_or_404(history_id, RESOURCE_TYPE, g.active_company)
    if err: return err

    filepath = os.path.join(IMPORT_DIR, history.stored_filename)
    if not os.path.exists(filepath):
        return jsonify({'message': 'File not found'}), 404

    return send_file(filepath, mimetype='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                     as_attachment=True, download_name=history.original_filename)


@admin_bp.route('/inspection-items/import/history/<history_id>', methods=['DELETE'])
@jwt_required()
@admin_required
@company_required
def delete_inspection_import_history(admin, history_id):
    if not admin.has_permission('inspection_items', 'delete'):
        return jsonify({'message': 'Permission denied'}), 403

    history, err = get_history_or_404(history_id, RESOURCE_TYPE, g.active_company)
    if err: return err

    filepath = os.path.join(IMPORT_DIR, history.stored_filename)
    if os.path.exists(filepath):
        os.remove(filepath)

    db.session.delete(history)
    db.session.commit()

    return jsonify({'message': 'Import history deleted successfully'}), 200
