import json
import logging
import queue
import secrets
import threading
from uuid import uuid4
from datetime import datetime, timedelta, timezone
from flask import request, jsonify, Response, current_app
from flask_jwt_extended import (
    create_access_token, jwt_required, get_jwt_identity, get_jwt,
    decode_token
)
from itsdangerous import URLSafeTimedSerializer, SignatureExpired, BadSignature
from flask_jwt_extended.exceptions import JWTDecodeError
from admin_api import admin_bp
from extensions import db, limiter
from models import Admin, AdminSession, Company
from decorators import admin_required
from utils import load_schema
from schemas import LoginSchema, ProfileUpdateSchema, ChangePasswordSchema, AdminResponseSchema
from session_cache import session_cache
from sse_manager import sse_manager

logger = logging.getLogger(__name__)

from config import (RESET_TOKEN_MAX_AGE, GRACE_SECONDS, REUSE_GRACE_SECONDS, SSE_TICKET_TTL,
                     RATE_LIMIT_LOGIN, RATE_LIMIT_FORGOT_PASSWORD, RATE_LIMIT_RESET_PASSWORD, RATE_LIMIT_REFRESH,
                     SSE_HEARTBEAT_INTERVAL, USER_AGENT_MAX_LENGTH)


# In-memory store for SSE one-time tickets (protected by lock for thread safety)
_sse_tickets = {}
_sse_tickets_lock = threading.Lock()


def _cleanup_expired_tickets():
    """Remove expired tickets to prevent memory leak."""
    now = datetime.now(timezone.utc).replace(tzinfo=None)
    with _sse_tickets_lock:
        expired = [k for k, v in _sse_tickets.items() if now > v['expires']]
        for k in expired:
            del _sse_tickets[k]


def _generate_reset_token(email):
    s = URLSafeTimedSerializer(current_app.config['SECRET_KEY'])
    return s.dumps(email, salt='password-reset')


def _verify_reset_token(token):
    s = URLSafeTimedSerializer(current_app.config['SECRET_KEY'])
    try:
        email = s.loads(token, salt='password-reset', max_age=RESET_TOKEN_MAX_AGE)
        return email, None
    except SignatureExpired:
        return None, 'Reset link has expired'
    except BadSignature:
        return None, 'Invalid reset token'


def _create_session(admin, raw_refresh, family=None, ip=None, ua=None):
    session = AdminSession(
        id=str(uuid4()),
        admin_id=admin.id,
        refresh_token_hash=AdminSession.hash_token(raw_refresh),
        token_family=family or str(uuid4()),
        status='active',
        ip_address=ip,
        user_agent=ua,
    )
    db.session.add(session)
    return session


def _make_access_token(admin, session):
    claims = {
        'user_type': 'admin',
        'session_id': session.id,
    }
    return create_access_token(identity=admin.public_id, additional_claims=claims)


def _decode_admin_jwt(allow_expired=False):
    """Decode JWT from Authorization header. Optionally allow expired tokens."""
    auth = request.headers.get('Authorization', '')
    if not auth.startswith('Bearer '):
        return None, 'Missing Authorization header'
    token = auth[7:]
    try:
        claims = decode_token(token, allow_expired=allow_expired)
    except JWTDecodeError as e:
        return None, str(e)
    if claims.get('user_type') != 'admin':
        return None, 'Wrong user type'
    return claims, None


@admin_bp.route('/login', methods=['POST'])
@limiter.limit(RATE_LIMIT_LOGIN)
def login():
    """Admin login — single session enforcement with grace period."""
    data, err = load_schema(LoginSchema)
    if err: return err

    admin = Admin.query.filter_by(email=data['email']).first()
    if not admin or not admin.check_password(data['password']):
        return jsonify({'code': 'INVALID_CREDENTIALS', 'message': 'Invalid email or password'}), 401

    ip = request.remote_addr
    ua = request.headers.get('User-Agent', '')[:USER_AGENT_MAX_LENGTH]

    old_sessions = AdminSession.query \
        .filter_by(admin_id=admin.id, status='active') \
        .with_for_update() \
        .all()

    # 1) Mark old sessions → grace_period (release UNIQUE slot)
    replaced_info = None
    for old in old_sessions:
        old.status = 'grace_period'
        old.grace_until = datetime.now(timezone.utc).replace(tzinfo=None) + timedelta(seconds=GRACE_SECONDS)
        replaced_info = {
            'old_session_id': old.id,
            'ip_address': old.ip_address,
            'last_active_at': old.last_active_at.isoformat() if old.last_active_at else None,
        }
        session_cache.invalidate(old.id)

    db.session.flush()  # flush grace_period → active_admin_id = NULL → UNIQUE slot free

    # 2) Create new session (active) — UNIQUE slot is now free
    raw_refresh = AdminSession.generate_refresh_token()
    new_session = _create_session(admin, raw_refresh, ip=ip, ua=ua)
    db.session.flush()  # flush new session so its id exists for FK reference

    # 3) Update replaced_by_session_id
    for old in old_sessions:
        old.replaced_by_session_id = new_session.id

    # Cleanup expired grace sessions (exclude the one just marked)
    old_ids = [o.id for o in old_sessions]
    expired = AdminSession.query.filter(
        AdminSession.admin_id == admin.id,
        AdminSession.status == 'grace_period',
        AdminSession.grace_until < datetime.now(timezone.utc).replace(tzinfo=None),
    )
    if old_ids:
        expired = expired.filter(~AdminSession.id.in_(old_ids))
    expired.update({'status': 'revoked'})

    db.session.commit()

    if replaced_info:
        sse_manager.send(replaced_info['old_session_id'], 'session_replaced', {
            'code': 'SESSION_REPLACED',
            'message': 'Your account has been logged in from another device.',
            'replaced_by': {
                'session_id': new_session.id,
                'ip_address': ip,
                'at': datetime.now(timezone.utc).replace(tzinfo=None).isoformat(),
            },
            'grace_seconds': GRACE_SECONDS,
        })

    access_token = _make_access_token(admin, new_session)

    if admin.company and admin.company.parent_id == 0:
        accessible = Company.query.filter_by(parent_id=admin.company.id).order_by(Company.name).all()
    else:
        accessible = [admin.company] if admin.company else []

    response = {
        'access_token': access_token,
        'refresh_token': raw_refresh,
        'admin': {**AdminResponseSchema().dump(admin), 'permissions': admin.get_permissions(), 'limits': admin.get_limits()},
        'session': new_session.to_dict(),
        'companies': [{'id': c.id, 'name': c.name} for c in accessible],
    }
    if replaced_info:
        response['replaced_session'] = {
            'ip_address': replaced_info['ip_address'],
            'last_active_at': replaced_info['last_active_at'],
        }

    return jsonify(response), 200


@admin_bp.route('/refresh', methods=['POST'])
@limiter.limit(RATE_LIMIT_REFRESH)
def refresh():
    """Refresh — accepts expired access token (real credential is opaque refresh token)"""
    claims, err = _decode_admin_jwt(allow_expired=True)
    if err:
        return jsonify({'code': 'INVALID_TOKEN', 'message': err}), 401

    admin_public_id = claims['sub']
    session_id = claims.get('session_id')
    data = request.get_json() or {}
    raw_token = data.get('refresh_token', '')

    if not raw_token:
        return jsonify({'code': 'INVALID_TOKEN', 'message': 'refresh_token is required'}), 400

    admin = Admin.query.filter_by(public_id=admin_public_id).first()
    if not admin:
        return jsonify({'code': 'INVALID_TOKEN', 'message': 'Admin not found'}), 401

    session = AdminSession.query.filter_by(id=session_id).with_for_update().first()

    if not session or session.admin_id != admin.id:
        return jsonify({'code': 'SESSION_NOT_FOUND', 'message': 'Session not found'}), 401

    if not AdminSession.verify_token(raw_token, session.refresh_token_hash):
        return jsonify({'code': 'INVALID_TOKEN', 'message': 'Invalid refresh token'}), 401

    if session.status == 'grace_period':
        return jsonify({'code': 'SESSION_REPLACED', 'message': 'Session has been replaced'}), 401

    if not session.is_valid():
        return jsonify({'code': 'SESSION_REVOKED', 'message': 'Session has been revoked'}), 401

    # Reuse detection
    if session.is_used:
        elapsed = (datetime.now(timezone.utc).replace(tzinfo=None) - session.used_at).total_seconds() if session.used_at else float('inf')

        if elapsed <= REUSE_GRACE_SECONDS:
            # Network retry — find latest unused session in this family and generate new refresh token for it
            latest = AdminSession.query.filter_by(
                token_family=session.token_family, is_used=False, status='active'
            ).order_by(AdminSession.created_at.desc()).first()

            if latest:
                new_raw = AdminSession.generate_refresh_token()
                latest.refresh_token_hash = AdminSession.hash_token(new_raw)
                db.session.commit()

                access_token = _make_access_token(admin, latest)
                return jsonify({
                    'access_token': access_token,
                    'refresh_token': new_raw,
                    'session': latest.to_dict(),
                }), 200

        # Theft detected — revoke entire family
        family_sessions = AdminSession.query.filter_by(token_family=session.token_family).all()
        for s in family_sessions:
            s.status = 'revoked'
            session_cache.invalidate(s.id)
        db.session.commit()

        sse_manager.send(session.id, 'security_alert', {
            'code': 'TOKEN_REUSE_DETECTED',
            'message': 'Token reuse detected. All sessions have been revoked.',
        })

        return jsonify({
            'code': 'TOKEN_REUSE_DETECTED',
            'message': 'Token reuse detected. All sessions have been revoked.'
        }), 401

    # Normal rotation
    session.is_used = True
    session.used_at = datetime.now(timezone.utc).replace(tzinfo=None)
    session.status = 'revoked'
    session_cache.invalidate(session.id)

    new_raw_refresh = AdminSession.generate_refresh_token()
    new_session = _create_session(
        admin, new_raw_refresh,
        family=session.token_family,
        ip=session.ip_address,
        ua=session.user_agent,
    )

    db.session.commit()

    access_token = _make_access_token(admin, new_session)

    return jsonify({
        'access_token': access_token,
        'refresh_token': new_raw_refresh,
        'session': new_session.to_dict(),
    }), 200


@admin_bp.route('/logout', methods=['POST'])
@jwt_required()
@admin_required
def logout(admin):
    """Logout — revoke current session."""
    claims = get_jwt()
    session_id = claims.get('session_id')

    session = AdminSession.query.get(session_id)
    if session:
        session.status = 'revoked'
        db.session.commit()
        session_cache.invalidate(session_id)

    return jsonify({'message': 'Successfully logged out'}), 200


@admin_bp.route('/forgot-password', methods=['POST'])
@limiter.limit(RATE_LIMIT_FORGOT_PASSWORD)
def forgot_password():
    data = request.get_json(silent=True)
    if not data or not data.get('email'):
        return jsonify({'message': 'Email is required'}), 400

    admin = Admin.query.filter_by(email=data['email']).first()
    if admin:
        token = _generate_reset_token(admin.email)
        # TODO: replace with actual email delivery once mail service is configured
        # WARNING: do NOT log the token — it is a credential that grants password reset access
        logger.info('Password reset initiated for %s', admin.email)

    # Always return 200 — do not reveal whether the email exists
    return jsonify({'message': 'If this email exists, a reset link will be sent'}), 200


@admin_bp.route('/reset-password', methods=['POST'])
@limiter.limit(RATE_LIMIT_RESET_PASSWORD)
def reset_password():
    data = request.get_json(silent=True)
    if not data or not data.get('token') or not data.get('new_password'):
        return jsonify({'message': 'token and new_password are required'}), 400

    email, err = _verify_reset_token(data['token'])
    if err:
        return jsonify({'code': 'INVALID_TOKEN', 'message': err}), 400

    admin = Admin.query.filter_by(email=email).first()
    if not admin:
        return jsonify({'code': 'INVALID_TOKEN', 'message': 'Invalid token'}), 400

    from marshmallow import ValidationError as MarshmallowValidationError
    from schemas import password_length
    try:
        password_length(data['new_password'])
    except MarshmallowValidationError as ve:
        return jsonify({'message': str(ve.messages[0]) if isinstance(ve.messages, list) else str(ve)}), 400

    admin.set_password(data['new_password'])

    # Revoke all active sessions after password reset
    active_sessions = AdminSession.query.filter(
        AdminSession.admin_id == admin.id,
        AdminSession.status.in_(['active', 'grace_period'])
    ).all()
    for s in active_sessions:
        s.status = 'revoked'
        session_cache.invalidate(s.id)

    db.session.commit()
    return jsonify({'message': 'Password reset successfully. Please login again.'}), 200


@admin_bp.route('/session/ticket', methods=['POST'])
@jwt_required()
@admin_required
def create_sse_ticket(admin):
    """Create a short-lived one-time ticket for SSE connection.
    Prevents JWT leak via URL query param."""
    _cleanup_expired_tickets()

    claims = get_jwt()
    session_id = claims.get('session_id')

    ticket = secrets.token_urlsafe(32)
    with _sse_tickets_lock:
        _sse_tickets[ticket] = {
            'session_id': session_id,
            'admin_id': admin.id,
            'expires': datetime.now(timezone.utc).replace(tzinfo=None) + timedelta(seconds=SSE_TICKET_TTL),
        }

    return jsonify({'ticket': ticket}), 200


@admin_bp.route('/session/stream', methods=['GET'])
def session_stream():
    """SSE endpoint — uses one-time ticket instead of raw JWT."""
    ticket_id = request.args.get('ticket')
    with _sse_tickets_lock:
        if not ticket_id or ticket_id not in _sse_tickets:
            return jsonify({'code': 'INVALID_TOKEN', 'message': 'Invalid or missing ticket'}), 401
        ticket = _sse_tickets.pop(ticket_id)

    if datetime.now(timezone.utc).replace(tzinfo=None) > ticket['expires']:
        return jsonify({'code': 'INVALID_TOKEN', 'message': 'Ticket expired'}), 401

    session_id = ticket['session_id']

    def generate():
        q = sse_manager.connect(session_id)
        try:
            while True:
                try:
                    msg = q.get(timeout=SSE_HEARTBEAT_INTERVAL)
                    yield f"event: {msg['type']}\ndata: {json.dumps(msg['data'], ensure_ascii=False)}\n\n"
                except queue.Empty:
                    yield ": heartbeat\n\n"
        finally:
            sse_manager.disconnect(session_id, q)

    return Response(
        generate(),
        mimetype='text/event-stream',
        headers={
            'Cache-Control': 'no-cache',
            'X-Accel-Buffering': 'no',
        }
    )


@admin_bp.route('/session/check', methods=['GET'])
@jwt_required()
@admin_required
def check_session(admin):
    """Lightweight session check — client polls this as SSE fallback."""
    claims = get_jwt()
    session_id = claims.get('session_id')

    session = AdminSession.query.get(session_id)
    if not session or not session.is_valid():
        replaced_by = None
        if session and session.replaced_by_session_id:
            new_ses = AdminSession.query.get(session.replaced_by_session_id)
            if new_ses:
                replaced_by = {'ip_address': new_ses.ip_address, 'at': new_ses.created_at.isoformat()}

        return jsonify({
            'valid': False,
            'code': 'SESSION_REPLACED',
            'replaced_by': replaced_by,
        }), 200

    return jsonify({'valid': True}), 200


@admin_bp.route('/profile', methods=['GET', 'PUT'])
@jwt_required()
@admin_required
def profile(admin):
    if request.method == 'GET':
        result = AdminResponseSchema().dump(admin)
        result['permissions'] = admin.get_permissions()
        result['limits'] = admin.get_limits()
        return jsonify(result), 200

    data, err = load_schema(ProfileUpdateSchema)
    if err: return err

    name_query = Admin.query.filter(Admin.name == data['name'], Admin.id != admin.id)
    if admin.company_id:
        name_query = name_query.filter(Admin.company_id == admin.company_id)
    if name_query.first():
        return jsonify({'message': 'Name already taken'}), 400

    admin.name = data['name']
    db.session.commit()

    result = AdminResponseSchema().dump(admin)
    result['permissions'] = admin.get_permissions()
    result['limits'] = admin.get_limits()
    return jsonify(result), 200


@admin_bp.route('/profile/change-password', methods=['PUT'])
@jwt_required()
@admin_required
def change_password(admin):
    data, err = load_schema(ChangePasswordSchema)
    if err: return err

    if not admin.check_password(data['old_password']):
        return jsonify({'code': 'INVALID_CREDENTIALS', 'message': 'Invalid old password'}), 401

    admin.set_password(data['new_password'])

    all_sessions = AdminSession.query.filter(
        AdminSession.admin_id == admin.id,
        AdminSession.status.in_(['active', 'grace_period'])
    ).all()
    for s in all_sessions:
        s.status = 'revoked'
        session_cache.invalidate(s.id)
        sse_manager.send(s.id, 'security_alert', {
            'code': 'PASSWORD_CHANGED',
            'message': 'Password has been changed. Please login again.',
        })

    db.session.commit()
    return jsonify({'message': 'Password changed successfully. Please login again.'}), 200
