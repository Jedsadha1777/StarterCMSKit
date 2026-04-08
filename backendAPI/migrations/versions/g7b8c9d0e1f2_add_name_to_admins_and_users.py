"""Add name to admins and users

Revision ID: g7b8c9d0e1f2
Revises: f6a7b8c9d0e1
Create Date: 2026-04-08 20:00:00.000000

"""
from alembic import op
import sqlalchemy as sa


revision = 'g7b8c9d0e1f2'
down_revision = 'f6a7b8c9d0e1'
branch_labels = None
depends_on = None


def upgrade():
    op.add_column('admins', sa.Column('name', sa.String(length=100), nullable=False, server_default=''))
    op.add_column('users', sa.Column('name', sa.String(length=100), nullable=False, server_default=''))

    # Backfill: set name = email prefix (before @) for existing rows
    conn = op.get_bind()
    conn.execute(sa.text("UPDATE admins SET name = SUBSTRING_INDEX(email, '@', 1) WHERE name = ''"))
    conn.execute(sa.text("UPDATE users SET name = SUBSTRING_INDEX(email, '@', 1) WHERE name = ''"))


def downgrade():
    op.drop_column('users', 'name')
    op.drop_column('admins', 'name')
