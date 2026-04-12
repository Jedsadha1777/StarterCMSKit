"""Create import_histories table

Revision ID: n4i5j6k7l8m9
Revises: m3h4i5j6k7l8
Create Date: 2026-04-12 11:00:00.000000

"""
from alembic import op
import sqlalchemy as sa


revision = 'n4i5j6k7l8m9'
down_revision = 'm3h4i5j6k7l8'
branch_labels = None
depends_on = None


def upgrade():
    op.create_table(
        'import_histories',
        sa.Column('id', sa.Integer(), primary_key=True),
        sa.Column('public_id', sa.String(36), unique=True, nullable=False),
        sa.Column('original_filename', sa.String(255), nullable=False),
        sa.Column('stored_filename', sa.String(255), nullable=False),
        sa.Column('imported_by', sa.Integer(), sa.ForeignKey('admins.id', ondelete='SET NULL'), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=True),
    )
    op.create_index('ix_import_histories_imported_by', 'import_histories', ['imported_by'])


def downgrade():
    op.drop_index('ix_import_histories_imported_by', table_name='import_histories')
    op.drop_table('import_histories')
