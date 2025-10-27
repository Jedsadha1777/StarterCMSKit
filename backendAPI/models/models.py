from extensions import db
from datetime import datetime

class TokenBlacklist(db.Model):
    __tablename__ = 'token_blacklist'
    
    id = db.Column(db.Integer, primary_key=True)
    jti = db.Column(db.String(36), nullable=False, unique=True, index=True)
    token_type = db.Column(db.String(10), nullable=False)  # 'access' or 'refresh'
    user_id = db.Column(db.String(50), nullable=False, index=True)
    user_type = db.Column(db.String(10), nullable=False)  # 'admin' or 'user'
    revoked_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    expires_at = db.Column(db.DateTime, nullable=False)
    
    def __repr__(self):
        return f'<TokenBlacklist {self.jti}>'
    
    @staticmethod
    def is_jti_blacklisted(jti):
        """ตรวจสอบว่า token ถูก blacklist หรือไม่"""
        query = TokenBlacklist.query.filter_by(jti=jti).first()
        return query is not None
    
    @staticmethod
    def add_to_blacklist(jti, token_type, user_id, user_type, expires_at):
        """เพิ่ม token เข้า blacklist"""
        blacklist_token = TokenBlacklist(
            jti=jti,
            token_type=token_type,
            user_id=user_id,
            user_type=user_type,
            expires_at=expires_at
        )
        db.session.add(blacklist_token)
        db.session.commit()