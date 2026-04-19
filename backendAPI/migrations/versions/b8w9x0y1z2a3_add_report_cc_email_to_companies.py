"""Add report_cc_email to companies

Revision ID: b8w9x0y1z2a3
Revises: a7v8w9x0y1z2
Create Date: 2026-04-19 10:02:00.000000

"""
from alembic import op
import sqlalchemy as sa

revision = 'b8w9x0y1z2a3'
down_revision = 'a7v8w9x0y1z2'
branch_labels = None
depends_on = None


def upgrade():
    op.add_column('companies', sa.Column('report_cc_email', sa.String(length=255), nullable=True))


def downgrade():
    op.drop_column('companies', 'report_cc_email')
