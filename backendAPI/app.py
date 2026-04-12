import os
from datetime import timedelta
from flask import Flask
from flask_cors import CORS
from dotenv import load_dotenv
from extensions import db, migrate, jwt, limiter
from admin_api import admin_bp
from user_api import user_bp
from commands import register_commands

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
    db_url = os.getenv('DATABASE_URL')
    if not db_url:
        raise RuntimeError('DATABASE_URL must be set in environment variables')
    app.config['SQLALCHEMY_DATABASE_URI'] = db_url
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config['MAX_CONTENT_LENGTH'] = 5 * 1024 * 1024  # 5 MB upload limit
    secret_key = os.getenv('SECRET_KEY')
    jwt_secret = os.getenv('JWT_SECRET_KEY')
    if not secret_key or not jwt_secret:
        raise RuntimeError('SECRET_KEY and JWT_SECRET_KEY must be set in environment variables')

    app.config['SECRET_KEY'] = secret_key

    # JWT Configuration
    app.config['JWT_SECRET_KEY'] = jwt_secret
    app.config['JWT_ACCESS_TOKEN_EXPIRES'] = timedelta(seconds=int(os.getenv('JWT_ACCESS_TOKEN_EXPIRES', 900)))
    app.config['JWT_REFRESH_TOKEN_EXPIRES'] = timedelta(seconds=int(os.getenv('JWT_REFRESH_TOKEN_EXPIRES', 604800)))
    
    # Initialize extensions
    db.init_app(app)
    migrate.init_app(app, db)
    jwt.init_app(app)
    limiter.init_app(app)
    
    # Register blueprints
    app.register_blueprint(admin_bp)
    app.register_blueprint(user_bp)
    
    # Import models to ensure they are registered with SQLAlchemy
    from models import Admin, User, Article, TokenBlacklist, Summary, AdminSession, Setting, Customer, ImportHistory
    
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
        response.headers['Content-Security-Policy'] = "default-src 'self'"
        response.headers['Strict-Transport-Security'] = 'max-age=63072000; includeSubDomains'
        response.headers['Referrer-Policy'] = 'strict-origin-when-cross-origin'
        return response

    register_commands(app)

    return app

if __name__ == '__main__':
    app = create_app()
    app.run(debug=True, threaded=True)