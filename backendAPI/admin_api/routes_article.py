from flask import request, jsonify
from flask_jwt_extended import jwt_required
from admin_api import admin_bp
from extensions import db
from models import Article, Admin
from decorators import admin_required
from utils import paginate_query, apply_filters, apply_sorting
from datetime import datetime

@admin_bp.route('/articles', methods=['GET'])
@jwt_required()
@admin_required
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
        },
        'author_email': {
            'type': 'relation',
            'model': Admin,
            'field': 'email'
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


@admin_bp.route('/articles', methods=['POST'])
@jwt_required()
@admin_required
def create_article(admin):  
    """Create new article"""
    data = request.get_json()
    
    if not data or not data.get('title') or not data.get('content'):
        return jsonify({'message': 'Title and content are required'}), 400
    
    article = Article(
        title=data['title'],
        content=data['content'],
        admin_id=admin.id  
    )
    
    db.session.add(article)
    db.session.commit()
    
    return jsonify(article.to_dict()), 201


@admin_bp.route('/articles/<int:article_id>', methods=['GET'])
@jwt_required()
@admin_required
def get_article(admin, article_id):  
    """Get article by ID"""
    article = Article.query.get(article_id)
    
    if not article:
        return jsonify({'message': 'Article not found'}), 404
    
    return jsonify(article.to_dict()), 200


@admin_bp.route('/articles/<int:article_id>', methods=['PUT'])
@jwt_required()
@admin_required
def update_article(admin, article_id):  
    """Update article"""
    article = Article.query.get(article_id)
    
    if not article:
        return jsonify({'message': 'Article not found'}), 404
    
    data = request.get_json()
    
    if data.get('title'):
        article.title = data['title']
    if data.get('content'):
        article.content = data['content']
    
    db.session.commit()
    
    return jsonify(article.to_dict()), 200


@admin_bp.route('/articles/<int:article_id>', methods=['DELETE'])
@jwt_required()
@admin_required
def delete_article(_, article_id): 
    """Delete article"""
    article = Article.query.get(article_id)
    
    if not article:
        return jsonify({'message': 'Article not found'}), 404
    
    db.session.delete(article)
    db.session.commit()
    
    return jsonify({'message': 'Article deleted successfully'}), 200