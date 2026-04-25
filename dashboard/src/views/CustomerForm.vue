<template>
  <FormPage :title="isEdit ? 'Edit Customer' : 'Register Customer'" backTo="/customers" :error="error" :loading="loading" @submit="handleSubmit">
    <v-text-field v-model="form.customer_id" label="Customer ID *" variant="outlined" required class="mb-4" :disabled="isEdit" :rules="[customerIdRule]" hint="English letters, numbers, hyphens or underscores only (no spaces)" persistent-hint />
    <v-text-field v-model="form.name" label="Name *" variant="outlined" required class="mb-4" />
    <v-textarea v-model="form.address" label="Address" variant="outlined" rows="3" class="mb-4" />
    <v-text-field v-model="form.tel" label="Tel" variant="outlined" class="mb-4" />
    <v-text-field v-model="form.fax" label="Fax" variant="outlined" class="mb-4" />
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
    const form = ref({ customer_id: '', name: '', address: '', tel: '', fax: '' }); const error = ref(''); const loading = ref(false)
    const isEdit = computed(() => !!route.params.id)
    const customerIdRule = (v) => !v || /^[A-Za-z0-9\-_]+$/.test(v) || 'English letters, numbers, hyphens or underscores only (no spaces)'

    onMounted(async () => {
      if (!isEdit.value) return
      try {
        const { data } = await api.getCustomer(route.params.id)
        form.value.customer_id = data.customer_id
        form.value.name = data.name
        form.value.address = data.address || ''
        form.value.tel = data.tel || ''
        form.value.fax = data.fax || ''
      } catch { error.value = 'Failed to load customer' }
    })

    const handleSubmit = async () => {
      error.value = ''; loading.value = true
      try {
        const payload = { customer_id: form.value.customer_id, name: form.value.name, address: form.value.address, tel: form.value.tel, fax: form.value.fax }
        if (isEdit.value) {
          await api.updateCustomer(route.params.id, payload)
        } else {
          await api.createCustomer(payload)
        }
        router.push('/customers')
      } catch (err) { error.value = err.response?.data?.message || 'Failed to save' }
      finally { loading.value = false }
    }
    return { form, error, loading, isEdit, handleSubmit, customerIdRule }
  }
}
</script>
