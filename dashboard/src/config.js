export const API_BASE = import.meta.env.VITE_API_BASE || 'http://127.0.0.1:5000'
export const API_BASE_URL = `${API_BASE}/admin-api`

export const SSE_RECONNECT_DELAY = Number(import.meta.env.VITE_SSE_RECONNECT_DELAY || 3000)
export const SSE_MAX_RETRIES = Number(import.meta.env.VITE_SSE_MAX_RETRIES || 10)
export const API_TIMEOUT = Number(import.meta.env.VITE_API_TIMEOUT || 10000)
export const MAX_REQUEST_QUEUE = Number(import.meta.env.VITE_MAX_REQUEST_QUEUE || 50)
export const GRACE_SECONDS_DEFAULT = Number(import.meta.env.VITE_GRACE_SECONDS_DEFAULT || 30)
