"""Add version and soft delete to articles

Revision ID: d4e5f6a7b8c9
Revises: c3d4e5f6a7b8
Create Date: 2026-04-08 16:00:00.000000

"""
from alembic import op
import sqlalchemy as sa


revision = 'd4e5f6a7b8c9'
down_revision = 'c3d4e5f6a7b8'
branch_labels = None
depends_on = None


def upgrade():
    op.add_column('articles', sa.Column('version', sa.Integer(), nullable=False, server_default='1'))
    op.add_column('articles', sa.Column('is_deleted', sa.Boolean(), nullable=False, server_default='0'))
    op.create_index('idx_articles_updated_at', 'articles', ['updated_at'])


def downgrade():
    op.drop_index('idx_articles_updated_at', table_name='articles')
    op.drop_column('articles', 'is_deleted')
    op.drop_column('articles', 'version')
