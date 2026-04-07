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
.profile-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
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

.btn-primary {
  width: 100%;
}
</style>
