<template>
  <FormPage :title="isEdit ? `Edit ${label}` : `Register ${label}`" :backTo="backTo" :error="error" :loading="loading" @submit="handleSubmit">
    <v-text-field v-model="form.name" label="Name *" variant="outlined" required class="mb-4" />
    <v-text-field v-model="form.email" label="Email *" type="email" variant="outlined" required class="mb-4" />
    <v-text-field v-model="form.password" :label="isEdit ? 'New Password (leave blank to keep)' : 'Password *'" :type="showPassword ? 'text' : 'password'" variant="outlined" :required="!isEdit" class="mb-4">
      <template v-slot:append-inner>
        <v-icon @click="showPassword = !showPassword" style="opacity:0.5;cursor:pointer">{{ showPassword ? 'mdi-eye-off' : 'mdi-eye' }}</v-icon>
      </template>
    </v-text-field>
  </FormPage>
</template>

<script>
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '../api'
import FormPage from './FormPage.vue'
import { useAdmin } from '../composables/useAdmin'

export default {
  components: { FormPage },
  props: {
    resource: { type: String, required: true },
    apiGet: { type: String, required: true },
    apiCreate: { type: String, required: true },
    apiUpdate: { type: String, required: true },
    backTo: { type: String, required: true },
    onSelfEdit: { type: Boolean, default: false },
  },
  setup(props) {
    const route = useRoute(); const router = useRouter()
    const { admin: currentAdmin, save } = useAdmin()
    const form = ref({ name: '', email: '', password: '' }); const error = ref(''); const loading = ref(false); const showPassword = ref(false)
    const isEdit = computed(() => !!route.params.id)
    const label = computed(() => props.resource.charAt(0).toUpperCase() + props.resource.slice(1))

    onMounted(async () => {
      if (!isEdit.value) return
      try {
        const { data } = await api[props.apiGet](route.params.id)
        form.value.name = data.name
        form.value.email = data.email
      } catch { error.value = `Failed to load ${props.resource}` }
    })

    const handleSubmit = async () => {
      error.value = ''; loading.value = true
      try {
        const payload = { name: form.value.name, email: form.value.email }
        if (form.value.password) payload.password = form.value.password
        if (isEdit.value) {
          const { data } = await api[props.apiUpdate](route.params.id, payload)
          if (props.onSelfEdit && String(currentAdmin.id) === String(route.params.id)) save(data)
        } else {
          await api[props.apiCreate](payload)
        }
        router.push(props.backTo)
      } catch (err) { error.value = err.response?.data?.message || 'Failed to save' }
      finally { loading.value = false }
    }
    return { form, error, loading, isEdit, showPassword, handleSubmit, label }
  }
}
</script>
