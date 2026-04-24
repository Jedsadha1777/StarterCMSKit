"""Create parts and parts_consumption tables

Revision ID: d0y1z2a3b4c5
Revises: c9x0y1z2a3b4
Create Date: 2026-04-24 09:00:00.000000

"""
from alembic import op
import sqlalchemy as sa


revision = 'd0y1z2a3b4c5'
down_revision = 'c9x0y1z2a3b4'
branch_labels = None
depends_on = None


def upgrade():
    op.create_table(
        'parts',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('public_id', sa.String(length=36), nullable=False),
        sa.Column('company_id', sa.Integer(), nullable=True),
        sa.Column('parts_code', sa.String(length=100), nullable=False),
        sa.Column('parts_name', sa.String(length=255), nullable=False),
        sa.Column('unit_price', sa.Numeric(12, 2), nullable=False, server_default='0'),
        sa.Column('is_deleted', sa.Boolean(), nullable=False, server_default=sa.text('0')),
        sa.Column('created_by', sa.Integer(), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=True),
        sa.Column('updated_at', sa.DateTime(), nullable=True),
        sa.ForeignKeyConstraint(['company_id'], ['companies.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['created_by'], ['admins.id'], ondelete='SET NULL'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('public_id'),
        sa.UniqueConstraint('company_id', 'parts_code', name='uq_parts_company_code'),
    )
    op.create_index('ix_parts_company_deleted', 'parts', ['company_id', 'is_deleted'])
    op.create_index('ix_parts_company_code', 'parts', ['company_id', 'parts_code'])
    op.create_index('ix_parts_created_by', 'parts', ['created_by'])

    op.create_table(
        'parts_consumption',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('report_id', sa.Integer(), nullable=False),
        sa.Column('company_id', sa.Integer(), nullable=False),
        sa.Column('parts_id', sa.Integer(), nullable=True),
        sa.Column('parts_code', sa.String(length=100), nullable=False),
        sa.Column('parts_name', sa.String(length=255), nullable=False),
        sa.Column('qty', sa.Integer(), nullable=False),
        sa.Column('unit_price', sa.Numeric(12, 2), nullable=False, server_default='0'),
        sa.Column('consumption_dt', sa.Date(), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=True),
        sa.ForeignKeyConstraint(['report_id'], ['reports.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['company_id'], ['companies.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['parts_id'], ['parts.id'], ondelete='SET NULL'),
        sa.PrimaryKeyConstraint('id'),
    )
    # Parts Summary: WHERE company + date range, GROUP BY parts_code
    op.create_index('ix_pc_summary', 'parts_consumption', ['company_id', 'consumption_dt', 'parts_code'])
    # Fetch parts of a specific report / cascade delete
    op.create_index('ix_pc_report', 'parts_consumption', ['report_id'])
    # Parts-by-code drill-down
    op.create_index('ix_pc_bycode', 'parts_consumption', ['company_id', 'parts_code', 'consumption_dt'])


def downgrade():
    op.drop_index('ix_pc_bycode', table_name='parts_consumption')
    op.drop_index('ix_pc_report', table_name='parts_consumption')
    op.drop_index('ix_pc_summary', table_name='parts_consumption')
    op.drop_table('parts_consumption')

    op.drop_index('ix_parts_created_by', table_name='parts')
    op.drop_index('ix_parts_company_code', table_name='parts')
    op.drop_index('ix_parts_company_deleted', table_name='parts')
    op.drop_table('parts')
