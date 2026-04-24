from flask import request, jsonify, g
from flask_jwt_extended import jwt_required
from admin_api import admin_bp
from extensions import db
from models import Admin, User
from decorators import admin_required, company_required
from utils import paginate_query, apply_filters, apply_sorting, format_paginated, load_schema, get_or_404_scoped, check_unique
from schemas import UserCreateSchema, UserUpdateSchema, UserResponseSchema
from datetime import datetime


@admin_bp.route('/users', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def get_users(admin):
    query = User.query.filter(User.company_id == g.active_company.id)

    filters = {
        'name': {'type': 'fuzzy'},
        'email': {'type': 'fuzzy'},
        'created_at': {'type': 'range', 'cast': lambda x: datetime.fromisoformat(x)}
    }

    query = apply_filters(query, User, filters, search_logic='AND')
    query = apply_sorting(query, User, sortable_fields=['name', 'email', 'created_at', 'updated_at'], default_sort='-created_at')
    result = paginate_query(query, default_per_page=10)

    return format_paginated('users', result, schema=UserResponseSchema())


@admin_bp.route('/users', methods=['POST'])
@jwt_required()
@admin_required
@company_required
def create_user(current_admin):
    if not current_admin.has_permission('users', 'create'):
        return jsonify({'message': 'Permission denied'}), 403

    current_count = User.query.filter(User.company_id == g.active_company.id).count()
    if not current_admin.check_limit('users', current_count):
        return jsonify({'message': 'User limit reached for your package'}), 403

    data, err = load_schema(UserCreateSchema)
    if err: return err

    err = check_unique(User, 'name', data['name'], company_id=g.active_company.id)
    if err: return err

    err = check_unique(User, 'email', data['email'])
    if err: return err

    # ตรวจว่า email ไม่ชนกับ admin (cross-table)
    from models import Admin
    if Admin.query.filter_by(email=data['email']).first():
        return jsonify({'message': 'Email already used by an admin'}), 400

    new_user = User(name=data['name'], email=data['email'], company_id=g.active_company.id)
    new_user.set_password(data['password'])
    db.session.add(new_user)
    db.session.commit()

    return jsonify(UserResponseSchema().dump(new_user)), 201


@admin_bp.route('/users/<user_id>', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def get_user(admin, user_id):
    user, err = get_or_404_scoped(User, user_id, g.active_company)
    if err: return err
    return jsonify(UserResponseSchema().dump(user)), 200


@admin_bp.route('/users/<user_id>', methods=['PUT'])
@jwt_required()
@admin_required
@company_required
def update_user(current_admin, user_id):
    if not current_admin.has_permission('users', 'edit'):
        return jsonify({'message': 'Permission denied'}), 403

    user, err = get_or_404_scoped(User, user_id, g.active_company)
    if err: return err

    data, err = load_schema(UserUpdateSchema)
    if err: return err

    if data.get('name'):
        err = check_unique(User, 'name', data['name'], exclude_id=user.id, company_id=g.active_company.id)
        if err: return err
        user.name = data['name']

    if data.get('email'):
        err = check_unique(User, 'email', data['email'], exclude_id=user.id)
        if err: return err
        err = check_unique(Admin, 'email', data['email'])
        if err: return err
        user.email = data['email']

    if data.get('password'):
        user.set_password(data['password'])

    db.session.commit()
    return jsonify(UserResponseSchema().dump(user)), 200


@admin_bp.route('/users/<user_id>', methods=['DELETE'])
@jwt_required()
@admin_required
@company_required
def delete_user(current_admin, user_id):
    if not current_admin.has_permission('users', 'delete'):
        return jsonify({'message': 'Permission denied'}), 403

    user, err = get_or_404_scoped(User, user_id, g.active_company)
    if err: return err

    db.session.delete(user)
    db.session.commit()
    return jsonify({'message': 'User deleted successfully'}), 200
