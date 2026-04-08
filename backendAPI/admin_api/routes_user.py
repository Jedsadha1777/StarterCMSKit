from flask import request, jsonify
from flask_jwt_extended import jwt_required
from admin_api import admin_bp
from extensions import db
from models import Admin, User
from decorators import admin_required
from utils import paginate_query, apply_filters, apply_sorting
from datetime import datetime

@admin_bp.route('/users', methods=['GET'])
@jwt_required()
@admin_required
def get_users(_):
    """Get all users"""
    query = User.query

    filters = {
        'name': {'type': 'fuzzy'},
        'email': {'type': 'fuzzy'},
        'created_at': {'type': 'range', 'cast': lambda x: datetime.fromisoformat(x)}
    }

    query = apply_filters(query, User, filters, search_logic='AND')

    query = apply_sorting(
        query,
        User, 
        sortable_fields=['name', 'email', 'created_at', 'updated_at'],
        default_sort='-created_at'
    )

    result = paginate_query(query, default_per_page=10)

    return jsonify({
        'users': [user.to_dict() for user in result['items']],
        'total': result['total'],
        'page': result['page'],
        'per_page': result['per_page'],
        'pages': result['pages']
    }), 200



@admin_bp.route('/users', methods=['POST'])
@jwt_required()
@admin_required
def create_user(_):
    """Create new user"""   
    data = request.get_json()
    
    if not data or not data.get('name') or not data.get('email') or not data.get('password'):
        return jsonify({'message': 'Name, email and password are required'}), 400

    if User.query.filter_by(name=data['name']).first():
        return jsonify({'message': 'Name already taken'}), 400

    if User.query.filter_by(email=data['email']).first():
        return jsonify({'message': 'Email already exists'}), 400

    new_user = User(name=data['name'], email=data['email'])
    new_user.set_password(data['password'])
    
    db.session.add(new_user)
    db.session.commit()
    
    return jsonify(new_user.to_dict()), 201


@admin_bp.route('/users/<user_id>', methods=['GET'])
@jwt_required()
@admin_required
def get_user(_, user_id):
    """Get user by public_id"""
    user = User.query.filter_by(public_id=user_id).first()
    if not user:
        return jsonify({'message': 'User not found'}), 404
    return jsonify(user.to_dict()), 200


@admin_bp.route('/users/<user_id>', methods=['PUT'])
@jwt_required()
@admin_required
def update_user(_, user_id):
    """Update user"""
    user = User.query.filter_by(public_id=user_id).first()
    if not user:
        return jsonify({'message': 'User not found'}), 404

    data = request.get_json()

    if data.get('name'):
        if User.query.filter(User.name == data['name'], User.id != user.id).first():
            return jsonify({'message': 'Name already taken'}), 400
        user.name = data['name']

    if data.get('email'):
        if User.query.filter(User.email == data['email'], User.id != user.id).first():
            return jsonify({'message': 'Email already exists in users'}), 400
        if Admin.query.filter_by(email=data['email']).first():
            return jsonify({'message': 'Email already exists in admins'}), 400
        user.email = data['email']

    if data.get('password'):
        user.set_password(data['password'])

    db.session.commit()
    return jsonify(user.to_dict()), 200


@admin_bp.route('/users/<user_id>', methods=['DELETE'])
@jwt_required()
@admin_required
def delete_user(_, user_id):
    """Delete user"""
    user = User.query.filter_by(public_id=user_id).first()
    if not user:
        return jsonify({'message': 'User not found'}), 404

    db.session.delete(user)
    db.session.commit()
    return jsonify({'message': 'User deleted successfully'}), 200
