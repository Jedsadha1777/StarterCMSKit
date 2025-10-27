from flask import request
from sqlalchemy import or_, and_

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
                    min_value = cast_type(min_value)
                    conditions.append(column >= min_value)
                except (ValueError, TypeError):
                    pass
                    
            if max_value:
                try:
                    max_value = cast_type(max_value)
                    conditions.append(column <= max_value)
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
                        relationship_attr = getattr(model, relation_name)
                        query = query.join(relationship_attr)
                    else:
                        query = query.join(relation_model)
                    joined_models.add(relation_model)
                
                relation_column = getattr(relation_model, relation_field)
                conditions.append(relation_column.ilike(f'%{value}%'))
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
            array_conditions = [column.ilike(f'%{v}%') for v in values]
            conditions.append(or_(*array_conditions))
            
        elif filter_type == 'prefix':
            conditions.append(column.ilike(f'{value}%'))
            
        elif filter_type == 'suffix':
            conditions.append(column.ilike(f'%{value}'))
            
        elif filter_type == 'bool':
            bool_value = value.lower() in ['true', '1', 'yes']
            conditions.append(column == bool_value)
            
        elif filter_type == 'enum':
            allowed_values = config.get('values', [])
            values = [v.strip() for v in value.split(',')]
            valid_values = [v for v in values if v in allowed_values]
            
            if valid_values:
                if len(valid_values) == 1:
                    conditions.append(column == valid_values[0])
                else:
                    conditions.append(column.in_(valid_values))
    
    if conditions:
        if search_logic == 'OR':
            query = query.filter(or_(*conditions))
        else:
            query = query.filter(and_(*conditions))
    
    return query


def apply_sorting(query, model, sortable_fields, default_sort=None):
    sort_param = request.args.get('sort_by', default_sort)
    
    if not sort_param:
        return query
    
    sort_items = [s.strip() for s in sort_param.split(',')]
    
    for item in sort_items:
        if item.startswith('-'):
            field = item[1:]
            direction = 'desc'
        else:
            field = item
            direction = 'asc'
        
        if field in sortable_fields:
            column = getattr(model, field)
            if direction == 'asc':
                query = query.order_by(column.asc())
            else:
                query = query.order_by(column.desc())
    
    return query



# ตัวอย่างการใช้งานใน Article

# ```python
# from flask import request, jsonify
# from flask_jwt_extended import jwt_required
# from admin_api import admin_bp
# from extensions import db
# from models import Article, Admin
# from decorators import admin_required
# from utils import paginate_query, apply_filters, apply_sorting
# from datetime import datetime


# @admin_bp.route('/articles', methods=['GET'])
# @jwt_required()
# @admin_required
# def get_articles(_):
#     """
#     Get all articles with advanced filtering, sorting, and pagination
    
#     Query Parameters:
#     - title: fuzzy search in title
#     - content: fuzzy search in content
#     - admin_id: exact match admin_id
#     - admin_id_min, admin_id_max: range search for admin_id
#     - created_at_min, created_at_max: date range search
#     - author_email: search by author email (relation)
#     - search_logic: AND or OR (default: AND)
#     - sort_by: field1,-field2,field3 (- = desc)
#     - page: page number (default: 1)
#     - per_page: items per page (default: 10)
    
#     Examples:
#     /articles
#     /articles?title=python
#     /articles?title=python&content=flask&search_logic=OR
#     /articles?admin_id_min=1&admin_id_max=5
#     /articles?created_at_min=2024-01-01&created_at_max=2024-12-31
#     /articles?author_email=admin@example.com
#     /articles?sort_by=-created_at,title
#     /articles?title=python&page=2&per_page=20
#     /articles?title=python&admin_id_min=1&sort_by=-created_at&page=1
#     """
#     query = Article.query
    
#     # Configure filters
#     filters = {
#         'title': {
#             'type': 'fuzzy'
#         },
#         'content': {
#             'type': 'fuzzy'
#         },
#         'admin_id': {
#             'type': 'range',
#             'cast': int
#         },
#         'created_at': {
#             'type': 'range',
#             'cast': lambda x: datetime.fromisoformat(x)
#         },
#         'author_email': {
#             'type': 'relation',
#             'model': Admin,
#             'field': 'email'
#         }
#     }
    
#     # Apply filters
#     query = apply_filters(query, Article, filters, search_logic='AND')
    
#     # Apply sorting
#     query = apply_sorting(
#         query, 
#         Article, 
#         sortable_fields=['id', 'title', 'created_at', 'updated_at', 'admin_id'],
#         default_sort='-created_at'
#     )
    
#     # Paginate
#     result = paginate_query(query, default_per_page=10)
    
#     return jsonify({
#         'articles': [article.to_dict() for article in result['items']],
#         'total': result['total'],
#         'page': result['page'],
#         'per_page': result['per_page'],
#         'pages': result['pages']
#     }), 200
# ```

# ---

# ตัวอย่าง Filter Types

# Fuzzy Search (ค้นหาแบบคลุมเครือ)

# ```python
# filters = {
#     'title': {'type': 'fuzzy'},
#     'content': {'type': 'fuzzy'}
# }
# ```

# **Query:**
# ```bash
# GET /articles?title=python
# GET /articles?title=python&content=flask
# GET /articles?title=python&content=flask&search_logic=OR
# ```

# **SQL ที่เกิด:**
# ```sql
# WHERE title ILIKE '%python%' AND content ILIKE '%flask%'
# WHERE title ILIKE '%python%' OR content ILIKE '%flask%'
# ```

# ---

# Exact Match 

# ```python
# filters = {
#     'admin_id': {'type': 'exact'}
# }
# ```

# **Query:**
# ```bash
# GET /articles?admin_id=1
# ```

# **SQL:**
# ```sql
# WHERE admin_id = 1
# ```

# ---

# ### Array Search (หลายค่า OR)

# ```python
# filters = {
#     'tags': {'type': 'array'}
# }
# ```

# **Query:**
# ```bash
# GET /articles?tags=python,flask,django
# ```

# **SQL:**
# ```sql
# WHERE (tags ILIKE '%python%' OR tags ILIKE '%flask%' OR tags ILIKE '%django%')
# ```

# ---

# Prefix/Suffix Search

# ```python
# filters = {
#     'title': {'type': 'prefix'},
#     'email': {'type': 'suffix'}
# }
# ```

# **Query:**
# ```bash
# GET /articles?title=Python
# GET /users?email=@gmail.com
# ```

# **SQL:**
# ```sql
# WHERE title ILIKE 'Python%'
# WHERE email ILIKE '%@gmail.com'
# ```

# ---

# Range Search (min/max)

# ```python
# filters = {
#     'admin_id': {
#         'type': 'range',
#         'cast': int
#     },
#     'price': {
#         'type': 'range',
#         'cast': float
#     },
#     'created_at': {
#         'type': 'range',
#         'cast': lambda x: datetime.fromisoformat(x)
#     }
# }
# ```

# **Query:**
# ```bash
# GET /articles?admin_id_min=1&admin_id_max=10
# GET /products?price_min=100&price_max=500
# GET /articles?created_at_min=2025-10-24T00:00:00&created_at_max=2025-10-30T23:59:59
# ```

# **SQL:**
# ```sql
# WHERE admin_id >= 1 AND admin_id <= 10
# WHERE price >= 100.0 AND price <= 500.0
# WHERE created_at >= '2025-10-24' AND created_at <= '2025-10-30'
# ```

# ---

# Boolean Search

# ```python
# filters = {
#     'is_published': {'type': 'bool'},
#     'is_active': {'type': 'bool'}
# }
# ```

# **Query:**
# ```bash
# GET /articles?is_published=true
# GET /articles?is_published=false
# GET /articles?is_published=1
# GET /articles?is_published=yes
# ```

# **SQL:**
# ```sql
# WHERE is_published = true
# WHERE is_published = false
# ```

# ---

# Enum Search (ค่าที่กำหนด + หลายค่า)

# ```python
# filters = {
#     'status': {
#         'type': 'enum',
#         'values': ['draft', 'published', 'archived']
#     },
#     'priority': {
#         'type': 'enum',
#         'values': ['low', 'medium', 'high']
#     }
# }
# ```

# **Query:**
# ```bash
# GET /articles?status=published
# GET /articles?status=draft,published
# GET /articles?priority=high
# ```

# **SQL:**
# ```sql
# WHERE status = 'published'
# WHERE status IN ('draft', 'published')
# WHERE priority = 'high'
# ```

# ---

# Relation Search (ค้นหาจาก table อื่น)

# ```python
# filters = {
#     'author_email': {
#         'type': 'relation',
#         'model': Admin,
#         'field': 'email'
#     },
#     'author_name': {
#         'type': 'relation',
#         'model': Admin,
#         'field': 'name'
#     }
# }
# ```

# **Query:**
# ```bash
# GET /articles?author_email=admin@example.com
# GET /articles?author_name=John
# ```

# **SQL:**
# ```sql
# SELECT * FROM articles 
# JOIN admins ON articles.admin_id = admins.id 
# WHERE admins.email ILIKE '%admin@example.com%'
# ```

# ---

# ตัวอย่าง Sorting

# Single Sort

# ```bash
# GET /articles?sort_by=created_at
# GET /articles?sort_by=-created_at
# ```

# Multi Sort

# ```bash
# GET /articles?sort_by=status,-created_at,title
# GET /articles?sort_by=-admin_id,title
# ```

# **อธิบาย:**
# - `created_at` = ascending
# - `-created_at` = descending
# - `status,-created_at,title` = sort by status ASC → created_at DESC → title ASC

# ---

# Pagination

# ```bash
# GET /articles?page=1
# GET /articles?page=2&per_page=20
# GET /articles?page=1&per_page=50
# ```

# **Response:**
# ```json
# {
#   "articles": [...],
#   "total": 100,
#   "page": 1,
#   "per_page": 10,
#   "pages": 10
# }
# ```

# ---

# ตัวอย่างแบบรวมทุกอย่าง

# ```bash
# GET /articles?title=python&content=flask&admin_id_min=1&admin_id_max=5&created_at_min=2024-01-01&author_email=admin&sort_by=-created_at,title&page=2&per_page=20&search_logic=AND
# ```

# **สิ่งที่เกิดขึ้น:**
# 1. ค้นหา title มี "python"
# 2. AND content มี "flask"
# 3. AND admin_id ระหว่าง 1-5
# 4. AND created_at หลัง 2024-01-01
# 5. AND author email มี "admin"
# 6. เรียงตาม created_at desc แล้วตาม title asc
# 7. แสดงหน้า 2 จำนวน 20 รายการ

# ---

# Simple List

# ถ้าไม่ต้องการ config มาก ใช้แบบ list ได้:

# ```python
# @admin_bp.route('/users', methods=['GET'])
# @jwt_required()
# @admin_required
# def get_users(_):
#     query = User.query
    
#     # Simple: จะเป็น fuzzy search ทั้งหมด
#     query = apply_filters(query, User, ['email', 'name'])
#     query = apply_sorting(query, User, ['created_at', 'email'], default_sort='-created_at')
#     result = paginate_query(query)
    
#     return jsonify({
#         'users': [user.to_dict() for user in result['items']],
#         'total': result['total'],
#         'page': result['page'],
#         'per_page': result['per_page'],
#         'pages': result['pages']
#     }), 200
# ```

# **Query:**
# ```bash
# GET /users?email=john
# GET /users?name=doe&page=2
# ```

# ---

# สรุป Filter Types ทั้งหมด

# | Type | Config | Query Example | SQL |
# |------|--------|---------------|-----|
# | fuzzy | `{'type': 'fuzzy'}` | `?title=python` | `ILIKE '%python%'` |
# | exact | `{'type': 'exact'}` | `?id=1` | `= 1` |
# | array | `{'type': 'array'}` | `?tags=a,b,c` | `OR (... OR ...)` |
# | prefix | `{'type': 'prefix'}` | `?name=John` | `ILIKE 'John%'` |
# | suffix | `{'type': 'suffix'}` | `?email=@gmail` | `ILIKE '%@gmail'` |
# | bool | `{'type': 'bool'}` | `?active=true` | `= true` |
# | enum | `{'type': 'enum', 'values': [...]}` | `?status=draft,published` | `IN (...)` |
# | range | `{'type': 'range', 'cast': int}` | `?id_min=1&id_max=10` | `>= 1 AND <= 10` |
# | relation | `{'type': 'relation', 'model': X, 'field': 'y'}` | `?author=john` | `JOIN ... WHERE` |
