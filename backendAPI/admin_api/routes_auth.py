from flask import request, jsonify
from flask_jwt_extended import (
    create_access_token, create_refresh_token,
    jwt_required, get_jwt_identity, get_jwt
)
from admin_api import admin_bp
from extensions import db
from models import Admin, TokenBlacklist
from decorators import admin_required
from datetime import datetime, timedelta
import os

@admin_bp.route('/login', methods=['POST'])
def login():
    """Admin login endpoint"""
    data = request.get_json()
    
    if not data or not data.get('email') or not data.get('password'):
        return jsonify({'message': 'Email and password are required'}), 400
    
    admin = Admin.query.filter_by(email=data['email']).first()
    
    if not admin or not admin.check_password(data['password']):
        return jsonify({'message': 'Invalid email or password'}), 401
    
    # create tokens
    additional_claims = {'user_type': 'admin'}
    access_token = create_access_token(identity=str(admin.id), additional_claims=additional_claims)
    refresh_token = create_refresh_token(identity=str(admin.id), additional_claims=additional_claims)
    
    return jsonify({
        'access_token': access_token,
        'refresh_token': refresh_token,
        'admin': admin.to_dict()
    }), 200


@admin_bp.route('/forgot-password', methods=['POST'])
def forgot_password():
    """Admin forgot password endpoint"""
    data = request.get_json()
    
    if not data or not data.get('email'):
        return jsonify({'message': 'Email is required'}), 400
    
    admin = Admin.query.filter_by(email=data['email']).first()
    
    # TODO: Implement email sending logic here
    return jsonify({'message': 'If this email exists, a reset link will be sent'}), 200


@admin_bp.route('/refresh', methods=['POST'])
@jwt_required(refresh=True)
def refresh():
    """Refresh access token endpoint - แบบ rotating refresh token"""
    current_admin_id = get_jwt_identity()
    claims = get_jwt()

    if claims.get('user_type') != 'admin':
        return jsonify({'message': 'Unauthorized'}), 403
    
    admin = Admin.query.get(current_admin_id)
    
    if not admin:
        return jsonify({'message': 'Admin not found'}), 404
    
    # old refresh token to blacklist
    old_jti = claims['jti']
    old_exp = datetime.fromtimestamp(claims['exp'])
    
    TokenBlacklist.add_to_blacklist(
        jti=old_jti,
        token_type='refresh',
        user_id=current_admin_id,
        user_type='admin',
        expires_at=old_exp
    )

    # Cleanup token (5% chance)
    import random
    if random.randint(1, 20) == 1:
       try:
           cutoff = datetime.utcnow() - timedelta(days=30)
           deleted = TokenBlacklist.query.filter(
               TokenBlacklist.expires_at < cutoff
           ).delete()
           db.session.commit()
       except:
           db.session.rollback()
    
    # create new tokens (rotating refresh token)
    additional_claims = {'user_type': 'admin'}
    new_access_token = create_access_token(identity=current_admin_id, additional_claims=additional_claims)
    new_refresh_token = create_refresh_token(identity=current_admin_id, additional_claims=additional_claims)
    
    return jsonify({
        'access_token': new_access_token,
        'refresh_token': new_refresh_token
    }), 200


@admin_bp.route('/logout', methods=['POST'])
@jwt_required()
def logout():
    """Logout endpoint - revoke ทั้ง access และ refresh tokens"""
    claims = get_jwt()
    jti = claims['jti']
    token_type = claims['type']
    user_id = get_jwt_identity()
    user_type = claims.get('user_type', 'admin')
    exp = datetime.fromtimestamp(claims['exp'])
    
    # เพิ่ม token เข้า blacklist
    TokenBlacklist.add_to_blacklist(
        jti=jti,
        token_type=token_type,
        user_id=user_id,
        user_type=user_type,
        expires_at=exp
    )
    
    return jsonify({'message': 'Successfully logged out'}), 200


@admin_bp.route('/profile', methods=['GET'])
@jwt_required()
@admin_required 
def get_profile(admin):
    """Get admin profile"""    
    return jsonify(admin.to_dict()), 200


@admin_bp.route('/profile/change-password', methods=['PUT'])
@jwt_required()
@admin_required
def change_password(admin):
    """Change admin password"""    
    data = request.get_json()
    
    if not data or not data.get('old_password') or not data.get('new_password'):
        return jsonify({'message': 'Old password and new password are required'}), 400
    
    if not admin.check_password(data['old_password']):
        return jsonify({'message': 'Invalid old password'}), 401
    
    admin.set_password(data['new_password'])
    db.session.commit()
    
    return jsonify({'message': 'Password changed successfully'}), 200