"""Remove package_id from admins

Revision ID: v2q3r4s5t6u7
Revises: u1p2q3r4s5t6
Create Date: 2026-04-16 10:02:00.000000

"""
from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = 'v2q3r4s5t6u7'
down_revision = 'u1p2q3r4s5t6'
branch_labels = None
depends_on = None


def upgrade():
    op.drop_constraint('fk_admins_package_id', 'admins', type_='foreignkey')
    op.drop_column('admins', 'package_id')


def downgrade():
    op.add_column('admins', sa.Column('package_id', sa.Integer(), nullable=True))
    op.create_foreign_key('fk_admins_package_id', 'admins', 'packages', ['package_id'], ['id'])
