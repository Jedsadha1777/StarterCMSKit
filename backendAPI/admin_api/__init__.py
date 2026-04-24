from flask import Blueprint

# Main blueprint for admin
admin_bp = Blueprint('admin', __name__, url_prefix='/admin-api')

# Import sub-routes
from admin_api import routes_auth, routes_article, routes_user, routes_admin, routes_summary, routes_settings, routes_customer, routes_inspection_item, routes_company, routes_machine_model, routes_report, routes_parts, routes_parts_summary
