"""Add summary table and triggers

Revision ID: a1b2c3d4e5f6
Revises: 4df6f39ec76b
Create Date: 2026-04-07 12:00:00.000000

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'a1b2c3d4e5f6'
down_revision = '4df6f39ec76b'
branch_labels = None
depends_on = None

# Tables to track
TRACKED_TABLES = ['admins', 'users', 'articles']


def upgrade():
    # 1) Create summary table
    op.create_table('summary',
        sa.Column('table_name', sa.String(length=64), nullable=False),
        sa.Column('row_count', sa.Integer(), nullable=False, server_default='0'),
        sa.Column('updated_at', sa.DateTime(), server_default=sa.text('CURRENT_TIMESTAMP')),
        sa.PrimaryKeyConstraint('table_name')
    )

    # 2) Seed initial counts from existing data
    for table in TRACKED_TABLES:
        op.execute(
            f"INSERT INTO summary (table_name, row_count) "
            f"SELECT '{table}', COUNT(*) FROM `{table}`"
        )

    # 3) Create triggers for each tracked table
    for table in TRACKED_TABLES:
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

    op.drop_table('summary')
