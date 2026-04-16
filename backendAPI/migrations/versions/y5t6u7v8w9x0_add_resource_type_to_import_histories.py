"""Add resource_type to import_histories

Revision ID: y5t6u7v8w9x0
Revises: x4s5t6u7v8w9
Create Date: 2026-04-16 16:00:00.000000

"""
from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = 'y5t6u7v8w9x0'
down_revision = 'x4s5t6u7v8w9'
branch_labels = None
depends_on = None


def upgrade():
    op.add_column('import_histories', sa.Column('resource_type', sa.String(length=50), nullable=False, server_default=''))


def downgrade():
    op.drop_column('import_histories', 'resource_type')
