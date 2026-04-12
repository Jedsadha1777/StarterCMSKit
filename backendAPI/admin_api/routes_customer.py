from flask import request, jsonify
from flask_jwt_extended import jwt_required
from admin_api import admin_bp
from extensions import db
from sqlalchemy.orm import joinedload
from models import Customer
from decorators import admin_required
from utils import paginate_query, apply_filters, apply_sorting, format_paginated, validate_required, validate_alphanumeric, get_or_404, check_unique
from datetime import datetime


@admin_bp.route('/customers', methods=['GET'])
@jwt_required()
@admin_required
def get_customers(admin):
    query = Customer.query.options(joinedload(Customer.creator))

    filters = {
        'customer_id': {'type': 'fuzzy'},
        'name': {'type': 'fuzzy'},
        'address': {'type': 'fuzzy'},
        'created_at': {'type': 'range', 'cast': lambda x: datetime.fromisoformat(x)},
    }

    query = apply_filters(query, Customer, filters, search_logic='AND')
    query = apply_sorting(query, Customer, sortable_fields=['customer_id', 'name', 'created_at', 'updated_at'], default_sort='-created_at')
    result = paginate_query(query, default_per_page=10)

    return format_paginated('customers', result)


@admin_bp.route('/customers', methods=['POST'])
@jwt_required()
@admin_required
def create_customer(admin):
    if not admin.has_permission('customers', 'create'):
        return jsonify({'message': 'Permission denied'}), 403

    data = request.get_json()

    err = validate_required(data, ['customer_id', 'name'])
    if err: return err

    err = validate_alphanumeric(data['customer_id'], 'Customer ID')
    if err: return err

    err = check_unique(Customer, 'customer_id', data['customer_id'])
    if err: return err

    customer = Customer(
        customer_id=data['customer_id'],
        name=data['name'],
        address=data.get('address', ''),
        created_by=admin.id,
    )

    db.session.add(customer)
    db.session.commit()

    return jsonify(customer.to_dict()), 201


@admin_bp.route('/customers/<customer_public_id>', methods=['GET'])
@jwt_required()
@admin_required
def get_customer(admin, customer_public_id):
    customer, err = get_or_404(Customer, customer_public_id)
    if err: return err
    return jsonify(customer.to_dict()), 200


@admin_bp.route('/customers/<customer_public_id>', methods=['PUT'])
@jwt_required()
@admin_required
def update_customer(admin, customer_public_id):
    if not admin.has_permission('customers', 'edit'):
        return jsonify({'message': 'Permission denied'}), 403

    customer, err = get_or_404(Customer, customer_public_id)
    if err: return err

    data = request.get_json()

    if data.get('customer_id'):
        err = validate_alphanumeric(data['customer_id'], 'Customer ID')
        if err: return err
        err = check_unique(Customer, 'customer_id', data['customer_id'], exclude_id=customer.id)
        if err: return err
        customer.customer_id = data['customer_id']

    if data.get('name'):
        customer.name = data['name']

    if 'address' in data:
        customer.address = data['address']

    db.session.commit()

    return jsonify(customer.to_dict()), 200


@admin_bp.route('/customers/<customer_public_id>', methods=['DELETE'])
@jwt_required()
@admin_required
def delete_customer(admin, customer_public_id):
    if not admin.has_permission('customers', 'delete'):
        return jsonify({'message': 'Permission denied'}), 403

    customer, err = get_or_404(Customer, customer_public_id)
    if err: return err

    db.session.delete(customer)
    db.session.commit()

    return jsonify({'message': 'Customer deleted successfully'}), 200
