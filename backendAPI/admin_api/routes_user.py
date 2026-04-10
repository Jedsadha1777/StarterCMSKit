from flask import request, jsonify
from flask_jwt_extended import jwt_required
from admin_api import admin_bp
from extensions import db
from models import Admin, User
from decorators import admin_required
from utils import paginate_query, apply_filters, apply_sorting, format_paginated, validate_required, validate_password, get_or_404, check_unique
from datetime import datetime


@admin_bp.route('/users', methods=['GET'])
@jwt_required()
@admin_required
def get_users(_):
    query = User.query

    filters = {
        'name': {'type': 'fuzzy'},
        'email': {'type': 'fuzzy'},
        'created_at': {'type': 'range', 'cast': lambda x: datetime.fromisoformat(x)}
    }

    query = apply_filters(query, User, filters, search_logic='AND')
    query = apply_sorting(query, User, sortable_fields=['name', 'email', 'created_at', 'updated_at'], default_sort='-created_at')
    result = paginate_query(query, default_per_page=10)

    return format_paginated('users', result)


@admin_bp.route('/users', methods=['POST'])
@jwt_required()
@admin_required
def create_user(current_admin):
    if not current_admin.has_permission('users', 'create'):
        return jsonify({'message': 'Permission denied'}), 403

    data = request.get_json()

    err = validate_required(data, ['name', 'email', 'password'])
    if err: return err

    err = check_unique(User, 'name', data['name'])
    if err: return err

    err = check_unique(User, 'email', data['email'])
    if err: return err

    err = validate_password(data['password'])
    if err: return err

    new_user = User(name=data['name'], email=data['email'])
    new_user.set_password(data['password'])
    db.session.add(new_user)
    db.session.commit()

    return jsonify(new_user.to_dict()), 201


@admin_bp.route('/users/<user_id>', methods=['GET'])
@jwt_required()
@admin_required
def get_user(_, user_id):
    user, err = get_or_404(User, user_id)
    if err: return err
    return jsonify(user.to_dict()), 200


@admin_bp.route('/users/<user_id>', methods=['PUT'])
@jwt_required()
@admin_required
def update_user(current_admin, user_id):
    if not current_admin.has_permission('users', 'edit'):
        return jsonify({'message': 'Permission denied'}), 403

    user, err = get_or_404(User, user_id)
    if err: return err

    data = request.get_json()

    if data.get('name'):
        err = check_unique(User, 'name', data['name'], exclude_id=user.id)
        if err: return err
        user.name = data['name']

    if data.get('email'):
        err = check_unique(User, 'email', data['email'], exclude_id=user.id)
        if err: return err
        err = check_unique(Admin, 'email', data['email'])
        if err: return err
        user.email = data['email']

    if data.get('password'):
        err = validate_password(data['password'])
        if err: return err
        user.set_password(data['password'])

    db.session.commit()
    return jsonify(user.to_dict()), 200


@admin_bp.route('/users/<user_id>', methods=['DELETE'])
@jwt_required()
@admin_required
def delete_user(current_admin, user_id):
    if not current_admin.has_permission('users', 'delete'):
        return jsonify({'message': 'Permission denied'}), 403

    user, err = get_or_404(User, user_id)
    if err: return err

    db.session.delete(user)
    db.session.commit()
    return jsonify({'message': 'User deleted successfully'}), 200
