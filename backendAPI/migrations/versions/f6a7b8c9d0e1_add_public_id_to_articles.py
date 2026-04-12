"""Add public_id to articles

Revision ID: f6a7b8c9d0e1
Revises: e5f6a7b8c9d0
Create Date: 2026-04-08 19:00:00.000000

"""
from alembic import op
import sqlalchemy as sa
from uuid import uuid4


revision = 'f6a7b8c9d0e1'
down_revision = 'e5f6a7b8c9d0'
branch_labels = None
depends_on = None


def upgrade():
    op.add_column('articles', sa.Column('public_id', sa.String(length=36), nullable=True))

    conn = op.get_bind()
    rows = conn.execute(sa.text('SELECT id FROM articles')).fetchall()
    for row in rows:
        conn.execute(
            sa.text("UPDATE articles SET public_id = :pid WHERE id = :id"),
            {'pid': str(uuid4()), 'id': row[0]}
        )

    op.alter_column('articles', 'public_id', existing_type=sa.String(length=36), nullable=False)
    op.create_index('idx_articles_public_id', 'articles', ['public_id'], unique=True)


def downgrade():
    op.drop_index('idx_articles_public_id', table_name='articles')
    op.drop_column('articles', 'public_id')
