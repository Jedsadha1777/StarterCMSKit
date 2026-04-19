import axios from 'axios'
import router from './router'
import { API_BASE_URL, API_TIMEOUT, MAX_REQUEST_QUEUE } from './config'

const SESSION_DEAD_CODES = ['SESSION_REPLACED', 'SESSION_REVOKED', 'TOKEN_REUSE_DETECTED', 'SESSION_NOT_FOUND', 'INVALID_TOKEN']
const NO_REFRESH_CODES = ['INVALID_CREDENTIALS']

export function clearAuthStorage() {
  localStorage.removeItem('access_token')
  localStorage.removeItem('refresh_token')
  localStorage.removeItem('admin')
  localStorage.removeItem('companies')
  localStorage.removeItem('active_company_id')
  window.dispatchEvent(new Event('auth-cleared'))
}

let isRefreshing = false
let failedQueue = []

const processQueue = (error, token = null) => {
  failedQueue.forEach(prom => {
    if (error) prom.reject(error)
    else prom.resolve(token)
  })
  failedQueue = []
}

const api = axios.create({
  baseURL: API_BASE_URL,
  timeout: API_TIMEOUT,
  withCredentials: true
})

api.interceptors.request.use(config => {
  const token = localStorage.getItem('access_token')
  if (token) config.headers.Authorization = `Bearer ${token}`
  const companyId = localStorage.getItem('active_company_id')
  if (companyId) config.headers['X-Company-Id'] = companyId
  return config
})

api.interceptors.response.use(
  response => response,
  async error => {
    const originalRequest = error.config

    if (!error.response) {
      return Promise.reject({ message: 'Connection error. Please check your internet.', type: 'NETWORK_ERROR' })
    }

    if (error.response.status >= 500) {
      return Promise.reject({ message: 'Server error. Please try again.', type: 'SERVER_ERROR', status: error.response.status })
    }

    if (error.response.status === 401 && !originalRequest._retry) {
      const code = error.response.data?.code

      if (SESSION_DEAD_CODES.includes(code)) {
        isRefreshing = false
        processQueue(error, null)
        clearAuthStorage()
        router.push('/login')
        return Promise.reject(error)
      }

      if (NO_REFRESH_CODES.includes(code)) {
        return Promise.reject(error)
      }

      const sentToken = originalRequest.headers.Authorization?.replace('Bearer ', '')
      const currentToken = localStorage.getItem('access_token')

      if (currentToken && currentToken !== sentToken) {
        originalRequest._retry = true
        originalRequest.headers.Authorization = `Bearer ${currentToken}`
        return api(originalRequest)
      }

      if (originalRequest.url.includes('/refresh')) {
        isRefreshing = false
        clearAuthStorage()
        router.push('/login')
        return Promise.reject(error)
      }

      if (isRefreshing) {
        if (failedQueue.length >= MAX_REQUEST_QUEUE) {
          return Promise.reject(new Error('Request queue is full'))
        }
        return new Promise((resolve, reject) => {
          failedQueue.push({ resolve, reject })
        }).then(token => {
          originalRequest.headers.Authorization = `Bearer ${token}`
          return api(originalRequest)
        })
      }

      originalRequest._retry = true
      isRefreshing = true

      const refreshToken = localStorage.getItem('refresh_token')
      const expiredAccessToken = localStorage.getItem('access_token')

      if (!refreshToken || !expiredAccessToken) {
        isRefreshing = false
        clearAuthStorage()
        router.push('/login')
        return Promise.reject(error)
      }

      try {
        const refreshApi = axios.create({ baseURL: API_BASE_URL, timeout: API_TIMEOUT, withCredentials: true })
        const { data } = await refreshApi.post('/refresh', { refresh_token: refreshToken }, {
          headers: { Authorization: `Bearer ${expiredAccessToken}` }
        })

        localStorage.setItem('access_token', data.access_token)
        localStorage.setItem('refresh_token', data.refresh_token)

        originalRequest.headers.Authorization = `Bearer ${data.access_token}`
        processQueue(null, data.access_token)
        isRefreshing = false

        return api(originalRequest)
      } catch (refreshError) {
        processQueue(refreshError, null)
        isRefreshing = false
        clearAuthStorage()
        router.push('/login')
        return Promise.reject(refreshError)
      }
    }

    return Promise.reject(error)
  }
)

export default {
  login(email, password) { return api.post('/login', { email, password }) },
  logout() { return api.post('/logout').finally(() => { clearAuthStorage(); router.push('/login') }) },
  getProfile() { return api.get('/profile') },
  updateProfile(data) { return api.put('/profile', data) },
  changePassword(oldPassword, newPassword) { return api.put('/profile/change-password', { old_password: oldPassword, new_password: newPassword }) },
  deleteAccount(password) { return api.post('/profile/delete-account', { password }) },
  getSummary() { return api.get('/summary') },
  getArticles(params = {}) { return api.get('/articles', { params }) },
  getArticle(id) { return api.get(`/articles/${id}`) },
  createArticle(data) { return api.post('/articles', data) },
  updateArticle(id, data) { return api.put(`/articles/${id}`, data) },
  deleteArticle(id) { return api.delete(`/articles/${id}`) },
  getUsers(params = {}) { return api.get('/users', { params }) },
  getUser(id) { return api.get(`/users/${id}`) },
  createUser(data) { return api.post('/users', data) },
  updateUser(id, data) { return api.put(`/users/${id}`, data) },
  deleteUser(id) { return api.delete(`/users/${id}`) },
  getPackages() { return api.get('/packages') },
  getCompanies() { return api.get('/companies') },
  getAccessibleCompanies() { return api.get('/companies/accessible') },
  createCompany(data) { return api.post('/companies', data) },
  updateCompany(id, data) { return api.put(`/companies/${id}`, data) },
  deleteCompany(id) { return api.delete(`/companies/${id}`) },
  getAdmins(params = {}) { return api.get('/admins', { params }) },
  getAdmin(id) { return api.get(`/admins/${id}`) },
  createAdmin(data) { return api.post('/admins', data) },
  updateAdmin(id, data) { return api.put(`/admins/${id}`, data) },
  deleteAdmin(id) { return api.delete(`/admins/${id}`) },
  getCustomers(params = {}) { return api.get('/customers', { params }) },
  getCustomer(id) { return api.get(`/customers/${id}`) },
  createCustomer(data) { return api.post('/customers', data) },
  updateCustomer(id, data) { return api.put(`/customers/${id}`, data) },
  deleteCustomer(id) { return api.delete(`/customers/${id}`) },
  exportCustomers() { return api.get('/customers/export', { responseType: 'blob' }) },
  importCustomersPreview(file) { const f = new FormData(); f.append('file', file); return api.post('/customers/import/preview', f, { headers: { 'Content-Type': 'multipart/form-data' } }) },
  importCustomersConfirm(file, rows) { const f = new FormData(); f.append('file', file); f.append('rows', JSON.stringify(rows)); return api.post('/customers/import/confirm', f, { headers: { 'Content-Type': 'multipart/form-data' } }) },
  getImportHistory(params = {}) { return api.get('/customers/import/history', { params }) },
  downloadImportFile(id) { return api.get(`/customers/import/history/${id}/download`, { responseType: 'blob' }) },
  deleteImportHistory(id) { return api.delete(`/customers/import/history/${id}`) },
  getInspectionItems(params = {}) { return api.get('/inspection-items', { params }) },
  getInspectionItem(id) { return api.get(`/inspection-items/${id}`) },
  createInspectionItem(data) { return api.post('/inspection-items', data) },
  updateInspectionItem(id, data) { return api.put(`/inspection-items/${id}`, data) },
  deleteInspectionItem(id) { return api.delete(`/inspection-items/${id}`) },
  exportInspectionItems() { return api.get('/inspection-items/export', { responseType: 'blob' }) },
  importInspectionItemsPreview(file) { const f = new FormData(); f.append('file', file); return api.post('/inspection-items/import/preview', f, { headers: { 'Content-Type': 'multipart/form-data' } }) },
  importInspectionItemsConfirm(file, rows) { const f = new FormData(); f.append('file', file); f.append('rows', JSON.stringify(rows)); return api.post('/inspection-items/import/confirm', f, { headers: { 'Content-Type': 'multipart/form-data' } }) },
  getInspectionImportHistory(params = {}) { return api.get('/inspection-items/import/history', { params }) },
  downloadInspectionImportFile(id) { return api.get(`/inspection-items/import/history/${id}/download`, { responseType: 'blob' }) },
  deleteInspectionImportHistory(id) { return api.delete(`/inspection-items/import/history/${id}`) },
  getMachineModels(params = {}) { return api.get('/machine-models', { params }) },
  getMachineModel(id) { return api.get(`/machine-models/${id}`) },
  createMachineModel(data) { return api.post('/machine-models', data) },
  updateMachineModel(id, data) { return api.put(`/machine-models/${id}`, data) },
  deleteMachineModel(id) { return api.delete(`/machine-models/${id}`) },
  exportMachineModels() { return api.get('/machine-models/export', { responseType: 'blob' }) },
  importMachineModelsPreview(file) { const f = new FormData(); f.append('file', file); return api.post('/machine-models/import/preview', f, { headers: { 'Content-Type': 'multipart/form-data' } }) },
  importMachineModelsConfirm(file, rows) { const f = new FormData(); f.append('file', file); f.append('rows', JSON.stringify(rows)); return api.post('/machine-models/import/confirm', f, { headers: { 'Content-Type': 'multipart/form-data' } }) },
  getMachineModelImportHistory(params = {}) { return api.get('/machine-models/import/history', { params }) },
  downloadMachineModelImportFile(id) { return api.get(`/machine-models/import/history/${id}/download`, { responseType: 'blob' }) },
  deleteMachineModelImportHistory(id) { return api.delete(`/machine-models/import/history/${id}`) },
  getReports(params = {}) { return api.get('/reports', { params }) },
  getReport(id) { return api.get(`/reports/${id}`) },
  updateReportStatus(id, data) { return api.put(`/reports/${id}`, data) },
  getReportPdf(id) { return api.get(`/reports/${id}/pdf`, { responseType: 'blob' }) },
  getReportSettings() { return api.get('/company/report-settings') },
  updateReportSettings(data) { return api.put('/company/report-settings', data) },
  getSettings() { return api.get('/settings') },
  updateSettings(data) { return api.put('/settings', data) },
  uploadSettingFile(field, file) { const f = new FormData(); f.append('file', file); return api.post(`/settings/upload/${field}`, f, { headers: { 'Content-Type': 'multipart/form-data' } }) },
}
