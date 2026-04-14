<template>
  <FormPage :title="isEdit ? 'Edit Admin' : 'Register Admin'" backTo="/admins" :error="error" :loading="loading" @submit="handleSubmit">
    <v-text-field v-model="form.name" label="Name *" variant="outlined" required class="mb-4" />
    <v-text-field v-model="form.email" label="Email *" type="email" variant="outlined" required class="mb-4" />
    <v-text-field v-model="form.password" :label="isEdit ? 'New Password (leave blank to keep)' : 'Password *'" :type="showPassword ? 'text' : 'password'" variant="outlined" :required="!isEdit" class="mb-4">
      <template v-slot:append-inner>
        <v-icon @click="showPassword = !showPassword" style="opacity:0.5;cursor:pointer">{{ showPassword ? 'mdi-eye-off' : 'mdi-eye' }}</v-icon>
      </template>
    </v-text-field>
    <template v-if="!isEditingSuperAdmin">
      <v-select v-model="form.role" :items="roles" item-title="title" item-value="value" label="Role *" variant="outlined" required class="mb-4" :disabled="!isSuperAdmin && isEdit && form.role === 'admin'" />
      <v-select v-model="form.package_id" :items="packages" item-title="name" item-value="id" label="Package *" variant="outlined" required class="mb-4" :loading="packagesLoading" :disabled="!isSuperAdmin && isEdit" no-data-text="No packages found. Please configure a package first." />
    </template>
    <v-alert v-else type="info" variant="tonal" class="mb-4">Super Admin — role and package are not applicable.</v-alert>
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
    const isSuperAdmin = computed(() => currentAdmin.permissions === '*')
    const form = ref({ name: '', email: '', password: '', role: null, package_id: null })
    const error = ref(''); const loading = ref(false); const showPassword = ref(false)
    const packages = ref([]); const packagesLoading = ref(false)
    const isEdit = computed(() => !!route.params.id)
    const isEditingSuperAdmin = computed(() => isEdit.value && form.value.role === 'super_admin')

    const roles = computed(() => {
      const items = [{ title: '-- Please select --', value: null }]
      if (isSuperAdmin.value) items.push({ title: 'Admin', value: 'admin' })
      items.push({ title: 'Editor', value: 'editor' })
      return items
    })

    const loadPackages = async () => {
      packagesLoading.value = true
      try {
        const { data } = await api.getPackages()
        packages.value = [{ id: null, name: '-- Please select --' }, ...data.packages]
      } catch { /* ignore */ }
      finally { packagesLoading.value = false }
    }

    onMounted(async () => {
      await loadPackages()
      if (!isEdit.value) return
      try {
        const { data } = await api.getAdmin(route.params.id)
        form.value.name = data.name
        form.value.email = data.email
        form.value.role = data.role
        form.value.package_id = data.package_id
      } catch { error.value = 'Failed to load admin' }
    })

    const handleSubmit = async () => {
      error.value = ''; loading.value = true
      try {
        const payload = { name: form.value.name, email: form.value.email }
        if (!isEditingSuperAdmin.value) {
          payload.role = form.value.role
          payload.package_id = form.value.package_id
        }
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
    return { form, error, loading, isEdit, isEditingSuperAdmin, showPassword, handleSubmit, roles, packages, packagesLoading, isSuperAdmin }
  }
}
</script>
