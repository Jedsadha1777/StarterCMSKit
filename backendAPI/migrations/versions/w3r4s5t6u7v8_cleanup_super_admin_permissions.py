"""Cleanup super_admin rows from package_role_permissions

Revision ID: w3r4s5t6u7v8
Revises: v2q3r4s5t6u7
Create Date: 2026-04-16 12:30:00.000000

"""
from alembic import op

# revision identifiers, used by Alembic.
revision = 'w3r4s5t6u7v8'
down_revision = 'v2q3r4s5t6u7'
branch_labels = None
depends_on = None


def upgrade():
    op.execute("DELETE FROM package_role_permissions WHERE role = 'super_admin'")


def downgrade():
    pass
