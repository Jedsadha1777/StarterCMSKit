"""Extract parts-used rows from a report's form_data JSON.

The mobile form stores parts in parallel keys partNo{i} / partName{i} /
partQtr{i} / partUnitPrice{i} for i = 1..15 (partId and partTotal are ignored —
partId is an internal UI id, partTotal is auto-calculated = qty × unit_price).

Used both at submit-time (user_api/routes_report.submit_report) and by the
backfill migration for existing reports.
"""
from decimal import Decimal, InvalidOperation


MAX_ROWS = 15


def _parse_int(v):
    if v is None:
        return 0
    try:
        return int(str(v).strip())
    except (ValueError, TypeError):
        return 0


def _to_decimal(v):
    if v is None or v == '':
        return Decimal('0')
    try:
        return Decimal(str(v).strip())
    except (InvalidOperation, ValueError, TypeError):
        return Decimal('0')


def extract_parts_from_form_data(form_data):
    """Return list of dicts ready to insert into parts_consumption.

    Each dict: {parts_code, parts_name, qty, unit_price}.
    Rows missing parts_code or with qty <= 0 are skipped.
    """
    if not isinstance(form_data, dict):
        return []

    parts = []
    for i in range(1, MAX_ROWS + 1):
        code = form_data.get(f'partNo{i}')
        if code is None:
            continue
        code = str(code).strip()
        if not code:
            continue

        qty = _parse_int(form_data.get(f'partQtr{i}'))
        if qty <= 0:
            continue

        name = form_data.get(f'partName{i}') or code
        name = str(name).strip()

        unit_price = _to_decimal(form_data.get(f'partUnitPrice{i}'))

        parts.append({
            'parts_code': code,
            'parts_name': name,
            'qty': qty,
            'unit_price': unit_price,
        })

    return parts
