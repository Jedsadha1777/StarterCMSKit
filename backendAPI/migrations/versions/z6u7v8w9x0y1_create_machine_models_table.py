"""Create machine_models and join table

Revision ID: z6u7v8w9x0y1
Revises: y5t6u7v8w9x0
Create Date: 2026-04-19 10:00:00.000000

"""
from alembic import op
import sqlalchemy as sa

revision = 'z6u7v8w9x0y1'
down_revision = 'y5t6u7v8w9x0'
branch_labels = None
depends_on = None


def upgrade():
    op.create_table(
        'machine_models',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('public_id', sa.String(length=36), nullable=False),
        sa.Column('model_code', sa.String(length=50), nullable=False),
        sa.Column('model_name', sa.String(length=200), nullable=False),
        sa.Column('company_id', sa.Integer(), nullable=True),
        sa.Column('created_by', sa.Integer(), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=True),
        sa.Column('updated_at', sa.DateTime(), nullable=True),
        sa.ForeignKeyConstraint(['company_id'], ['companies.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['created_by'], ['admins.id'], ondelete='SET NULL'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('public_id'),
        sa.UniqueConstraint('company_id', 'model_code', name='uq_machine_model_company_code'),
    )
    op.create_index('ix_machine_models_company_id', 'machine_models', ['company_id'])
    op.create_index('ix_machine_models_created_by', 'machine_models', ['created_by'])

    op.create_table(
        'machine_model_inspection_items',
        sa.Column('machine_model_id', sa.Integer(), nullable=False),
        sa.Column('inspection_item_id', sa.Integer(), nullable=False),
        sa.ForeignKeyConstraint(['machine_model_id'], ['machine_models.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['inspection_item_id'], ['inspection_items.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('machine_model_id', 'inspection_item_id'),
    )


def downgrade():
    op.drop_table('machine_model_inspection_items')
    op.drop_index('ix_machine_models_created_by', table_name='machine_models')
    op.drop_index('ix_machine_models_company_id', table_name='machine_models')
    op.drop_table('machine_models')
