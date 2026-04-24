"""Seed parts permissions + default package limit

Revision ID: e1z2a3b4c5d6
Revises: d0y1z2a3b4c5
Create Date: 2026-04-24 09:05:00.000000

"""
from alembic import op
import sqlalchemy as sa


revision = 'e1z2a3b4c5d6'
down_revision = 'd0y1z2a3b4c5'
branch_labels = None
depends_on = None


def upgrade():
    conn = op.get_bind()

    admin_perms = [
        ('parts', 'view'),
        ('parts', 'create'),
        ('parts', 'edit'),
        ('parts', 'delete'),
    ]
    for resource, action in admin_perms:
        conn.execute(sa.text(
            "INSERT INTO package_role_permissions (package_id, role, resource, action) "
            "VALUES (:p, :r, :res, :a)"
        ), {'p': 1, 'r': 'admin', 'res': resource, 'a': action})

    editor_perms = [
        ('parts', 'view'),
        ('parts', 'create'),
        ('parts', 'edit'),
    ]
    for resource, action in editor_perms:
        conn.execute(sa.text(
            "INSERT INTO package_role_permissions (package_id, role, resource, action) "
            "VALUES (:p, :r, :res, :a)"
        ), {'p': 1, 'r': 'editor', 'res': resource, 'a': action})

    conn.execute(sa.text(
        "INSERT INTO package_limits (package_id, resource, max_value) VALUES (:p, :r, :m)"
    ), {'p': 1, 'r': 'parts', 'm': -1})


def downgrade():
    conn = op.get_bind()
    conn.execute(sa.text(
        "DELETE FROM package_role_permissions WHERE resource = 'parts' AND package_id = 1"
    ))
    conn.execute(sa.text(
        "DELETE FROM package_limits WHERE resource = 'parts' AND package_id = 1"
    ))
