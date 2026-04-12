# Convention: ALL db.Column(db.DateTime) fields in this project are naive UTC.
# Always produce a naive datetime before storing or comparing:
#   datetime.now(timezone.utc).replace(tzinfo=None)          ← current time
#   datetime.fromtimestamp(ts, tz=timezone.utc).replace(tzinfo=None)  ← from epoch
# Never store a timezone-aware datetime directly — SQLAlchemy will raise SAWarning
# and SQLite may embed the "+00:00" suffix, breaking subsequent ">" comparisons.

from functools import wraps
from datetime import datetime, timezone
from flask import jsonify
from flask_jwt_extended import get_jwt_identity, get_jwt
from models import Admin, User
from session_cache import session_cache


def _get_admin_by_identity(public_id):
    """Lookup admin by public_id (from JWT identity)."""
    return Admin.query.filter_by(public_id=public_id).first()


def _get_user_by_identity(public_id):
    """Lookup user by public_id (from JWT identity)."""
    return User.query.filter_by(public_id=public_id).first()


def _validate_admin_session(session_id, admin_internal_id):
    """Validate admin session with cache + grace period support."""
    cached = session_cache.get(session_id)
    if cached is not None:
        if cached is False:
            return None, 'SESSION_REPLACED'
        return cached, None

    from models import AdminSession
    session = AdminSession.query.get(session_id)

    if not session or session.admin_id != admin_internal_id:
        session_cache.set(session_id, False)
        return None, 'SESSION_NOT_FOUND'

    if session.status == 'revoked':
        session_cache.set(session_id, False)
        return None, 'SESSION_REVOKED'

    if session.status == 'grace_period':
        if session.grace_until and datetime.now(timezone.utc).replace(tzinfo=None) <= session.grace_until:
            return {'session_id': session.id, 'admin_id': session.admin_id, 'status': 'grace_period'}, None
        from extensions import db
        session.status = 'revoked'
        db.session.commit()
        session_cache.set(session_id, False)
        return None, 'SESSION_REPLACED'

    session.last_active_at = datetime.now(timezone.utc).replace(tzinfo=None)
    from extensions import db
    db.session.commit()

    data = {'session_id': session.id, 'admin_id': session.admin_id, 'status': 'active'}
    session_cache.set(session_id, data)
    return data, None


def admin_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        claims = get_jwt()

        if claims.get('user_type') != 'admin':
            return jsonify({'code': 'WRONG_USER_TYPE', 'message': 'Unauthorized'}), 403

        public_id = get_jwt_identity()
        session_id = claims.get('session_id')

        if not session_id:
            return jsonify({'code': 'INVALID_TOKEN', 'message': 'Missing session_id'}), 401

        admin = _get_admin_by_identity(public_id)
        if not admin:
            return jsonify({'code': 'INVALID_TOKEN', 'message': 'Admin not found'}), 401

        session_data, error_code = _validate_admin_session(session_id, admin.id)

        if error_code:
            msg = 'Your account has been logged in from another device. Please login again.'
            if error_code == 'SESSION_NOT_FOUND':
                msg = 'Session not found'
            elif error_code == 'SESSION_REVOKED':
                msg = 'Session has been revoked'
            return jsonify({'code': error_code, 'message': msg}), 401

        return f(admin, *args, **kwargs)
    return decorated_function


def user_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        claims = get_jwt()

        if claims.get('user_type') != 'user':
            return jsonify({'code': 'WRONG_USER_TYPE', 'message': 'Unauthorized'}), 403

        public_id = get_jwt_identity()
        user = _get_user_by_identity(public_id)

        if not user:
            return jsonify({'message': 'User not found'}), 404

        return f(user, *args, **kwargs)
    return decorated_function
