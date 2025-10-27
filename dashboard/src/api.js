import axios from 'axios'
import router from './router'

const API_BASE_URL = 'http://127.0.0.1:5000/admin-api'

// Global lock สำหรับ refresh token
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

    // จัดการ network errors
    if (!error.response) {
      console.error('Network error:', error.message)
      return Promise.reject({
        message: 'เกิดข้อผิดพลาดในการเชื่อมต่อ กรุณาตรวจสอบอินเทอร์เน็ต',
        type: 'NETWORK_ERROR'
      })
    }

    // จัดการ 5xx errors
    if (error.response.status >= 500) {
      console.error('Server error:', error.response.status)
      return Promise.reject({
        message: 'เซิร์ฟเวอร์ขัดข้อง กรุณาลองใหม่อีกครั้ง',
        type: 'SERVER_ERROR',
        status: error.response.status
      })
    }

    // จัดการ 401 Unauthorized
    if (error.response.status === 401 && !originalRequest._retry) {
      // ป้องกันการ refresh loop
      if (originalRequest.url.includes('/refresh')) {
        isRefreshing = false
        localStorage.clear()
        router.push('/login')
        return Promise.reject(error)
      }

      // ถ้ากำลัง refresh อยู่ ให้เข้าคิว
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
        // สร้าง axios instance แยกสำหรับ refresh (ไม่ผ่าน interceptor)
        const refreshApi = axios.create({
          baseURL: API_BASE_URL,
          timeout: 10000,
          withCredentials: true
        })

        const { data } = await refreshApi.post('/refresh', {}, {
          headers: { Authorization: `Bearer ${refreshToken}` }
        })

        const newAccessToken = data.access_token
        
        // อัปเดต access token
        localStorage.setItem('access_token', newAccessToken)
        
        // อัปเดต refresh token ถ้ามี (rotating refresh tokens)
        if (data.refresh_token) {
          localStorage.setItem('refresh_token', data.refresh_token)
        }

        // อัปเดต header ของ request เดิม
        originalRequest.headers.Authorization = `Bearer ${newAccessToken}`
        
        // ประมวลผล queued requests
        processQueue(null, newAccessToken)
        isRefreshing = false

        return api(originalRequest)
      } catch (refreshError) {
        processQueue(refreshError, null)
        isRefreshing = false
        
        // ล้างข้อมูลและ redirect
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

  changePassword(oldPassword, newPassword) {
    return api.put('/profile/change-password', {
      old_password: oldPassword,
      new_password: newPassword
    })
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
  }
}