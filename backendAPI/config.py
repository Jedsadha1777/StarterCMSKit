import os

BASE_DIR = os.path.dirname(__file__)
STATIC_DIR = os.path.join(BASE_DIR, 'static')

# File upload
MAX_UPLOAD_MB = int(os.getenv('MAX_UPLOAD_MB', '5'))
MAX_UPLOAD_BYTES = MAX_UPLOAD_MB * 1024 * 1024
IMPORT_DIR = os.path.join(STATIC_DIR, 'imports')
UPLOAD_DIR = os.path.join(STATIC_DIR, 'uploads')
ALLOWED_EXCEL_EXTENSIONS = {'xlsx'}
ALLOWED_IMAGE_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'svg', 'ico', 'webp'}

# Auth / Session
RESET_TOKEN_MAX_AGE = int(os.getenv('RESET_TOKEN_MAX_AGE', '3600'))
GRACE_SECONDS = int(os.getenv('SESSION_GRACE_SECONDS', '30'))
REUSE_GRACE_SECONDS = int(os.getenv('SESSION_REUSE_GRACE_SECONDS', '30'))
SSE_TICKET_TTL = int(os.getenv('SSE_TICKET_TTL', '30'))

# Sync
SYNC_PAGE_SIZE = int(os.getenv('SYNC_PAGE_SIZE', '100'))

# Rate limiting
RATE_LIMIT_LOGIN = os.getenv('RATE_LIMIT_LOGIN', '5 per minute')
RATE_LIMIT_FORGOT_PASSWORD = os.getenv('RATE_LIMIT_FORGOT_PASSWORD', '3 per minute')
RATE_LIMIT_RESET_PASSWORD = os.getenv('RATE_LIMIT_RESET_PASSWORD', '5 per minute')

# SSE
SSE_HEARTBEAT_INTERVAL = int(os.getenv('SSE_HEARTBEAT_INTERVAL', '25'))

# Cleanup
CLEANUP_CUTOFF_DAYS = int(os.getenv('CLEANUP_CUTOFF_DAYS', '7'))

# Misc
USER_AGENT_MAX_LENGTH = int(os.getenv('USER_AGENT_MAX_LENGTH', '255'))
