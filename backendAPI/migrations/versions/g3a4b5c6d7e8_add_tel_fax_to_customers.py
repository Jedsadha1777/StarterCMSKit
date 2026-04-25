"""Add tel and fax to customers

Revision ID: g3a4b5c6d7e8
Revises: f2a3b4c5d6e7
Create Date: 2026-04-25 10:00:00.000000

"""
from alembic import op
import sqlalchemy as sa


revision = 'g3a4b5c6d7e8'
down_revision = 'f2a3b4c5d6e7'
branch_labels = None
depends_on = None


def upgrade():
    op.add_column('customers', sa.Column('tel', sa.String(length=50), nullable=True))
    op.add_column('customers', sa.Column('fax', sa.String(length=50), nullable=True))


def downgrade():
    op.drop_column('customers', 'fax')
    op.drop_column('customers', 'tel')
