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
.container {
  max-width: 800px;
}
</style>
