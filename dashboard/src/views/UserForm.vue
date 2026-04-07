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
.container {
  max-width: 800px;
}
</style>
