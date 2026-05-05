from uuid import uuid4
from extensions import db
from datetime import datetime, timezone


class Customer(db.Model):
    __tablename__ = 'customers'

    id = db.Column(db.Integer, primary_key=True)
    public_id = db.Column(db.String(36), unique=True, nullable=False, default=lambda: str(uuid4()))
    customer_id = db.Column(db.String(50), nullable=False)
    name = db.Column(db.String(200), nullable=False)            # company name
    contact_name = db.Column(db.String(200), nullable=True)     # contact person
    email = db.Column(db.String(255), nullable=True)
    address = db.Column(db.Text, nullable=True)
    tel = db.Column(db.String(50), nullable=True)
    fax = db.Column(db.String(50), nullable=True)
    company_id = db.Column(db.Integer, db.ForeignKey('companies.id', ondelete='CASCADE'), nullable=True, index=True)
    created_by = db.Column(db.Integer, db.ForeignKey('admins.id', ondelete='SET NULL'), nullable=True, index=True)
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc).replace(tzinfo=None))
    updated_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc).replace(tzinfo=None), onupdate=lambda: datetime.now(timezone.utc).replace(tzinfo=None))

    creator = db.relationship('Admin', backref='customers', lazy=True, foreign_keys=[created_by])

    def to_dict(self):
        return {
            'id': self.public_id,
            'customer_id': self.customer_id,
            'name': self.name,
            'contact_name': self.contact_name,
            'email': self.email,
            'address': self.address,
            'tel': self.tel,
            'fax': self.fax,
            'created_by': self.creator.public_id if self.creator else None,
            'created_by_name': self.creator.name if self.creator else None,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
        }
