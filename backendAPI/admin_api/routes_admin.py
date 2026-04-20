from flask import request, jsonify, g
from flask_jwt_extended import jwt_required
from admin_api import admin_bp
from extensions import db
from models import Admin, Article, AdminSession, Package, User
from decorators import admin_required, company_required
from utils import paginate_query, apply_filters, apply_sorting, format_paginated, load_schema, get_or_404_scoped, check_unique
from schemas import AdminCreateSchema, AdminUpdateSchema, AdminResponseSchema, PackageResponseSchema
from session_cache import session_cache
from datetime import datetime, timezone


@admin_bp.route('/packages', methods=['GET'])
@jwt_required()
@admin_required
def get_packages(admin):
    packages = Package.query.order_by(Package.name).all()
    return jsonify({'packages': PackageResponseSchema().dump(packages, many=True)}), 200


@admin_bp.route('/admins', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def get_admins(current_admin):
    query = Admin.query.filter(Admin.company_id == g.active_company.id)

    filters = {
        'name': {'type': 'fuzzy'},
        'email': {'type': 'fuzzy'},
        'created_at': {'type': 'range', 'cast': lambda x: datetime.fromisoformat(x)}
    }

    query = apply_filters(query, Admin, filters, search_logic='AND')
    query = apply_sorting(query, Admin, sortable_fields=['name', 'email', 'created_at'], default_sort='-created_at')
    result = paginate_query(query, default_per_page=10)

    return format_paginated('admins', result, schema=AdminResponseSchema())


@admin_bp.route('/admins', methods=['POST'])
@jwt_required()
@admin_required
@company_required
def create_admin(current_admin):
    if not current_admin.has_permission('admins', 'create'):
        return jsonify({'message': 'Permission denied'}), 403

    data, err = load_schema(AdminCreateSchema)
    if err: return err

    err = check_unique(Admin, 'name', data['name'], company_id=g.active_company.id)
    if err: return err

    err = check_unique(Admin, 'email', data['email'])
    if err: return err

    # ตรวจว่า email ไม่ชนกับ user (cross-table)
    if User.query.filter_by(email=data['email']).first():
        return jsonify({'message': 'Email already used by a user'}), 400

    if data['role'] == 'admin' and not current_admin.is_super_admin:
        return jsonify({'message': 'Only root admin can create admin role'}), 403

    admin = Admin(name=data['name'], email=data['email'], role=data['role'], company_id=g.active_company.id)
    admin.set_password(data['password'])
    db.session.add(admin)
    db.session.commit()

    return jsonify(AdminResponseSchema().dump(admin)), 201


@admin_bp.route('/admins/<admin_id>', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def get_admin(current_admin, admin_id):
    admin, err = get_or_404_scoped(Admin, admin_id, g.active_company)
    if err: return err
    return jsonify(AdminResponseSchema().dump(admin)), 200


@admin_bp.route('/admins/<admin_id>', methods=['PUT'])
@jwt_required()
@admin_required
@company_required
def update_admin(current_admin, admin_id):
    if not current_admin.has_permission('admins', 'edit'):
        return jsonify({'message': 'Permission denied'}), 403

    admin, err = get_or_404_scoped(Admin, admin_id, g.active_company)
    if err: return err

    data, err = load_schema(AdminUpdateSchema)
    if err: return err

    if data.get('name'):
        err = check_unique(Admin, 'name', data['name'], exclude_id=admin.id, company_id=g.active_company.id)
        if err: return err
        admin.name = data['name']

    if data.get('email'):
        err = check_unique(Admin, 'email', data['email'], exclude_id=admin.id)
        if err: return err
        # ตรวจว่า email ไม่ชนกับ user (cross-table)
        if User.query.filter_by(email=data['email']).first():
            return jsonify({'message': 'Email already used by a user'}), 400
        admin.email = data['email']

    if data.get('password'):
        admin.set_password(data['password'])

    if data.get('role'):
        if data['role'] == 'admin' and not current_admin.is_super_admin:
            return jsonify({'message': 'Only root admin can assign admin role'}), 403
        admin.role = data['role']

    db.session.commit()
    return jsonify(AdminResponseSchema().dump(admin)), 200


@admin_bp.route('/admins/<admin_id>', methods=['DELETE'])
@jwt_required()
@admin_required
@company_required
def delete_admin(current_admin, admin_id):
    if not current_admin.has_permission('admins', 'delete'):
        return jsonify({'message': 'Permission denied'}), 403

    admin, err = get_or_404_scoped(Admin, admin_id, g.active_company)
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
    data = request.get_json(silent=True)
    if not data or not data.get('password'):
        return jsonify({'message': 'password is required'}), 400

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
