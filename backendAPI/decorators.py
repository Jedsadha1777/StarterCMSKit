from functools import wraps
from flask import jsonify
from flask_jwt_extended import get_jwt_identity, get_jwt
from models import Admin, User

def admin_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        claims = get_jwt()
        
        if claims.get('user_type') != 'admin':
            return jsonify({'message': 'Unauthorized'}), 403
        
        current_admin_id = get_jwt_identity()
        admin = Admin.query.get(current_admin_id)
        
        if not admin:
            return jsonify({'message': 'Admin not found'}), 404
        
        return f(admin, *args, **kwargs)
    return decorated_function

def user_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        claims = get_jwt()
        
        if claims.get('user_type') != 'user':
            return jsonify({'message': 'Unauthorized'}), 403
        
        current_user_id = get_jwt_identity()
        user = User.query.get(current_user_id)
        
        if not user:
            return jsonify({'message': 'User not found'}), 404
        
        return f(user, *args, **kwargs)
    return decorated_function