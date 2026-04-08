<template>
  <ListPage title="Articles" createTo="/articles/new">
    <template #filters>
      <div class="d-flex align-center ga-3 mb-3">
        <span class="text-body-2 font-weight-medium text-no-wrap">Search:</span>
        <v-text-field v-model="search" placeholder="Search by title or content..." prepend-inner-icon="mdi-magnify" variant="outlined" density="compact" hide-details clearable style="flex:1" @update:model-value="handleSearch" />
        <span class="text-body-2 font-weight-medium text-no-wrap">Status:</span>
        <v-select v-model="filterStatus" :items="statusOptions" variant="outlined" density="compact" hide-details clearable style="max-width:150px" @update:model-value="handleSearch" />
      </div>
      <div class="d-flex align-center ga-3">
        <span class="text-body-2 font-weight-medium text-no-wrap">From:</span>
        <v-text-field v-model="dateFrom" type="date" variant="outlined" density="compact" hide-details clearable style="max-width:200px" @update:model-value="handleSearch" />
        <span class="text-body-2 font-weight-medium text-no-wrap">To:</span>
        <v-text-field v-model="dateTo" type="date" variant="outlined" density="compact" hide-details clearable style="max-width:200px" @update:model-value="handleSearch" />
        <v-btn color="primary" variant="flat" @click="load"><v-icon start>mdi-magnify</v-icon>Search</v-btn>
      </div>
    </template>

    <template #table>
      <DataTable
        :items="items" :columns="columns" :loading="loading"
        :total="total" :page="page" :totalPages="totalPages" :visiblePages="visiblePages"
        :sortBy="sortBy" :sortDir="sortDir"
        @sort="toggleSort" @page="goToPage"
        emptyText="No articles found"
      >
        <template #cell-status="{ item }">
          <v-chip :color="item.status === 'published' ? 'success' : 'grey'" size="small" variant="tonal">{{ item.status }}</v-chip>
        </template>
        <template #cell-publish_date="{ item }">{{ item.publish_date ? formatDate(item.publish_date) : '-' }}</template>
        <template #cell-created_at="{ item }">{{ formatDate(item.created_at) }}</template>
        <template #actions="{ item }">
          <v-btn size="small" color="info" variant="tonal" class="mr-3" :to="`/articles/${item.id}/edit`"><v-icon start size="small">mdi-pencil</v-icon>Edit</v-btn>
          <v-btn size="small" color="error" variant="tonal" @click="deleteItem(item.id)"><v-icon start size="small">mdi-delete</v-icon>Delete</v-btn>
        </template>
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
    const filterStatus = ref(null)
    const dateFrom = ref('')
    const dateTo = ref('')
    const statusOptions = ['draft', 'published']

    const columns = [
      { key: 'title', label: 'Title', sortable: true },
      { key: 'status', label: 'Status', sortable: true, width: '100px', nowrap: true },
      { key: 'publish_date', label: 'Publish Date', sortable: true, width: '140px', nowrap: true },
      { key: 'author_email', label: 'Author', width: '120px' },
      { key: 'created_at', label: 'Created', sortable: true, width: '140px', nowrap: true },
    ]

    const dt = useDataTable(load)

    async function load() {
      dt.loading.value = true
      try {
        const params = { page: dt.page.value, per_page: 10 }
        if (search.value) { params.title = search.value; params.content = search.value; params.search_logic = 'OR' }
        if (filterStatus.value) params.status = filterStatus.value
        if (dateFrom.value) params.created_at_min = dateFrom.value + 'T00:00:00'
        if (dateTo.value) params.created_at_max = dateTo.value + 'T23:59:59'
        params.sort_by = dt.sortParam.value
        const { data } = await api.getArticles(params)
        dt.items.value = data.articles; dt.total.value = data.total; dt.totalPages.value = data.pages
      } catch { alert('Failed to load articles') }
      finally { dt.loading.value = false }
    }

    const deleteItem = async (id) => {
      if (!confirm('Delete this article?')) return
      try { await api.deleteArticle(id); load() } catch { alert('Failed to delete') }
    }

    onMounted(load)

    return { search, filterStatus, dateFrom, dateTo, statusOptions, columns, ...dt, load, deleteItem }
  }
}
</script>
