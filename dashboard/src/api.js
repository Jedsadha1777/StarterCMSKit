import axios from 'axios'
import router from './router'
import { API_BASE_URL } from './config'

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
    const token = localStorage.getItem('access_token')
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
          if (localStorage.getItem('access_token')) {
            localStorage.clear()
            router.push('/login')
          }
        }, 2000)
        return Promise.reject(error)
      }

      if (originalRequest.url.includes('/refresh')) {
        isRefreshing = false
        localStorage.clear()
        router.push('/login')
        return Promise.reject(error)
      }

      if (isRefreshing) {
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

      const refreshToken = localStorage.getItem('refresh_token')

      if (!refreshToken) {
        isRefreshing = false
        localStorage.clear()
        router.push('/login')
        return Promise.reject(error)
      }

      try {
        const refreshApi = axios.create({
          baseURL: API_BASE_URL,
          timeout: 10000,
          withCredentials: true
        })

        const expiredAccessToken = localStorage.getItem('access_token')
        const { data } = await refreshApi.post('/refresh', { refresh_token: refreshToken }, {
          headers: { Authorization: `Bearer ${expiredAccessToken}` }
        })

        localStorage.setItem('access_token', data.access_token)
        if (data.refresh_token) {
          localStorage.setItem('refresh_token', data.refresh_token)
        }

        originalRequest.headers.Authorization = `Bearer ${data.access_token}`
        processQueue(null, data.access_token)
        isRefreshing = false

        return api(originalRequest)
      } catch (refreshError) {
        processQueue(refreshError, null)
        isRefreshing = false
        localStorage.clear()
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
      localStorage.clear()
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
