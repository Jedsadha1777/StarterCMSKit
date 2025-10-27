from flask import request, jsonify
from flask_jwt_extended import (
    create_access_token, create_refresh_token,
    jwt_required, get_jwt_identity, get_jwt
)
from user_api import user_bp
from extensions import db
from models import User, TokenBlacklist
from decorators import user_required
from datetime import datetime

@user_bp.route('/login', methods=['POST'])
def login():
    """User login endpoint"""
    data = request.get_json()
    
    if not data or not data.get('email') or not data.get('password'):
        return jsonify({'message': 'Email and password are required'}), 400
    
    user = User.query.filter_by(email=data['email']).first()
    
    if not user or not user.check_password(data['password']):
        return jsonify({'message': 'Invalid email or password'}), 401
    
    # user_type in JWT claims
    additional_claims = {'user_type': 'user'}
    access_token = create_access_token(identity=str(user.id), additional_claims=additional_claims)
    refresh_token = create_refresh_token(identity=str(user.id), additional_claims=additional_claims)
    
    return jsonify({
        'access_token': access_token,
        'refresh_token': refresh_token,
        'user': user.to_dict()
    }), 200


@user_bp.route('/refresh', methods=['POST'])
@jwt_required(refresh=True)
def refresh():
    """Refresh access token endpoint"""
    current_user_id = get_jwt_identity()
    claims = get_jwt()
    
    # is user
    if claims.get('user_type') != 'user':
        return jsonify({'message': 'Unauthorized'}), 403
    
    user = User.query.get(current_user_id)
    
    if not user:
        return jsonify({'message': 'User not found'}), 404
    
    # add old refresh token to blacklist
    old_jti = claims['jti']
    old_exp = datetime.fromtimestamp(claims['exp'])
    
    TokenBlacklist.add_to_blacklist(
        jti=old_jti,
        token_type='refresh',
        user_id=current_user_id,
        user_type='user',
        expires_at=old_exp
    )
    
    # create new tokens (rotating refresh token)
    additional_claims = {'user_type': 'user'}
    new_access_token = create_access_token(identity=current_user_id, additional_claims=additional_claims)
    new_refresh_token = create_refresh_token(identity=current_user_id, additional_claims=additional_claims)
    
    return jsonify({
        'access_token': new_access_token,
        'refresh_token': new_refresh_token
    }), 200


@user_bp.route('/logout', methods=['POST'])
@jwt_required()
def logout():
    """Logout endpoint - revoke token"""
    claims = get_jwt()
    jti = claims['jti']
    token_type = claims['type']
    user_id = get_jwt_identity()
    user_type = claims.get('user_type', 'user')
    exp = datetime.fromtimestamp(claims['exp'])
    
    # add token to blacklist
    TokenBlacklist.add_to_blacklist(
        jti=jti,
        token_type=token_type,
        user_id=user_id,
        user_type=user_type,
        expires_at=exp
    )
    
    return jsonify({'message': 'Successfully logged out'}), 200


@user_bp.route('/profile', methods=['GET'])
@jwt_required()
@user_required 
def get_profile(user):
    """Get user profile"""    
    return jsonify(user.to_dict()), 200


@user_bp.route('/profile/change-password', methods=['PUT'])
@jwt_required()
@user_required
def change_password(user):
    """Change user password"""    
    data = request.get_json()
    
    if not data or not data.get('old_password') or not data.get('new_password'):
        return jsonify({'message': 'Old password and new password are required'}), 400
    
    if not user.check_password(data['old_password']):
        return jsonify({'message': 'Invalid old password'}), 401
    
    user.set_password(data['new_password'])
    db.session.commit()
    
    return jsonify({'message': 'Password changed successfully'}), 200