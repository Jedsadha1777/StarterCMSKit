import os
import smtplib
from datetime import datetime, timezone
from flask import jsonify, request, send_file
from flask_jwt_extended import jwt_required
from user_api import user_bp
from extensions import db
from sqlalchemy.orm import joinedload
from models import Report, MachineModel, Customer, generate_report_no
from decorators import user_required
from utils import load_schema, paginate_query, apply_sorting, format_paginated
from schemas import ReportCreateSchema, ReportResponseSchema
from services.email_service import send_report_email
from config import UPLOAD_DIR, MAX_UPLOAD_BYTES


REPORTS_DIR = os.path.join(UPLOAD_DIR, 'reports')


# Step 1: Submit report → generate report_no → status=pending_pdf
@user_bp.route('/reports', methods=['POST'])
@jwt_required()
@user_required
def submit_report(user):
    data, err = load_schema(ReportCreateSchema)
    if err: return err

    current_count = Report.query.filter(Report.company_id == user.company_id).count()
    if not user.company.check_limit('reports', current_count):
        return jsonify({'message': 'Report limit reached for your package'}), 403

    machine_model = MachineModel.query.filter_by(
        public_id=data['machine_model_id'],
        company_id=user.company_id,
    ).first()
    if not machine_model:
        return jsonify({'message': 'Machine model not found'}), 400

    customer = None
    if data.get('customer_id'):
        customer = Customer.query.filter_by(
            public_id=data['customer_id'],
            company_id=user.company_id,
        ).first()

    report_no = generate_report_no(user.company_id)

    report = Report(
        report_no=report_no,
        form_data=data['form_data'],
        machine_model_id=machine_model.id,
        customer_id=customer.id if customer else None,
        serial_no=data.get('serial_no'),
        inspector_name=data.get('inspector_name'),
        inspected_at=data.get('inspected_at'),
        user_id=user.id,
        company_id=user.company_id,
        email_recipients=data['recipient_emails'],
        status='pending_pdf',
    )
    db.session.add(report)
    db.session.commit()

    return jsonify(ReportResponseSchema().dump(report)), 201


# Step 2: Upload PDF → save file → send email → update status
@user_bp.route('/reports/<report_public_id>/upload-pdf', methods=['POST'])
@jwt_required()
@user_required
def upload_pdf(user, report_public_id):
    report = Report.query.filter_by(public_id=report_public_id, user_id=user.id).first()
    if not report:
        return jsonify({'message': 'Report not found'}), 404

    if report.status != 'pending_pdf':
        return jsonify({'message': 'Report is not in pending_pdf status'}), 400

    file = request.files.get('file')
    if not file or not file.filename:
        return jsonify({'message': 'No PDF file provided'}), 400

    # Validate file type
    if not file.content_type or 'pdf' not in file.content_type.lower():
        header = file.read(5)
        file.seek(0)
        if header != b'%PDF-':
            return jsonify({'message': 'File is not a valid PDF'}), 400

    # Validate file size
    file.seek(0, 2)
    size = file.tell()
    file.seek(0)
    if size > MAX_UPLOAD_BYTES:
        return jsonify({'message': f'File too large (max {MAX_UPLOAD_BYTES // 1024 // 1024}MB)'}), 400

    # Save PDF
    os.makedirs(REPORTS_DIR, exist_ok=True)
    pdf_path = os.path.join(REPORTS_DIR, f'{report.public_id}.pdf')
    file.save(pdf_path)
    report.pdf_path = pdf_path

    # Send email
    cc_email = user.company.report_cc_email if user.company else None
    try:
        send_report_email(report, user, report.email_recipients, pdf_path, cc_email=cc_email)
        report.status = 'sent'
        report.sent_at = datetime.now(timezone.utc).replace(tzinfo=None)
    except (smtplib.SMTPException, OSError, RuntimeError):
        report.status = 'email_failed'

    db.session.commit()

    return jsonify(ReportResponseSchema().dump(report)), 200


@user_bp.route('/reports', methods=['GET'])
@jwt_required()
@user_required
def get_reports(user):
    query = Report.query.options(
        joinedload(Report.machine_model),
        joinedload(Report.customer),
        joinedload(Report.user),
    ).filter(Report.user_id == user.id)

    query = apply_sorting(query, Report, sortable_fields=['created_at', 'report_no', 'status'], default_sort='-created_at')
    result = paginate_query(query, default_per_page=20)

    return format_paginated('reports', result, schema=ReportResponseSchema())


@user_bp.route('/reports/<report_public_id>/retry-email', methods=['POST'])
@jwt_required()
@user_required
def retry_email(user, report_public_id):
    report = Report.query.filter_by(public_id=report_public_id, user_id=user.id).first()
    if not report:
        return jsonify({'message': 'Report not found'}), 404

    if report.status != 'email_failed':
        return jsonify({'message': 'Report is not in email_failed status'}), 400

    if not report.pdf_path or not os.path.exists(report.pdf_path):
        return jsonify({'message': 'PDF file not found. Cannot retry.'}), 400

    cc_email = user.company.report_cc_email if user.company else None
    try:
        send_report_email(report, user, report.email_recipients, report.pdf_path, cc_email=cc_email)
        report.status = 'sent'
        report.sent_at = datetime.now(timezone.utc).replace(tzinfo=None)
        db.session.commit()
        return jsonify(ReportResponseSchema().dump(report)), 200
    except (smtplib.SMTPException, OSError, RuntimeError) as e:
        return jsonify({'message': f'Email send failed: {str(e)}'}), 500


@user_bp.route('/reports/<report_public_id>/pdf', methods=['GET'])
@jwt_required()
@user_required
def get_report_pdf(user, report_public_id):
    report = Report.query.filter_by(public_id=report_public_id, user_id=user.id).first()
    if not report:
        return jsonify({'message': 'Report not found'}), 404

    if not report.pdf_path or not os.path.exists(report.pdf_path):
        return jsonify({'message': 'PDF not available'}), 404

    return send_file(report.pdf_path, mimetype='application/pdf')
