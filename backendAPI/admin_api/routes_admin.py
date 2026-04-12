from flask import request, jsonify
from flask_jwt_extended import jwt_required
from admin_api import admin_bp
from extensions import db
from models import Admin, AdminRole, Article, AdminSession
from decorators import admin_required
from utils import paginate_query, apply_filters, apply_sorting, format_paginated, validate_required, validate_password, get_or_404, check_unique
from session_cache import session_cache
from datetime import datetime, timezone


@admin_bp.route('/admins', methods=['GET'])
@jwt_required()
@admin_required
def get_admins(current_admin):
    query = Admin.query
    if not current_admin.has_permission('super_admin', 'view'):
        query = query.filter(Admin.role != AdminRole.SUPER_ADMIN)

    filters = {
        'name': {'type': 'fuzzy'},
        'email': {'type': 'fuzzy'},
        'created_at': {'type': 'range', 'cast': lambda x: datetime.fromisoformat(x)}
    }

    query = apply_filters(query, Admin, filters, search_logic='AND')
    query = apply_sorting(query, Admin, sortable_fields=['name', 'email', 'created_at'], default_sort='-created_at')
    result = paginate_query(query, default_per_page=10)

    return format_paginated('admins', result)


@admin_bp.route('/admins', methods=['POST'])
@jwt_required()
@admin_required
def create_admin(current_admin):
    if not current_admin.has_permission('admins', 'create'):
        return jsonify({'message': 'Permission denied'}), 403

    data = request.get_json()

    err = validate_required(data, ['name', 'email', 'password'])
    if err: return err

    err = check_unique(Admin, 'name', data['name'])
    if err: return err

    err = check_unique(Admin, 'email', data['email'])
    if err: return err

    err = validate_password(data['password'])
    if err: return err

    admin = Admin(name=data['name'], email=data['email'])
    admin.set_password(data['password'])
    db.session.add(admin)
    db.session.commit()

    return jsonify(admin.to_dict()), 201


@admin_bp.route('/admins/<admin_id>', methods=['GET'])
@jwt_required()
@admin_required
def get_admin(current_admin, admin_id):
    admin, err = get_or_404(Admin, admin_id)
    if err: return err
    return jsonify(admin.to_dict()), 200


@admin_bp.route('/admins/<admin_id>', methods=['PUT'])
@jwt_required()
@admin_required
def update_admin(current_admin, admin_id):
    if not current_admin.has_permission('admins', 'edit'):
        return jsonify({'message': 'Permission denied'}), 403

    admin, err = get_or_404(Admin, admin_id)
    if err: return err

    data = request.get_json()

    if data.get('name'):
        err = check_unique(Admin, 'name', data['name'], exclude_id=admin.id)
        if err: return err
        admin.name = data['name']

    if data.get('email'):
        err = check_unique(Admin, 'email', data['email'], exclude_id=admin.id)
        if err: return err
        admin.email = data['email']

    if data.get('password'):
        err = validate_password(data['password'])
        if err: return err
        admin.set_password(data['password'])

    db.session.commit()
    return jsonify(admin.to_dict()), 200


@admin_bp.route('/admins/<admin_id>', methods=['DELETE'])
@jwt_required()
@admin_required
def delete_admin(current_admin, admin_id):
    if not current_admin.has_permission('admins', 'delete'):
        return jsonify({'message': 'Permission denied'}), 403

    admin, err = get_or_404(Admin, admin_id)
    if err: return err

    if current_admin.id == admin.id:
        return jsonify({'message': 'Cannot delete your own account. Use the Profile page instead.'}), 400

    if Admin.query.count() <= 1:
        return jsonify({'message': 'At least one admin is required. Cannot delete.'}), 400

    Article.query.filter_by(admin_id=admin.id).update({'admin_id': None})
    db.session.delete(admin)
    db.session.commit()
    return jsonify({'message': 'Admin deleted successfully'}), 200


@admin_bp.route('/profile/delete-account', methods=['POST'])
@jwt_required()
@admin_required
def delete_own_account(admin):
    data = request.get_json()

    err = validate_required(data, ['password'])
    if err: return err

    if not admin.check_password(data['password']):
        return jsonify({'message': 'Invalid password'}), 401

    if Admin.query.count() <= 1:
        return jsonify({'message': 'At least one admin is required. Cannot delete.'}), 400

    sessions = AdminSession.query.filter(
        AdminSession.admin_id == admin.id,
        AdminSession.status.in_(['active', 'grace_period'])
    ).all()
    for s in sessions:
        s.status = 'revoked'
        session_cache.invalidate(s.id)

    Article.query.filter_by(admin_id=admin.id).update({'admin_id': None})
    db.session.delete(admin)
    db.session.commit()
    return jsonify({'message': 'Account deleted successfully'}), 200
