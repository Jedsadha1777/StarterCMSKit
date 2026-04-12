from extensions import db
from datetime import datetime, timezone


class Package(db.Model):
    __tablename__ = 'packages'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), unique=True, nullable=False)
    description = db.Column(db.String(255), nullable=True)
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc).replace(tzinfo=None))
    updated_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc).replace(tzinfo=None), onupdate=lambda: datetime.now(timezone.utc).replace(tzinfo=None))

    limits = db.relationship('PackageLimit', backref='package', lazy=True, cascade='all, delete-orphan')
    role_permissions = db.relationship('PackageRolePermission', backref='package', lazy=True, cascade='all, delete-orphan')
    admins = db.relationship('Admin', backref='package', lazy=True)

    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'description': self.description,
            'limits': {l.resource: l.max_value for l in self.limits},
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }


class PackageLimit(db.Model):
    __tablename__ = 'package_limits'

    package_id = db.Column(db.Integer, db.ForeignKey('packages.id', ondelete='CASCADE'), primary_key=True)
    resource = db.Column(db.String(50), primary_key=True)
    max_value = db.Column(db.Integer, nullable=False)
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc).replace(tzinfo=None))

    def to_dict(self):
        return {
            'resource': self.resource,
            'max_value': self.max_value
        }


class PackageRolePermission(db.Model):
    __tablename__ = 'package_role_permissions'

    package_id = db.Column(db.Integer, db.ForeignKey('packages.id', ondelete='CASCADE'), primary_key=True)
    role = db.Column(db.Enum('super_admin', 'admin', 'editor', name='admin_role', create_type=False), primary_key=True)
    resource = db.Column(db.String(50), primary_key=True)
    action = db.Column(db.String(30), primary_key=True)
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc).replace(tzinfo=None))

    def to_dict(self):
        return {
            'resource': self.resource,
            'action': self.action
        }
