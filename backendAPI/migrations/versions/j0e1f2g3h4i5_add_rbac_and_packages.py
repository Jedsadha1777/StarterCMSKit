"""Add RBAC (role in admins) and packages system

Revision ID: j0e1f2g3h4i5
Revises: i9d0e1f2g3h4
Create Date: 2026-04-10 12:00:00.000000

"""
from alembic import op
import sqlalchemy as sa


revision = 'j0e1f2g3h4i5'
down_revision = 'i9d0e1f2g3h4'
branch_labels = None
depends_on = None

admin_role_enum = sa.Enum('super_admin', 'admin', 'editor', name='admin_role')


def upgrade():
    # 1. Create packages table
    op.create_table('packages',
        sa.Column('id', sa.Integer(), nullable=False, autoincrement=True),
        sa.Column('name', sa.String(length=50), nullable=False),
        sa.Column('description', sa.String(length=255), nullable=True),
        sa.Column('created_at', sa.DateTime(), server_default=sa.func.now(), nullable=False),
        sa.Column('updated_at', sa.DateTime(), server_default=sa.func.now(), onupdate=sa.func.now(), nullable=False),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('name')
    )

    # 2. Create package_limits table
    op.create_table('package_limits',
        sa.Column('package_id', sa.Integer(), nullable=False),
        sa.Column('resource', sa.String(length=50), nullable=False),
        sa.Column('max_value', sa.Integer(), nullable=False),
        sa.Column('created_at', sa.DateTime(), server_default=sa.func.now(), nullable=False),
        sa.PrimaryKeyConstraint('package_id', 'resource'),
        sa.ForeignKeyConstraint(['package_id'], ['packages.id'], ondelete='CASCADE')
    )

    # 3. Create package_role_permissions table
    op.create_table('package_role_permissions',
        sa.Column('package_id', sa.Integer(), nullable=False),
        sa.Column('role', admin_role_enum, nullable=False),
        sa.Column('resource', sa.String(length=50), nullable=False),
        sa.Column('action', sa.String(length=30), nullable=False),
        sa.Column('created_at', sa.DateTime(), server_default=sa.func.now(), nullable=False),
        sa.PrimaryKeyConstraint('package_id', 'role', 'resource', 'action'),
        sa.ForeignKeyConstraint(['package_id'], ['packages.id'], ondelete='CASCADE')
    )

    # 4. Add role and package_id to admins
    op.add_column('admins', sa.Column('role', admin_role_enum, nullable=False, server_default='admin'))
    op.add_column('admins', sa.Column('package_id', sa.Integer(), nullable=True))
    op.create_foreign_key('fk_admins_package_id', 'admins', 'packages', ['package_id'], ['id'])

    # 5. Migrate admin id=1 to super_admin
    conn = op.get_bind()
    conn.execute(sa.text("UPDATE admins SET role = 'super_admin' WHERE id = 1"))


def downgrade():
    op.drop_constraint('fk_admins_package_id', 'admins', type_='foreignkey')
    op.drop_column('admins', 'package_id')
    op.drop_column('admins', 'role')
    op.drop_table('package_role_permissions')
    op.drop_table('package_limits')
    op.drop_table('packages')
    admin_role_enum.drop(op.get_bind(), checkfirst=True)
