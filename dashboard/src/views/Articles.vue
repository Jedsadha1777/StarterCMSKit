<template>
  <div class="page">
    <div class="container">
      <div class="header">
        <h1>Articles</h1>
        <router-link to="/articles/new" class="btn-primary">Create Article</router-link>
      </div>
      
      <div class="search-bar">
        <input 
          v-model="searchTitle" 
          type="text" 
          placeholder="Search by title..."
          @input="handleSearch"
        >
        <input 
          v-model="searchContent" 
          type="text" 
          placeholder="Search by content..."
          @input="handleSearch"
        >
      </div>
      
      <div v-if="loading" class="loading">Loading...</div>
      
      <div v-else-if="articles.length === 0" class="empty">
        No articles found
      </div>
      
      <div v-else class="table-container">
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Title</th>
              <th>Author</th>
              <th>Created</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="article in articles" :key="article.id">
              <td>{{ article.id }}</td>
              <td>{{ article.title }}</td>
              <td>{{ article.author_email }}</td>
              <td>{{ formatDate(article.created_at) }}</td>
              <td>
                <div class="actions">
                  <router-link 
                    :to="`/articles/${article.id}/edit`" 
                    class="btn-sm btn-edit"
                  >
                    Edit
                  </router-link>
                  <button 
                    @click="deleteArticle(article.id)" 
                    class="btn-sm btn-delete"
                  >
                    Delete
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
        
        <div class="pagination">
          <button 
            @click="goToPage(page - 1)" 
            :disabled="page === 1"
            class="btn-page"
          >
            Previous
          </button>
          
          <span class="page-info">
            Page {{ page }} of {{ totalPages }} ({{ total }} total)
          </span>
          
          <button 
            @click="goToPage(page + 1)" 
            :disabled="page === totalPages"
            class="btn-page"
          >
            Next
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import api from '../api'

export default {
  setup() {
    const articles = ref([])
    const loading = ref(true)
    const searchTitle = ref('')
    const searchContent = ref('')
    const page = ref(1)
    const perPage = ref(10)
    const total = ref(0)
    const totalPages = ref(0)
    
    let searchTimeout = null
    
    const loadArticles = async () => {
      loading.value = true
      try {
        const params = {
          page: page.value,
          per_page: perPage.value
        }
        
        if (searchTitle.value) {
          params.title = searchTitle.value
        }
        
        if (searchContent.value) {
          params.content = searchContent.value
        }
        
        const { data } = await api.getArticles(params)
        articles.value = data.articles
        total.value = data.total
        totalPages.value = data.pages
      } catch (error) {
        alert('Failed to load articles')
      } finally {
        loading.value = false
      }
    }
    
    const handleSearch = () => {
      clearTimeout(searchTimeout)
      searchTimeout = setTimeout(() => {
        page.value = 1
        loadArticles()
      }, 500)
    }
    
    const goToPage = (newPage) => {
      if (newPage >= 1 && newPage <= totalPages.value) {
        page.value = newPage
        loadArticles()
      }
    }
    
    const deleteArticle = async (id) => {
      if (!confirm('Are you sure you want to delete this article?')) return
      
      try {
        await api.deleteArticle(id)
        loadArticles()
      } catch (error) {
        alert('Failed to delete article')
      }
    }
    
    const formatDate = (dateString) => {
      return new Date(dateString).toLocaleDateString()
    }
    
    onMounted(loadArticles)
    
    return {
      articles,
      loading,
      searchTitle,
      searchContent,
      page,
      total,
      totalPages,
      handleSearch,
      goToPage,
      deleteArticle,
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

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
}

h1 {
  color: #2c3e50;
}

.btn-primary {
  background: #667eea;
  color: white;
  padding: 0.75rem 1.5rem;
  border-radius: 4px;
  text-decoration: none;
  transition: background 0.2s;
}

.btn-primary:hover {
  background: #5568d3;
}

.search-bar {
  display: flex;
  gap: 1rem;
  margin-bottom: 2rem;
}

.search-bar input {
  flex: 1;
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 1rem;
}

.search-bar input:focus {
  outline: none;
  border-color: #667eea;
}

.loading, .empty {
  text-align: center;
  padding: 3rem;
  color: #666;
}

.table-container {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  overflow: hidden;
}

table {
  width: 100%;
  border-collapse: collapse;
}

th {
  background: #f8f9fa;
  padding: 1rem;
  text-align: left;
  font-weight: 600;
  color: #2c3e50;
  border-bottom: 2px solid #e9ecef;
}

td {
  padding: 1rem;
  border-bottom: 1px solid #e9ecef;
}

.actions {
  display: flex;
  gap: 0.5rem;
}

.btn-sm {
  padding: 0.4rem 0.8rem;
  border-radius: 4px;
  font-size: 0.875rem;
  border: none;
  cursor: pointer;
  text-decoration: none;
  transition: opacity 0.2s;
}

.btn-sm:hover {
  opacity: 0.8;
}

.btn-edit {
  background: #3498db;
  color: white;
}

.btn-delete {
  background: #e74c3c;
  color: white;
}

.pagination {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  background: #f8f9fa;
}

.btn-page {
  padding: 0.5rem 1rem;
  background: #667eea;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: background 0.2s;
}

.btn-page:hover:not(:disabled) {
  background: #5568d3;
}

.btn-page:disabled {
  background: #ccc;
  cursor: not-allowed;
}

.page-info {
  color: #666;
  font-size: 0.9rem;
}
</style>