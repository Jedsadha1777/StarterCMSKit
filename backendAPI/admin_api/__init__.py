from flask import Blueprint

# สร้าง main blueprint สำหรับ admin
admin_bp = Blueprint('admin', __name__, url_prefix='/admin-api')

# Import sub-routes
from admin_api import routes_auth, routes_article, routes_user
