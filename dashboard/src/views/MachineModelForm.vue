<template>
  <FormPage :title="isEdit ? 'Edit Machine Model' : 'Register Machine Model'" backTo="/machine-models" :error="error" :loading="loading" @submit="handleSubmit">
    <v-text-field v-model="form.model_code" label="Model Code *" variant="outlined" required class="mb-4" :disabled="isEdit" :rules="[modelCodeRule]" hint="English letters, numbers, hyphens or underscores only" persistent-hint />
    <v-text-field v-model="form.model_name" label="Model Name *" variant="outlined" required class="mb-4" />
    <v-autocomplete
      v-model="form.inspection_item_ids"
      :items="inspectionItems"
      item-title="label"
      item-value="id"
      label="Inspection Items"
      variant="outlined"
      multiple
      chips
      closable-chips
      class="mb-4"
      :loading="loadingItems"
      hint="Select inspection items to associate with this model"
      persistent-hint
    />
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
    const form = ref({ model_code: '', model_name: '', inspection_item_ids: [] })
    const error = ref(''); const loading = ref(false)
    const isEdit = computed(() => !!route.params.id)
    const modelCodeRule = (v) => !v || /^[A-Za-z0-9\-_]+$/.test(v) || 'English letters, numbers, hyphens or underscores only'

    const inspectionItems = ref([])
    const loadingItems = ref(false)

    const loadInspectionItems = async () => {
      loadingItems.value = true
      try {
        const { data } = await api.getInspectionItems({ per_page: 9999 })
        inspectionItems.value = (data.inspection_items || []).map(item => ({
          id: item.id,
          label: `${item.item_code} - ${item.item_name}${item.spec ? ` (${item.spec})` : ''}`,
        }))
      } catch { /* ignore */ }
      finally { loadingItems.value = false }
    }

    onMounted(async () => {
      await loadInspectionItems()
      if (!isEdit.value) return
      try {
        const { data } = await api.getMachineModel(route.params.id)
        form.value.model_code = data.model_code
        form.value.model_name = data.model_name
        form.value.inspection_item_ids = (data.inspection_items || []).map(item => item.id)
      } catch { error.value = 'Failed to load machine model' }
    })

    const handleSubmit = async () => {
      error.value = ''; loading.value = true
      try {
        const payload = {
          model_code: form.value.model_code,
          model_name: form.value.model_name,
          inspection_item_ids: form.value.inspection_item_ids,
        }
        if (isEdit.value) {
          await api.updateMachineModel(route.params.id, payload)
        } else {
          await api.createMachineModel(payload)
        }
        router.push('/machine-models')
      } catch (err) { error.value = err.response?.data?.message || 'Failed to save' }
      finally { loading.value = false }
    }

    return { form, error, loading, isEdit, handleSubmit, modelCodeRule, inspectionItems, loadingItems }
  }
}
</script>
