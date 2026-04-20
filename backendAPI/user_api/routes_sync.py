from datetime import datetime, timezone
from flask import request, jsonify
from flask_jwt_extended import jwt_required
from user_api import user_bp
from models import Article
from decorators import user_required
from config import SYNC_PAGE_SIZE


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
def sync(user):
    """Delta sync — return articles changed since `since` timestamp."""
    since_str = request.args.get('since')
    since = _parse_since(since_str)
    if since is None:
        return jsonify({'message': 'Invalid since format. Use ISO 8601.'}), 400

    # Capture server_time BEFORE query → articles created between query and response
    # will be picked up in the next sync (updated_at > server_time)
    server_time = datetime.now(timezone.utc).replace(tzinfo=None).isoformat()

    # Filter logic (ต้องครอบคลุม published→draft ด้วย เพื่อลบที่ mobile):
    #   published + not deleted  → upserted (client adds/updates)
    #   published + deleted      → deleted  (client removes)
    #   draft + not deleted      → deleted  (client removes — article ถูก unpublish)
    #   draft + deleted          → deleted  (client removes)
    query = Article.query.filter(Article.updated_at > since)

    if user.company_id:
        query = query.filter(Article.company_id == user.company_id)

    articles = query \
        .order_by(Article.updated_at.asc()) \
        .limit(SYNC_PAGE_SIZE + 1) \
        .all()

    has_more = len(articles) > SYNC_PAGE_SIZE
    if has_more:
        articles = articles[:SYNC_PAGE_SIZE]

    upserted = []
    deleted = []

    for a in articles:
        # published + ไม่ลบ → upsert
        # status != published หรือ is_deleted → delete (mobile ลบออก)
        if a.status == 'published' and not a.is_deleted:
            upserted.append(a.to_dict())
        else:
            deleted.append(a.public_id)

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
