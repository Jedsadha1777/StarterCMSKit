from flask import Blueprint

# Main blueprint for user
user_bp = Blueprint('user', __name__, url_prefix='/user-api')

# Import sub-routes
from user_api import routes_auth, routes_article, routes_sync, routes_report, routes_master_data
