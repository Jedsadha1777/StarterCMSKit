import axios from 'axios'
import router from './router'

const API_BASE_URL = 'http://127.0.0.1:5000/admin-api'

// Global lock for refresh token
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

// Request interceptor
api.interceptors.request.use(
  config => {
    const token = localStorage.getItem('access_token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  error => {
    return Promise.reject(error)
  }
)

// Response interceptor
api.interceptors.response.use(
  response => response,
  async error => {
    const originalRequest = error.config

    // Handle network errors
    if (!error.response) {
      console.error('Network error:', error.message)
      return Promise.reject({
        message: 'Connection error. Please check your internet.',
        type: 'NETWORK_ERROR'
      })
    }

    // Handle 5xx errors
    if (error.response.status >= 500) {
      console.error('Server error:', error.response.status)
      return Promise.reject({
        message: 'Server error. Please try again.',
        type: 'SERVER_ERROR',
        status: error.response.status
      })
    }

    // Handle 401 Unauthorized
    if (error.response.status === 401 && !originalRequest._retry) {
      const code = error.response.data?.code

      // SESSION_REPLACED / TOKEN_REUSE_DETECTED → SSE modal handles notification
      // fallback: if SSE disconnected, redirect after 2 seconds
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

      // Prevent refresh loop
      if (originalRequest.url.includes('/refresh')) {
        isRefreshing = false
        localStorage.clear()
        router.push('/login')
        return Promise.reject(error)
      }

      // If already refreshing, queue the request
      if (isRefreshing) {
        return new Promise((resolve, reject) => {
          failedQueue.push({ resolve, reject })
        })
          .then(token => {
            originalRequest.headers.Authorization = `Bearer ${token}`
            return api(originalRequest)
          })
          .catch(err => {
            return Promise.reject(err)
          })
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
        // Separate axios instance for refresh (bypass interceptor)
        const refreshApi = axios.create({
          baseURL: API_BASE_URL,
          timeout: 10000,
          withCredentials: true
        })

        // Send expired access token as Bearer (server decodes with allow_expired=True)
        // + opaque refresh token in body
        const expiredAccessToken = localStorage.getItem('access_token')
        const { data } = await refreshApi.post('/refresh', { refresh_token: refreshToken }, {
          headers: { Authorization: `Bearer ${expiredAccessToken}` }
        })

        const newAccessToken = data.access_token
        
        // Update access token
        localStorage.setItem('access_token', newAccessToken)
        
        // Update refresh token if present (rotating refresh tokens)
        if (data.refresh_token) {
          localStorage.setItem('refresh_token', data.refresh_token)
        }

        // Update header of original request
        originalRequest.headers.Authorization = `Bearer ${newAccessToken}`
        
        // Process queued requests
        processQueue(null, newAccessToken)
        isRefreshing = false

        return api(originalRequest)
      } catch (refreshError) {
        processQueue(refreshError, null)
        isRefreshing = false
        
        // Clear data and redirect
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
  }
}