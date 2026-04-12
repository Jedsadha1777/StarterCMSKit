from extensions import db
from datetime import datetime, timezone
from sqlalchemy import and_

class TokenBlacklist(db.Model):
    __tablename__ = 'token_blacklist'
    
    id = db.Column(db.Integer, primary_key=True)
    jti = db.Column(db.String(36), nullable=False, unique=True, index=True)
    token_type = db.Column(db.String(10), nullable=False)  # 'access' or 'refresh'
    user_id = db.Column(db.String(50), nullable=False, index=True)
    user_type = db.Column(db.String(10), nullable=False)  # 'admin' or 'user'
    revoked_at = db.Column(db.DateTime, nullable=False, default=lambda: datetime.now(timezone.utc).replace(tzinfo=None))
    expires_at = db.Column(db.DateTime, nullable=False)
    
    def __repr__(self):
        return f'<TokenBlacklist {self.jti}>'
    
    @staticmethod
    def is_jti_blacklisted(jti):
        """Check if token is blacklisted and not yet expired.
        Filtering by expires_at prevents scanning the full table indefinitely."""
        now = datetime.now(timezone.utc).replace(tzinfo=None)
        token = TokenBlacklist.query.filter(
            and_(TokenBlacklist.jti == jti, TokenBlacklist.expires_at > now)
        ).first()
        return token is not None
    
    @staticmethod
    def add_to_blacklist(jti, token_type, user_id, user_type, expires_at):
        """Add token to blacklist"""
        blacklist_token = TokenBlacklist(
            jti=jti,
            token_type=token_type,
            user_id=user_id,
            user_type=user_type,
            expires_at=expires_at
        )
        db.session.add(blacklist_token)

    @staticmethod
    def cleanup_expired():
        """Delete blacklist entries whose tokens have already expired.
        Call periodically (e.g. via `flask cleanup`) to keep the table bounded."""
        now = datetime.now(timezone.utc).replace(tzinfo=None)
        count = TokenBlacklist.query.filter(
            TokenBlacklist.expires_at < now
        ).delete()
        db.session.commit()
        return count