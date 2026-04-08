from flask import request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from admin_api import admin_bp
from extensions import db
from models import Admin
from decorators import admin_required
from utils import paginate_query, apply_filters, apply_sorting
from datetime import datetime


@admin_bp.route('/admins', methods=['GET'])
@jwt_required()
@admin_required
def get_admins(_):
    """Get all admins"""
    query = Admin.query

    filters = {
        'name': {'type': 'fuzzy'},
        'email': {'type': 'fuzzy'},
        'created_at': {'type': 'range', 'cast': lambda x: datetime.fromisoformat(x)}
    }

    query = apply_filters(query, Admin, filters, search_logic='AND')
    query = apply_sorting(query, Admin, sortable_fields=['name', 'email', 'created_at'], default_sort='-created_at')
    result = paginate_query(query, default_per_page=10)

    return jsonify({
        'admins': [a.to_dict() for a in result['items']],
        'total': result['total'],
        'page': result['page'],
        'per_page': result['per_page'],
        'pages': result['pages']
    }), 200


@admin_bp.route('/admins', methods=['POST'])
@jwt_required()
@admin_required
def create_admin(_):
    """Create new admin"""
    data = request.get_json()

    if not data or not data.get('name') or not data.get('email') or not data.get('password'):
        return jsonify({'message': 'Name, email and password are required'}), 400

    if Admin.query.filter_by(name=data['name']).first():
        return jsonify({'message': 'Name already taken'}), 400

    if Admin.query.filter_by(email=data['email']).first():
        return jsonify({'message': 'Email already exists'}), 400

    admin = Admin(name=data['name'], email=data['email'])
    admin.set_password(data['password'])
    db.session.add(admin)
    db.session.commit()

    return jsonify(admin.to_dict()), 201


@admin_bp.route('/admins/<admin_id>', methods=['GET'])
@jwt_required()
@admin_required
def get_admin(_, admin_id):
    """Get admin by public_id"""
    admin = Admin.query.filter_by(public_id=admin_id).first()
    if not admin:
        return jsonify({'message': 'Admin not found'}), 404
    return jsonify(admin.to_dict()), 200


@admin_bp.route('/admins/<admin_id>', methods=['PUT'])
@jwt_required()
@admin_required
def update_admin(_, admin_id):
    """Update admin"""
    admin = Admin.query.filter_by(public_id=admin_id).first()
    if not admin:
        return jsonify({'message': 'Admin not found'}), 404

    data = request.get_json()

    if data.get('name'):
        if Admin.query.filter(Admin.name == data['name'], Admin.id != admin.id).first():
            return jsonify({'message': 'Name already taken'}), 400
        admin.name = data['name']

    if data.get('email'):
        if Admin.query.filter(Admin.email == data['email'], Admin.id != admin.id).first():
            return jsonify({'message': 'Email already exists'}), 400
        admin.email = data['email']

    if data.get('password'):
        admin.set_password(data['password'])

    db.session.commit()
    return jsonify(admin.to_dict()), 200


@admin_bp.route('/admins/<admin_id>', methods=['DELETE'])
@jwt_required()
@admin_required
def delete_admin(current_admin, admin_id):
    """Delete other admin (cannot delete self, must keep at least 1)"""
    admin = Admin.query.filter_by(public_id=admin_id).first()
    if not admin:
        return jsonify({'message': 'Admin not found'}), 404

    if current_admin.id == admin.id:
        return jsonify({'message': 'Cannot delete your own account. Use the Profile page instead.'}), 400

    if Admin.query.count() <= 1:
        return jsonify({'message': 'At least one admin is required. Cannot delete.'}), 400

    db.session.delete(admin)
    db.session.commit()
    return jsonify({'message': 'Admin deleted successfully'}), 200


@admin_bp.route('/profile/delete-account', methods=['POST'])
@jwt_required()
@admin_required
def delete_own_account(admin):
    """Delete own account — requires password confirmation, must keep at least 1 admin"""
    data = request.get_json()

    if not data or not data.get('password'):
        return jsonify({'message': 'Password is required'}), 400

    if not admin.check_password(data['password']):
        return jsonify({'message': 'Invalid password'}), 401

    if Admin.query.count() <= 1:
        return jsonify({'message': 'At least one admin is required. Cannot delete.'}), 400

    # Revoke all sessions
    from models import AdminSession
    from session_cache import session_cache
    sessions = AdminSession.query.filter(
        AdminSession.admin_id == admin.id,
        AdminSession.status.in_(['active', 'grace_period'])
    ).all()
    for s in sessions:
        s.status = 'revoked'
        session_cache.invalidate(s.id)

    db.session.delete(admin)
    db.session.commit()
    return jsonify({'message': 'Account deleted successfully'}), 200
