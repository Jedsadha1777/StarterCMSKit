<template>
  <FormPage :title="isEdit ? 'Edit Admin' : 'Register Admin'" backTo="/admins" :error="error" :loading="loading" @submit="handleSubmit">
    <v-text-field v-model="form.name" label="Name *" variant="outlined" required class="mb-4" />
    <v-text-field v-model="form.email" label="Email *" type="email" variant="outlined" required class="mb-4" />
    <v-text-field v-model="form.password" :label="isEdit ? 'New Password (leave blank to keep)' : 'Password *'" :type="showPassword ? 'text' : 'password'" variant="outlined" :required="!isEdit" class="mb-4">
      <template v-slot:append-inner>
        <v-icon @click="showPassword = !showPassword" style="opacity:0.5;cursor:pointer">{{ showPassword ? 'mdi-eye-off' : 'mdi-eye' }}</v-icon>
      </template>
    </v-text-field>
    <v-select v-model="form.role" :items="roles" item-title="title" item-value="value" label="Role *" variant="outlined" required class="mb-4" :disabled="!isSuperAdmin && isEdit && form.role === 'admin'" />
  </FormPage>
</template>

<script>
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '../api'
import FormPage from '../components/FormPage.vue'
import { useAdmin } from '../composables/useAdmin'

export default {
  components: { FormPage },
  setup() {
    const route = useRoute(); const router = useRouter()
    const { admin: currentAdmin, save } = useAdmin()
    const isSuperAdmin = computed(() => currentAdmin.is_super_admin)
    const form = ref({ name: '', email: '', password: '', role: null })
    const error = ref(''); const loading = ref(false); const showPassword = ref(false)
    const isEdit = computed(() => !!route.params.id)

    const roles = computed(() => {
      const items = [{ title: '-- Please select --', value: null }]
      if (isSuperAdmin.value) items.push({ title: 'Admin', value: 'admin' })
      items.push({ title: 'Editor', value: 'editor' })
      return items
    })

    onMounted(async () => {
      if (!isEdit.value) return
      try {
        const { data } = await api.getAdmin(route.params.id)
        form.value.name = data.name
        form.value.email = data.email
        form.value.role = data.role
      } catch { error.value = 'Failed to load admin' }
    })

    const handleSubmit = async () => {
      error.value = ''; loading.value = true
      try {
        const payload = { name: form.value.name, email: form.value.email, role: form.value.role }
        if (form.value.password) payload.password = form.value.password
        if (isEdit.value) {
          const { data } = await api.updateAdmin(route.params.id, payload)
          if (String(currentAdmin.id) === String(route.params.id)) save(data)
        } else {
          await api.createAdmin(payload)
        }
        router.push('/admins')
      } catch (err) { error.value = err.response?.data?.message || 'Failed to save' }
      finally { loading.value = false }
    }
    return { form, error, loading, isEdit, showPassword, handleSubmit, roles, isSuperAdmin }
  }
}
</script>
