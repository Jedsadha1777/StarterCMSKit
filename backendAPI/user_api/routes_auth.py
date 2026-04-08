from flask import request, jsonify
from flask_jwt_extended import (
    create_access_token, create_refresh_token,
    jwt_required, get_jwt_identity, get_jwt, decode_token
)
from user_api import user_bp
from extensions import db
from models import User, TokenBlacklist
from decorators import user_required
from datetime import datetime, timezone


@user_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()

    if not data or not data.get('email') or not data.get('password'):
        return jsonify({'message': 'Email and password are required'}), 400

    user = User.query.filter_by(email=data['email']).first()

    if not user or not user.check_password(data['password']):
        return jsonify({'message': 'Invalid email or password'}), 401

    additional_claims = {'user_type': 'user'}
    access_token = create_access_token(identity=user.public_id, additional_claims=additional_claims)
    refresh_token = create_refresh_token(identity=user.public_id, additional_claims=additional_claims)

    return jsonify({
        'access_token': access_token,
        'refresh_token': refresh_token,
        'user': user.to_dict()
    }), 200


@user_bp.route('/refresh', methods=['POST'])
@jwt_required(refresh=True)
def refresh():
    """Refresh — rotate refresh token + blacklist old one"""
    claims = get_jwt()

    if claims.get('user_type') != 'user':
        return jsonify({'code': 'WRONG_USER_TYPE', 'message': 'Unauthorized'}), 403

    public_id = get_jwt_identity()
    user = User.query.filter_by(public_id=public_id).first()

    if not user:
        return jsonify({'message': 'User not found'}), 404

    old_jti = claims['jti']
    old_exp = datetime.fromtimestamp(claims['exp'], tz=timezone.utc)

    TokenBlacklist.add_to_blacklist(
        jti=old_jti,
        token_type='refresh',
        user_id=public_id,
        user_type='user',
        expires_at=old_exp
    )

    additional_claims = {'user_type': 'user'}
    new_access_token = create_access_token(identity=user.public_id, additional_claims=additional_claims)
    new_refresh_token = create_refresh_token(identity=user.public_id, additional_claims=additional_claims)

    return jsonify({
        'access_token': new_access_token,
        'refresh_token': new_refresh_token
    }), 200


@user_bp.route('/logout', methods=['POST'])
@jwt_required()
@user_required
def logout(user):
    """Logout — blacklist access token + decode refresh token from body"""
    claims = get_jwt()
    public_id = get_jwt_identity()
    exp = datetime.fromtimestamp(claims['exp'], tz=timezone.utc)

    TokenBlacklist.add_to_blacklist(
        jti=claims['jti'],
        token_type=claims['type'],
        user_id=public_id,
        user_type='user',
        expires_at=exp
    )

    # Blacklist refresh token — client sends raw refresh JWT in body
    data = request.get_json(silent=True) or {}
    raw_refresh = data.get('refresh_token')
    if raw_refresh:
        try:
            refresh_claims = decode_token(raw_refresh)
            refresh_exp = datetime.fromtimestamp(refresh_claims['exp'], tz=timezone.utc)
            TokenBlacklist.add_to_blacklist(
                jti=refresh_claims['jti'],
                token_type='refresh',
                user_id=public_id,
                user_type='user',
                expires_at=refresh_exp
            )
        except Exception:
            pass

    return jsonify({'message': 'Successfully logged out'}), 200


@user_bp.route('/profile', methods=['GET'])
@jwt_required()
@user_required
def get_profile(user):
    return jsonify(user.to_dict()), 200


@user_bp.route('/profile/change-password', methods=['PUT'])
@jwt_required()
@user_required
def change_password(user):
    """Change password — blacklist current access + refresh token"""
    data = request.get_json()

    if not data or not data.get('old_password') or not data.get('new_password'):
        return jsonify({'message': 'Old password and new password are required'}), 400

    if not user.check_password(data['old_password']):
        return jsonify({'message': 'Invalid old password'}), 401

    user.set_password(data['new_password'])

    claims = get_jwt()
    public_id = get_jwt_identity()
    exp = datetime.fromtimestamp(claims['exp'], tz=timezone.utc)
    TokenBlacklist.add_to_blacklist(
        jti=claims['jti'],
        token_type=claims['type'],
        user_id=public_id,
        user_type='user',
        expires_at=exp
    )

    raw_refresh = data.get('refresh_token')
    if raw_refresh:
        try:
            refresh_claims = decode_token(raw_refresh)
            refresh_exp = datetime.fromtimestamp(refresh_claims['exp'], tz=timezone.utc)
            TokenBlacklist.add_to_blacklist(
                jti=refresh_claims['jti'],
                token_type='refresh',
                user_id=public_id,
                user_type='user',
                expires_at=refresh_exp
            )
        except Exception:
            pass

    db.session.commit()

    return jsonify({'message': 'Password changed successfully. Please login again.'}), 200
