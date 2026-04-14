<template>
  <FormPage :title="isEdit ? 'Edit Inspection Item' : 'Register Inspection Item'" backTo="/inspection-items" :error="error" :loading="loading" @submit="handleSubmit">
    <v-text-field v-model="form.item_code" label="Item Code *" variant="outlined" required class="mb-4" :disabled="isEdit" :rules="[itemCodeRule]" hint="English letters, numbers, hyphens or underscores only (no spaces)" persistent-hint />
    <v-text-field v-model="form.item_name" label="Item Name *" variant="outlined" required class="mb-4" />
    <v-text-field v-model="form.spec" label="Spec" variant="outlined" class="mb-4" />
  </FormPage>
</template>

<script>
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '../api'
import FormPage from '../components/FormPage.vue'

export default {
  components: { FormPage },
  setup() {
    const route = useRoute(); const router = useRouter()
    const form = ref({ item_code: '', item_name: '', spec: '' }); const error = ref(''); const loading = ref(false)
    const isEdit = computed(() => !!route.params.id)
    const itemCodeRule = (v) => !v || /^[A-Za-z0-9\-_]+$/.test(v) || 'English letters, numbers, hyphens or underscores only (no spaces)'

    onMounted(async () => {
      if (!isEdit.value) return
      try {
        const { data } = await api.getInspectionItem(route.params.id)
        form.value.item_code = data.item_code
        form.value.item_name = data.item_name
        form.value.spec = data.spec || ''
      } catch { error.value = 'Failed to load inspection item' }
    })

    const handleSubmit = async () => {
      error.value = ''; loading.value = true
      try {
        const payload = { item_code: form.value.item_code, item_name: form.value.item_name, spec: form.value.spec }
        if (isEdit.value) {
          await api.updateInspectionItem(route.params.id, payload)
        } else {
          await api.createInspectionItem(payload)
        }
        router.push('/inspection-items')
      } catch (err) { error.value = err.response?.data?.message || 'Failed to save' }
      finally { loading.value = false }
    }
    return { form, error, loading, isEdit, handleSubmit, itemCodeRule }
  }
}
</script>
