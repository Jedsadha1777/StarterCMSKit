<template>
  <FormPage :title="isEdit ? 'Edit Article' : 'Create Article'" backTo="/articles" :error="error" :loading="loading" @submit="handleSubmit">
    <v-text-field v-model="form.title" label="Title *" variant="outlined" required class="mb-4" />
    <v-textarea v-model="form.content" label="Content *" variant="outlined" rows="10" required class="mb-4" />
    <div class="d-flex ga-4 mb-4 align-center">
      <v-select v-model="form.status" :items="['draft', 'published']" label="Status" variant="outlined" hide-details style="max-width:200px" @update:model-value="onStatusChange" />
      <template v-if="form.status === 'published'">
        <DatePicker v-model="publishDatePart" label="Publish Date" />
        <v-text-field v-model="publishTimePart" label="Time (HH:MM)" variant="outlined" hide-details placeholder="14:30" style="max-width:140px" maxlength="5" />
      </template>
    </div>
  </FormPage>
</template>

<script>
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '../api'
import FormPage from '../components/FormPage.vue'
import DatePicker from '../components/DatePicker.vue'

export default {
  components: { FormPage, DatePicker },
  setup() {
    const route = useRoute(); const router = useRouter()
    const form = ref({ title: '', content: '', status: 'draft' }); const error = ref(''); const loading = ref(false)
    const publishDatePart = ref('')
    const publishTimePart = ref('')
    const isEdit = computed(() => !!route.params.id)

    onMounted(async () => {
      if (!isEdit.value) return
      try {
        const { data } = await api.getArticle(route.params.id)
        form.value = { title: data.title, content: data.content, status: data.status || 'draft' }
        if (data.publish_date) {
          const local = new Date(data.publish_date)
          publishDatePart.value = local.getFullYear() + '-' + String(local.getMonth()+1).padStart(2,'0') + '-' + String(local.getDate()).padStart(2,'0')
          publishTimePart.value = String(local.getHours()).padStart(2,'0') + ':' + String(local.getMinutes()).padStart(2,'0')
        }
      }
      catch { error.value = 'Failed to load article' }
    })

    const onStatusChange = (val) => {
      if (val === 'published' && !publishDatePart.value) {
        const d = new Date()
        publishDatePart.value = d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0') + '-' + String(d.getDate()).padStart(2,'0')
        publishTimePart.value = String(d.getHours()).padStart(2,'0') + ':' + String(d.getMinutes()).padStart(2,'0')
      }
    }

    const handleSubmit = async () => {
      error.value = ''; loading.value = true
      try {
        const payload = { ...form.value }
        if (payload.status === 'published' && publishDatePart.value) {
          payload.publish_date = publishDatePart.value + 'T' + (publishTimePart.value || '00:00')
        } else if (payload.status === 'published') {
          payload.publish_date = new Date().toISOString()
        } else {
          payload.publish_date = null
        }
        if (isEdit.value) await api.updateArticle(route.params.id, payload)
        else await api.createArticle(payload)
        router.push('/articles')
      } catch (err) { error.value = err.response?.data?.message || 'Failed to save' }
      finally { loading.value = false }
    }
    return { form, error, loading, isEdit, publishDatePart, publishTimePart, onStatusChange, handleSubmit }
  }
}
</script>
