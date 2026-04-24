"""Backfill parts_consumption from existing reports' form_data JSON

Extracts partNo{i}/partName{i}/partQtr{i}/partUnitPrice{i} for i = 1..15
and inserts one row per used part into parts_consumption.

- parts_id is NULL (master parts table is empty at this time)
- consumption_dt = reports.inspected_at.date()
- Skip rows where partNo empty OR partQtr missing/zero

Revision ID: f2a3b4c5d6e7
Revises: e1z2a3b4c5d6
Create Date: 2026-04-24 09:10:00.000000

"""
from alembic import op
import sqlalchemy as sa
import json
from datetime import datetime


revision = 'f2a3b4c5d6e7'
down_revision = 'e1z2a3b4c5d6'
branch_labels = None
depends_on = None


def _parse_json(v):
    if v is None:
        return {}
    if isinstance(v, dict):
        return v
    try:
        return json.loads(v)
    except (json.JSONDecodeError, TypeError):
        return {}


def _parse_int(v):
    if v is None:
        return 0
    try:
        return int(str(v).strip())
    except (ValueError, TypeError):
        return 0


def _parse_float(v):
    if v is None:
        return 0.0
    try:
        return float(str(v).strip())
    except (ValueError, TypeError):
        return 0.0


def upgrade():
    conn = op.get_bind()
    now = datetime.utcnow().replace(microsecond=0)

    reports = conn.execute(sa.text(
        "SELECT id, company_id, form_data, inspected_at FROM reports"
    )).fetchall()

    insert_sql = sa.text("""
        INSERT INTO parts_consumption
          (report_id, company_id, parts_id, parts_code, parts_name,
           qty, unit_price, consumption_dt, created_at)
        VALUES
          (:report_id, :company_id, NULL, :code, :name,
           :qty, :price, :dt, :now)
    """)

    total = 0
    for r in reports:
        form_data = _parse_json(r.form_data)
        if not form_data:
            continue

        consumption_dt = None
        if r.inspected_at:
            consumption_dt = r.inspected_at.date() if hasattr(r.inspected_at, 'date') else r.inspected_at

        for i in range(1, 16):
            code = form_data.get(f'partNo{i}')
            if code is not None:
                code = str(code).strip()
            if not code:
                continue

            qty = _parse_int(form_data.get(f'partQtr{i}'))
            if qty <= 0:
                continue

            name = form_data.get(f'partName{i}') or code
            name = str(name).strip()
            price = _parse_float(form_data.get(f'partUnitPrice{i}'))

            conn.execute(insert_sql, {
                'report_id': r.id,
                'company_id': r.company_id,
                'code': code,
                'name': name,
                'qty': qty,
                'price': price,
                'dt': consumption_dt,
                'now': now,
            })
            total += 1

    # Emit to alembic log so operator can see how many rows inserted
    print(f"[backfill] inserted {total} parts_consumption row(s) from {len(reports)} report(s)")


def downgrade():
    conn = op.get_bind()
    conn.execute(sa.text("DELETE FROM parts_consumption"))
