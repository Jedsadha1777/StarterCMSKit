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


def _column_exists(conn, table, column):
    result = conn.execute(sa.text(
        f"SELECT COUNT(*) FROM information_schema.COLUMNS "
        f"WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = '{table}' AND COLUMN_NAME = '{column}'"
    ))
    return result.scalar() > 0


def _index_exists(conn, table, index):
    result = conn.execute(sa.text(
        f"SELECT COUNT(*) FROM information_schema.STATISTICS "
        f"WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = '{table}' AND INDEX_NAME = '{index}'"
    ))
    return result.scalar() > 0


def upgrade():
    conn = op.get_bind()

    # Add column only if not exists (safe for partial re-run)
    for table in ['admins', 'users']:
        if not _column_exists(conn, table, 'public_id'):
            op.add_column(table, sa.Column('public_id', sa.String(length=36), nullable=True))

    # Backfill rows that still have NULL
    for table in ['admins', 'users']:
        rows = conn.execute(sa.text(f'SELECT id FROM {table} WHERE public_id IS NULL')).fetchall()
        for row in rows:
            conn.execute(
                sa.text(f"UPDATE {table} SET public_id = :pid WHERE id = :id"),
                {'pid': str(uuid4()), 'id': row[0]}
            )

    # Make non-nullable + unique
    op.alter_column('admins', 'public_id', existing_type=sa.String(length=36), nullable=False)
    op.alter_column('users', 'public_id', existing_type=sa.String(length=36), nullable=False)

    if not _index_exists(conn, 'admins', 'idx_admins_public_id'):
        op.create_index('idx_admins_public_id', 'admins', ['public_id'], unique=True)
    if not _index_exists(conn, 'users', 'idx_users_public_id'):
        op.create_index('idx_users_public_id', 'users', ['public_id'], unique=True)


def downgrade():
    op.drop_index('idx_users_public_id', table_name='users')
    op.drop_index('idx_admins_public_id', table_name='admins')
    op.drop_column('users', 'public_id')
    op.drop_column('admins', 'public_id')
