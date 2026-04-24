"""Parts Summary — aggregate qty/value consumed per parts_code over a date range.

Backed by parts_consumption (normalized usage log). Indexed for fast range +
group-by queries.
"""
from datetime import datetime, date
from flask import request, jsonify, g
from flask_jwt_extended import jwt_required
from sqlalchemy import func, or_
from admin_api import admin_bp
from extensions import db
from models import PartsConsumption, Report
from decorators import admin_required, company_required
from services.import_export import export_to_excel


def _parse_date(s):
    if not s:
        return None
    try:
        return datetime.strptime(s, '%Y-%m-%d').date()
    except (ValueError, TypeError):
        return None


def _summary_query(company_id, from_dt, to_dt, search=None, report_no=None):
    """Build the aggregate query. Returns SQLAlchemy query yielding
    (parts_code, parts_name, total_qty, total_value) rows sorted by qty DESC.

    Filters (all optional):
      - search      fuzzy-match on parts_code OR parts_name (case-insensitive)
      - report_no   fuzzy-match on reports.report_no (JOINs reports when set)
    """
    q = db.session.query(
        PartsConsumption.parts_code.label('parts_code'),
        func.max(PartsConsumption.parts_name).label('parts_name'),
        func.sum(PartsConsumption.qty).label('total_qty'),
        func.sum(PartsConsumption.qty * PartsConsumption.unit_price).label('total_value'),
    ).filter(PartsConsumption.company_id == company_id)

    if from_dt:
        q = q.filter(PartsConsumption.consumption_dt >= from_dt)
    if to_dt:
        q = q.filter(PartsConsumption.consumption_dt <= to_dt)
    if search:
        pattern = f"%{search}%"
        q = q.filter(or_(
            PartsConsumption.parts_code.ilike(pattern),
            PartsConsumption.parts_name.ilike(pattern),
        ))
    if report_no:
        q = q.join(Report, Report.id == PartsConsumption.report_id) \
             .filter(Report.report_no.ilike(f"%{report_no}%"))

    return q.group_by(PartsConsumption.parts_code).order_by(func.sum(PartsConsumption.qty).desc())


@admin_bp.route('/parts-summary', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def get_parts_summary(admin):
    if not admin.has_permission('parts', 'view'):
        return jsonify({'message': 'Permission denied'}), 403

    from_dt = _parse_date(request.args.get('from'))
    to_dt = _parse_date(request.args.get('to'))
    search = (request.args.get('search') or '').strip() or None
    report_no = (request.args.get('report_no') or '').strip() or None

    rows = _summary_query(g.active_company.id, from_dt, to_dt, search, report_no).all()

    return jsonify({
        'from': from_dt.isoformat() if from_dt else None,
        'to': to_dt.isoformat() if to_dt else None,
        'search': search,
        'report_no': report_no,
        'rows': [
            {
                'parts_code': r.parts_code,
                'parts_name': r.parts_name,
                'total_qty': int(r.total_qty or 0),
                'total_value': float(r.total_value or 0),
            }
            for r in rows
        ],
    }), 200


@admin_bp.route('/parts-summary/export', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def export_parts_summary(admin):
    if not admin.has_permission('parts', 'view'):
        return jsonify({'message': 'Permission denied'}), 403

    from_dt = _parse_date(request.args.get('from'))
    to_dt = _parse_date(request.args.get('to'))
    search = (request.args.get('search') or '').strip() or None
    report_no = (request.args.get('report_no') or '').strip() or None

    rows = _summary_query(g.active_company.id, from_dt, to_dt, search, report_no).all()

    columns = ['PART No.', 'Parts Name', 'Total QTR.', 'Total Value']

    def row_mapper(r):
        return [
            r.parts_code,
            r.parts_name or '',
            int(r.total_qty or 0),
            float(r.total_value or 0),
        ]

    suffix = ''
    if from_dt or to_dt:
        suffix = f"_{from_dt.isoformat() if from_dt else 'start'}_to_{to_dt.isoformat() if to_dt else 'end'}"
    download_name = f'parts_summary{suffix}.xlsx'

    return export_to_excel(rows, columns, row_mapper, 'Parts Summary', download_name)


@admin_bp.route('/parts-summary/by-code/<parts_code>', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def get_parts_usage_by_code(admin, parts_code):
    """Drill-down: list each report that used this parts_code in the range."""
    if not admin.has_permission('parts', 'view'):
        return jsonify({'message': 'Permission denied'}), 403

    from_dt = _parse_date(request.args.get('from'))
    to_dt = _parse_date(request.args.get('to'))
    report_no = (request.args.get('report_no') or '').strip() or None

    q = db.session.query(
        PartsConsumption.id,
        PartsConsumption.parts_code,
        PartsConsumption.parts_name,
        PartsConsumption.qty,
        PartsConsumption.unit_price,
        PartsConsumption.consumption_dt,
        Report.public_id.label('report_id'),
        Report.report_no.label('report_no'),
    ).join(Report, Report.id == PartsConsumption.report_id).filter(
        PartsConsumption.company_id == g.active_company.id,
        PartsConsumption.parts_code == parts_code,
    )
    if from_dt:
        q = q.filter(PartsConsumption.consumption_dt >= from_dt)
    if to_dt:
        q = q.filter(PartsConsumption.consumption_dt <= to_dt)
    if report_no:
        q = q.filter(Report.report_no.ilike(f"%{report_no}%"))
    q = q.order_by(PartsConsumption.consumption_dt.desc())

    rows = q.all()
    return jsonify({
        'parts_code': parts_code,
        'rows': [
            {
                'id': r.id,
                'parts_name': r.parts_name,
                'qty': r.qty,
                'unit_price': float(r.unit_price or 0),
                'total': float(r.unit_price or 0) * (r.qty or 0),
                'consumption_dt': r.consumption_dt.isoformat() if r.consumption_dt else None,
                'report_id': r.report_id,
                'report_no': r.report_no,
            }
            for r in rows
        ],
    }), 200
