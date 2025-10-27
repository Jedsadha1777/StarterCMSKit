import os
from datetime import timedelta
from flask import Flask
from flask_cors import CORS
from dotenv import load_dotenv
from extensions import db, migrate, jwt
from admin_api import admin_bp
from user_api import user_bp

# Load environment variables
load_dotenv()

def create_app():
    app = Flask(__name__)

    # CORS Configuration
    allowed_origins = [origin.strip() for origin in os.getenv('ALLOWED_ORIGINS', 'http://localhost:5000').split(',') if origin.strip()]
    
    CORS(app, 
         resources={
             r"/admin-api/*": {
                 "origins": allowed_origins,
                 "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
                 "allow_headers": ["Content-Type", "Authorization"],
                 "supports_credentials": True,
                 "max_age": 3600
             },
             r"/user-api/*": {
                 "origins": "*",
                 "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
                 "allow_headers": ["Content-Type", "Authorization"],
                 "supports_credentials": False,
                 "max_age": 3600
             }
         })    
    
    
    # Configuration
    app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DATABASE_URL', 'mysql+pymysql://root:root@localhost:8889/cms')
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config['SECRET_KEY'] = os.getenv('SECRET_KEY', 'dev-secret-key')
    
    # JWT Configuration
    app.config['JWT_SECRET_KEY'] = os.getenv('JWT_SECRET_KEY', 'jwt-secret-key')
    app.config['JWT_ACCESS_TOKEN_EXPIRES'] = timedelta(seconds=int(os.getenv('JWT_ACCESS_TOKEN_EXPIRES', 900)))
    app.config['JWT_REFRESH_TOKEN_EXPIRES'] = timedelta(seconds=int(os.getenv('JWT_REFRESH_TOKEN_EXPIRES', 604800)))
    
    # Initialize extensions
    db.init_app(app)
    migrate.init_app(app, db)
    jwt.init_app(app)
    
    # Register blueprints
    app.register_blueprint(admin_bp)
    app.register_blueprint(user_bp)
    
    # Import models to ensure they are registered with SQLAlchemy
    from models import Admin, User, Article, TokenBlacklist
    
    @app.route('/')
    def index():
        return {
            'message': 'Flask API is running',
            'endpoints': {
                'admin': '/admin-api',
                'user': '/user-api'
            },
            'info': 'Admins and Users are in separate tables'
        }
    
    @app.after_request
    def set_security_headers(response):
       response.headers['X-Content-Type-Options'] = 'nosniff'
       response.headers['X-Frame-Options'] = 'DENY'
       response.headers['X-XSS-Protection'] = '1; mode=block'
       return response

    return app

if __name__ == '__main__':
    app = create_app()
    app.run(debug=True)