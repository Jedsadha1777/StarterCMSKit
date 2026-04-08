"""Add admin_sessions table

Revision ID: c3d4e5f6a7b8
Revises: b2c3d4e5f6a7
Create Date: 2026-04-08 14:00:00.000000

"""
from alembic import op
import sqlalchemy as sa


revision = 'c3d4e5f6a7b8'
down_revision = 'a1b2c3d4e5f6'
branch_labels = None
depends_on = None


def upgrade():
    op.create_table('admin_sessions',
        sa.Column('id', sa.String(length=36), nullable=False),
        sa.Column('admin_id', sa.Integer(), nullable=False),
        sa.Column('refresh_token_hash', sa.String(length=255), nullable=False),
        sa.Column('token_family', sa.String(length=36), nullable=False),
        sa.Column('is_used', sa.Boolean(), server_default='0'),
        sa.Column('used_at', sa.DateTime(), nullable=True),
        sa.Column('status', sa.String(length=20), server_default='active'),
        sa.Column('grace_until', sa.DateTime(), nullable=True),
        sa.Column('replaced_by_session_id', sa.String(length=36), nullable=True),
        sa.Column('ip_address', sa.String(length=45), nullable=True),
        sa.Column('user_agent', sa.String(length=255), nullable=True),
        sa.Column('created_at', sa.DateTime(), server_default=sa.text('CURRENT_TIMESTAMP')),
        sa.Column('last_active_at', sa.DateTime(), server_default=sa.text('CURRENT_TIMESTAMP')),
        sa.ForeignKeyConstraint(['admin_id'], ['admins.id']),
        sa.ForeignKeyConstraint(['replaced_by_session_id'], ['admin_sessions.id']),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index('idx_admin_status', 'admin_sessions', ['admin_id', 'status'])
    op.create_index('idx_family', 'admin_sessions', ['token_family'])

    # Generated column: enforce max 1 active session per admin at DB level
    # NULL when not active → MySQL UNIQUE allows multiple NULLs
    op.execute("""
        ALTER TABLE admin_sessions
        ADD COLUMN active_admin_id INT AS (CASE WHEN status = 'active' THEN admin_id ELSE NULL END) STORED,
        ADD UNIQUE INDEX idx_one_active_per_admin (active_admin_id)
    """)


def downgrade():
    op.drop_index('idx_one_active_per_admin', table_name='admin_sessions')
    op.execute("ALTER TABLE admin_sessions DROP COLUMN active_admin_id")
    op.drop_index('idx_family', table_name='admin_sessions')
    op.drop_index('idx_admin_status', table_name='admin_sessions')
    op.drop_table('admin_sessions')
