import os
from uuid import uuid4
from flask import request, jsonify, current_app
from flask_jwt_extended import jwt_required
from werkzeug.utils import secure_filename
from admin_api import admin_bp
from extensions import db
from models import Setting
from decorators import admin_required

UPLOAD_DIR = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'static', 'uploads')
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'svg', 'ico', 'webp'}


def _allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


def _save_upload(file):
    """Save uploaded file and return relative URL path."""
    os.makedirs(UPLOAD_DIR, exist_ok=True)
    ext = file.filename.rsplit('.', 1)[1].lower()
    filename = f"{uuid4().hex}.{ext}"
    file.save(os.path.join(UPLOAD_DIR, filename))
    return f"/static/uploads/{filename}"


@admin_bp.route('/settings', methods=['GET'])
@jwt_required()
@admin_required
def get_settings(_):
    """Get all settings."""
    return jsonify(Setting.get_all()), 200


@admin_bp.route('/settings', methods=['PUT'])
@jwt_required()
@admin_required
def update_settings(_):
    """Update settings (JSON fields)."""
    data = request.get_json()
    if not data:
        return jsonify({'message': 'No data provided'}), 400

    allowed_keys = Setting.DEFAULTS.keys()
    for key, value in data.items():
        if key in allowed_keys:
            Setting.set(key, str(value))

    db.session.commit()
    return jsonify(Setting.get_all()), 200


@admin_bp.route('/settings/upload/<field>', methods=['POST'])
@jwt_required()
@admin_required
def upload_setting_file(_, field):
    """Upload logo or favicon file."""
    if field not in ('logo', 'favicon'):
        return jsonify({'message': 'Invalid field'}), 400

    file = request.files.get('file')
    if not file or not file.filename:
        return jsonify({'message': 'No file provided'}), 400

    if not _allowed_file(file.filename):
        return jsonify({'message': 'File type not allowed'}), 400

    url = _save_upload(file)
    Setting.set(field, url)
    db.session.commit()

    return jsonify({'url': url, 'field': field}), 200
