from datetime import datetime
from flask import request, jsonify
from flask_jwt_extended import jwt_required
from user_api import user_bp
from models import Article
from decorators import user_required

SYNC_PAGE_SIZE = 100


def _parse_since(value):
    """Parse ISO 8601 timestamp, handle Z suffix for Python < 3.11."""
    if not value:
        return datetime.min
    value = value.replace('Z', '+00:00')
    try:
        dt = datetime.fromisoformat(value)
        return dt.replace(tzinfo=None) if dt.tzinfo else dt
    except ValueError:
        return None


@user_bp.route('/sync', methods=['GET'])
@jwt_required()
@user_required
def sync(_):
    """Delta sync — return articles changed since `since` timestamp."""
    since_str = request.args.get('since')
    since = _parse_since(since_str)
    if since is None:
        return jsonify({'message': 'Invalid since format. Use ISO 8601.'}), 400

    # Capture server_time BEFORE query → articles created between query and response
    # will be picked up in the next sync (updated_at > server_time)
    server_time = datetime.utcnow().isoformat()

    articles = Article.query \
        .filter(Article.updated_at > since) \
        .filter((Article.status == 'published') | (Article.is_deleted == True)) \
        .order_by(Article.updated_at.asc()) \
        .limit(SYNC_PAGE_SIZE + 1) \
        .all()

    has_more = len(articles) > SYNC_PAGE_SIZE
    if has_more:
        articles = articles[:SYNC_PAGE_SIZE]

    upserted = []
    deleted = []

    for a in articles:
        if a.is_deleted:
            deleted.append(a.public_id)
        else:
            upserted.append(a.to_dict())

    result = {
        'sync': {
            'server_time': server_time,
            'since': since_str,
            'changes': {
                'articles': {
                    'upserted': upserted,
                    'deleted': deleted,
                }
            },
            'has_more': has_more,
        }
    }

    # Pagination cursor: client uses this as `since` for the next page
    if has_more and articles:
        result['sync']['next_cursor'] = articles[-1].updated_at.isoformat()

    return jsonify(result), 200
