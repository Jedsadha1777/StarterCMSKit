<template>
  <div>
    <PageBanner :title="isEdit ? 'Edit Article' : 'Create Article'" />

    <v-container style="max-width: 800px">
      <v-card variant="outlined">
        <v-card-text class="pa-6">
          <v-form @submit.prevent="handleSubmit">
            <v-text-field v-model="form.title" label="Title *" variant="outlined" required class="mb-4" />
            <v-textarea v-model="form.content" label="Content *" variant="outlined" rows="10" required class="mb-4" />
            <div class="d-flex ga-4 mb-4">
              <v-select v-model="form.status" :items="['draft', 'published']" label="Status" variant="outlined" style="max-width:200px" />
              <v-text-field v-model="form.publish_date" label="Publish Date" type="datetime-local" variant="outlined" clearable style="max-width:280px" />
            </div>
            <p v-if="error" class="text-error text-body-2 mb-4">{{ error }}</p>
          </v-form>
        </v-card-text>
      </v-card>

      <div class="d-flex justify-space-between mt-6">
        <v-btn color="primary" variant="flat" rounded="pill" to="/articles">
          <v-icon start>mdi-arrow-left</v-icon>Back
        </v-btn>
        <v-btn color="success" variant="flat" rounded="pill" :loading="loading" @click="handleSubmit">
          <v-icon start>mdi-content-save</v-icon>Save
        </v-btn>
      </div>
    </v-container>
  </div>
</template>

<script>
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '../api'
import PageBanner from '../components/PageBanner.vue'

export default {
  components: { PageBanner },
  setup() {
    const route = useRoute(); const router = useRouter()
    const form = ref({ title: '', content: '', status: 'draft', publish_date: '' }); const error = ref(''); const loading = ref(false)
    const isEdit = computed(() => !!route.params.id)

    onMounted(async () => {
      if (!isEdit.value) return
      try {
        const { data } = await api.getArticle(route.params.id)
        form.value = {
          title: data.title,
          content: data.content,
          status: data.status || 'draft',
          publish_date: data.publish_date ? data.publish_date.substring(0, 16) : '',
        }
      }
      catch { error.value = 'Failed to load article' }
    })

    const handleSubmit = async () => {
      error.value = ''; loading.value = true
      try {
        const payload = { ...form.value }
        if (!payload.publish_date) payload.publish_date = null
        if (isEdit.value) await api.updateArticle(route.params.id, payload)
        else await api.createArticle(payload)
        router.push('/articles')
      } catch (err) { error.value = err.response?.data?.message || 'Failed to save' }
      finally { loading.value = false }
    }
    return { form, error, loading, isEdit, handleSubmit }
  }
}
</script>
