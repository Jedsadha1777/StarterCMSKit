import os
from datetime import datetime
from flask import jsonify, g, send_file
from flask_jwt_extended import jwt_required
from admin_api import admin_bp
from extensions import db
from sqlalchemy.orm import joinedload
from models import Report
from decorators import admin_required, company_required
from utils import paginate_query, apply_filters, apply_sorting, format_paginated, load_schema, get_or_404_scoped
from schemas import ReportResponseSchema, ReportStatusUpdateSchema


@admin_bp.route('/reports', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def get_reports(admin):
    if not admin.has_permission('reports', 'view'):
        return jsonify({'message': 'Permission denied'}), 403

    query = Report.query.options(
        joinedload(Report.machine_model),
        joinedload(Report.customer),
        joinedload(Report.user),
    ).filter(Report.company_id == g.active_company.id)

    filters = {
        'report_no': {'type': 'fuzzy'},
        'status': {'type': 'exact'},
        'inspector_name': {'type': 'fuzzy'},
        'serial_no': {'type': 'fuzzy'},
        'created_at': {'type': 'range', 'cast': lambda x: datetime.fromisoformat(x)},
    }

    query = apply_filters(query, Report, filters, search_logic='AND')
    query = apply_sorting(query, Report, sortable_fields=['report_no', 'status', 'created_at', 'updated_at'], default_sort='-created_at')
    result = paginate_query(query, default_per_page=10)

    return format_paginated('reports', result, schema=ReportResponseSchema())


@admin_bp.route('/reports/<report_public_id>', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def get_report(admin, report_public_id):
    if not admin.has_permission('reports', 'view'):
        return jsonify({'message': 'Permission denied'}), 403

    report, err = get_or_404_scoped(Report, report_public_id, g.active_company)
    if err: return err
    return jsonify(ReportResponseSchema().dump(report)), 200


@admin_bp.route('/reports/<report_public_id>', methods=['PUT'])
@jwt_required()
@admin_required
@company_required
def update_report_status(admin, report_public_id):
    if not admin.has_permission('reports', 'edit'):
        return jsonify({'message': 'Permission denied'}), 403

    report, err = get_or_404_scoped(Report, report_public_id, g.active_company)
    if err: return err

    data, err = load_schema(ReportStatusUpdateSchema)
    if err: return err

    valid_transitions = {
        'submitted': ['reviewed'],
        'sent': ['reviewed'],
        'email_failed': ['reviewed'],
        'pending_pdf': ['reviewed'],
        'reviewed': ['approved', 'rejected'],
    }
    allowed = valid_transitions.get(report.status, [])
    if data['status'] not in allowed:
        return jsonify({'message': f'Cannot change from {report.status} to {data["status"]}'}), 400

    report.status = data['status']
    db.session.commit()

    return jsonify(ReportResponseSchema().dump(report)), 200


@admin_bp.route('/reports/<report_public_id>/pdf', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def get_report_pdf(admin, report_public_id):
    if not admin.has_permission('reports', 'view'):
        return jsonify({'message': 'Permission denied'}), 403

    report, err = get_or_404_scoped(Report, report_public_id, g.active_company)
    if err: return err

    if not report.pdf_path or not os.path.exists(report.pdf_path):
        return jsonify({'message': 'PDF not available'}), 404

    return send_file(report.pdf_path, mimetype='application/pdf')
