import time
import threading


class SessionCache:
    """In-memory cache for admin session validity. TTL=10s."""

    def __init__(self, ttl=10):
        self._ttl = ttl
        self._store = {}
        self._lock = threading.Lock()

    def get(self, session_id):
        with self._lock:
            entry = self._store.get(session_id)
            if entry and entry[1] > time.time():
                return entry[0]
        return None

    def set(self, session_id, data):
        with self._lock:
            self._store[session_id] = (data, time.time() + self._ttl)

    def invalidate(self, session_id):
        with self._lock:
            self._store.pop(session_id, None)


session_cache = SessionCache(ttl=10)
