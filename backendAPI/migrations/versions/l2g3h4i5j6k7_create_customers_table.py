"""Create customers table

Revision ID: l2g3h4i5j6k7
Revises: k1f2g3h4i5j6
Create Date: 2026-04-12 10:00:00.000000

"""
from alembic import op
import sqlalchemy as sa


revision = 'l2g3h4i5j6k7'
down_revision = 'k1f2g3h4i5j6'
branch_labels = None
depends_on = None


def upgrade():
    op.create_table(
        'customers',
        sa.Column('id', sa.Integer(), primary_key=True),
        sa.Column('public_id', sa.String(36), unique=True, nullable=False),
        sa.Column('customer_id', sa.String(50), unique=True, nullable=False),
        sa.Column('name', sa.String(200), nullable=False),
        sa.Column('address', sa.Text(), nullable=True),
        sa.Column('created_by', sa.Integer(), sa.ForeignKey('admins.id', ondelete='SET NULL'), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=True),
        sa.Column('updated_at', sa.DateTime(), nullable=True),
    )
    op.create_index('ix_customers_created_by', 'customers', ['created_by'])
    op.create_index('ix_customers_customer_id', 'customers', ['customer_id'])


def downgrade():
    op.drop_index('ix_customers_customer_id', table_name='customers')
    op.drop_index('ix_customers_created_by', table_name='customers')
    op.drop_table('customers')
