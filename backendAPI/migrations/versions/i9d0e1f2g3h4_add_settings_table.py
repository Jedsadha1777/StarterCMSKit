"""Add settings table

Revision ID: i9d0e1f2g3h4
Revises: h8c9d0e1f2g3
Create Date: 2026-04-08 22:00:00.000000

"""
from alembic import op
import sqlalchemy as sa


revision = 'i9d0e1f2g3h4'
down_revision = 'h8c9d0e1f2g3'
branch_labels = None
depends_on = None


def upgrade():
    op.create_table('settings',
        sa.Column('key', sa.String(length=50), nullable=False),
        sa.Column('value', sa.Text(), nullable=False, server_default=''),
        sa.PrimaryKeyConstraint('key')
    )

    # Seed defaults
    conn = op.get_bind()
    defaults = [
        ('site_title', 'Admin Panel'),
        ('logo', ''),
        ('favicon', ''),
        ('posts_per_page', '10'),
        ('date_format', 'YYYY-MM-DD'),
        ('primary_color', '#c4193c'),
    ]
    for key, value in defaults:
        conn.execute(sa.text("INSERT INTO settings (`key`, value) VALUES (:k, :v)"), {'k': key, 'v': value})


def downgrade():
    op.drop_table('settings')
