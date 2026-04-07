<template>
  <div class="page">
    <div class="container">
      <div class="header">
        <h1>Users</h1>
        <router-link to="/users/new" class="btn-primary">Create User</router-link>
      </div>
      
      <div class="search-bar">
        <input 
          v-model="searchEmail" 
          type="text" 
          placeholder="Search by email..."
          @input="handleSearch"
        >
      </div>
      
      <div v-if="loading" class="loading">Loading...</div>
      
      <div v-else-if="users.length === 0" class="empty">
        No users found
      </div>
      
      <div v-else class="table-container">
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Email</th>
              <th>Created</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="user in users" :key="user.id">
              <td>{{ user.id }}</td>
              <td>{{ user.email }}</td>
              <td>{{ formatDate(user.created_at) }}</td>
              <td>
                <div class="actions">
                  <router-link 
                    :to="`/users/${user.id}/edit`" 
                    class="btn-sm btn-edit"
                  >
                    Edit
                  </router-link>
                  <button 
                    @click="deleteUser(user.id)" 
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
    const users = ref([])
    const loading = ref(true)
    const searchEmail = ref('')
    const page = ref(1)
    const perPage = ref(10)
    const total = ref(0)
    const totalPages = ref(0)
    
    let searchTimeout = null
    
    const loadUsers = async () => {
      loading.value = true
      try {
        const params = {
          page: page.value,
          per_page: perPage.value
        }
        
        if (searchEmail.value) {
          params.email = searchEmail.value
        }
        
        const { data } = await api.getUsers(params)
        users.value = data.users
        total.value = data.total
        totalPages.value = data.pages
      } catch (error) {
        alert('Failed to load users')
      } finally {
        loading.value = false
      }
    }
    
    const handleSearch = () => {
      clearTimeout(searchTimeout)
      searchTimeout = setTimeout(() => {
        page.value = 1
        loadUsers()
      }, 500)
    }
    
    const goToPage = (newPage) => {
      if (newPage >= 1 && newPage <= totalPages.value) {
        page.value = newPage
        loadUsers()
      }
    }
    
    const deleteUser = async (id) => {
      if (!confirm('Are you sure you want to delete this user?')) return
      
      try {
        await api.deleteUser(id)
        loadUsers()
      } catch (error) {
        alert(error.response?.data?.message || 'Failed to delete user')
      }
    }
    
    const formatDate = (dateString) => {
      return new Date(dateString).toLocaleDateString()
    }
    
    onMounted(loadUsers)
    
    return {
      users,
      loading,
      searchEmail,
      page,
      total,
      totalPages,
      handleSearch,
      goToPage,
      deleteUser,
      formatDate
    }
  }
}
</script>

<style scoped>
</style>