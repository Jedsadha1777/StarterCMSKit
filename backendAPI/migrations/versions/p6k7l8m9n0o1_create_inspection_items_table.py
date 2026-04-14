"""Create inspection_items table

Revision ID: p6k7l8m9n0o1
Revises: n4i5j6k7l8m9
Create Date: 2026-04-13 10:00:00.000000

"""
from alembic import op
import sqlalchemy as sa


revision = 'p6k7l8m9n0o1'
down_revision = 'n4i5j6k7l8m9'
branch_labels = None
depends_on = None


def upgrade():
    op.create_table(
        'inspection_items',
        sa.Column('id', sa.Integer(), primary_key=True),
        sa.Column('public_id', sa.String(36), unique=True, nullable=False),
        sa.Column('item_code', sa.String(50), unique=True, nullable=False),
        sa.Column('item_name', sa.String(200), nullable=False),
        sa.Column('spec', sa.Text(), nullable=True),
        sa.Column('created_by', sa.Integer(), sa.ForeignKey('admins.id', ondelete='SET NULL'), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=True),
        sa.Column('updated_at', sa.DateTime(), nullable=True),
    )
    op.create_index('ix_inspection_items_created_by', 'inspection_items', ['created_by'])
    op.create_index('ix_inspection_items_item_code', 'inspection_items', ['item_code'])


def downgrade():
    op.drop_index('ix_inspection_items_item_code', table_name='inspection_items')
    op.drop_index('ix_inspection_items_created_by', table_name='inspection_items')
    op.drop_table('inspection_items')
