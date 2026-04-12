import secrets
import hashlib
from extensions import db
from datetime import datetime, timezone


class AdminSession(db.Model):
    __tablename__ = 'admin_sessions'

    id = db.Column(db.String(36), primary_key=True)
    admin_id = db.Column(db.Integer, db.ForeignKey('admins.id'), nullable=False)
    refresh_token_hash = db.Column(db.String(255), nullable=False)
    token_family = db.Column(db.String(36), nullable=False, index=True)
    is_used = db.Column(db.Boolean, default=False)
    used_at = db.Column(db.DateTime, nullable=True)
    status = db.Column(db.String(20), default='active')
    grace_until = db.Column(db.DateTime, nullable=True)
    replaced_by_session_id = db.Column(db.String(36), db.ForeignKey('admin_sessions.id'), nullable=True)
    ip_address = db.Column(db.String(45))
    user_agent = db.Column(db.String(255))
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc).replace(tzinfo=None))
    last_active_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc).replace(tzinfo=None))

    replaced_by = db.relationship('AdminSession', remote_side=[id], uselist=False)

    def is_valid(self):
        if self.status == 'active':
            return True
        if self.status == 'grace_period' and self.grace_until and datetime.now(timezone.utc).replace(tzinfo=None) <= self.grace_until:
            return True
        return False

    def to_dict(self):
        return {
            'id': self.id,
            'ip_address': self.ip_address,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'last_active_at': self.last_active_at.isoformat() if self.last_active_at else None,
        }

    @staticmethod
    def hash_token(raw_token):
        return hashlib.sha256(raw_token.encode()).hexdigest()

    @staticmethod
    def generate_refresh_token():
        return 'rt_' + secrets.token_urlsafe(48)

    @staticmethod
    def verify_token(raw_token, stored_hash):
        return AdminSession.hash_token(raw_token) == stored_hash
