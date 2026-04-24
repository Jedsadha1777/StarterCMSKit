<template>
  <v-dialog :model-value="visible" max-width="700" scrollable @update:model-value="$emit('close')">
    <v-card>
      <v-card-title class="d-flex align-center">
        <v-icon start>mdi-history</v-icon>
        Import History
        <v-spacer />
        <v-btn icon="mdi-close" variant="text" size="small" @click="$emit('close')" />
      </v-card-title>

      <v-divider />

      <v-card-text style="max-height: 400px; overflow-y: auto; padding: 0;">
        <v-table v-if="!loading && items.length > 0" density="comfortable">
          <thead>
            <tr class="bg-grey-lighten-3">
              <th class="text-caption font-weight-bold">Filename</th>
              <th class="text-caption font-weight-bold" style="width:140px">Imported By</th>
              <th class="text-caption font-weight-bold text-no-wrap" style="width:140px">Date</th>
              <th class="text-caption font-weight-bold text-right" style="width:140px">Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in items" :key="item.id">
              <td class="text-caption">{{ item.original_filename }}</td>
              <td class="text-caption">{{ item.imported_by_name }}</td>
              <td class="text-caption text-no-wrap">{{ formatDate(item.created_at) }}</td>
              <td class="text-right">
                <v-btn size="small" color="info" variant="tonal" class="mr-1" icon="mdi-download" @click="download(item)" />
                <v-btn size="small" color="error" variant="tonal" icon="mdi-delete" @click="remove(item)" />
              </td>
            </tr>
          </tbody>
        </v-table>

        <v-card-text v-if="loading" class="text-center py-8">
          <v-progress-circular indeterminate color="primary" />
        </v-card-text>
        <v-card-text v-else-if="items.length === 0" class="text-center py-8 text-grey">
          No import history
        </v-card-text>
      </v-card-text>

      <template v-if="!loading && totalPages > 1">
        <v-divider />
        <div class="d-flex justify-center pa-3 ga-1">
          <v-btn size="small" variant="text" :disabled="page === 1" @click="goToPage(page - 1)" icon="mdi-chevron-left" />
          <v-btn v-for="p in visiblePages" :key="p" size="small" :variant="p === page ? 'flat' : 'text'" :color="p === page ? 'primary' : undefined" @click="goToPage(p)">{{ p }}</v-btn>
          <v-btn size="small" variant="text" :disabled="page === totalPages" @click="goToPage(page + 1)" icon="mdi-chevron-right" />
        </div>
      </template>
    </v-card>
  </v-dialog>
</template>

<script>
import { ref, watch, computed } from 'vue'
import api from '../api'
import { useSiteSettings } from '../composables/useSiteSettings'

const RESOURCES = ['customers', 'machine-models', 'inspection-items']

export default {
  props: {
    visible: { type: Boolean, default: false },
    resource: {
      type: String,
      required: true,
      validator: v => RESOURCES.includes(v),
    },
  },
  emits: ['close'],
  setup(props) {
    const { formatDate } = useSiteSettings()
    const items = ref([])
    const loading = ref(false)
    const page = ref(1)
    const totalPages = ref(0)
    // Defer endpoint lookup to setup (avoid TDZ with circular import through router)
    const endpoints = {
      'customers':        { get: api.getImportHistory,              download: api.downloadImportFile,              remove: api.deleteImportHistory },
      'machine-models':   { get: api.getMachineModelImportHistory,  download: api.downloadMachineModelImportFile,  remove: api.deleteMachineModelImportHistory },
      'inspection-items': { get: api.getInspectionImportHistory,    download: api.downloadInspectionImportFile,    remove: api.deleteInspectionImportHistory },
    }
    const ep = computed(() => endpoints[props.resource])

    const visiblePages = computed(() => {
      const pages = []
      const start = Math.max(1, page.value - 2)
      const end = Math.min(totalPages.value, page.value + 2)
      for (let i = start; i <= end; i++) pages.push(i)
      return pages
    })

    async function load() {
      loading.value = true
      try {
        const { data } = await ep.value.get({ page: page.value, per_page: 10 })
        items.value = data.histories
        totalPages.value = data.pages
      } catch { /* ignore */ }
      finally { loading.value = false }
    }

    const goToPage = (p) => { page.value = p; load() }

    const download = async (item) => {
      try {
        const { data } = await ep.value.download(item.id)
        const url = URL.createObjectURL(data)
        const a = document.createElement('a')
        a.href = url
        a.download = item.original_filename
        a.click()
        URL.revokeObjectURL(url)
      } catch { alert('Failed to download file') }
    }

    const remove = async (item) => {
      if (!confirm(`Delete import history "${item.original_filename}"?`)) return
      try { await ep.value.remove(item.id); load() } catch { alert('Failed to delete') }
    }

    watch(() => props.visible, (val) => {
      if (val) { page.value = 1; load() }
    })

    return { items, loading, page, totalPages, visiblePages, goToPage, download, remove, formatDate }
  }
}
</script>
