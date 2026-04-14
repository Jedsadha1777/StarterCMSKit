"""Alter inspection_item spec from TEXT to VARCHAR(255)

Revision ID: r8m9n0o1p2q3
Revises: q7l8m9n0o1p2
Create Date: 2026-04-13 10:30:00.000000

"""
from alembic import op
import sqlalchemy as sa


revision = 'r8m9n0o1p2q3'
down_revision = 'q7l8m9n0o1p2'
branch_labels = None
depends_on = None


def upgrade():
    op.alter_column('inspection_items', 'spec',
                     existing_type=sa.Text(),
                     type_=sa.String(255),
                     existing_nullable=True)


def downgrade():
    op.alter_column('inspection_items', 'spec',
                     existing_type=sa.String(255),
                     type_=sa.Text(),
                     existing_nullable=True)
