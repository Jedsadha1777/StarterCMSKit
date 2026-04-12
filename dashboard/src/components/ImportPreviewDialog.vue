<template>
  <v-dialog :model-value="visible" persistent max-width="900" scrollable>
    <v-card>
      <v-card-title class="d-flex align-center">
        <v-icon start>mdi-file-import</v-icon>
        Import Preview
        <v-spacer />
        <v-btn icon="mdi-close" variant="text" size="small" @click="$emit('close')" />
      </v-card-title>

      <v-divider />

      <!-- Summary -->
      <div class="d-flex ga-3 pa-4">
        <v-chip color="grey">Total: {{ summary.total }}</v-chip>
        <v-chip color="success">New: {{ summary.new }}</v-chip>
        <v-chip color="warning">Replace: {{ summary.replace }}</v-chip>
        <v-chip color="grey">Unchanged: {{ summary.unchanged }}</v-chip>
        <v-chip color="error">Error: {{ summary.error }}</v-chip>
      </div>

      <v-divider />

      <!-- Preview Table -->
      <v-card-text style="max-height: 400px; overflow-y: auto; padding: 0;">
        <v-table density="compact">
          <thead>
            <tr class="bg-grey-lighten-3">
              <th style="width:50px">
                <v-checkbox-btn :model-value="allSelected" :indeterminate="someSelected && !allSelected" @update:model-value="toggleAll" density="compact" hide-details />
              </th>
              <th class="text-caption font-weight-bold" style="width:100px">Status</th>
              <th class="text-caption font-weight-bold">Customer ID</th>
              <th class="text-caption font-weight-bold">Name</th>
              <th class="text-caption font-weight-bold">Address</th>
              <th class="text-caption font-weight-bold" style="min-width:180px">Note</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="row in rows" :key="row.row" :class="rowClass(row)">
              <td>
                <v-checkbox-btn v-model="row._selected" :disabled="row.status === 'error' || row.status === 'unchanged'" density="compact" hide-details />
              </td>
              <td>
                <v-chip v-if="row.status === 'new'" color="success" size="small" variant="flat">NEW</v-chip>
                <v-chip v-else-if="row.status === 'replace'" color="warning" size="small" variant="flat">REPLACE</v-chip>
                <v-chip v-else-if="row.status === 'unchanged'" color="grey" size="small" variant="flat">UNCHANGED</v-chip>
                <v-chip v-else color="error" size="small" variant="flat">ERROR</v-chip>
              </td>
              <td class="text-caption">{{ row.customer_id }}</td>
              <td>
                <template v-if="row.status === 'replace' && row.existing">
                  {{ row.name }}
                  <div class="text-caption text-grey text-decoration-line-through">{{ row.existing.name }}</div>
                </template>
                <template v-else>{{ row.name }}</template>
              </td>
              <td>
                <template v-if="row.status === 'replace' && row.existing">
                  {{ row.address }}
                  <div class="text-caption text-grey text-decoration-line-through">{{ row.existing.address }}</div>
                </template>
                <template v-else>{{ row.address }}</template>
              </td>
              <td>
                <span v-if="row.errors.length" class="text-error text-caption">{{ row.errors.join(', ') }}</span>
              </td>
            </tr>
          </tbody>
        </v-table>
      </v-card-text>

      <v-divider />

      <v-card-actions class="pa-4">
        <v-btn variant="outlined" @click="$emit('close')">Cancel</v-btn>
        <v-spacer />
        <v-btn color="primary" variant="flat" :loading="confirming" :disabled="selectedCount === 0" @click="$emit('confirm', selectedRows)">
          <v-icon start>mdi-check</v-icon>
          Confirm Import ({{ selectedCount }})
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
import { computed } from 'vue'

export default {
  props: {
    visible: { type: Boolean, default: false },
    rows: { type: Array, default: () => [] },
    summary: { type: Object, default: () => ({ total: 0, new: 0, replace: 0, unchanged: 0, error: 0 }) },
    confirming: { type: Boolean, default: false },
  },
  emits: ['close', 'confirm'],
  setup(props) {
    const selectableRows = computed(() => props.rows.filter(r => r.status !== 'error' && r.status !== 'unchanged'))
    const selectedRows = computed(() => selectableRows.value.filter(r => r._selected))
    const selectedCount = computed(() => selectedRows.value.length)
    const allSelected = computed(() => selectableRows.value.length > 0 && selectableRows.value.every(r => r._selected))
    const someSelected = computed(() => selectableRows.value.some(r => r._selected))

    const toggleAll = (val) => {
      selectableRows.value.forEach(r => { r._selected = val })
    }

    const rowClass = (row) => {
      if (row.status === 'error') return 'bg-red-lighten-5'
      if (row.status === 'unchanged') return 'bg-grey-lighten-4'
      return ''
    }

    return { selectedRows, selectedCount, allSelected, someSelected, toggleAll, rowClass }
  }
}
</script>
