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

    query = Article.query.filter_by(is_deleted=False)

    # filters
    filters = {
        'title': {'type': 'fuzzy'},
        'content': {'type': 'fuzzy'},
        'status': {'type': 'exact'},
        'created_at': {'type': 'range', 'cast': lambda x: datetime.fromisoformat(x)},
        'publish_date': {'type': 'range', 'cast': lambda x: datetime.fromisoformat(x)},
        'author_email': {'type': 'relation', 'model': Admin, 'field': 'email'}
    }

    query = apply_filters(query, Article, filters, search_logic='AND')

    query = apply_sorting(
        query,
        Article,
        sortable_fields=['title', 'status', 'publish_date', 'created_at', 'updated_at'],
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
    
    publish_date = None
    if data.get('publish_date'):
        try:
            publish_date = datetime.fromisoformat(data['publish_date'])
        except ValueError:
            return jsonify({'message': 'Invalid publish_date format'}), 400

    article = Article(
        title=data['title'],
        content=data['content'],
        admin_id=admin.id,
        status=data.get('status', 'draft'),
        publish_date=publish_date,
    )
    
    db.session.add(article)
    db.session.commit()
    
    return jsonify(article.to_dict()), 201


@admin_bp.route('/articles/<article_id>', methods=['GET'])
@jwt_required()
@admin_required
def get_article(admin, article_id):
    """Get article by public_id"""
    article = Article.query.filter_by(public_id=article_id, is_deleted=False).first()

    if not article:
        return jsonify({'message': 'Article not found'}), 404

    return jsonify(article.to_dict()), 200


@admin_bp.route('/articles/<article_id>', methods=['PUT'])
@jwt_required()
@admin_required
def update_article(admin, article_id):
    """Update article"""
    article = Article.query.filter_by(public_id=article_id, is_deleted=False).first()

    if not article:
        return jsonify({'message': 'Article not found'}), 404
    
    data = request.get_json()
    
    if data.get('title'):
        article.title = data['title']
    if data.get('content'):
        article.content = data['content']
    if 'status' in data:
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
def delete_article(_, article_id):
    """Soft-delete article"""
    article = Article.query.filter_by(public_id=article_id, is_deleted=False).first()

    if not article:
        return jsonify({'message': 'Article not found'}), 404
    
    article.is_deleted = True
    article.version += 1
    db.session.commit()

    return jsonify({'message': 'Article deleted successfully'}), 200