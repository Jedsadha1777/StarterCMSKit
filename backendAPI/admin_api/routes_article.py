from flask import request, jsonify, g
from flask_jwt_extended import jwt_required
from admin_api import admin_bp
from extensions import db
from sqlalchemy.orm import joinedload
from models import Article, Admin
from decorators import admin_required, company_required
from datetime import datetime
from utils import paginate_query, apply_filters, apply_sorting, format_paginated, load_schema, get_or_404_scoped
from schemas import ArticleCreateSchema, ArticleUpdateSchema, ArticleResponseSchema


@admin_bp.route('/articles', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def get_articles(admin):
    query = Article.query.options(joinedload(Article.admin_author)).filter_by(is_deleted=False) \
        .filter(Article.company_id == g.active_company.id)

    filters = {
        'title': {'type': 'fuzzy'},
        'content': {'type': 'fuzzy'},
        'status': {'type': 'exact'},
        'created_at': {'type': 'range', 'cast': lambda x: datetime.fromisoformat(x)},
        'publish_date': {'type': 'range', 'cast': lambda x: datetime.fromisoformat(x)},
        'author_email': {'type': 'relation', 'model': Admin, 'field': 'email'}
    }

    query = apply_filters(query, Article, filters, search_logic='AND')
    query = apply_sorting(query, Article, sortable_fields=['title', 'status', 'publish_date', 'created_at', 'updated_at'], default_sort='-created_at')
    result = paginate_query(query, default_per_page=10)

    return format_paginated('articles', result, schema=ArticleResponseSchema())


@admin_bp.route('/articles', methods=['POST'])
@jwt_required()
@admin_required
@company_required
def create_article(admin):
    if not admin.has_permission('articles', 'create'):
        return jsonify({'message': 'Permission denied'}), 403

    data, err = load_schema(ArticleCreateSchema)
    if err: return err

    article = Article(
        title=data['title'],
        content=data['content'],
        admin_id=admin.id,
        company_id=g.active_company.id,
        status=data.get('status', 'draft'),
        publish_date=data.get('publish_date'),
    )

    db.session.add(article)
    db.session.commit()

    return jsonify(ArticleResponseSchema().dump(article)), 201


@admin_bp.route('/articles/<article_id>', methods=['GET'])
@jwt_required()
@admin_required
@company_required
def get_article(admin, article_id):
    article, err = get_or_404_scoped(Article, article_id, g.active_company, is_deleted=False)
    if err: return err
    return jsonify(ArticleResponseSchema().dump(article)), 200


@admin_bp.route('/articles/<article_id>', methods=['PUT'])
@jwt_required()
@admin_required
@company_required
def update_article(admin, article_id):
    if not admin.has_permission('articles', 'edit'):
        return jsonify({'message': 'Permission denied'}), 403

    article, err = get_or_404_scoped(Article, article_id, g.active_company, is_deleted=False)
    if err: return err

    if not admin.is_super_admin and article.admin_id != admin.id:
        return jsonify({'message': 'You can only edit your own articles'}), 403

    data, err = load_schema(ArticleUpdateSchema)
    if err: return err

    if data.get('title'):
        article.title = data['title']
    if data.get('content'):
        article.content = data['content']
    if 'status' in data:
        article.status = data['status']
    if 'publish_date' in data:
        article.publish_date = data['publish_date']
    article.version += 1

    db.session.commit()

    return jsonify(ArticleResponseSchema().dump(article)), 200


@admin_bp.route('/articles/<article_id>', methods=['DELETE'])
@jwt_required()
@admin_required
@company_required
def delete_article(admin, article_id):
    if not admin.has_permission('articles', 'delete'):
        return jsonify({'message': 'Permission denied'}), 403

    article, err = get_or_404_scoped(Article, article_id, g.active_company, is_deleted=False)
    if err: return err

    if not admin.is_super_admin and article.admin_id != admin.id:
        return jsonify({'message': 'You can only delete your own articles'}), 403

    article.is_deleted = True
    article.version += 1
    db.session.commit()

    return jsonify({'message': 'Article deleted successfully'}), 200
