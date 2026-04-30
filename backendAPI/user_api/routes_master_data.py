from flask import jsonify
from flask_jwt_extended import jwt_required
from sqlalchemy.orm import joinedload
from user_api import user_bp
from models import MachineModel, Customer, Setting, Parts
from decorators import user_required
from schemas import MachineModelResponseSchema, CustomerResponseSchema, PartsResponseSchema


@user_bp.route('/master-data', methods=['GET'])
@jwt_required()
@user_required
def get_master_data(user):
    models = MachineModel.query.options(
        joinedload(MachineModel.inspection_items),
    ).filter(MachineModel.company_id == user.company_id).all()

    customers = Customer.query.options(
        joinedload(Customer.creator),
    ).filter(
        Customer.company_id == user.company_id,
    ).limit(5000).all()

    parts = Parts.query.filter(
        Parts.company_id == user.company_id,
        Parts.is_deleted == False,  # noqa: E712
    ).limit(5000).all()

    return jsonify({
        'machine_models': MachineModelResponseSchema().dump(models, many=True),
        'customers': CustomerResponseSchema().dump(customers, many=True),
        'parts': PartsResponseSchema().dump(parts, many=True),
        'settings': {
            'date_format': Setting.get('date_format') or 'YYYY-MM-DD',
        },
    }), 200
