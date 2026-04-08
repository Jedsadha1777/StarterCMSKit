from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_jwt_extended import JWTManager

db = SQLAlchemy()
migrate = Migrate()
jwt = JWTManager()


@jwt.token_in_blocklist_loader
def check_if_token_revoked(jwt_header, jwt_payload):
    """Admin uses session-based auth — only check blacklist for user tokens"""
    user_type = jwt_payload.get('user_type')

    if user_type == 'admin':
        return False

    from models import TokenBlacklist
    jti = jwt_payload['jti']
    return TokenBlacklist.is_jti_blacklisted(jti)


@jwt.revoked_token_loader
def revoked_token_callback(jwt_header, jwt_payload):
    return {
        'code': 'TOKEN_REVOKED',
        'message': 'Token has been revoked'
    }, 401
