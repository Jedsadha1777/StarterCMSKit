import { reactive } from 'vue'
import api from '../api'

const admin = reactive({
  id: '',
  name: '',
  email: '',
  role: '',
  permissions: [],
  limits: {},
})

function loadFromStorage() {
  try {
    // Only name and email are persisted — permissions/limits are re-fetched from the server
    const data = JSON.parse(localStorage.getItem('admin') || '{}')
    if (data.name)  admin.name  = data.name
    if (data.email) admin.email = data.email
  } catch { /* ignore */ }
}

function save(data) {
  Object.assign(admin, data)
  // Store only display fields — keep role/permissions/limits out of localStorage
  // to limit XSS privilege reconnaissance (audit D1)
  localStorage.setItem('admin', JSON.stringify({ name: data.name, email: data.email }))
  window.dispatchEvent(new Event('storage-updated'))
}

async function sync() {
  try {
    const { data } = await api.getProfile()
    save(data)
  } catch { /* ignore */ }
}

function can(resource, action) {
  if (admin.permissions === '*') return true
  return (admin.permissions || []).includes(`${resource}.${action}`)
}

loadFromStorage()
window.addEventListener('storage-updated', loadFromStorage)

export function useAdmin() {
  return { admin, save, sync, can }
}
