import enum
from uuid import uuid4
from extensions import db
from datetime import datetime, timezone
from models.mixins import PasswordMixin


UNLIMITED = -1  # sentinel for PackageLimit.max_value — means no upper bound


class AdminRole(str, enum.Enum):
    ADMIN = 'admin'
    EDITOR = 'editor'


class Admin(PasswordMixin, db.Model):
    __tablename__ = 'admins'

    id = db.Column(db.Integer, primary_key=True)
    public_id = db.Column(db.String(36), unique=True, nullable=False, default=lambda: str(uuid4()))
    name = db.Column(db.String(100), nullable=False, default='')
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)
    role = db.Column(db.Enum(AdminRole, values_callable=lambda e: [x.value for x in e], name='admin_role'), nullable=False, default=AdminRole.ADMIN)
    company_id = db.Column(db.Integer, db.ForeignKey('companies.id', ondelete='SET NULL'), nullable=True)
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc).replace(tzinfo=None))
    updated_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc).replace(tzinfo=None), onupdate=lambda: datetime.now(timezone.utc).replace(tzinfo=None))

    articles = db.relationship('Article', backref='admin_author', lazy=True)

    @property
    def is_super_admin(self):
        return self.company is not None and self.company.parent_id == 0

    def has_permission(self, resource, action):
        if self.is_super_admin:
            return True
        if not self.company or not self.company.package_id:
            return False
        from models.package import PackageRolePermission
        return PackageRolePermission.query.filter_by(
            package_id=self.company.package_id,
            role=self.role,
            resource=resource,
            action=action
        ).first() is not None

    def check_limit(self, resource, current_count):
        if self.is_super_admin:
            return True
        if not self.company or not self.company.package_id:
            return False
        from models.package import PackageLimit
        limit = PackageLimit.query.filter_by(
            package_id=self.company.package_id,
            resource=resource
        ).first()
        if not limit:
            return True
        if limit.max_value == UNLIMITED:
            return True
        return current_count < limit.max_value

    def get_permissions(self):
        if self.is_super_admin:
            return '*'
        if not self.company or not self.company.package_id:
            return []
        from models.package import PackageRolePermission
        rows = PackageRolePermission.query.filter_by(
            package_id=self.company.package_id,
            role=self.role
        ).all()
        return [f"{r.resource}.{r.action}" for r in rows]

    def get_limits(self):
        if self.is_super_admin:
            return {}
        if not self.company or not self.company.package_id:
            return {}
        from models.package import PackageLimit
        rows = PackageLimit.query.filter_by(package_id=self.company.package_id).all()
        return {r.resource: r.max_value for r in rows}

    def to_dict(self, include_permissions=False):
        result = {
            'id': self.public_id,
            'name': self.name,
            'email': self.email,
            'role': self.role.value if self.role else None,
            'company_id': self.company.public_id if self.company else None,
            'company_name': self.company.name if self.company else None,
            'is_super_admin': self.is_super_admin,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }
        if include_permissions:
            result['permissions'] = self.get_permissions()
            result['limits'] = self.get_limits()
        return result
