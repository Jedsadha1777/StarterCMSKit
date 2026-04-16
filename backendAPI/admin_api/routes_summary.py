from flask import jsonify, g
from flask_jwt_extended import jwt_required
from admin_api import admin_bp
from models import Customer, InspectionItem, Article, User, Admin
from decorators import admin_required, company_required


@admin_bp.route('/summary', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def get_summary(admin):
    company_id = g.active_company.id
    return jsonify({
        'articles': Article.query.filter_by(company_id=company_id).count(),
        'users': User.query.filter_by(company_id=company_id).count(),
        'admins': Admin.query.filter_by(company_id=company_id).count(),
        'customers': Customer.query.filter_by(company_id=company_id).count(),
        'inspection_items': InspectionItem.query.filter_by(company_id=company_id).count(),
    }), 200
