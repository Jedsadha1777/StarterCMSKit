from uuid import uuid4
from decimal import Decimal
from extensions import db
from datetime import datetime, timezone


class Parts(db.Model):
    __tablename__ = 'parts'

    id = db.Column(db.Integer, primary_key=True)
    public_id = db.Column(db.String(36), unique=True, nullable=False, default=lambda: str(uuid4()))
    company_id = db.Column(db.Integer, db.ForeignKey('companies.id', ondelete='CASCADE'), nullable=True, index=True)
    parts_code = db.Column(db.String(100), nullable=False)
    parts_name = db.Column(db.String(255), nullable=False)
    unit_price = db.Column(db.Numeric(12, 2), nullable=False, default=0)
    is_deleted = db.Column(db.Boolean, nullable=False, default=False)
    created_by = db.Column(db.Integer, db.ForeignKey('admins.id', ondelete='SET NULL'), nullable=True, index=True)
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc).replace(tzinfo=None))
    updated_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc).replace(tzinfo=None), onupdate=lambda: datetime.now(timezone.utc).replace(tzinfo=None))

    creator = db.relationship('Admin', backref='parts', lazy=True, foreign_keys=[created_by])

    __table_args__ = (
        db.UniqueConstraint('company_id', 'parts_code', name='uq_parts_company_code'),
    )

    def to_dict(self):
        return {
            'id': self.public_id,
            'parts_code': self.parts_code,
            'parts_name': self.parts_name,
            'unit_price': float(self.unit_price) if self.unit_price is not None else 0.0,
            'created_by': self.creator.public_id if self.creator else None,
            'created_by_name': self.creator.name if self.creator else None,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
        }


class PartsConsumption(db.Model):
    __tablename__ = 'parts_consumption'

    id = db.Column(db.Integer, primary_key=True)
    report_id = db.Column(db.Integer, db.ForeignKey('reports.id', ondelete='CASCADE'), nullable=False)
    company_id = db.Column(db.Integer, db.ForeignKey('companies.id', ondelete='CASCADE'), nullable=False)
    parts_id = db.Column(db.Integer, db.ForeignKey('parts.id', ondelete='SET NULL'), nullable=True)
    parts_code = db.Column(db.String(100), nullable=False)
    parts_name = db.Column(db.String(255), nullable=False)
    qty = db.Column(db.Integer, nullable=False)
    unit_price = db.Column(db.Numeric(12, 2), nullable=False, default=0)
    consumption_dt = db.Column(db.Date, nullable=True)
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc).replace(tzinfo=None))

    def to_dict(self):
        return {
            'id': self.id,
            'report_id': self.report_id,
            'parts_code': self.parts_code,
            'parts_name': self.parts_name,
            'qty': self.qty,
            'unit_price': float(self.unit_price) if self.unit_price is not None else 0.0,
            'total': float(self.unit_price or 0) * (self.qty or 0),
            'consumption_dt': self.consumption_dt.isoformat() if self.consumption_dt else None,
        }
