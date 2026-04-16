"""Add company_id to admins, users, and data tables

Revision ID: u1p2q3r4s5t6
Revises: t0o1p2q3r4s5
Create Date: 2026-04-16 10:01:00.000000

"""
from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = 'u1p2q3r4s5t6'
down_revision = 't0o1p2q3r4s5'
branch_labels = None
depends_on = None


def upgrade():
    # Add company_id to admins
    op.add_column('admins', sa.Column('company_id', sa.Integer(), nullable=True))
    op.create_foreign_key('fk_admins_company_id', 'admins', 'companies', ['company_id'], ['id'], ondelete='SET NULL')

    # Add company_id to users
    op.add_column('users', sa.Column('company_id', sa.Integer(), nullable=True))
    op.create_foreign_key('fk_users_company_id', 'users', 'companies', ['company_id'], ['id'], ondelete='SET NULL')

    # Add company_id to customers
    op.add_column('customers', sa.Column('company_id', sa.Integer(), nullable=True))
    op.create_foreign_key('fk_customers_company_id', 'customers', 'companies', ['company_id'], ['id'], ondelete='CASCADE')
    op.create_index('ix_customers_company_id', 'customers', ['company_id'])

    # Add company_id to inspection_items
    op.add_column('inspection_items', sa.Column('company_id', sa.Integer(), nullable=True))
    op.create_foreign_key('fk_inspection_items_company_id', 'inspection_items', 'companies', ['company_id'], ['id'], ondelete='CASCADE')
    op.create_index('ix_inspection_items_company_id', 'inspection_items', ['company_id'])

    # Add company_id to import_histories
    op.add_column('import_histories', sa.Column('company_id', sa.Integer(), nullable=True))
    op.create_foreign_key('fk_import_histories_company_id', 'import_histories', 'companies', ['company_id'], ['id'], ondelete='CASCADE')
    op.create_index('ix_import_histories_company_id', 'import_histories', ['company_id'])

    # Add company_id to articles
    op.add_column('articles', sa.Column('company_id', sa.Integer(), nullable=True))
    op.create_foreign_key('fk_articles_company_id', 'articles', 'companies', ['company_id'], ['id'], ondelete='CASCADE')
    op.create_index('ix_articles_company_id', 'articles', ['company_id'])

    # Migrate existing data:
    # super_admin admins → root company (id=1)
    op.execute("UPDATE admins SET company_id = 1 WHERE role = 'super_admin'")
    # other admins → default tenant company (id=2)
    op.execute("UPDATE admins SET company_id = 2 WHERE role != 'super_admin'")
    # super_admin → admin (role determined by company.parent_id now)
    op.execute("UPDATE admins SET role = 'admin' WHERE role = 'super_admin'")

    # Move all users to default tenant company
    op.execute("UPDATE users SET company_id = 2")

    # Move all data to default tenant company
    op.execute("UPDATE customers SET company_id = 2")
    op.execute("UPDATE inspection_items SET company_id = 2")
    op.execute("UPDATE import_histories SET company_id = 2")
    op.execute("UPDATE articles SET company_id = 2")


def downgrade():
    # Restore super_admin role for root company admins
    op.execute("UPDATE admins SET role = 'super_admin' WHERE company_id = 1")

    op.drop_constraint('fk_articles_company_id', 'articles', type_='foreignkey')
    op.drop_index('ix_articles_company_id', 'articles')
    op.drop_column('articles', 'company_id')

    op.drop_constraint('fk_import_histories_company_id', 'import_histories', type_='foreignkey')
    op.drop_index('ix_import_histories_company_id', 'import_histories')
    op.drop_column('import_histories', 'company_id')

    op.drop_constraint('fk_inspection_items_company_id', 'inspection_items', type_='foreignkey')
    op.drop_index('ix_inspection_items_company_id', 'inspection_items')
    op.drop_column('inspection_items', 'company_id')

    op.drop_constraint('fk_customers_company_id', 'customers', type_='foreignkey')
    op.drop_index('ix_customers_company_id', 'customers')
    op.drop_column('customers', 'company_id')

    op.drop_constraint('fk_users_company_id', 'users', type_='foreignkey')
    op.drop_column('users', 'company_id')

    op.drop_constraint('fk_admins_company_id', 'admins', type_='foreignkey')
    op.drop_column('admins', 'company_id')
