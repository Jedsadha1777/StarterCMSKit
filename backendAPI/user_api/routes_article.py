from flask import jsonify
from flask_jwt_extended import jwt_required
from user_api import user_bp
from models import Article
from decorators import user_required
from utils import paginate_query, apply_filters, apply_sorting
from datetime import datetime

@user_bp.route('/articles', methods=['GET'])
@jwt_required()
@user_required
def get_articles(_):
    """Get all articles"""

    query = Article.query

    # filters
    filters = {
        'title': {
            'type': 'fuzzy'
        },
        'content': {
            'type': 'fuzzy'
        },
        'admin_id': {
            'type': 'range',
            'cast': int
        },
        'created_at': {
            'type': 'range',
            'cast': lambda x: datetime.fromisoformat(x)
        }
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

    return jsonify({
        'articles': [article.to_dict() for article in result['items']],
        'total': result['total'],
        'page': result['page'],
        'per_page': result['per_page'],
        'pages': result['pages']
    }), 200


@user_bp.route('/articles/<int:article_id>', methods=['GET'])
@jwt_required()
@user_required
def get_article(_, article_id):
    """Get article by ID (user must login)"""
    article = Article.query.get(article_id)
    
    if not article:
        return jsonify({'message': 'Article not found'}), 404
    
    return jsonify(article.to_dict()), 200