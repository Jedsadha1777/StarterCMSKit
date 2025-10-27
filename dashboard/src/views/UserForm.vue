<template>
  <div class="page">
    <div class="container">
      <h1>{{ isEdit ? 'Edit User' : 'Create User' }}</h1>
      
      <div class="form-card">
        <form @submit.prevent="handleSubmit">
          <div class="form-group">
            <label>Email *</label>
            <input 
              v-model="form.email" 
              type="email" 
              required 
              placeholder="user@example.com"
            >
          </div>
          
          <div class="form-group">
            <label>Password {{ isEdit ? '(leave blank to keep current)' : '*' }}</label>
            <input 
              v-model="form.password" 
              type="password" 
              :required="!isEdit"
              placeholder="••••••••"
            >
          </div>
          
          <div v-if="error" class="error">{{ error }}</div>
          
          <div class="form-actions">
            <button type="submit" class="btn-primary" :disabled="loading">
              {{ loading ? 'Saving...' : 'Save' }}
            </button>
            <router-link to="/users" class="btn-secondary">Cancel</router-link>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '../api'

export default {
  setup() {
    const route = useRoute()
    const router = useRouter()
    const form = ref({
      email: '',
      password: ''
    })
    const error = ref('')
    const loading = ref(false)
    
    const isEdit = computed(() => !!route.params.id)
    
    const loadUser = async () => {
      if (!isEdit.value) return
      
      try {
        const { data } = await api.getUser(route.params.id)
        form.value.email = data.email
      } catch (err) {
        error.value = 'Failed to load user'
      }
    }
    
    const handleSubmit = async () => {
      error.value = ''
      loading.value = true
      
      try {
        const payload = { email: form.value.email }
        if (form.value.password) {
          payload.password = form.value.password
        }
        
        if (isEdit.value) {
          await api.updateUser(route.params.id, payload)
        } else {
          await api.createUser(payload)
        }
        router.push('/users')
      } catch (err) {
        error.value = err.response?.data?.message || 'Failed to save user'
      } finally {
        loading.value = false
      }
    }
    
    onMounted(loadUser)
    
    return {
      form,
      error,
      loading,
      isEdit,
      handleSubmit
    }
  }
}
</script>

<style scoped>
.page {
  padding: 2rem 0;
}

.container {
  max-width: 800px;
  margin: 0 auto;
  padding: 0 1rem;
}

h1 {
  margin-bottom: 2rem;
  color: #2c3e50;
}

.form-card {
  background: white;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
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

.form-actions {
  display: flex;
  gap: 1rem;
}

.btn-primary, .btn-secondary {
  padding: 0.75rem 1.5rem;
  border-radius: 4px;
  font-size: 1rem;
  cursor: pointer;
  text-decoration: none;
  border: none;
  transition: opacity 0.2s;
}

.btn-primary {
  background: #667eea;
  color: white;
}

.btn-primary:hover:not(:disabled) {
  opacity: 0.9;
}

.btn-primary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.btn-secondary {
  background: #e9ecef;
  color: #495057;
  display: inline-block;
  text-align: center;
}

.btn-secondary:hover {
  opacity: 0.9;
}
</style>
