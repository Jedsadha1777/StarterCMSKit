from flask import Blueprint

# สร้าง main blueprint สำหรับ user
user_bp = Blueprint('user', __name__, url_prefix='/user-api')

# Import sub-routes
from user_api import routes_auth, routes_article
