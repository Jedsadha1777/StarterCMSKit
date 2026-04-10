from flask import request, jsonify
from flask_jwt_extended import jwt_required
from admin_api import admin_bp
from extensions import db
from sqlalchemy.orm import joinedload
from models import Article, Admin
from decorators import admin_required
from utils import paginate_query, apply_filters, apply_sorting, format_paginated, validate_required, get_or_404
from datetime import datetime


@admin_bp.route('/articles', methods=['GET'])
@jwt_required()
@admin_required
def get_articles(_):
    query = Article.query.options(joinedload(Article.admin_author)).filter_by(is_deleted=False)

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

    return format_paginated('articles', result)


@admin_bp.route('/articles', methods=['POST'])
@jwt_required()
@admin_required
def create_article(admin):
    if not admin.has_permission('articles', 'create'):
        return jsonify({'message': 'Permission denied'}), 403

    data = request.get_json()

    err = validate_required(data, ['title', 'content'])
    if err: return err

    publish_date = None
    if data.get('publish_date'):
        try:
            publish_date = datetime.fromisoformat(data['publish_date'])
        except ValueError:
            return jsonify({'message': 'Invalid publish_date format'}), 400

    status = data.get('status', 'draft')
    if status not in ('draft', 'published'):
        return jsonify({'message': 'Status must be draft or published'}), 400

    article = Article(
        title=data['title'],
        content=data['content'],
        admin_id=admin.id,
        status=status,
        publish_date=publish_date,
    )

    db.session.add(article)
    db.session.commit()

    return jsonify(article.to_dict()), 201


@admin_bp.route('/articles/<article_id>', methods=['GET'])
@jwt_required()
@admin_required
def get_article(_, article_id):
    article, err = get_or_404(Article, article_id, is_deleted=False)
    if err: return err
    return jsonify(article.to_dict()), 200


@admin_bp.route('/articles/<article_id>', methods=['PUT'])
@jwt_required()
@admin_required
def update_article(admin, article_id):
    if not admin.has_permission('articles', 'edit'):
        return jsonify({'message': 'Permission denied'}), 403

    article, err = get_or_404(Article, article_id, is_deleted=False)
    if err: return err

    if not admin.is_super_admin and article.admin_id != admin.id:
        return jsonify({'message': 'You can only edit your own articles'}), 403

    data = request.get_json()

    if data.get('title'):
        article.title = data['title']
    if data.get('content'):
        article.content = data['content']
    if 'status' in data:
        if data['status'] not in ('draft', 'published'):
            return jsonify({'message': 'Status must be draft or published'}), 400
        article.status = data['status']
    if 'publish_date' in data:
        if data['publish_date']:
            try:
                article.publish_date = datetime.fromisoformat(data['publish_date'])
            except ValueError:
                return jsonify({'message': 'Invalid publish_date format'}), 400
        else:
            article.publish_date = None
    article.version += 1

    db.session.commit()

    return jsonify(article.to_dict()), 200


@admin_bp.route('/articles/<article_id>', methods=['DELETE'])
@jwt_required()
@admin_required
def delete_article(admin, article_id):
    if not admin.has_permission('articles', 'delete'):
        return jsonify({'message': 'Permission denied'}), 403

    article, err = get_or_404(Article, article_id, is_deleted=False)
    if err: return err

    if not admin.is_super_admin and article.admin_id != admin.id:
        return jsonify({'message': 'You can only delete your own articles'}), 403

    article.is_deleted = True
    article.version += 1
    db.session.commit()

    return jsonify({'message': 'Article deleted successfully'}), 200
