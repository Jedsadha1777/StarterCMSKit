<template>
  <div class="page">
    <div class="container">
      <h1>{{ isEdit ? 'Edit Article' : 'Create Article' }}</h1>
      
      <div class="form-card">
        <form @submit.prevent="handleSubmit">
          <div class="form-group">
            <label>Title *</label>
            <input 
              v-model="form.title" 
              type="text" 
              required 
              placeholder="Enter article title"
            >
          </div>
          
          <div class="form-group">
            <label>Content *</label>
            <textarea 
              v-model="form.content" 
              required 
              rows="10"
              placeholder="Enter article content"
            ></textarea>
          </div>
          
          <div v-if="error" class="error">{{ error }}</div>
          
          <div class="form-actions">
            <button type="submit" class="btn-primary" :disabled="loading">
              {{ loading ? 'Saving...' : 'Save' }}
            </button>
            <router-link to="/articles" class="btn-secondary">Cancel</router-link>
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
      title: '',
      content: ''
    })
    const error = ref('')
    const loading = ref(false)
    
    const isEdit = computed(() => !!route.params.id)
    
    const loadArticle = async () => {
      if (!isEdit.value) return
      
      try {
        const { data } = await api.getArticle(route.params.id)
        form.value = {
          title: data.title,
          content: data.content
        }
      } catch (err) {
        error.value = 'Failed to load article'
      }
    }
    
    const handleSubmit = async () => {
      error.value = ''
      loading.value = true
      
      try {
        if (isEdit.value) {
          await api.updateArticle(route.params.id, form.value)
        } else {
          await api.createArticle(form.value)
        }
        router.push('/articles')
      } catch (err) {
        error.value = err.response?.data?.message || 'Failed to save article'
      } finally {
        loading.value = false
      }
    }
    
    onMounted(loadArticle)
    
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

input, textarea {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 1rem;
  font-family: inherit;
  transition: border-color 0.2s;
}

input:focus, textarea:focus {
  outline: none;
  border-color: #667eea;
}

textarea {
  resize: vertical;
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
