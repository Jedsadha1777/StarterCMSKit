<template>
  <v-card variant="outlined">
    <v-table v-if="!loading && items.length > 0" density="comfortable">
      <thead>
        <tr class="bg-grey-lighten-3">
          <!-- ID column (always first) -->
          <th class="font-weight-bold" style="width:80px">ID</th>
          <!-- Dynamic columns -->
          <th
            v-for="col in columns"
            :key="col.key"
            :class="['font-weight-bold', col.nowrap ? 'text-no-wrap' : '']"
            :style="[col.width ? `width:${col.width}` : '', col.sortable ? 'cursor:pointer' : ''].filter(Boolean).join(';')"
            @click="col.sortable && $emit('sort', col.key)"
          >
            {{ col.label }}
            <v-icon v-if="col.sortable" size="x-small">{{ sortIcon(col.key) }}</v-icon>
          </th>
          <!-- Actions column -->
          <th class="text-center font-weight-bold" style="min-width:240px;width:240px">Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="item in items" :key="item.id">
          <!-- ID cell -->
          <td class="text-caption">
            <v-tooltip :text="item.id" location="top">
              <template v-slot:activator="{ props }">
                <span v-bind="props" style="cursor:help">{{ item.id.substring(0, 8) }}</span>
              </template>
            </v-tooltip>
          </td>
          <!-- Dynamic cells -->
          <td v-for="col in columns" :key="col.key" :class="col.nowrap ? 'text-no-wrap' : ''">
            <slot :name="`cell-${col.key}`" :item="item">
              {{ item[col.key] }}
            </slot>
          </td>
          <!-- Actions cell -->
          <td class="text-center">
            <slot name="actions" :item="item" />
          </td>
        </tr>
      </tbody>
    </v-table>

    <v-card-text v-if="loading" class="text-center py-8">
      <v-progress-circular indeterminate color="primary" />
    </v-card-text>
    <v-card-text v-else-if="items.length === 0" class="text-center py-8 text-grey">
      {{ emptyText }}
    </v-card-text>

    <!-- Pagination -->
    <template v-if="!loading && items.length > 0">
      <v-divider />
      <div class="d-flex justify-space-between align-center px-4 py-3">
        <span class="text-body-2 text-grey">Total: {{ total }} items</span>
        <div class="d-flex align-center ga-1">
          <v-btn size="small" variant="text" :disabled="page === 1" @click="$emit('page', page - 1)" icon="mdi-chevron-left" />
          <v-btn
            v-for="p in visiblePages"
            :key="p"
            size="small"
            :variant="p === page ? 'flat' : 'text'"
            :color="p === page ? 'primary' : undefined"
            @click="$emit('page', p)"
          >{{ p }}</v-btn>
          <v-btn size="small" variant="text" :disabled="page === totalPages" @click="$emit('page', page + 1)" icon="mdi-chevron-right" />
        </div>
      </div>
    </template>
  </v-card>
</template>

<script>
export default {
  props: {
    items: { type: Array, default: () => [] },
    columns: { type: Array, required: true },
    loading: { type: Boolean, default: false },
    total: { type: Number, default: 0 },
    page: { type: Number, default: 1 },
    totalPages: { type: Number, default: 0 },
    visiblePages: { type: Array, default: () => [] },
    sortBy: { type: String, default: '' },
    sortDir: { type: String, default: 'asc' },
    emptyText: { type: String, default: 'No data found' },
  },
  emits: ['sort', 'page'],
  setup(props) {
    const sortIcon = (field) => {
      if (props.sortBy !== field) return 'mdi-unfold-more-horizontal'
      return props.sortDir === 'asc' ? 'mdi-arrow-up' : 'mdi-arrow-down'
    }
    return { sortIcon }
  }
}
</script>
