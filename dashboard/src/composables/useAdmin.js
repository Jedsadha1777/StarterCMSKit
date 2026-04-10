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
    const data = JSON.parse(localStorage.getItem('admin') || '{}')
    Object.assign(admin, data)
  } catch { /* ignore */ }
}

function save(data) {
  Object.assign(admin, data)
  localStorage.setItem('admin', JSON.stringify(data))
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
