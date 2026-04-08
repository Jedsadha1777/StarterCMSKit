<template>
  <div>
    <PageBanner title="Admin Management" />

    <v-container>
      <v-row class="mb-4">
        <v-col cols="12" sm="10">
          <v-text-field v-model="searchQuery" label="Search by name or email" variant="outlined" density="compact" hide-details clearable @update:model-value="handleSearch" />
        </v-col>
        <v-col cols="12" sm="2">
          <v-btn color="primary" variant="flat" block @click="loadAdmins">Search</v-btn>
        </v-col>
      </v-row>

      <v-card variant="outlined">
        <v-table v-if="!loading && admins.length > 0" density="comfortable">
          <thead>
            <tr class="bg-grey-lighten-3">
              <th class="text-center font-weight-bold" style="width:40px">No.</th>
              <th class="font-weight-bold" style="width:80px">ID</th>
              <th class="font-weight-bold" style="cursor:pointer" @click="toggleSort('name')">Name <v-icon size="x-small">{{ sortIcon('name') }}</v-icon></th>
              <th class="font-weight-bold" style="cursor:pointer" @click="toggleSort('email')">Email <v-icon size="x-small">{{ sortIcon('email') }}</v-icon></th>
              <th class="font-weight-bold text-no-wrap" style="width:140px;white-space:nowrap;cursor:pointer" @click="toggleSort('created_at')">Created <v-icon size="x-small">{{ sortIcon('created_at') }}</v-icon></th>
              <th class="text-center font-weight-bold" style="width:200px">Settings</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(admin, idx) in admins" :key="admin.id">
              <td class="text-center">{{ (page - 1) * 10 + idx + 1 }}</td>
              <td class="text-caption"><v-tooltip :text="admin.id" location="top"><template v-slot:activator="{ props }"><span v-bind="props" style="cursor:help">{{ admin.id.substring(0, 8) }}</span></template></v-tooltip></td>
              <td>{{ admin.name }}</td>
              <td>{{ admin.email }}</td>
              <td>{{ formatDate(admin.created_at) }}</td>
              <td class="text-center">
                <v-btn size="small" color="info" variant="tonal" class="mr-2" :to="`/admins/${admin.id}/edit`">Edit</v-btn>
                <v-btn v-if="admin.id !== currentAdminId" size="small" color="error" variant="tonal" @click="deleteAdmin(admin.id)">Delete</v-btn>
                <v-chip v-else size="small" color="primary" variant="tonal">You</v-chip>
              </td>
            </tr>
          </tbody>
        </v-table>

        <v-card-text v-if="loading" class="text-center py-8">
          <v-progress-circular indeterminate color="primary" />
        </v-card-text>
        <v-card-text v-else-if="admins.length === 0" class="text-center py-8 text-grey">No admins found</v-card-text>
      </v-card>

      <div class="d-flex justify-space-between align-center mt-6">
        <v-btn color="primary" variant="flat" rounded="pill" to="/">
          <v-icon start>mdi-arrow-left</v-icon>Back
        </v-btn>
        <div v-if="admins.length > 0" class="d-flex align-center ga-3">
          <v-btn size="small" :disabled="page === 1" @click="goToPage(page - 1)"><v-icon>mdi-chevron-left</v-icon></v-btn>
          <span class="text-body-2 text-grey">Page {{ page }} / {{ totalPages }} ({{ total }})</span>
          <v-btn size="small" :disabled="page === totalPages" @click="goToPage(page + 1)"><v-icon>mdi-chevron-right</v-icon></v-btn>
        </div>
        <v-btn color="success" variant="flat" rounded="pill" to="/admins/new">
          <v-icon start>mdi-plus</v-icon>Register Admin
        </v-btn>
      </div>
    </v-container>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import api from '../api'
import PageBanner from '../components/PageBanner.vue'

export default {
  components: { PageBanner },
  setup() {
    const currentAdminId = JSON.parse(localStorage.getItem('admin') || '{}').id
    const admins = ref([]); const loading = ref(true); const searchQuery = ref('')
    const page = ref(1); const total = ref(0); const totalPages = ref(0)
    const sortBy = ref('created_at'); const sortDir = ref('desc')
    let searchTimeout = null

    const loadAdmins = async () => {
      loading.value = true
      try {
        const params = { page: page.value, per_page: 10 }
        if (searchQuery.value) { params.name = searchQuery.value; params.email = searchQuery.value; params.search_logic = 'OR' }
        params.sort_by = (sortDir.value === 'desc' ? '-' : '') + sortBy.value
        const { data } = await api.getAdmins(params)
        admins.value = data.admins; total.value = data.total; totalPages.value = data.pages
      } catch { alert('Failed to load admins') }
      finally { loading.value = false }
    }

    const toggleSort = (field) => {
      if (sortBy.value === field) sortDir.value = sortDir.value === 'asc' ? 'desc' : 'asc'
      else { sortBy.value = field; sortDir.value = 'asc' }
      page.value = 1; loadAdmins()
    }

    const sortIcon = (field) => {
      if (sortBy.value !== field) return 'mdi-unfold-more-horizontal'
      return sortDir.value === 'asc' ? 'mdi-arrow-up' : 'mdi-arrow-down'
    }

    const handleSearch = () => { clearTimeout(searchTimeout); searchTimeout = setTimeout(() => { page.value = 1; loadAdmins() }, 500) }
    const goToPage = (p) => { page.value = p; loadAdmins() }
    const deleteAdmin = async (id) => {
      if (!confirm('Delete this admin?')) return
      try { await api.deleteAdmin(id); loadAdmins() }
      catch (e) { alert(e.response?.data?.message || 'Failed to delete') }
    }
    const formatDate = (d) => {
      const date = new Date(d)
      return date.toLocaleDateString() + ' ' + date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', hour12: false })
    }
    onMounted(loadAdmins)
    return { currentAdminId, admins, loading, searchQuery, page, total, totalPages, sortBy, sortDir, handleSearch, goToPage, deleteAdmin, formatDate, loadAdmins, toggleSort, sortIcon }
  }
}
</script>
