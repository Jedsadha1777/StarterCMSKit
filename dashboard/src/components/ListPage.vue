<template>
  <div>
    <PageBanner :title="title" />

    <v-container fluid>
      <!-- Create button -->
      <div class="d-flex justify-end mb-4">
        <v-btn color="success" variant="flat" :to="createTo">
          <v-icon start>mdi-plus</v-icon>Create New
        </v-btn>
      </div>

      <!-- Filter + Table -->
      <v-card variant="outlined" style="border-width: thin; border-color: rgba(0,0,0,0.2);">
        <div style="padding: 16px;">
          <slot name="filters" />
        </div>
        <v-divider style="border-color: rgba(0,0,0,0.08);" />
        <slot name="table" />
      </v-card>

    </v-container>
  </div>
</template>

<script>
import PageBanner from './PageBanner.vue'

export default {
  components: { PageBanner },
  props: {
    title: { type: String, required: true },
    createTo: { type: String, required: true },
    backTo: { type: String, default: '/' },
  }
}
</script>
