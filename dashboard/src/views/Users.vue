<template>
  <ListPage title="User Management" createTo="/users/new">
    <template #filters>
      <div class="d-flex align-center ga-3">
        <span class="text-body-2 font-weight-medium text-no-wrap">Search:</span>
        <v-text-field v-model="search" placeholder="Search by name or email..." prepend-inner-icon="mdi-magnify" variant="outlined" density="compact" hide-details clearable style="flex:1" @update:model-value="handleSearch" />
        <v-btn color="primary" variant="flat" @click="load"><v-icon start>mdi-magnify</v-icon>Search</v-btn>
      </div>
    </template>

    <template #table>
      <DataTable
        :items="items" :columns="columns" :loading="loading"
        :total="total" :page="page" :totalPages="totalPages" :visiblePages="visiblePages"
        :sortBy="sortBy" :sortDir="sortDir"
        @sort="toggleSort" @page="goToPage"
        emptyText="No users found"
      >
        <template #actions="{ item }">
          <v-btn size="small" color="info" variant="tonal" class="mr-3" :to="`/users/${item.id}/edit`"><v-icon start size="small">mdi-pencil</v-icon>Edit</v-btn>
          <v-btn size="small" color="error" variant="tonal" @click="deleteItem(item.id)"><v-icon start size="small">mdi-delete</v-icon>Delete</v-btn>
        </template>
        <template #cell-created_at="{ item }">{{ formatDate(item.created_at) }}</template>
      </DataTable>
    </template>
  </ListPage>
</template>

<script>
import { onMounted, ref } from 'vue'
import api from '../api'
import ListPage from '../components/ListPage.vue'
import DataTable from '../components/DataTable.vue'
import { useDataTable } from '../composables/useDataTable'

export default {
  components: { ListPage, DataTable },
  setup() {
    const search = ref('')

    const columns = [
      { key: 'name', label: 'Name', sortable: true },
      { key: 'email', label: 'Email', sortable: true },
      { key: 'created_at', label: 'Created', sortable: true, width: '140px', nowrap: true },
    ]

    const dt = useDataTable(load)

    async function load() {
      dt.loading.value = true
      try {
        const params = { page: dt.page.value, per_page: 10 }
        if (search.value) { params.name = search.value; params.email = search.value; params.search_logic = 'OR' }
        params.sort_by = dt.sortParam.value
        const { data } = await api.getUsers(params)
        dt.items.value = data.users; dt.total.value = data.total; dt.totalPages.value = data.pages
      } catch { alert('Failed to load users') }
      finally { dt.loading.value = false }
    }

    const deleteItem = async (id) => {
      if (!confirm('Delete this user?')) return
      try { await api.deleteUser(id); load() } catch (e) { alert(e.response?.data?.message || 'Failed') }
    }

    onMounted(load)

    return { search, columns, ...dt, load, deleteItem }
  }
}
</script>
