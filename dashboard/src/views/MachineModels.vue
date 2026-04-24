<template>
  <ListPage title="Machine Model Setup" createTo="/machine-models/new">
    <template #filters>
      <div class="d-flex align-center ga-3 flex-wrap">
        <span class="text-body-2 font-weight-medium text-no-wrap">Search:</span>
        <v-text-field v-model="search" placeholder="Search by code or name..." prepend-inner-icon="mdi-magnify" variant="outlined" density="compact" hide-details clearable style="flex:1; max-width:400px" @update:model-value="handleSearch" />
        <v-btn color="primary" variant="flat" @click="load"><v-icon start>mdi-magnify</v-icon>Search</v-btn>
        <v-spacer />
        <v-btn color="success" variant="tonal" @click="handleExport"><v-icon start>mdi-file-export</v-icon>Export</v-btn>
        <v-btn color="info" variant="tonal" @click="triggerImport"><v-icon start>mdi-file-import</v-icon>Import</v-btn>
        <v-btn color="info" variant="tonal" @click="showHistory = true"><v-icon start>mdi-history</v-icon>History</v-btn>
        <input ref="fileInput" type="file" accept=".xlsx" hidden @change="handleFileSelected" />
      </div>
    </template>

    <template #table>
      <DataTable
        :items="items" :columns="columns" :loading="loading"
        :total="total" :page="page" :totalPages="totalPages" :visiblePages="visiblePages"
        :sortBy="sortBy" :sortDir="sortDir"
        @sort="toggleSort" @page="goToPage"
        editBasePath="/machine-models"
        emptyText="No machine models found"
      >
        <template #actions="{ item }">
          <v-btn size="small" color="info" variant="tonal" class="mr-2 text-caption" style="min-width:80px" :to="`/machine-models/${item.id}/edit`"><v-icon start size="small">mdi-pencil</v-icon>Edit</v-btn>
          <v-btn size="small" color="error" variant="tonal" class="text-caption" style="min-width:80px" @click="deleteItem(item.id)"><v-icon start size="small">mdi-delete</v-icon>Delete</v-btn>
        </template>
        <template #cell-inspection_items="{ item }">
          <v-chip size="small" color="primary" variant="tonal">{{ (item.inspection_items || []).length }} items</v-chip>
        </template>
        <template #cell-created_at="{ item }">{{ formatDate(item.created_at) }}</template>
      </DataTable>
    </template>
  </ListPage>

  <ImportPreviewDialog
    :visible="showPreview"
    :rows="previewRows"
    :summary="previewSummary"
    :confirming="confirming"
    :columns="previewColumns"
    @close="showPreview = false"
    @confirm="handleConfirm"
  />

  <ImportHistoryDialog
    :visible="showHistory"
    resource="machine-models"
    @close="showHistory = false"
  />
</template>

<script>
import { onMounted, ref } from 'vue'
import api from '../api'
import ListPage from '../components/ListPage.vue'
import DataTable from '../components/DataTable.vue'
import ImportPreviewDialog from '../components/ImportPreviewDialog.vue'
import ImportHistoryDialog from '../components/ImportHistoryDialog.vue'
import { useDataTable } from '../composables/useDataTable'

export default {
  components: { ListPage, DataTable, ImportPreviewDialog, ImportHistoryDialog },
  setup() {
    const search = ref('')
    const fileInput = ref(null)
    const importFile = ref(null)
    const showPreview = ref(false)
    const showHistory = ref(false)
    const previewRows = ref([])
    const previewSummary = ref({ total: 0, new: 0, replace: 0, unchanged: 0, error: 0 })
    const confirming = ref(false)

    const columns = [
      { key: 'model_code', label: 'Model Code', sortable: true, width: '160px' },
      { key: 'model_name', label: 'Model Name', sortable: true, link: true },
      { key: 'inspection_items', label: 'Inspection Items', width: '140px' },
      { key: 'created_by_name', label: 'Created By', width: '140px' },
      { key: 'created_at', label: 'Created', sortable: true, width: '140px', nowrap: true },
    ]

    const previewColumns = ['model_code', 'model_name']

    const dt = useDataTable(load)

    async function load() {
      dt.loading.value = true
      try {
        const params = { page: dt.page.value, per_page: dt.perPage() }
        if (search.value) { params.model_code = search.value; params.model_name = search.value; params.search_logic = 'OR' }
        params.sort_by = dt.sortParam.value
        const { data } = await api.getMachineModels(params)
        dt.items.value = data.machine_models; dt.total.value = data.total; dt.totalPages.value = data.pages
      } catch { alert('Failed to load machine models') }
      finally { dt.loading.value = false }
    }

    const deleteItem = async (id) => {
      if (!confirm('Delete this machine model?')) return
      try { await api.deleteMachineModel(id); load() } catch (e) { alert(e.response?.data?.message || 'Failed') }
    }

    const handleExport = async () => {
      try {
        const { data } = await api.exportMachineModels()
        const url = URL.createObjectURL(data)
        const a = document.createElement('a')
        a.href = url; a.download = 'machine_models.xlsx'; a.click()
        URL.revokeObjectURL(url)
      } catch { alert('Failed to export') }
    }

    const triggerImport = () => { fileInput.value.value = ''; fileInput.value.click() }

    const handleFileSelected = async (e) => {
      const file = e.target.files[0]
      if (!file) return
      importFile.value = file
      try {
        const { data } = await api.importMachineModelsPreview(file)
        previewRows.value = data.rows.map(r => ({ ...r, _selected: r.status === 'new' || r.status === 'replace' }))
        previewSummary.value = data.summary
        showPreview.value = true
      } catch (err) { alert(err.response?.data?.message || 'Failed to preview') }
    }

    const handleConfirm = async (selectedRows) => {
      confirming.value = true
      try {
        const rows = selectedRows.map(r => ({ model_code: r.model_code, model_name: r.model_name }))
        const { data } = await api.importMachineModelsConfirm(importFile.value, rows)
        showPreview.value = false
        alert(`Import completed: ${data.created} created, ${data.updated} updated`)
        load()
      } catch (err) { alert(err.response?.data?.message || 'Import failed') }
      finally { confirming.value = false }
    }

    onMounted(load)

    return {
      search, columns, ...dt, load, deleteItem, api,
      fileInput, showPreview, previewRows, previewSummary, previewColumns, confirming, showHistory,
      handleExport, triggerImport, handleFileSelected, handleConfirm,
    }
  }
}
</script>
