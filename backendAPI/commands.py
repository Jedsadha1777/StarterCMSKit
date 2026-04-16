import click
from uuid import uuid4
from datetime import datetime, timedelta, timezone
from extensions import db


def register_commands(app):

    @app.cli.command('seed')
    @click.option('--name',     default='Admin',           help='Admin name')
    @click.option('--email',    default='admin',           help='Admin email')
    @click.option('--password', default='admin',           help='Admin password')
    @click.option('--role',     default='admin',           help='Admin role: admin | editor')
    @click.option('--root',     is_flag=True,              help='Place admin in root company (super_admin)')
    def seed(name, email, password, role, root):
        """Seed initial admin user and default settings."""
        from models import Admin, Company, Setting
        from models.admin import AdminRole

        # --- Admin ---
        if Admin.query.filter_by(email=email).first():
            click.echo(f'Admin "{email}" already exists, skipping.')
        else:
            try:
                admin_role = AdminRole(role)
            except ValueError:
                click.echo(f'Invalid role "{role}". Use: admin, editor')
                return

            if root:
                company = Company.query.filter_by(parent_id=0).first()
            else:
                company = Company.query.filter(Company.parent_id > 0).first()

            admin = Admin(name=name, email=email, role=admin_role, company_id=company.id if company else None)
            admin.set_password(password)
            db.session.add(admin)
            db.session.commit()
            company_name = company.name if company else 'None'
            click.echo(f'Admin created — name: {name}, email: {email}, role: {role}, company: {company_name}')

        # --- Settings ---
        seeded = 0
        for key, value in Setting.DEFAULTS.items():
            if not Setting.query.get(key):
                db.session.add(Setting(key=key, value=value))
                seeded += 1
        if seeded:
            db.session.commit()
            click.echo(f'Settings seeded — {seeded} default(s) added.')
        else:
            click.echo('Settings already exist, skipping.')

    @app.cli.command('backfill')
    def backfill():
        """Backfill public_id (UUID v4) for existing rows that have NULL."""
        from models import Admin, User, Article
        count = 0
        for model in [Admin, User, Article]:
            rows = model.query.filter(
                model.public_id.is_(None) | (model.public_id == '')
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
        from models import AdminSession, TokenBlacklist
        from config import CLEANUP_CUTOFF_DAYS
        cutoff = datetime.now(timezone.utc).replace(tzinfo=None) - timedelta(days=CLEANUP_CUTOFF_DAYS)

        count = AdminSession.query.filter(
            AdminSession.status == 'revoked',
            AdminSession.created_at < cutoff
        ).delete()
        click.echo(f'Deleted {count} revoked admin sessions')

        updated = AdminSession.query.filter(
            AdminSession.status == 'grace_period',
            AdminSession.grace_until < datetime.now(timezone.utc).replace(tzinfo=None)
        ).update({'status': 'revoked'})
        click.echo(f'Revoked {updated} expired grace sessions')

        bl_count = TokenBlacklist.cleanup_expired()
        click.echo(f'Deleted {bl_count} expired blacklist entries')
        click.echo('Cleanup complete')
