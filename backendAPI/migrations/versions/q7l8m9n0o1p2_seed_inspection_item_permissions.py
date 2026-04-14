"""Seed inspection_item permissions for default package

Revision ID: q7l8m9n0o1p2
Revises: p6k7l8m9n0o1
Create Date: 2026-04-13 10:01:00.000000

"""
from alembic import op
import sqlalchemy as sa


revision = 'q7l8m9n0o1p2'
down_revision = 'p6k7l8m9n0o1'
branch_labels = None
depends_on = None


def upgrade():
    conn = op.get_bind()

    admin_perms = [
        ('inspection_items', 'view'),
        ('inspection_items', 'create'),
        ('inspection_items', 'edit'),
        ('inspection_items', 'delete'),
    ]
    for resource, action in admin_perms:
        conn.execute(sa.text(
            "INSERT INTO package_role_permissions (package_id, role, resource, action) "
            "VALUES (:p, :r, :res, :a)"
        ), {'p': 1, 'r': 'admin', 'res': resource, 'a': action})

    editor_perms = [
        ('inspection_items', 'view'),
        ('inspection_items', 'create'),
        ('inspection_items', 'edit'),
    ]
    for resource, action in editor_perms:
        conn.execute(sa.text(
            "INSERT INTO package_role_permissions (package_id, role, resource, action) "
            "VALUES (:p, :r, :res, :a)"
        ), {'p': 1, 'r': 'editor', 'res': resource, 'a': action})

    conn.execute(sa.text(
        "INSERT INTO package_limits (package_id, resource, max_value) VALUES (:p, :r, :m)"
    ), {'p': 1, 'r': 'inspection_items', 'm': -1})


def downgrade():
    conn = op.get_bind()
    conn.execute(sa.text(
        "DELETE FROM package_role_permissions WHERE resource = 'inspection_items' AND package_id = 1"
    ))
    conn.execute(sa.text(
        "DELETE FROM package_limits WHERE resource = 'inspection_items' AND package_id = 1"
    ))
