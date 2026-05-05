"""Reorder customer columns: name → contact_name → email → address → tel → fax

Revision ID: i5c6d7e8f9g0
Revises: h4b5c6d7e8f9
Create Date: 2026-04-30 14:00:00.000000

MySQL supports physical column reorder via ALTER TABLE ... MODIFY ... AFTER.
This is cosmetic for code/CLI inspection — application logic is unaffected
because all queries reference columns by name, not position.
"""
from alembic import op


revision = 'i5c6d7e8f9g0'
down_revision = 'h4b5c6d7e8f9'
branch_labels = None
depends_on = None


def upgrade():
    # Walk in target order, each MODIFY ... AFTER repositions the column.
    # Final order: ... name → contact_name → email → address → tel → fax → ...
    op.execute("ALTER TABLE customers MODIFY COLUMN contact_name VARCHAR(200) NULL AFTER name")
    op.execute("ALTER TABLE customers MODIFY COLUMN email VARCHAR(255) NULL AFTER contact_name")
    op.execute("ALTER TABLE customers MODIFY COLUMN address TEXT NULL AFTER email")
    op.execute("ALTER TABLE customers MODIFY COLUMN tel VARCHAR(50) NULL AFTER address")
    op.execute("ALTER TABLE customers MODIFY COLUMN fax VARCHAR(50) NULL AFTER tel")


def downgrade():
    # Revert to the order produced by previous migrations:
    # name → tel → fax → contact_name → email (h4 added contact_name + email at end)
    op.execute("ALTER TABLE customers MODIFY COLUMN tel VARCHAR(50) NULL AFTER address")
    op.execute("ALTER TABLE customers MODIFY COLUMN fax VARCHAR(50) NULL AFTER tel")
    op.execute("ALTER TABLE customers MODIFY COLUMN contact_name VARCHAR(200) NULL AFTER fax")
    op.execute("ALTER TABLE customers MODIFY COLUMN email VARCHAR(255) NULL AFTER contact_name")
