<template>
  <FormPage :title="isEdit ? 'Edit Machine Part' : 'Register Machine Part'" backTo="/parts" :error="error" :loading="loading" @submit="handleSubmit">
    <v-text-field v-model="form.parts_code" label="PART No. *" variant="outlined" required class="mb-4" :disabled="isEdit" />
    <v-text-field v-model="form.parts_name" label="Parts Name *" variant="outlined" required class="mb-4" />
    <v-text-field v-model.number="form.unit_price" label="UNIT PRICE" variant="outlined" type="number" step="0.01" min="0" class="mb-4" />
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
    const form = ref({ parts_code: '', parts_name: '', unit_price: 0 })
    const error = ref(''); const loading = ref(false)
    const isEdit = computed(() => !!route.params.id)

    onMounted(async () => {
      if (!isEdit.value) return
      try {
        const { data } = await api.getPart(route.params.id)
        form.value.parts_code = data.parts_code
        form.value.parts_name = data.parts_name
        form.value.unit_price = Number(data.unit_price) || 0
      } catch { error.value = 'Failed to load part' }
    })

    const handleSubmit = async () => {
      error.value = ''; loading.value = true
      try {
        const payload = {
          parts_code: form.value.parts_code,
          parts_name: form.value.parts_name,
          unit_price: Number(form.value.unit_price) || 0,
        }
        if (isEdit.value) {
          await api.updatePart(route.params.id, payload)
        } else {
          await api.createPart(payload)
        }
        router.push('/parts')
      } catch (err) { error.value = err.response?.data?.message || 'Failed to save' }
      finally { loading.value = false }
    }
    return { form, error, loading, isEdit, handleSubmit }
  }
}
</script>
