import queue
import threading


class SSEManager:

    def __init__(self):
        self._lock = threading.Lock()
        self._connections = {}

    def connect(self, session_id):
        q = queue.Queue()
        with self._lock:
            self._connections[session_id] = q
        return q

    def disconnect(self, session_id, q=None):
        with self._lock:
            current = self._connections.get(session_id)
            if q is None or current is q:
                self._connections.pop(session_id, None)

    def send(self, session_id, event_type, data):
        with self._lock:
            q = self._connections.get(session_id)
        if q:
            q.put({'type': event_type, 'data': data})
            return True
        return False


sse_manager = SSEManager()
