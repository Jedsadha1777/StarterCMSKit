"""Create companies table

Revision ID: t0o1p2q3r4s5
Revises: s9n0o1p2q3r4
Create Date: 2026-04-16 10:00:00.000000

"""
from alembic import op
import sqlalchemy as sa
from uuid import uuid4

# revision identifiers, used by Alembic.
revision = 't0o1p2q3r4s5'
down_revision = 's9n0o1p2q3r4'
branch_labels = None
depends_on = None


def upgrade():
    op.create_table('companies',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('public_id', sa.String(length=36), nullable=False),
        sa.Column('name', sa.String(length=200), nullable=False),
        sa.Column('parent_id', sa.Integer(), nullable=False, server_default='0'),
        sa.Column('package_id', sa.Integer(), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=True),
        sa.Column('updated_at', sa.DateTime(), nullable=True),
        sa.ForeignKeyConstraint(['package_id'], ['packages.id'], ondelete='SET NULL'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('public_id')
    )

    # Seed root company (platform owner)
    op.execute(
        f"INSERT INTO companies (public_id, name, parent_id, package_id, created_at, updated_at) "
        f"VALUES ('{uuid4()}', 'Platform', 0, NULL, NOW(), NOW())"
    )

    # Seed default tenant company
    op.execute(
        f"INSERT INTO companies (public_id, name, parent_id, package_id, created_at, updated_at) "
        f"VALUES ('{uuid4()}', 'Default Company', 1, 1, NOW(), NOW())"
    )


def downgrade():
    op.drop_table('companies')
