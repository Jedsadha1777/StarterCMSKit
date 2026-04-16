import os

BASE_DIR = os.path.dirname(__file__)
STATIC_DIR = os.path.join(BASE_DIR, 'static')

MAX_UPLOAD_MB = int(os.getenv('MAX_UPLOAD_MB', '5'))
MAX_UPLOAD_BYTES = MAX_UPLOAD_MB * 1024 * 1024

IMPORT_DIR = os.path.join(STATIC_DIR, 'imports')
UPLOAD_DIR = os.path.join(STATIC_DIR, 'uploads')

ALLOWED_EXCEL_EXTENSIONS = {'xlsx'}
ALLOWED_IMAGE_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'svg', 'ico', 'webp'}
