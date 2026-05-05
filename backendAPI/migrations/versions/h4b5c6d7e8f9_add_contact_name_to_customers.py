"""Add contact_name and email to customers

Revision ID: h4b5c6d7e8f9
Revises: g3a4b5c6d7e8
Create Date: 2026-04-30 13:00:00.000000

"""
from alembic import op
import sqlalchemy as sa


revision = 'h4b5c6d7e8f9'
down_revision = 'g3a4b5c6d7e8'
branch_labels = None
depends_on = None


def upgrade():
    op.add_column('customers', sa.Column('contact_name', sa.String(length=200), nullable=True))
    op.add_column('customers', sa.Column('email', sa.String(length=255), nullable=True))


def downgrade():
    op.drop_column('customers', 'email')
    op.drop_column('customers', 'contact_name')
