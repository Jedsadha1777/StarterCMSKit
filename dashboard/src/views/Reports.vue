<template>
  <ListPage title="Reports">
    <template #filters>
      <div class="d-flex align-center ga-3 flex-wrap">
        <span class="text-body-2 font-weight-medium text-no-wrap">Search:</span>
        <v-text-field v-model="search" placeholder="Search report no or inspector..." prepend-inner-icon="mdi-magnify" variant="outlined" density="compact" hide-details clearable style="flex:1; max-width:300px" @update:model-value="handleSearch" />
        <v-select v-model="statusFilter" :items="statusOptions" label="Status" variant="outlined" density="compact" hide-details clearable style="max-width:180px" @update:model-value="load" />
        <v-btn color="primary" variant="flat" @click="load"><v-icon start>mdi-magnify</v-icon>Search</v-btn>
        <v-spacer />
      </div>
    </template>

    <template #table>
      <DataTable
        :items="items" :columns="columns" :loading="loading"
        :total="total" :page="page" :totalPages="totalPages" :visiblePages="visiblePages"
        :sortBy="sortBy" :sortDir="sortDir"
        @sort="toggleSort" @page="goToPage"
        emptyText="No reports found"
      >
        <template #cell-status="{ item }">
          <v-chip :color="statusColor(item.status)" size="small" variant="tonal">{{ item.status }}</v-chip>
        </template>
        <template #cell-created_at="{ item }">{{ formatDate(item.created_at) }}</template>
        <template #actions="{ item }">
          <v-btn v-if="item.pdf_path" size="small" color="primary" variant="tonal" class="mr-2 text-caption" @click="viewPdf(item.id)">
            <v-icon start size="small">mdi-file-pdf-box</v-icon>View PDF
          </v-btn>
          <v-chip v-else-if="item.status === 'pending_pdf'" size="small" color="orange" variant="tonal" class="mr-2">PDF Pending</v-chip>
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
    const statusFilter = ref(null)
    // Only the statuses the backend actually sets (pending_pdf on submit,
    // sent / email_failed after PDF upload). Review/approve workflow removed.
    const statusOptions = ['pending_pdf', 'sent', 'email_failed']

    const columns = [
      { key: 'report_no', label: 'Report No', sortable: true, width: '160px' },
      { key: 'status', label: 'Status', width: '130px' },
      { key: 'inspector_name', label: 'Inspector' },
      { key: 'serial_no', label: 'Serial No', width: '140px' },
      { key: 'user_name', label: 'Submitted By', width: '140px' },
      { key: 'created_at', label: 'Created', sortable: true, width: '140px', nowrap: true },
    ]

    const dt = useDataTable(load)

    async function load() {
      dt.loading.value = true
      try {
        const params = { page: dt.page.value, per_page: dt.perPage() }
        if (search.value) { params.report_no = search.value; params.inspector_name = search.value; params.search_logic = 'OR' }
        if (statusFilter.value) params.status = statusFilter.value
        params.sort_by = dt.sortParam.value
        const { data } = await api.getReports(params)
        dt.items.value = data.reports; dt.total.value = data.total; dt.totalPages.value = data.pages
      } catch { alert('Failed to load reports') }
      finally { dt.loading.value = false }
    }

    const statusColor = (status) => {
      const map = { sent: 'success', email_failed: 'error', pending_pdf: 'grey' }
      return map[status] || 'default'
    }

    const viewPdf = async (id) => {
      try {
        const { data } = await api.getReportPdf(id)
        const url = URL.createObjectURL(data)
        window.open(url, '_blank')
      } catch { alert('PDF not available') }
    }

    onMounted(load)

    return { search, statusFilter, statusOptions, columns, ...dt, load, statusColor, viewPdf }
  }
}
</script>
