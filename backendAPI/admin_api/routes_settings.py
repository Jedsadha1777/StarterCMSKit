import os
from uuid import uuid4
from flask import request, jsonify
from flask_jwt_extended import jwt_required
from admin_api import admin_bp
from extensions import db
from models import Setting
from decorators import admin_required

UPLOAD_DIR = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'static', 'uploads')
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'svg', 'ico', 'webp'}
MAX_UPLOAD_BYTES = 5 * 1024 * 1024  # 5 MB

# Magic byte signatures for supported binary image formats
_IMAGE_MAGIC = {
    b'\x89PNG\r\n\x1a\n': 'png',
    b'\xff\xd8\xff': 'jpeg',
    b'GIF87a': 'gif',
    b'GIF89a': 'gif',
    b'\x00\x00\x01\x00': 'ico',
}


def _allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


def _get_file_size(file):
    file.stream.seek(0, 2)
    size = file.stream.tell()
    file.stream.seek(0)
    return size


def _verify_image_bytes(stream, ext):
    """Verify binary image content via magic bytes.
    SVG and WebP use a different check; unknown binary ext → reject."""
    header = stream.read(16)
    stream.seek(0)

    if ext == 'svg':
        return header.lstrip()[:5] in (b'<svg ', b'<?xml')

    if ext == 'webp':
        return header[:4] == b'RIFF' and header[8:12] == b'WEBP'

    for magic, detected_ext in _IMAGE_MAGIC.items():
        if header.startswith(magic):
            return detected_ext in (ext, 'jpeg' if ext == 'jpg' else ext)

    return False


def _save_upload(file):
    """Save uploaded file and return relative URL path."""
    os.makedirs(UPLOAD_DIR, exist_ok=True)
    _, ext_with_dot = os.path.splitext(file.filename)
    ext = ext_with_dot.lstrip('.').lower()
    filename = f"{uuid4().hex}.{ext}"
    file.save(os.path.join(UPLOAD_DIR, filename))
    return f"/static/uploads/{filename}"


@admin_bp.route('/settings', methods=['GET'])
@jwt_required()
@admin_required
def get_settings(admin):
    """Get all settings."""
    return jsonify(Setting.get_all()), 200


@admin_bp.route('/settings', methods=['PUT'])
@jwt_required()
@admin_required
def update_settings(admin):
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
def upload_setting_file(admin, field):
    """Upload logo or favicon file."""
    if field not in ('logo', 'favicon'):
        return jsonify({'message': 'Invalid field'}), 400

    file = request.files.get('file')
    if not file or not file.filename:
        return jsonify({'message': 'No file provided'}), 400

    if not _allowed_file(file.filename):
        return jsonify({'message': 'File type not allowed'}), 400

    size = _get_file_size(file)
    if size > MAX_UPLOAD_BYTES:
        return jsonify({'message': f'File too large. Maximum size is {MAX_UPLOAD_BYTES // (1024 * 1024)} MB'}), 400

    ext = file.filename.rsplit('.', 1)[1].lower()
    if not _verify_image_bytes(file.stream, ext):
        return jsonify({'message': 'File content does not match declared type'}), 400

    url = _save_upload(file)
    Setting.set(field, url)
    db.session.commit()

    return jsonify({'url': url, 'field': field}), 200
