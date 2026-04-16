from uuid import uuid4
from extensions import db
from datetime import datetime, timezone


class Company(db.Model):
    __tablename__ = 'companies'

    id = db.Column(db.Integer, primary_key=True)
    public_id = db.Column(db.String(36), unique=True, nullable=False, default=lambda: str(uuid4()))
    name = db.Column(db.String(200), nullable=False)
    parent_id = db.Column(db.Integer, nullable=False, default=0)
    package_id = db.Column(db.Integer, db.ForeignKey('packages.id', ondelete='SET NULL'), nullable=True)
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc).replace(tzinfo=None))
    updated_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc).replace(tzinfo=None), onupdate=lambda: datetime.now(timezone.utc).replace(tzinfo=None))

    package = db.relationship('Package', backref='companies')
    admins = db.relationship('Admin', backref='company', lazy=True)
    users = db.relationship('User', backref='company', lazy=True)

    @property
    def is_root(self):
        return self.parent_id == 0

    def to_dict(self):
        return {
            'id': self.public_id,
            'name': self.name,
            'parent_id': self.parent_id,
            'package_id': self.package_id,
            'is_root': self.is_root,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
        }
