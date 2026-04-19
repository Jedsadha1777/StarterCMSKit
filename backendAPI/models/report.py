from uuid import uuid4
from extensions import db
from datetime import datetime, timezone
from sqlalchemy import text


class ReportCounter(db.Model):
    __tablename__ = 'report_counters'
    company_id = db.Column(db.Integer, db.ForeignKey('companies.id'), primary_key=True)
    year = db.Column(db.Integer, primary_key=True)
    last_seq = db.Column(db.Integer, nullable=False, default=0)


class Report(db.Model):
    __tablename__ = 'reports'

    id = db.Column(db.Integer, primary_key=True)
    public_id = db.Column(db.String(36), unique=True, nullable=False, default=lambda: str(uuid4()))
    report_no = db.Column(db.String(50), nullable=False)
    form_data = db.Column(db.JSON, nullable=False)
    machine_model_id = db.Column(db.Integer, db.ForeignKey('machine_models.id'), nullable=True)
    customer_id = db.Column(db.Integer, db.ForeignKey('customers.id'), nullable=True)
    serial_no = db.Column(db.String(100), nullable=True)
    inspector_name = db.Column(db.String(200), nullable=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True)
    company_id = db.Column(db.Integer, db.ForeignKey('companies.id', ondelete='CASCADE'), nullable=True, index=True)
    status = db.Column(db.String(20), nullable=False, default='submitted')
    inspected_at = db.Column(db.DateTime, nullable=True)
    sent_at = db.Column(db.DateTime, nullable=True)
    email_recipients = db.Column(db.JSON, nullable=True)
    pdf_path = db.Column(db.String(500), nullable=True)
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc).replace(tzinfo=None))
    updated_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc).replace(tzinfo=None), onupdate=lambda: datetime.now(timezone.utc).replace(tzinfo=None))

    __table_args__ = (
        db.UniqueConstraint('company_id', 'report_no', name='uq_report_company_no'),
    )

    machine_model = db.relationship('MachineModel', backref='reports', lazy=True)
    customer = db.relationship('Customer', backref='reports', lazy=True)
    user = db.relationship('User', backref='reports', lazy=True)

    def to_dict(self):
        return {
            'id': self.public_id,
            'report_no': self.report_no,
            'form_data': self.form_data,
            'machine_model_id': self.machine_model.public_id if self.machine_model else None,
            'customer_id': self.customer.public_id if self.customer else None,
            'serial_no': self.serial_no,
            'inspector_name': self.inspector_name,
            'user_id': self.user.public_id if self.user else None,
            'user_name': self.user.name if self.user else None,
            'status': self.status,
            'inspected_at': self.inspected_at.isoformat() if self.inspected_at else None,
            'sent_at': self.sent_at.isoformat() if self.sent_at else None,
            'email_recipients': self.email_recipients,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
        }


def generate_report_no(company_id):
    year = int(datetime.now(timezone.utc).strftime('%y'))
    db.session.execute(text(
        "INSERT INTO report_counters (company_id, year, last_seq) "
        "VALUES (:cid, :yr, 0) "
        "ON DUPLICATE KEY UPDATE last_seq = last_seq"
    ), {'cid': company_id, 'yr': year})
    counter = db.session.query(ReportCounter) \
        .filter_by(company_id=company_id, year=year) \
        .with_for_update().first()
    counter.last_seq += 1
    return f"RPT-{counter.last_seq:06d}/{year}"
