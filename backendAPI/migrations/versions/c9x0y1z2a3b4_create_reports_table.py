"""Create reports and report_counters tables + seed report permissions

Revision ID: c9x0y1z2a3b4
Revises: b8w9x0y1z2a3
Create Date: 2026-04-19 10:03:00.000000

"""
from alembic import op
import sqlalchemy as sa

revision = 'c9x0y1z2a3b4'
down_revision = 'b8w9x0y1z2a3'
branch_labels = None
depends_on = None


def upgrade():
    op.create_table(
        'report_counters',
        sa.Column('company_id', sa.Integer(), nullable=False),
        sa.Column('year', sa.Integer(), nullable=False),
        sa.Column('last_seq', sa.Integer(), nullable=False, server_default='0'),
        sa.ForeignKeyConstraint(['company_id'], ['companies.id']),
        sa.PrimaryKeyConstraint('company_id', 'year'),
    )

    op.create_table(
        'reports',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('public_id', sa.String(length=36), nullable=False),
        sa.Column('report_no', sa.String(length=50), nullable=False),
        sa.Column('form_data', sa.JSON(), nullable=False),
        sa.Column('machine_model_id', sa.Integer(), nullable=True),
        sa.Column('customer_id', sa.Integer(), nullable=True),
        sa.Column('serial_no', sa.String(length=100), nullable=True),
        sa.Column('inspector_name', sa.String(length=200), nullable=True),
        sa.Column('user_id', sa.Integer(), nullable=True),
        sa.Column('company_id', sa.Integer(), nullable=True),
        sa.Column('status', sa.String(length=20), nullable=False, server_default='submitted'),
        sa.Column('inspected_at', sa.DateTime(), nullable=True),
        sa.Column('sent_at', sa.DateTime(), nullable=True),
        sa.Column('email_recipients', sa.JSON(), nullable=True),
        sa.Column('pdf_path', sa.String(length=500), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=True),
        sa.Column('updated_at', sa.DateTime(), nullable=True),
        sa.ForeignKeyConstraint(['machine_model_id'], ['machine_models.id']),
        sa.ForeignKeyConstraint(['customer_id'], ['customers.id']),
        sa.ForeignKeyConstraint(['user_id'], ['users.id']),
        sa.ForeignKeyConstraint(['company_id'], ['companies.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('public_id'),
        sa.UniqueConstraint('company_id', 'report_no', name='uq_report_company_no'),
    )
    op.create_index('ix_reports_company_id', 'reports', ['company_id'])

    # Seed report permissions
    conn = op.get_bind()

    admin_perms = [
        ('reports', 'view'),
        ('reports', 'create'),
        ('reports', 'edit'),
        ('reports', 'delete'),
    ]
    for resource, action in admin_perms:
        conn.execute(sa.text(
            "INSERT INTO package_role_permissions (package_id, role, resource, action) "
            "VALUES (:p, :r, :res, :a)"
        ), {'p': 1, 'r': 'admin', 'res': resource, 'a': action})

    editor_perms = [
        ('reports', 'view'),
    ]
    for resource, action in editor_perms:
        conn.execute(sa.text(
            "INSERT INTO package_role_permissions (package_id, role, resource, action) "
            "VALUES (:p, :r, :res, :a)"
        ), {'p': 1, 'r': 'editor', 'res': resource, 'a': action})

    conn.execute(sa.text(
        "INSERT INTO package_limits (package_id, resource, max_value) VALUES (:p, :r, :m)"
    ), {'p': 1, 'r': 'reports', 'm': -1})


def downgrade():
    conn = op.get_bind()
    conn.execute(sa.text(
        "DELETE FROM package_role_permissions WHERE resource = 'reports' AND package_id = 1"
    ))
    conn.execute(sa.text(
        "DELETE FROM package_limits WHERE resource = 'reports' AND package_id = 1"
    ))

    op.drop_index('ix_reports_company_id', table_name='reports')
    op.drop_table('reports')
    op.drop_table('report_counters')
