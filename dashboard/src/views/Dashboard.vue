<template>
  <div class="page">
    <div class="container">
      <h1>Dashboard</h1>
      
      <div class="stats">
        <div class="stat-card">
          <div class="stat-value">{{ stats.articles }}</div>
          <div class="stat-label">Articles</div>
        </div>
        
        <div class="stat-card">
          <div class="stat-value">{{ stats.users }}</div>
          <div class="stat-label">Users</div>
        </div>
        
        <div class="stat-card">
          <div class="stat-value">{{ adminInfo.email }}</div>
          <div class="stat-label">Logged in as</div>
        </div>
      </div>
      
      <div class="quick-actions">
        <h2>Quick Actions</h2>
        <div class="actions-grid">
          <router-link to="/articles/new" class="action-card">
            <span class="icon">📝</span>
            <span>Create Article</span>
          </router-link>
          
          <router-link to="/users/new" class="action-card">
            <span class="icon">👤</span>
            <span>Create User</span>
          </router-link>
          
          <router-link to="/articles" class="action-card">
            <span class="icon">📚</span>
            <span>View Articles</span>
          </router-link>
          
          <router-link to="/users" class="action-card">
            <span class="icon">👥</span>
            <span>View Users</span>
          </router-link>
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
    const stats = ref({
      articles: 0,
      users: 0
    })
    
    const adminInfo = ref(JSON.parse(localStorage.getItem('admin') || '{}'))
    
    const loadStats = async () => {
      try {
        const [articlesRes, usersRes] = await Promise.all([
          api.getArticles(),
          api.getUsers()
        ])
        
        stats.value.articles = articlesRes.data.length
        stats.value.users = usersRes.data.length
      } catch (error) {
        console.error('Failed to load stats:', error)
      }
    }
    
    onMounted(loadStats)
    
    return { stats, adminInfo }
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
  margin: 2rem 0 1rem;
  color: #2c3e50;
}

.stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1.5rem;
  margin-bottom: 3rem;
}

.stat-card {
  background: white;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  text-align: center;
}

.stat-value {
  font-size: 2.5rem;
  font-weight: bold;
  color: #667eea;
  margin-bottom: 0.5rem;
}

.stat-label {
  color: #666;
  font-size: 0.9rem;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.actions-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1.5rem;
}

.action-card {
  background: white;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  text-decoration: none;
  color: #2c3e50;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
  transition: transform 0.2s, box-shadow 0.2s;
}

.action-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}

.action-card .icon {
  font-size: 2rem;
}
</style>
