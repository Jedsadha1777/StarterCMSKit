<template>
  <div>
    <PageBanner :title="title" />

    <v-container>
      <!-- Create button -->
      <div class="d-flex justify-end mb-4">
        <v-btn color="success" variant="flat" :to="createTo">
          <v-icon start>mdi-plus</v-icon>Create New
        </v-btn>
      </div>

      <!-- Filter bar -->
      <v-card variant="outlined" class="mb-4 pa-3">
        <slot name="filters" />
      </v-card>

      <!-- Table -->
      <slot name="table" />

      <!-- Back -->
      <div class="mt-4">
        <v-btn color="primary" variant="flat" rounded="pill" :to="backTo">
          <v-icon start>mdi-arrow-left</v-icon>Back
        </v-btn>
      </div>
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
