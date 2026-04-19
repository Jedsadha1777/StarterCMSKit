"""Seed machine_model permissions for default package

Revision ID: a7v8w9x0y1z2
Revises: z6u7v8w9x0y1
Create Date: 2026-04-19 10:01:00.000000

"""
from alembic import op
import sqlalchemy as sa


revision = 'a7v8w9x0y1z2'
down_revision = 'z6u7v8w9x0y1'
branch_labels = None
depends_on = None


def upgrade():
    conn = op.get_bind()

    admin_perms = [
        ('machine_models', 'view'),
        ('machine_models', 'create'),
        ('machine_models', 'edit'),
        ('machine_models', 'delete'),
    ]
    for resource, action in admin_perms:
        conn.execute(sa.text(
            "INSERT INTO package_role_permissions (package_id, role, resource, action) "
            "VALUES (:p, :r, :res, :a)"
        ), {'p': 1, 'r': 'admin', 'res': resource, 'a': action})

    editor_perms = [
        ('machine_models', 'view'),
        ('machine_models', 'create'),
        ('machine_models', 'edit'),
    ]
    for resource, action in editor_perms:
        conn.execute(sa.text(
            "INSERT INTO package_role_permissions (package_id, role, resource, action) "
            "VALUES (:p, :r, :res, :a)"
        ), {'p': 1, 'r': 'editor', 'res': resource, 'a': action})

    conn.execute(sa.text(
        "INSERT INTO package_limits (package_id, resource, max_value) VALUES (:p, :r, :m)"
    ), {'p': 1, 'r': 'machine_models', 'm': -1})


def downgrade():
    conn = op.get_bind()
    conn.execute(sa.text(
        "DELETE FROM package_role_permissions WHERE resource = 'machine_models' AND package_id = 1"
    ))
    conn.execute(sa.text(
        "DELETE FROM package_limits WHERE resource = 'machine_models' AND package_id = 1"
    ))
