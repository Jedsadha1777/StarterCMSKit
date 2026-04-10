<template>
  <div style="padding: 0 16px;">
    <v-table v-if="!loading && items.length > 0" density="comfortable" class="border rounded">
      <thead>
        <tr class="bg-grey-lighten-3">
          <!-- Dynamic columns -->
          <th
            v-for="col in columns"
            :key="col.key"
            :class="['font-weight-bold text-caption', col.nowrap ? 'text-no-wrap' : '']"
            :style="[col.width ? `width:${col.width}` : '', col.sortable ? 'cursor:pointer' : ''].filter(Boolean).join(';')"
            @click="col.sortable && $emit('sort', col.key)"
          >
            {{ col.label }}
            <v-icon v-if="col.sortable" size="x-small">{{ sortIcon(col.key) }}</v-icon>
          </th>
          <!-- Actions column -->
          <th class="text-right font-weight-bold text-caption" style="min-width:200px;width:200px">Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="item in items" :key="item.id">
          <!-- Dynamic cells -->
          <td v-for="(col, colIndex) in columns" :key="col.key" :class="[col.nowrap ? 'text-no-wrap' : '', colIndex === 0 ? 'font-weight-bold' : '']">
            <slot :name="`cell-${col.key}`" :item="item">
              <router-link v-if="colIndex === 0 && editBasePath" :to="`${editBasePath}/${item.id}/edit`" class="title-link">
                {{ item[col.key] }}
                <v-icon size="small" class="edit-icon ml-1">mdi-pencil</v-icon>
              </router-link>
              <template v-else>{{ item[col.key] }}</template>
            </slot>
          </td>
          <!-- Actions cell -->
          <td class="text-right">
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
      <div class="d-flex flex-column align-center px-4 py-3" style="gap: 4px;">
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
        <span class="text-caption text-grey">Total: {{ total }} items</span>
      </div>
    </template>
  </div>
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
    editBasePath: { type: String, default: '' },
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

<style scoped>
.title-link {
  text-decoration: none;
  color: inherit;
  display: inline-flex;
  align-items: center;
}
.title-link:hover {
  color: rgb(var(--v-theme-primary));
}
.title-link .edit-icon {
  opacity: 0;
  transition: opacity 0.2s;
}
.title-link:hover .edit-icon {
  opacity: 1;
  color: rgb(var(--v-theme-primary));
}
</style>
