"""Add status and publish_date to articles

Revision ID: h8c9d0e1f2g3
Revises: g7b8c9d0e1f2
Create Date: 2026-04-08 21:00:00.000000

"""
from alembic import op
import sqlalchemy as sa


revision = 'h8c9d0e1f2g3'
down_revision = 'g7b8c9d0e1f2'
branch_labels = None
depends_on = None


def upgrade():
    op.add_column('articles', sa.Column('status', sa.String(length=20), nullable=False, server_default='draft'))
    op.add_column('articles', sa.Column('publish_date', sa.DateTime(), nullable=True))
    op.create_index('idx_articles_status', 'articles', ['status'])


def downgrade():
    op.drop_index('idx_articles_status', table_name='articles')
    op.drop_column('articles', 'publish_date')
    op.drop_column('articles', 'status')
