from flask import jsonify
from flask_jwt_extended import jwt_required
from sqlalchemy.orm import joinedload
from user_api import user_bp
from models import Article
from decorators import user_required
from utils import paginate_query, apply_filters, apply_sorting, format_paginated, get_or_404
from datetime import datetime

@user_bp.route('/articles', methods=['GET'])
@jwt_required()
@user_required
def get_articles(user):
    query = Article.query.options(joinedload(Article.admin_author)).filter_by(is_deleted=False, status='published')

    if user.company_id:
        query = query.filter(Article.company_id == user.company_id)

    # filters
    filters = {
        'title': {'type': 'fuzzy'},
        'content': {'type': 'fuzzy'},
        'created_at': {'type': 'range', 'cast': lambda x: datetime.fromisoformat(x)}
    }

    query = apply_filters(query, Article, filters, search_logic='AND')

    #  sorting
    query = apply_sorting(
        query, 
        Article, 
        sortable_fields=['title', 'created_at', 'updated_at'],
        default_sort='-created_at'
    )

    result = paginate_query(query, default_per_page=10)

    return format_paginated('articles', result)


@user_bp.route('/articles/<article_id>', methods=['GET'])
@jwt_required()
@user_required
def get_article(user, article_id):
    article, err = get_or_404(Article, article_id, is_deleted=False, status='published')
    if err: return err
    if user.company_id and article.company_id != user.company_id:
        return jsonify({'message': 'Article not found'}), 404
    return jsonify(article.to_dict()), 200