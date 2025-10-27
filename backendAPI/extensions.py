from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_jwt_extended import JWTManager

db = SQLAlchemy()
migrate = Migrate()
jwt = JWTManager()

# JWT token blacklist checker
@jwt.token_in_blocklist_loader
def check_if_token_revoked(jwt_header, jwt_payload):
    """ตรวจสอบว่า token ถูก revoke หรือไม่"""
    from models import TokenBlacklist
    jti = jwt_payload['jti']
    return TokenBlacklist.is_jti_blacklisted(jti)

@jwt.revoked_token_loader
def revoked_token_callback(jwt_header, jwt_payload):
    """Response เมื่อ token ถูก revoke"""
    return {
        'message': 'Token has been revoked',
        'error': 'token_revoked'
    }, 401