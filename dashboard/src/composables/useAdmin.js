import { reactive, ref } from 'vue'
import api from '../api'

const admin = reactive({
  id: '',
  name: '',
  email: '',
  role: '',
  company_id: null,
  company_name: '',
  is_super_admin: false,
  permissions: [],
  limits: {},
})

const companies = ref([])
const activeCompanyId = ref(null)

function loadFromStorage() {
  try {
    const data = JSON.parse(localStorage.getItem('admin') || '{}')
    if (data.name)  admin.name  = data.name
    if (data.email) admin.email = data.email
    if (data.company_name) admin.company_name = data.company_name
    if (data.is_super_admin !== undefined) admin.is_super_admin = data.is_super_admin
  } catch { /* ignore */ }
  try {
    const stored = JSON.parse(localStorage.getItem('companies') || '[]')
    if (stored.length) companies.value = stored
  } catch { /* ignore */ }
  const storedCompanyId = localStorage.getItem('active_company_id')
  if (storedCompanyId) activeCompanyId.value = Number(storedCompanyId)
}

function save(data) {
  Object.assign(admin, data)
  localStorage.setItem('admin', JSON.stringify({ name: data.name, email: data.email, company_name: data.company_name, is_super_admin: data.is_super_admin }))
  window.dispatchEvent(new Event('storage-updated'))
}

function saveCompanies(list) {
  companies.value = list || []
  localStorage.setItem('companies', JSON.stringify(companies.value))
  if (companies.value.length && !activeCompanyId.value) {
    setActiveCompany(companies.value[0].id)
  }
}

function setActiveCompany(id) {
  activeCompanyId.value = id
  if (id) {
    localStorage.setItem('active_company_id', String(id))
  } else {
    localStorage.removeItem('active_company_id')
  }
  window.dispatchEvent(new Event('company-changed'))
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
  return { admin, companies, activeCompanyId, save, saveCompanies, setActiveCompany, sync, can }
}
