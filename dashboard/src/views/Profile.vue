<template>
  <div class="page">
    <div class="container">
      <h1>Profile</h1>
      
      <div class="profile-grid">
        <div class="card">
          <h2>Account Information</h2>
          <div class="info-row">
            <span class="label">Email:</span>
            <span class="value">{{ admin.email }}</span>
          </div>
          <div class="info-row">
            <span class="label">Account ID:</span>
            <span class="value">{{ admin.id }}</span>
          </div>
          <div class="info-row">
            <span class="label">Created:</span>
            <span class="value">{{ formatDate(admin.created_at) }}</span>
          </div>
        </div>
        
        <div class="card">
          <h2>Change Password</h2>
          <form @submit.prevent="handleChangePassword">
            <div class="form-group">
              <label>Current Password</label>
              <input 
                v-model="passwordForm.oldPassword" 
                type="password" 
                required
              >
            </div>
            
            <div class="form-group">
              <label>New Password</label>
              <input 
                v-model="passwordForm.newPassword" 
                type="password" 
                required
                minlength="6"
              >
            </div>
            
            <div class="form-group">
              <label>Confirm New Password</label>
              <input 
                v-model="passwordForm.confirmPassword" 
                type="password" 
                required
              >
            </div>
            
            <div v-if="error" class="error">{{ error }}</div>
            <div v-if="success" class="success">{{ success }}</div>
            
            <button type="submit" class="btn-primary" :disabled="loading">
              {{ loading ? 'Changing...' : 'Change Password' }}
            </button>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref } from 'vue'
import api from '../api'

export default {
  setup() {
    const admin = ref(JSON.parse(localStorage.getItem('admin') || '{}'))
    const passwordForm = ref({
      oldPassword: '',
      newPassword: '',
      confirmPassword: ''
    })
    const error = ref('')
    const success = ref('')
    const loading = ref(false)
    
    const handleChangePassword = async () => {
      error.value = ''
      success.value = ''
      
      if (passwordForm.value.newPassword !== passwordForm.value.confirmPassword) {
        error.value = 'New passwords do not match'
        return
      }
      
      if (passwordForm.value.newPassword.length < 6) {
        error.value = 'Password must be at least 6 characters'
        return
      }
      
      loading.value = true
      
      try {
        await api.changePassword(
          passwordForm.value.oldPassword,
          passwordForm.value.newPassword
        )
        success.value = 'Password changed successfully'
        passwordForm.value = {
          oldPassword: '',
          newPassword: '',
          confirmPassword: ''
        }
      } catch (err) {
        error.value = err.response?.data?.message || 'Failed to change password'
      } finally {
        loading.value = false
      }
    }
    
    const formatDate = (dateString) => {
      return new Date(dateString).toLocaleDateString()
    }
    
    return {
      admin,
      passwordForm,
      error,
      success,
      loading,
      handleChangePassword,
      formatDate
    }
  }
}
</script>

<style scoped>
.page {
  padding: 2rem 0;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 1rem;
}

h1 {
  margin-bottom: 2rem;
  color: #2c3e50;
}

h2 {
  margin-bottom: 1.5rem;
  color: #2c3e50;
  font-size: 1.25rem;
}

.profile-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
}

.card {
  background: white;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.info-row {
  display: flex;
  justify-content: space-between;
  padding: 0.75rem 0;
  border-bottom: 1px solid #e9ecef;
}

.info-row:last-child {
  border-bottom: none;
}

.label {
  font-weight: 500;
  color: #666;
}

.value {
  color: #2c3e50;
}

.form-group {
  margin-bottom: 1.5rem;
}

label {
  display: block;
  margin-bottom: 0.5rem;
  color: #555;
  font-weight: 500;
}

input {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 1rem;
  transition: border-color 0.2s;
}

input:focus {
  outline: none;
  border-color: #667eea;
}

.error {
  background: #fee;
  color: #c33;
  padding: 0.75rem;
  border-radius: 4px;
  margin-bottom: 1rem;
}

.success {
  background: #d4edda;
  color: #155724;
  padding: 0.75rem;
  border-radius: 4px;
  margin-bottom: 1rem;
}

.btn-primary {
  width: 100%;
  padding: 0.75rem;
  background: #667eea;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 1rem;
  cursor: pointer;
  transition: background 0.2s;
}

.btn-primary:hover:not(:disabled) {
  background: #5568d3;
}

.btn-primary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
</style>
