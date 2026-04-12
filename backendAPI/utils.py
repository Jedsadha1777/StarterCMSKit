import re
import logging
from flask import request, jsonify
from sqlalchemy import or_, and_
from extensions import db

logger = logging.getLogger(__name__)


# ── Validation ──

def validate_required(data, fields):
    if not data:
        missing = fields
    else:
        missing = [f for f in fields if not data.get(f)]
    if missing:
        return jsonify({'message': f'{", ".join(missing)} {"is" if len(missing) == 1 else "are"} required'}), 400
    return None


def validate_password(password):
    if len(password) < 6:
        return jsonify({'message': 'Password must be at least 6 characters'}), 400
    return None


def validate_alphanumeric(value, label='Value'):
    if not re.fullmatch(r'[A-Za-z0-9\-_]+', value):
        return jsonify({'message': f'{label} must contain only English letters, numbers, hyphens or underscores (no spaces)'}), 400
    return None


# ── Resource lookup ──

def get_or_404(model, public_id, label=None, **extra_filters):
    query = model.query.filter_by(public_id=public_id, **extra_filters)
    resource = query.first()
    if not resource:
        # Derive a readable label from the table name by stripping a trailing 's'.
        # Using [:-1] (remove exactly the last char) is safer than rstrip('s')
        # which would strip all trailing 's' chars (e.g. 'admins' → 'admi').
        tablename = model.__tablename__
        singular = tablename[:-1] if tablename.endswith('s') else tablename
        name = label or singular.capitalize()
        return None, (jsonify({'message': f'{name} not found'}), 404)
    return resource, None


# ── Uniqueness check ──

def check_unique(model, field, value, exclude_id=None):
    column = getattr(model, field)
    query = model.query.filter(column == value)
    if exclude_id is not None:
        query = query.filter(model.id != exclude_id)
    if query.first():
        label = field.replace('_', ' ').capitalize()
        return jsonify({'message': f'{label} already exists'}), 400
    return None


# ── Paginated response ──

def format_paginated(key, result):
    return jsonify({
        key: [item.to_dict() for item in result['items']],
        'total': result['total'],
        'page': result['page'],
        'per_page': result['per_page'],
        'pages': result['pages']
    }), 200


# ── Token blacklist ──

def blacklist_tokens(claims, public_id, user_type, refresh_token_raw=None):
    from models import TokenBlacklist
    from flask_jwt_extended import decode_token
    from datetime import datetime, timezone

    # DB DateTime columns are naive UTC — strip tzinfo before storing
    exp = datetime.fromtimestamp(claims['exp'], tz=timezone.utc).replace(tzinfo=None)
    TokenBlacklist.add_to_blacklist(
        jti=claims['jti'],
        token_type=claims['type'],
        user_id=public_id,
        user_type=user_type,
        expires_at=exp
    )

    if refresh_token_raw:
        try:
            refresh_claims = decode_token(refresh_token_raw)
            refresh_exp = datetime.fromtimestamp(refresh_claims['exp'], tz=timezone.utc).replace(tzinfo=None)
            TokenBlacklist.add_to_blacklist(
                jti=refresh_claims['jti'],
                token_type='refresh',
                user_id=public_id,
                user_type=user_type,
                expires_at=refresh_exp
            )
        except Exception as e:
            logger.warning('Failed to blacklist refresh token: %s', e)

    db.session.commit()


# ── Pagination ──

def paginate_query(query, default_per_page=10):
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', default_per_page, type=int)

    pagination = query.paginate(
        page=page,
        per_page=per_page,
        error_out=False
    )

    return {
        'items': pagination.items,
        'total': pagination.total,
        'page': pagination.page,
        'per_page': pagination.per_page,
        'pages': pagination.pages
    }


# ── Filtering ──

def apply_filters(query, model, filterable_fields, search_logic='AND'):
    if isinstance(filterable_fields, list):
        filterable_fields = {field: {'type': 'fuzzy'} for field in filterable_fields}

    search_logic = request.args.get('search_logic', search_logic).upper()
    conditions = []
    joined_models = set()

    for field, config in filterable_fields.items():
        filter_type = config.get('type', 'fuzzy')

        if filter_type == 'range':
            min_value = request.args.get(f'{field}_min')
            max_value = request.args.get(f'{field}_max')
            column = getattr(model, field)
            cast_type = config.get('cast', str)

            if min_value:
                try:
                    conditions.append(column >= cast_type(min_value))
                except (ValueError, TypeError):
                    pass
            if max_value:
                try:
                    conditions.append(column <= cast_type(max_value))
                except (ValueError, TypeError):
                    pass
            continue

        if filter_type == 'relation':
            value = request.args.get(field)
            if not value:
                continue

            relation_model = config.get('model')
            relation_field = config.get('field')
            relation_name = config.get('relation_name')

            if relation_model and relation_field:
                if relation_model not in joined_models:
                    if relation_name:
                        query = query.join(getattr(model, relation_name))
                    else:
                        query = query.join(relation_model)
                    joined_models.add(relation_model)

                conditions.append(getattr(relation_model, relation_field).ilike(f'%{value}%'))
            continue

        value = request.args.get(field)
        if not value:
            continue

        column = getattr(model, field)

        if filter_type == 'fuzzy':
            conditions.append(column.ilike(f'%{value}%'))
        elif filter_type == 'exact':
            conditions.append(column == value)
        elif filter_type == 'array':
            values = [v.strip() for v in value.split(',')]
            conditions.append(or_(*[column.ilike(f'%{v}%') for v in values]))
        elif filter_type == 'prefix':
            conditions.append(column.ilike(f'{value}%'))
        elif filter_type == 'suffix':
            conditions.append(column.ilike(f'%{value}'))
        elif filter_type == 'bool':
            conditions.append(column == (value.lower() in ['true', '1', 'yes']))
        elif filter_type == 'enum':
            allowed_values = config.get('values', [])
            valid = [v.strip() for v in value.split(',') if v.strip() in allowed_values]
            if valid:
                conditions.append(column.in_(valid) if len(valid) > 1 else column == valid[0])

    if conditions:
        if search_logic == 'OR':
            query = query.filter(or_(*conditions))
        else:
            query = query.filter(and_(*conditions))

    return query


# ── Sorting ──

def apply_sorting(query, model, sortable_fields, default_sort=None):
    sort_param = request.args.get('sort_by', default_sort)
    if not sort_param:
        return query

    for item in [s.strip() for s in sort_param.split(',')]:
        if item.startswith('-'):
            field, direction = item[1:], 'desc'
        else:
            field, direction = item, 'asc'

        if field in sortable_fields:
            column = getattr(model, field)
            query = query.order_by(column.desc() if direction == 'desc' else column.asc())

    return query
