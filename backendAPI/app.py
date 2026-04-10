import os
import click
from uuid import uuid4
from datetime import datetime, timedelta
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
    db_url = os.getenv('DATABASE_URL')
    if not db_url:
        raise RuntimeError('DATABASE_URL must be set in environment variables')
    app.config['SQLALCHEMY_DATABASE_URI'] = db_url
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
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
    
    # Register blueprints
    app.register_blueprint(admin_bp)
    app.register_blueprint(user_bp)
    
    # Import models to ensure they are registered with SQLAlchemy
    from models import Admin, User, Article, TokenBlacklist, Summary, AdminSession, Setting
    
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

    @app.cli.command('seed')
    @click.option('--name', default='Admin', help='Admin name')
    @click.option('--email', default='admin@admin.com', help='Admin email')
    @click.option('--password', default='admin', help='Admin password')
    def seed(name, email, password):
        """Create initial admin user."""
        from models import Admin
        if Admin.query.filter_by(email=email).first():
            click.echo(f'Admin "{email}" already exists, skipping.')
            return
        admin = Admin(name=name, email=email)
        admin.set_password(password)
        db.session.add(admin)
        db.session.commit()
        click.echo(f'Admin created — name: {name}, email: {email}')

    @app.cli.command('backfill')
    def backfill():
        """Backfill public_id (UUID v4) for existing rows that have NULL."""
        from models import Admin, User, Article
        count = 0
        for model in [Admin, User, Article]:
            rows = model.query.filter(
                (model.public_id == None) | (model.public_id == '')
            ).all()
            for row in rows:
                row.public_id = str(uuid4())
                count += 1
            click.echo(f'{model.__tablename__}: {len(rows)} rows backfilled')
        db.session.commit()
        click.echo(f'Done — {count} total rows updated')

    @app.cli.command('cleanup')
    def cleanup():
        """Clean up expired sessions and blacklist entries."""
        cutoff = datetime.utcnow() - timedelta(days=7)

        # Revoked admin sessions > 7 days
        count = AdminSession.query.filter(
            AdminSession.status == 'revoked',
            AdminSession.created_at < cutoff
        ).delete()
        click.echo(f'Deleted {count} revoked admin sessions')

        # Expired grace period → revoke
        updated = AdminSession.query.filter(
            AdminSession.status == 'grace_period',
            AdminSession.grace_until < datetime.utcnow()
        ).update({'status': 'revoked'})
        click.echo(f'Revoked {updated} expired grace sessions')

        # Expired blacklist entries > 7 days
        bl_count = TokenBlacklist.query.filter(
            TokenBlacklist.expires_at < cutoff
        ).delete()
        click.echo(f'Deleted {bl_count} expired blacklist entries')

        db.session.commit()
        click.echo('Cleanup complete')

    return app

if __name__ == '__main__':
    app = create_app()
    app.run(debug=True, threaded=True)