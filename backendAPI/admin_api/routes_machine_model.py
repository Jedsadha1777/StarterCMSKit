import json
from datetime import datetime
from flask import request, jsonify, send_file, g
from flask_jwt_extended import jwt_required
from admin_api import admin_bp
from extensions import db
from sqlalchemy.orm import joinedload
from models import MachineModel, InspectionItem, ImportHistory
from decorators import admin_required, company_required
from utils import paginate_query, apply_filters, apply_sorting, format_paginated, load_schema, get_or_404_scoped, check_unique
from schemas import MachineModelCreateSchema, MachineModelUpdateSchema, MachineModelResponseSchema, ImportHistoryResponseSchema
from services.import_export import parse_excel, validate_row, export_to_excel, save_import_history, get_history_or_404
from config import IMPORT_DIR
import os

RESOURCE_TYPE = 'machine_models'
EXPORT_COLUMNS = ['model_code', 'model_name', 'created_by_name', 'created_at', 'updated_at']
IMPORT_COLUMNS = ['model_code', 'model_name']
REQUIRED_COLUMNS = ['model_code', 'model_name']
COMPARE_FIELDS = ['model_code', 'model_name']


def _resolve_inspection_items(item_ids, company_id):
    if not item_ids:
        return []
    items = InspectionItem.query.filter(
        InspectionItem.public_id.in_(item_ids),
        InspectionItem.company_id == company_id,
    ).all()
    return items


# ── CRUD ──

@admin_bp.route('/machine-models', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def get_machine_models(admin):
    query = MachineModel.query.options(
        joinedload(MachineModel.creator),
        joinedload(MachineModel.inspection_items),
    ).filter(MachineModel.company_id == g.active_company.id)

    filters = {
        'model_code': {'type': 'fuzzy'},
        'model_name': {'type': 'fuzzy'},
        'created_at': {'type': 'range', 'cast': lambda x: datetime.fromisoformat(x)},
    }

    query = apply_filters(query, MachineModel, filters, search_logic='AND')
    query = apply_sorting(query, MachineModel, sortable_fields=['model_code', 'model_name', 'created_at', 'updated_at'], default_sort='-created_at')
    result = paginate_query(query, default_per_page=10)

    return format_paginated('machine_models', result, schema=MachineModelResponseSchema())


@admin_bp.route('/machine-models', methods=['POST'])
@jwt_required()
@admin_required
@company_required
def create_machine_model(admin):
    if not admin.has_permission('machine_models', 'create'):
        return jsonify({'message': 'Permission denied'}), 403

    current_count = MachineModel.query.filter(MachineModel.company_id == g.active_company.id).count()
    if not admin.check_limit('machine_models', current_count):
        return jsonify({'message': 'Machine model limit reached for your package'}), 403

    data, err = load_schema(MachineModelCreateSchema)
    if err: return err

    err = check_unique(MachineModel, 'model_code', data['model_code'], company_id=g.active_company.id)
    if err: return err

    model = MachineModel(
        model_code=data['model_code'],
        model_name=data['model_name'],
        company_id=g.active_company.id,
        created_by=admin.id,
    )

    model.inspection_items = _resolve_inspection_items(data.get('inspection_item_ids', []), g.active_company.id)

    db.session.add(model)
    db.session.commit()

    return jsonify(MachineModelResponseSchema().dump(model)), 201


@admin_bp.route('/machine-models/<model_public_id>', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def get_machine_model(admin, model_public_id):
    model, err = get_or_404_scoped(MachineModel, model_public_id, g.active_company)
    if err: return err
    return jsonify(MachineModelResponseSchema().dump(model)), 200


@admin_bp.route('/machine-models/<model_public_id>', methods=['PUT'])
@jwt_required()
@admin_required
@company_required
def update_machine_model(admin, model_public_id):
    if not admin.has_permission('machine_models', 'edit'):
        return jsonify({'message': 'Permission denied'}), 403

    model, err = get_or_404_scoped(MachineModel, model_public_id, g.active_company)
    if err: return err

    data, err = load_schema(MachineModelUpdateSchema)
    if err: return err

    if data.get('model_code'):
        err = check_unique(MachineModel, 'model_code', data['model_code'], exclude_id=model.id, company_id=g.active_company.id)
        if err: return err
        model.model_code = data['model_code']

    if data.get('model_name'):
        model.model_name = data['model_name']

    if data.get('inspection_item_ids') is not None:
        model.inspection_items = _resolve_inspection_items(data['inspection_item_ids'], g.active_company.id)

    db.session.commit()

    return jsonify(MachineModelResponseSchema().dump(model)), 200


@admin_bp.route('/machine-models/<model_public_id>', methods=['DELETE'])
@jwt_required()
@admin_required
@company_required
def delete_machine_model(admin, model_public_id):
    if not admin.has_permission('machine_models', 'delete'):
        return jsonify({'message': 'Permission denied'}), 403

    model, err = get_or_404_scoped(MachineModel, model_public_id, g.active_company)
    if err: return err

    db.session.delete(model)
    db.session.commit()

    return jsonify({'message': 'Machine model deleted successfully'}), 200


# ── Export ──

@admin_bp.route('/machine-models/export', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def export_machine_models(admin):
    models = MachineModel.query.options(joinedload(MachineModel.creator)) \
        .filter(MachineModel.company_id == g.active_company.id) \
        .order_by(MachineModel.created_at.desc()).all()

    def row_mapper(m):
        return [
            m.model_code, m.model_name,
            m.creator.name if m.creator else '',
            m.created_at.isoformat() if m.created_at else '',
            m.updated_at.isoformat() if m.updated_at else '',
        ]

    return export_to_excel(models, EXPORT_COLUMNS, row_mapper, 'Machine Models', 'machine_models.xlsx')


# ── Import ──

@admin_bp.route('/machine-models/import/preview', methods=['POST'])
@jwt_required()
@admin_required
@company_required
def import_machine_model_preview(admin):
    if not admin.has_permission('machine_models', 'create') or not admin.has_permission('machine_models', 'edit'):
        return jsonify({'message': 'Permission denied'}), 403

    file = request.files.get('file')
    if not file or not file.filename:
        return jsonify({'message': 'No file provided'}), 400

    rows, err = parse_excel(file, REQUIRED_COLUMNS, IMPORT_COLUMNS)
    if err:
        return jsonify({'message': err}), 400

    model_codes = [r['model_code'] for r in rows if r.get('model_code')]
    existing = MachineModel.query.filter(MachineModel.model_code.in_(model_codes), MachineModel.company_id == g.active_company.id).all() if model_codes else []
    existing_map = {m.model_code: m for m in existing}

    preview_rows = []
    summary = {'total': len(rows), 'new': 0, 'replace': 0, 'unchanged': 0, 'error': 0}

    for data in rows:
        status, errors, ex = validate_row(data, existing_map, 'model_code', REQUIRED_COLUMNS, COMPARE_FIELDS)
        summary[status] += 1

        row_result = {
            'row': data['_row'],
            'model_code': data.get('model_code', ''),
            'model_name': data.get('model_name', ''),
            'status': status,
            'errors': errors,
        }
        if status == 'replace' and ex:
            row_result['existing'] = {'model_name': ex.model_name}
        preview_rows.append(row_result)

    return jsonify({'rows': preview_rows, 'summary': summary}), 200


@admin_bp.route('/machine-models/import/confirm', methods=['POST'])
@jwt_required()
@admin_required
@company_required
def import_machine_model_confirm(admin):
    if not admin.has_permission('machine_models', 'create') or not admin.has_permission('machine_models', 'edit'):
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

    model_codes = [r['model_code'] for r in selected_rows]
    existing = MachineModel.query.filter(MachineModel.model_code.in_(model_codes), MachineModel.company_id == g.active_company.id).all()
    existing_map = {m.model_code: m for m in existing}

    new_rows_count = sum(1 for r in selected_rows if r['model_code'] not in existing_map)
    if new_rows_count > 0:
        current_count = MachineModel.query.filter(MachineModel.company_id == g.active_company.id).count()
        if not admin.check_limit('machine_models', current_count, add_count=new_rows_count):
            return jsonify({'message': f'Import would exceed machine model limit (current: {current_count}, adding: {new_rows_count})'}), 403

    created = 0
    updated = 0

    for row in selected_rows:
        ex = existing_map.get(row['model_code'])
        if ex:
            ex.model_name = row['model_name']
            updated += 1
        else:
            db.session.add(MachineModel(
                model_code=row['model_code'], model_name=row['model_name'],
                company_id=g.active_company.id, created_by=admin.id,
            ))
            created += 1

    save_import_history(file, RESOURCE_TYPE, g.active_company.id, admin.id)
    db.session.commit()

    return jsonify({'created': created, 'updated': updated}), 200


# ── Import History ──

@admin_bp.route('/machine-models/import/history', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def get_machine_model_import_history(admin):
    query = ImportHistory.query.options(joinedload(ImportHistory.importer)) \
        .filter(ImportHistory.company_id == g.active_company.id, ImportHistory.resource_type == RESOURCE_TYPE) \
        .order_by(ImportHistory.created_at.desc())
    result = paginate_query(query, default_per_page=10)
    return format_paginated('histories', result, schema=ImportHistoryResponseSchema())


@admin_bp.route('/machine-models/import/history/<history_id>/download', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def download_machine_model_import_file(admin, history_id):
    history, err = get_history_or_404(history_id, RESOURCE_TYPE, g.active_company)
    if err: return err

    filepath = os.path.join(IMPORT_DIR, history.stored_filename)
    if not os.path.exists(filepath):
        return jsonify({'message': 'File not found'}), 404

    return send_file(filepath, mimetype='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                     as_attachment=True, download_name=history.original_filename)


@admin_bp.route('/machine-models/import/history/<history_id>', methods=['DELETE'])
@jwt_required()
@admin_required
@company_required
def delete_machine_model_import_history(admin, history_id):
    if not admin.has_permission('machine_models', 'delete'):
        return jsonify({'message': 'Permission denied'}), 403

    history, err = get_history_or_404(history_id, RESOURCE_TYPE, g.active_company)
    if err: return err

    filepath = os.path.join(IMPORT_DIR, history.stored_filename)
    if os.path.exists(filepath):
        os.remove(filepath)

    db.session.delete(history)
    db.session.commit()

    return jsonify({'message': 'Import history deleted successfully'}), 200
