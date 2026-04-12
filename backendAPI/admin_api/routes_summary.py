from flask import jsonify
from flask_jwt_extended import jwt_required
from admin_api import admin_bp
from models import Summary
from decorators import admin_required


@admin_bp.route('/summary', methods=['GET'])
@jwt_required()
@admin_required
def get_summary(admin):
    """Get dashboard summary counts from pre-computed summary table."""
    rows = Summary.query.all()
    counts = {row.table_name: row.row_count for row in rows}

    return jsonify({
        'articles': counts.get('articles', 0),
        'users': counts.get('users', 0),
        'admins': counts.get('admins', 0),
    }), 200
