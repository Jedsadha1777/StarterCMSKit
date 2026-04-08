<template>
  <FormPage :title="isEdit ? 'Edit User' : 'Register User'" backTo="/users" :error="error" :loading="loading" @submit="handleSubmit">
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
import FormPage from '../components/FormPage.vue'

export default {
  components: { FormPage },
  setup() {
    const route = useRoute(); const router = useRouter()
    const form = ref({ name: '', email: '', password: '' }); const error = ref(''); const loading = ref(false); const showPassword = ref(false)
    const isEdit = computed(() => !!route.params.id)

    onMounted(async () => {
      if (!isEdit.value) return
      try { const { data } = await api.getUser(route.params.id); form.value.name = data.name; form.value.email = data.email }
      catch { error.value = 'Failed to load user' }
    })

    const handleSubmit = async () => {
      error.value = ''; loading.value = true
      try {
        const payload = { name: form.value.name, email: form.value.email }
        if (form.value.password) payload.password = form.value.password
        if (isEdit.value) await api.updateUser(route.params.id, payload)
        else await api.createUser(payload)
        router.push('/users')
      } catch (err) { error.value = err.response?.data?.message || 'Failed to save' }
      finally { loading.value = false }
    }
    return { form, error, loading, isEdit, showPassword, handleSubmit }
  }
}
</script>
