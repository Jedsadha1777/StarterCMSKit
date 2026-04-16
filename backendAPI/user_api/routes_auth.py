from flask import request, jsonify
from flask_jwt_extended import (
    create_access_token, create_refresh_token,
    jwt_required, get_jwt_identity, get_jwt
)
from user_api import user_bp
from extensions import db, limiter
from models import User, TokenBlacklist
from decorators import user_required
from utils import load_schema, blacklist_tokens
from schemas import LoginSchema, ChangePasswordSchema, UserResponseSchema
from datetime import datetime, timezone
from config import RATE_LIMIT_LOGIN


@user_bp.route('/login', methods=['POST'])
@limiter.limit(RATE_LIMIT_LOGIN)
def login():
    data, err = load_schema(LoginSchema)
    if err: return err

    user = User.query.filter_by(email=data['email']).first()
    if not user or not user.check_password(data['password']):
        return jsonify({'code': 'INVALID_CREDENTIALS', 'message': 'Invalid email or password'}), 401

    additional_claims = {'user_type': 'user'}
    access_token = create_access_token(identity=user.public_id, additional_claims=additional_claims)
    refresh_token = create_refresh_token(identity=user.public_id, additional_claims=additional_claims)

    user_data = UserResponseSchema().dump(user)
    if user.company:
        user_data['company'] = {'id': user.company.public_id, 'name': user.company.name}

    return jsonify({
        'access_token': access_token,
        'refresh_token': refresh_token,
        'user': user_data
    }), 200


@user_bp.route('/refresh', methods=['POST'])
@jwt_required(refresh=True)
def refresh():
    claims = get_jwt()

    if claims.get('user_type') != 'user':
        return jsonify({'code': 'WRONG_USER_TYPE', 'message': 'Unauthorized'}), 403

    public_id = get_jwt_identity()
    user = User.query.filter_by(public_id=public_id).first()
    if not user:
        return jsonify({'message': 'User not found'}), 404

    # DB DateTime columns are naive UTC — strip tzinfo before storing
    old_exp = datetime.fromtimestamp(claims['exp'], tz=timezone.utc).replace(tzinfo=None)
    TokenBlacklist.add_to_blacklist(
        jti=claims['jti'],
        token_type='refresh',
        user_id=public_id,
        user_type='user',
        expires_at=old_exp
    )
    db.session.commit()

    additional_claims = {'user_type': 'user'}
    return jsonify({
        'access_token': create_access_token(identity=user.public_id, additional_claims=additional_claims),
        'refresh_token': create_refresh_token(identity=user.public_id, additional_claims=additional_claims)
    }), 200


@user_bp.route('/logout', methods=['POST'])
@jwt_required()
@user_required
def logout(user):
    claims = get_jwt()

    data = request.get_json(silent=True) or {}
    blacklist_tokens(claims, user.public_id, 'user', refresh_token_raw=data.get('refresh_token'))

    return jsonify({'message': 'Successfully logged out'}), 200


@user_bp.route('/profile', methods=['GET'])
@jwt_required()
@user_required
def get_profile(user):
    return jsonify(UserResponseSchema().dump(user)), 200


@user_bp.route('/profile/change-password', methods=['PUT'])
@jwt_required()
@user_required
def change_password(user):
    data, err = load_schema(ChangePasswordSchema)
    if err: return err

    if not user.check_password(data['old_password']):
        return jsonify({'message': 'Invalid old password'}), 401

    user.set_password(data['new_password'])

    claims = get_jwt()
    public_id = get_jwt_identity()
    blacklist_tokens(claims, public_id, 'user', refresh_token_raw=data.get('refresh_token'))

    db.session.commit()

    return jsonify({'message': 'Password changed successfully. Please login again.'}), 200
