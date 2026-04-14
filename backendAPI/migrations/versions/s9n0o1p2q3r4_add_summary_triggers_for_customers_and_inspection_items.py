"""Add summary triggers for customers and inspection_items

Revision ID: s9n0o1p2q3r4
Revises: r8m9n0o1p2q3
Create Date: 2026-04-13 11:00:00.000000

"""
from alembic import op
import sqlalchemy as sa


revision = 's9n0o1p2q3r4'
down_revision = 'r8m9n0o1p2q3'
branch_labels = None
depends_on = None

TRACKED_TABLES = ['customers', 'inspection_items']


def upgrade():
    for table in TRACKED_TABLES:
        op.execute(
            f"INSERT INTO summary (table_name, row_count) "
            f"SELECT '{table}', COUNT(*) FROM `{table}`"
        )

        op.execute(f"""
            CREATE TRIGGER trg_{table}_after_insert
            AFTER INSERT ON `{table}`
            FOR EACH ROW
            UPDATE summary SET row_count = row_count + 1, updated_at = NOW()
            WHERE table_name = '{table}'
        """)

        op.execute(f"""
            CREATE TRIGGER trg_{table}_after_delete
            AFTER DELETE ON `{table}`
            FOR EACH ROW
            UPDATE summary SET row_count = row_count - 1, updated_at = NOW()
            WHERE table_name = '{table}'
        """)


def downgrade():
    for table in TRACKED_TABLES:
        op.execute(f"DROP TRIGGER IF EXISTS trg_{table}_after_insert")
        op.execute(f"DROP TRIGGER IF EXISTS trg_{table}_after_delete")
        op.execute(f"DELETE FROM summary WHERE table_name = '{table}'")
