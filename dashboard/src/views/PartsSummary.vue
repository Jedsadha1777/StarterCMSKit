<template>
  <ListPage title="Parts Summary">
    <template #filters>
      <div class="d-flex align-center ga-3 flex-wrap">
        <v-text-field
          v-model="searchText"
          placeholder="Search PART No. or Parts Name..."
          prepend-inner-icon="mdi-magnify"
          variant="outlined"
          density="compact"
          hide-details
          clearable
          style="flex:1; max-width:280px"
          @keyup.enter="load"
          @click:clear="onSearchClear"
        />

        <v-text-field
          v-model="reportNoText"
          placeholder="Report No..."
          prepend-inner-icon="mdi-file-document-outline"
          variant="outlined"
          density="compact"
          hide-details
          clearable
          style="max-width:200px"
          @keyup.enter="load"
          @click:clear="onReportNoClear"
        />

        <span class="text-body-2 font-weight-medium text-no-wrap">Date:</span>

        <v-menu v-model="fromMenu" :close-on-content-click="false" location="bottom">
          <template v-slot:activator="{ props }">
            <v-text-field
              :model-value="fromDate"
              label="From"
              placeholder="YYYY-MM-DD"
              readonly
              v-bind="props"
              prepend-inner-icon="mdi-calendar"
              variant="outlined"
              density="compact"
              hide-details
              clearable
              @click:clear="fromDate = ''"
              style="max-width:200px"
            />
          </template>
          <v-date-picker
            :model-value="fromDateObj"
            @update:model-value="onFromPicked"
            hide-header
          />
        </v-menu>

        <v-menu v-model="toMenu" :close-on-content-click="false" location="bottom">
          <template v-slot:activator="{ props }">
            <v-text-field
              :model-value="toDate"
              label="To"
              placeholder="YYYY-MM-DD"
              readonly
              v-bind="props"
              prepend-inner-icon="mdi-calendar"
              variant="outlined"
              density="compact"
              hide-details
              clearable
              @click:clear="toDate = ''"
              style="max-width:200px"
            />
          </template>
          <v-date-picker
            :model-value="toDateObj"
            @update:model-value="onToPicked"
            hide-header
          />
        </v-menu>

        <v-btn color="primary" variant="flat" @click="load"><v-icon start>mdi-magnify</v-icon>Search</v-btn>
        <v-btn v-if="fromDate || toDate || searchText || reportNoText" variant="text" size="small" @click="clearAll">Clear</v-btn>
        <v-spacer />
        <v-btn color="success" variant="tonal" :disabled="rows.length === 0" @click="handleExport"><v-icon start>mdi-file-export</v-icon>Export Excel</v-btn>
      </div>
    </template>

    <template #table>
      <v-table v-if="!loading && rows.length > 0" density="comfortable">
        <thead>
          <tr class="bg-grey-lighten-3">
            <th class="text-caption font-weight-bold" style="width:180px">PART No.</th>
            <th class="text-caption font-weight-bold">Parts Name</th>
            <th class="text-caption font-weight-bold text-right" style="width:120px">Total QTR.</th>
            <th class="text-caption font-weight-bold text-right" style="width:160px">Total Value</th>
            <th class="text-caption font-weight-bold text-right" style="width:140px">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="r in rows" :key="r.parts_code">
            <td class="text-caption font-weight-medium">{{ r.parts_code }}</td>
            <td class="text-caption">{{ r.parts_name }}</td>
            <td class="text-caption text-right">{{ r.total_qty.toLocaleString() }}</td>
            <td class="text-caption text-right">{{ formatValue(r.total_value) }}</td>
            <td class="text-right">
              <v-btn size="small" color="info" variant="tonal" @click="showDetail(r.parts_code)">
                <v-icon start size="small">mdi-eye</v-icon>Detail
              </v-btn>
            </td>
          </tr>
          <tr class="font-weight-bold bg-grey-lighten-4">
            <td class="text-caption">TOTAL</td>
            <td class="text-caption">{{ rows.length }} parts</td>
            <td class="text-caption text-right">{{ totalQty.toLocaleString() }}</td>
            <td class="text-caption text-right">{{ formatValue(totalValue) }}</td>
            <td></td>
          </tr>
        </tbody>
      </v-table>

      <v-card-text v-if="loading" class="text-center py-8">
        <v-progress-circular indeterminate color="primary" />
      </v-card-text>
      <v-card-text v-else-if="rows.length === 0" class="text-center py-8 text-grey">
        No parts consumption data{{ (fromDate || toDate) ? ' in the selected range' : '' }}.
      </v-card-text>
    </template>
  </ListPage>

  <!-- Drill-down dialog -->
  <v-dialog v-model="detailVisible" max-width="900" scrollable>
    <v-card v-if="detailCode">
      <v-card-title class="d-flex align-center">
        <v-icon start>mdi-nut</v-icon>
        Usage of {{ detailCode }}
        <v-spacer />
        <v-btn icon="mdi-close" variant="text" size="small" @click="detailVisible = false" />
      </v-card-title>
      <v-divider />
      <v-card-text style="max-height:500px">
        <v-table v-if="detailRows.length > 0" density="comfortable">
          <thead>
            <tr class="bg-grey-lighten-3">
              <th class="text-caption font-weight-bold">Report No</th>
              <th class="text-caption font-weight-bold">Date</th>
              <th class="text-caption font-weight-bold">Parts Name</th>
              <th class="text-caption font-weight-bold text-right">Qty</th>
              <th class="text-caption font-weight-bold text-right">Unit Price</th>
              <th class="text-caption font-weight-bold text-right">Total</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="d in detailRows" :key="d.id">
              <td class="text-caption">{{ d.report_no }}</td>
              <td class="text-caption">{{ d.consumption_dt || '—' }}</td>
              <td class="text-caption">{{ d.parts_name }}</td>
              <td class="text-caption text-right">{{ d.qty }}</td>
              <td class="text-caption text-right">{{ formatValue(d.unit_price) }}</td>
              <td class="text-caption text-right">{{ formatValue(d.total) }}</td>
            </tr>
          </tbody>
        </v-table>
        <div v-else-if="detailLoading" class="text-center py-8"><v-progress-circular indeterminate color="primary" /></div>
        <div v-else class="text-center py-8 text-grey">No usage records</div>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>

<script>
import { ref, computed, onMounted } from 'vue'
import api from '../api'
import ListPage from '../components/ListPage.vue'

// Convert Date → "YYYY-MM-DD" (local time, avoids timezone shift from toISOString)
const toISODate = (d) => {
  if (!d) return ''
  const year = d.getFullYear()
  const month = String(d.getMonth() + 1).padStart(2, '0')
  const day = String(d.getDate()).padStart(2, '0')
  return `${year}-${month}-${day}`
}

export default {
  components: { ListPage },
  setup() {
    const fromDate = ref('')
    const toDate = ref('')
    const searchText = ref('')
    const reportNoText = ref('')
    const fromMenu = ref(false)
    const toMenu = ref(false)
    const rows = ref([])
    const loading = ref(false)

    const fromDateObj = computed(() => fromDate.value ? new Date(fromDate.value) : null)
    const toDateObj = computed(() => toDate.value ? new Date(toDate.value) : null)

    const onFromPicked = (val) => {
      if (val) fromDate.value = toISODate(val instanceof Date ? val : new Date(val))
      fromMenu.value = false
    }
    const onToPicked = (val) => {
      if (val) toDate.value = toISODate(val instanceof Date ? val : new Date(val))
      toMenu.value = false
    }

    const detailVisible = ref(false)
    const detailCode = ref('')
    const detailRows = ref([])
    const detailLoading = ref(false)

    const totalQty = computed(() => rows.value.reduce((s, r) => s + (r.total_qty || 0), 0))
    const totalValue = computed(() => rows.value.reduce((s, r) => s + (r.total_value || 0), 0))

    const rangeParams = () => {
      const p = {}
      if (fromDate.value) p.from = fromDate.value
      if (toDate.value) p.to = toDate.value
      if (searchText.value && searchText.value.trim()) p.search = searchText.value.trim()
      if (reportNoText.value && reportNoText.value.trim()) p.report_no = reportNoText.value.trim()
      return p
    }

    async function load() {
      loading.value = true
      try {
        const { data } = await api.getPartsSummary(rangeParams())
        rows.value = data.rows || []
      } catch (e) { alert(e.response?.data?.message || 'Failed to load parts summary') }
      finally { loading.value = false }
    }

    const clearRange = () => { fromDate.value = ''; toDate.value = ''; load() }
    const clearAll = () => { fromDate.value = ''; toDate.value = ''; searchText.value = ''; reportNoText.value = ''; load() }
    const onSearchClear = () => { searchText.value = ''; load() }
    const onReportNoClear = () => { reportNoText.value = ''; load() }

    const handleExport = async () => {
      try {
        const { data } = await api.exportPartsSummary(rangeParams())
        const url = URL.createObjectURL(data)
        const a = document.createElement('a')
        a.href = url
        a.download = 'parts_summary.xlsx'
        a.click()
        URL.revokeObjectURL(url)
      } catch { alert('Failed to export') }
    }

    const showDetail = async (code) => {
      detailCode.value = code
      detailVisible.value = true
      detailLoading.value = true
      detailRows.value = []
      try {
        const { data } = await api.getPartsUsageByCode(code, rangeParams())
        detailRows.value = data.rows || []
      } catch { alert('Failed to load detail') }
      finally { detailLoading.value = false }
    }

    const formatValue = (v) => {
      const n = Number(v)
      return isNaN(n) ? '' : n.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })
    }

    onMounted(load)

    return {
      fromDate, toDate, searchText, reportNoText, fromMenu, toMenu, fromDateObj, toDateObj,
      rows, loading, totalQty, totalValue,
      detailVisible, detailCode, detailRows, detailLoading,
      load, clearRange, clearAll, onSearchClear, onReportNoClear, handleExport, showDetail, formatValue,
      onFromPicked, onToPicked,
    }
  }
}
</script>
