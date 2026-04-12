# Gunicorn configuration for StarterCMSKit backendAPI
#
# IMPORTANT — single worker is required.
# _sse_tickets is stored in process memory (in-memory dict).
# With multiple workers, a ticket created in worker A is invisible to worker B,
# causing 401 "Invalid ticket" errors on SSE connections that land on a different
# worker.  Running with workers=1 eliminates cross-worker ticket loss.
#
# The gevent worker class allows many concurrent SSE streams (long-lived
# connections) without blocking; each stream is handled as a green thread.
#
# To scale beyond one process in the future, move _sse_tickets to Redis and
# this constraint can be removed.
#
# Usage:
#   pip install gunicorn gevent
#   gunicorn --config gunicorn.conf.py "app:create_app()"

workers = 1
worker_class = "gevent"
worker_connections = 1000  # max concurrent green-thread connections per worker

bind = "0.0.0.0:5000"

# SSE connections are long-lived; disable the worker timeout so Gunicorn does
# not kill the worker while clients are connected.  The application-level
# SSE heartbeat (if any) keeps the connection alive on the client side.
timeout = 0

# Log to stdout so process managers (systemd, Docker) capture it naturally.
accesslog = "-"
errorlog = "-"
loglevel = "info"
