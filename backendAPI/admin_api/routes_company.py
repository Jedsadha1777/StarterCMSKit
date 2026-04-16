from flask import request, jsonify
from flask_jwt_extended import jwt_required
from admin_api import admin_bp
from extensions import db
from models import Company, Package
from decorators import admin_required
from utils import load_schema, get_or_404
from schemas import CompanyCreateSchema, CompanyUpdateSchema, CompanyResponseSchema


@admin_bp.route('/companies', methods=['GET'])
@jwt_required()
@admin_required
def get_companies(admin):
    if admin.is_super_admin:
        companies = Company.query.filter(Company.parent_id > 0).order_by(Company.name).all()
    else:
        companies = [admin.company] if admin.company else []

    return jsonify({'companies': CompanyResponseSchema().dump(companies, many=True)}), 200


@admin_bp.route('/companies/accessible', methods=['GET'])
@jwt_required()
@admin_required
def get_accessible_companies(admin):
    if admin.is_super_admin:
        companies = Company.query.filter(Company.parent_id == admin.company.id).order_by(Company.name).all()
    else:
        companies = [admin.company] if admin.company else []

    return jsonify({'companies': [{'id': c.id, 'name': c.name} for c in companies]}), 200


@admin_bp.route('/companies', methods=['POST'])
@jwt_required()
@admin_required
def create_company(admin):
    if not admin.is_super_admin:
        return jsonify({'message': 'Permission denied'}), 403

    data, err = load_schema(CompanyCreateSchema)
    if err: return err

    package_id = data.get('package_id')
    if package_id:
        package = Package.query.get(package_id)
        if not package:
            return jsonify({'message': 'Package not found'}), 400

    company = Company(
        name=data['name'],
        parent_id=admin.company.id,
        package_id=package_id,
    )
    db.session.add(company)
    db.session.commit()

    return jsonify(CompanyResponseSchema().dump(company)), 201


@admin_bp.route('/companies/<company_public_id>', methods=['GET'])
@jwt_required()
@admin_required
def get_company(admin, company_public_id):
    company, err = get_or_404(Company, company_public_id, label='Company')
    if err: return err

    if not admin.is_super_admin and (not admin.company or admin.company.id != company.id):
        return jsonify({'message': 'Permission denied'}), 403

    return jsonify(CompanyResponseSchema().dump(company)), 200


@admin_bp.route('/companies/<company_public_id>', methods=['PUT'])
@jwt_required()
@admin_required
def update_company(admin, company_public_id):
    if not admin.is_super_admin:
        return jsonify({'message': 'Permission denied'}), 403

    company, err = get_or_404(Company, company_public_id, label='Company')
    if err: return err

    if company.is_root:
        return jsonify({'message': 'Cannot edit root company'}), 400

    data, err = load_schema(CompanyUpdateSchema)
    if err: return err

    if data.get('name'):
        company.name = data['name']

    if 'package_id' in data:
        if data['package_id']:
            package = Package.query.get(data['package_id'])
            if not package:
                return jsonify({'message': 'Package not found'}), 400
            company.package_id = package.id
        else:
            company.package_id = None

    db.session.commit()
    return jsonify(CompanyResponseSchema().dump(company)), 200


@admin_bp.route('/companies/<company_public_id>', methods=['DELETE'])
@jwt_required()
@admin_required
def delete_company(admin, company_public_id):
    if not admin.is_super_admin:
        return jsonify({'message': 'Permission denied'}), 403

    company, err = get_or_404(Company, company_public_id, label='Company')
    if err: return err

    if company.is_root:
        return jsonify({'message': 'Cannot delete root company'}), 400

    db.session.delete(company)
    db.session.commit()

    return jsonify({'message': 'Company deleted successfully'}), 200
