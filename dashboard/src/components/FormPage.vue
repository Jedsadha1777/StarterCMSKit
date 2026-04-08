<template>
  <div>
    <PageBanner :title="title" />

    <v-container style="max-width: 800px">
      <v-card variant="outlined" style="border-color: rgba(0,0,0,0.12);">
        <v-card-text class="pa-6">
          <v-form @submit.prevent="$emit('submit')">
            <slot />
            <p v-if="error" class="text-error text-body-2 mb-4">{{ error }}</p>
          </v-form>
        </v-card-text>
      </v-card>

      <div class="d-flex justify-space-between mt-6">
        <v-btn color="primary" variant="flat" rounded="pill" :to="backTo">
          <v-icon start>mdi-arrow-left</v-icon>Back
        </v-btn>
        <v-btn color="success" variant="flat" rounded="pill" :loading="loading" @click="$emit('submit')">
          <v-icon start>mdi-content-save</v-icon>Save
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
    backTo: { type: String, required: true },
    error: { type: String, default: '' },
    loading: { type: Boolean, default: false },
  },
  emits: ['submit'],
}
</script>
