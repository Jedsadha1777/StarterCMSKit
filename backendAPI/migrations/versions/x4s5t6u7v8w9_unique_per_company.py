"""Change unique constraints to per-company uniqueness

Revision ID: x4s5t6u7v8w9
Revises: w3r4s5t6u7v8
Create Date: 2026-04-16 14:00:00.000000

"""
from alembic import op

# revision identifiers, used by Alembic.
revision = 'x4s5t6u7v8w9'
down_revision = 'w3r4s5t6u7v8'
branch_labels = None
depends_on = None


def upgrade():
    # customers: drop global unique on customer_id, add composite unique (customer_id + company_id)
    op.drop_constraint('customer_id', 'customers', type_='unique')
    op.create_unique_constraint('uq_customers_customer_id_company', 'customers', ['customer_id', 'company_id'])

    # inspection_items: drop global unique on item_code, add composite unique (item_code + company_id)
    op.drop_constraint('item_code', 'inspection_items', type_='unique')
    op.create_unique_constraint('uq_inspection_items_item_code_company', 'inspection_items', ['item_code', 'company_id'])


def downgrade():
    op.drop_constraint('uq_inspection_items_item_code_company', 'inspection_items', type_='unique')
    op.create_unique_constraint('item_code', 'inspection_items', ['item_code'])

    op.drop_constraint('uq_customers_customer_id_company', 'customers', type_='unique')
    op.create_unique_constraint('customer_id', 'customers', ['customer_id'])
