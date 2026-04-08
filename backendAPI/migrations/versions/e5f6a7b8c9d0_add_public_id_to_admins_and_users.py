"""Add public_id to admins and users

Revision ID: e5f6a7b8c9d0
Revises: d4e5f6a7b8c9
Create Date: 2026-04-08 18:00:00.000000

"""
from alembic import op
import sqlalchemy as sa
from uuid import uuid4


revision = 'e5f6a7b8c9d0'
down_revision = 'd4e5f6a7b8c9'
branch_labels = None
depends_on = None


def upgrade():
    # Add column (nullable first)
    op.add_column('admins', sa.Column('public_id', sa.String(length=36), nullable=True))
    op.add_column('users', sa.Column('public_id', sa.String(length=36), nullable=True))

    # Backfill existing rows with UUIDs
    conn = op.get_bind()
    for table in ['admins', 'users']:
        rows = conn.execute(sa.text(f'SELECT id FROM {table}')).fetchall()
        for row in rows:
            conn.execute(
                sa.text(f"UPDATE {table} SET public_id = :pid WHERE id = :id"),
                {'pid': str(uuid4()), 'id': row[0]}
            )

    # Make non-nullable + unique
    op.alter_column('admins', 'public_id', nullable=False)
    op.alter_column('users', 'public_id', nullable=False)
    op.create_index('idx_admins_public_id', 'admins', ['public_id'], unique=True)
    op.create_index('idx_users_public_id', 'users', ['public_id'], unique=True)


def downgrade():
    op.drop_index('idx_users_public_id', table_name='users')
    op.drop_index('idx_admins_public_id', table_name='admins')
    op.drop_column('users', 'public_id')
    op.drop_column('admins', 'public_id')
