"""Seed default package with role permissions and limits

Revision ID: k1f2g3h4i5j6
Revises: j0e1f2g3h4i5
Create Date: 2026-04-10 12:30:00.000000

"""
from alembic import op
import sqlalchemy as sa


revision = 'k1f2g3h4i5j6'
down_revision = 'j0e1f2g3h4i5'
branch_labels = None
depends_on = None


def upgrade():
    conn = op.get_bind()

    # 1. Default package
    conn.execute(sa.text(
        "INSERT INTO packages (id, name, description) VALUES (1, 'default', 'Default package')"
    ))

    # 2. Package limits
    limits = [
        ('articles', 50),
        ('users', 20),
    ]
    for resource, max_val in limits:
        conn.execute(sa.text(
            "INSERT INTO package_limits (package_id, resource, max_value) VALUES (:p, :r, :m)"
        ), {'p': 1, 'r': resource, 'm': max_val})

    # 3. Role permissions — admin: manage articles, users, admins (no settings)
    admin_perms = [
        ('articles', 'view'),
        ('articles', 'create'),
        ('articles', 'edit'),
        ('articles', 'delete'),
        ('articles', 'publish'),
        ('users', 'view'),
        ('users', 'create'),
        ('users', 'edit'),
        ('users', 'delete'),
        ('admins', 'view'),
        ('admins', 'create'),
        ('admins', 'edit'),
        ('admins', 'delete'),
    ]
    for resource, action in admin_perms:
        conn.execute(sa.text(
            "INSERT INTO package_role_permissions (package_id, role, resource, action) "
            "VALUES (:p, :r, :res, :a)"
        ), {'p': 1, 'r': 'admin', 'res': resource, 'a': action})

    # 4. Role permissions — editor: articles only
    editor_perms = [
        ('articles', 'view'),
        ('articles', 'create'),
        ('articles', 'edit'),
    ]
    for resource, action in editor_perms:
        conn.execute(sa.text(
            "INSERT INTO package_role_permissions (package_id, role, resource, action) "
            "VALUES (:p, :r, :res, :a)"
        ), {'p': 1, 'r': 'editor', 'res': resource, 'a': action})

    # 5. Assign default package to all non-super_admin admins
    conn.execute(sa.text("UPDATE admins SET package_id = 1 WHERE role != 'super_admin'"))


def downgrade():
    conn = op.get_bind()
    conn.execute(sa.text("UPDATE admins SET package_id = NULL"))
    conn.execute(sa.text("DELETE FROM package_role_permissions WHERE package_id = 1"))
    conn.execute(sa.text("DELETE FROM package_limits WHERE package_id = 1"))
    conn.execute(sa.text("DELETE FROM packages WHERE id = 1"))
