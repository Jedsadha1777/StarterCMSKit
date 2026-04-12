"""Seed customer permissions for default package

Revision ID: m3h4i5j6k7l8
Revises: l2g3h4i5j6k7
Create Date: 2026-04-12 10:01:00.000000

"""
from alembic import op
import sqlalchemy as sa


revision = 'm3h4i5j6k7l8'
down_revision = 'l2g3h4i5j6k7'
branch_labels = None
depends_on = None


def upgrade():
    conn = op.get_bind()

    # Admin role: full CRUD on customers
    admin_perms = [
        ('customers', 'view'),
        ('customers', 'create'),
        ('customers', 'edit'),
        ('customers', 'delete'),
    ]
    for resource, action in admin_perms:
        conn.execute(sa.text(
            "INSERT INTO package_role_permissions (package_id, role, resource, action) "
            "VALUES (:p, :r, :res, :a)"
        ), {'p': 1, 'r': 'admin', 'res': resource, 'a': action})

    # Editor role: view, create, edit (no delete)
    editor_perms = [
        ('customers', 'view'),
        ('customers', 'create'),
        ('customers', 'edit'),
    ]
    for resource, action in editor_perms:
        conn.execute(sa.text(
            "INSERT INTO package_role_permissions (package_id, role, resource, action) "
            "VALUES (:p, :r, :res, :a)"
        ), {'p': 1, 'r': 'editor', 'res': resource, 'a': action})

    # Resource limit for customers
    conn.execute(sa.text(
        "INSERT INTO package_limits (package_id, resource, max_value) VALUES (:p, :r, :m)"
    ), {'p': 1, 'r': 'customers', 'm': -1})


def downgrade():
    conn = op.get_bind()
    conn.execute(sa.text(
        "DELETE FROM package_role_permissions WHERE resource = 'customers' AND package_id = 1"
    ))
    conn.execute(sa.text(
        "DELETE FROM package_limits WHERE resource = 'customers' AND package_id = 1"
    ))
