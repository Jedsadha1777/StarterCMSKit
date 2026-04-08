from flask import Blueprint

# Main blueprint for admin
admin_bp = Blueprint('admin', __name__, url_prefix='/admin-api')

# Import sub-routes
from admin_api import routes_auth, routes_article, routes_user, routes_admin, routes_summary
