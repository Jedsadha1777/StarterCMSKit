import axios from 'axios'
import router from './router'
import { API_BASE_URL } from './config'

// D15: access_token อยู่ใน sessionStorage (ล้างเมื่อปิด tab) เพื่อลดความเสี่ยง XSS
// refresh_token อยู่ใน localStorage เพื่อให้ session คงอยู่ข้ามการเปิด tab ใหม่
const getAccessToken = () => sessionStorage.getItem('access_token')
const setAccessToken = (t) => sessionStorage.setItem('access_token', t)
const getRefreshToken = () => localStorage.getItem('refresh_token')
const setRefreshToken = (t) => localStorage.setItem('refresh_token', t)

// D16: ล้างเฉพาะ key ที่เป็น auth เพื่อไม่ให้กระทบ localStorage ของ third-party
// ยิง 'auth-changed' ทุกครั้งที่ล้าง เพื่อให้ App.vue อัปเดต isAuthenticated ทันที
export function clearAuthStorage() {
  sessionStorage.removeItem('access_token')
  localStorage.removeItem('refresh_token')
  localStorage.removeItem('admin')
  window.dispatchEvent(new Event('auth-changed'))
}

// D27: จำกัดขนาด queue เพื่อป้องกัน unbounded growth ระหว่างรอ refresh
const MAX_QUEUE_SIZE = 50

let isRefreshing = false
let failedQueue = []

const processQueue = (error, token = null) => {
  failedQueue.forEach(prom => {
    if (error) {
      prom.reject(error)
    } else {
      prom.resolve(token)
    }
  })
  failedQueue = []
}

const api = axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000,
  withCredentials: true
})

api.interceptors.request.use(
  config => {
    const token = getAccessToken()
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  error => Promise.reject(error)
)

api.interceptors.response.use(
  response => response,
  async error => {
    const originalRequest = error.config

    if (!error.response) {
      return Promise.reject({
        message: 'Connection error. Please check your internet.',
        type: 'NETWORK_ERROR'
      })
    }

    if (error.response.status >= 500) {
      return Promise.reject({
        message: 'Server error. Please try again.',
        type: 'SERVER_ERROR',
        status: error.response.status
      })
    }

    if (error.response.status === 401 && !originalRequest._retry) {
      const code = error.response.data?.code

      if (code === 'SESSION_REPLACED' || code === 'SESSION_REVOKED' || code === 'TOKEN_REUSE_DETECTED') {
        isRefreshing = false
        processQueue(error, null)
        setTimeout(() => {
          if (getAccessToken()) {
            clearAuthStorage()
            router.push('/login')
          }
        }, 2000)
        return Promise.reject(error)
      }

      if (originalRequest.url.includes('/refresh')) {
        isRefreshing = false
        clearAuthStorage()
        router.push('/login')
        return Promise.reject(error)
      }

      if (isRefreshing) {
        if (failedQueue.length >= MAX_QUEUE_SIZE) {
          return Promise.reject(new Error('Request queue is full, please try again'))
        }
        return new Promise((resolve, reject) => {
          failedQueue.push({ resolve, reject })
        })
          .then(token => {
            originalRequest.headers.Authorization = `Bearer ${token}`
            return api(originalRequest)
          })
          .catch(err => Promise.reject(err))
      }

      originalRequest._retry = true
      isRefreshing = true

      const refreshToken = getRefreshToken()

      if (!refreshToken) {
        isRefreshing = false
        clearAuthStorage()
        router.push('/login')
        return Promise.reject(error)
      }

      try {
        const refreshApi = axios.create({
          baseURL: API_BASE_URL,
          timeout: 10000,
          withCredentials: true
        })

        const expiredAccessToken = getAccessToken()
        const { data } = await refreshApi.post('/refresh', { refresh_token: refreshToken }, {
          headers: { Authorization: `Bearer ${expiredAccessToken}` }
        })

        setAccessToken(data.access_token)
        if (data.refresh_token) {
          setRefreshToken(data.refresh_token)
        }

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
  login(email, password) {
    return api.post('/login', { email, password })
  },

  logout() {
    return api.post('/logout').finally(() => {
      clearAuthStorage()
      router.push('/login')
    })
  },

  getProfile() {
    return api.get('/profile')
  },

  updateProfile(data) {
    return api.put('/profile', data)
  },

  changePassword(oldPassword, newPassword) {
    return api.put('/profile/change-password', {
      old_password: oldPassword,
      new_password: newPassword
    })
  },

  deleteAccount(password) {
    return api.post('/profile/delete-account', { password })
  },

  getSummary() {
    return api.get('/summary')
  },

  getArticles(params = {}) {
    return api.get('/articles', { params })
  },

  getArticle(id) {
    return api.get(`/articles/${id}`)
  },

  createArticle(data) {
    return api.post('/articles', data)
  },

  updateArticle(id, data) {
    return api.put(`/articles/${id}`, data)
  },

  deleteArticle(id) {
    return api.delete(`/articles/${id}`)
  },

  getUsers(params = {}) {
    return api.get('/users', { params })
  },

  getUser(id) {
    return api.get(`/users/${id}`)
  },

  createUser(data) {
    return api.post('/users', data)
  },

  updateUser(id, data) {
    return api.put(`/users/${id}`, data)
  },

  deleteUser(id) {
    return api.delete(`/users/${id}`)
  },

  getPackages() {
    return api.get('/packages')
  },

  getAdmins(params = {}) {
    return api.get('/admins', { params })
  },

  getAdmin(id) {
    return api.get(`/admins/${id}`)
  },

  createAdmin(data) {
    return api.post('/admins', data)
  },

  updateAdmin(id, data) {
    return api.put(`/admins/${id}`, data)
  },

  deleteAdmin(id) {
    return api.delete(`/admins/${id}`)
  },

  getCustomers(params = {}) {
    return api.get('/customers', { params })
  },

  getCustomer(id) {
    return api.get(`/customers/${id}`)
  },

  createCustomer(data) {
    return api.post('/customers', data)
  },

  updateCustomer(id, data) {
    return api.put(`/customers/${id}`, data)
  },

  deleteCustomer(id) {
    return api.delete(`/customers/${id}`)
  },

  exportCustomers() {
    return api.get('/customers/export', { responseType: 'blob' })
  },

  importCustomersPreview(file) {
    const formData = new FormData()
    formData.append('file', file)
    return api.post('/customers/import/preview', formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })
  },

  importCustomersConfirm(file, rows) {
    const formData = new FormData()
    formData.append('file', file)
    formData.append('rows', JSON.stringify(rows))
    return api.post('/customers/import/confirm', formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })
  },

  getImportHistory(params = {}) {
    return api.get('/customers/import/history', { params })
  },

  downloadImportFile(id) {
    return api.get(`/customers/import/history/${id}/download`, { responseType: 'blob' })
  },

  deleteImportHistory(id) {
    return api.delete(`/customers/import/history/${id}`)
  },

  getInspectionItems(params = {}) {
    return api.get('/inspection-items', { params })
  },

  getInspectionItem(id) {
    return api.get(`/inspection-items/${id}`)
  },

  createInspectionItem(data) {
    return api.post('/inspection-items', data)
  },

  updateInspectionItem(id, data) {
    return api.put(`/inspection-items/${id}`, data)
  },

  deleteInspectionItem(id) {
    return api.delete(`/inspection-items/${id}`)
  },

  exportInspectionItems() {
    return api.get('/inspection-items/export', { responseType: 'blob' })
  },

  importInspectionItemsPreview(file) {
    const formData = new FormData()
    formData.append('file', file)
    return api.post('/inspection-items/import/preview', formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })
  },

  importInspectionItemsConfirm(file, rows) {
    const formData = new FormData()
    formData.append('file', file)
    formData.append('rows', JSON.stringify(rows))
    return api.post('/inspection-items/import/confirm', formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })
  },

  getInspectionImportHistory(params = {}) {
    return api.get('/inspection-items/import/history', { params })
  },

  downloadInspectionImportFile(id) {
    return api.get(`/inspection-items/import/history/${id}/download`, { responseType: 'blob' })
  },

  deleteInspectionImportHistory(id) {
    return api.delete(`/inspection-items/import/history/${id}`)
  },

  getSettings() {
    return api.get('/settings')
  },

  updateSettings(data) {
    return api.put('/settings', data)
  },

  uploadSettingFile(field, file) {
    const formData = new FormData()
    formData.append('file', file)
    return api.post(`/settings/upload/${field}`, formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })
  }
}
