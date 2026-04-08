<template>
  <div>
    <PageBanner :title="isEdit ? 'Edit Admin' : 'Register Admin'" />

    <v-container style="max-width: 800px">
      <v-card variant="outlined">
        <v-card-text class="pa-6">
          <v-form @submit.prevent="handleSubmit">
            <v-text-field v-model="form.name" label="Name *" variant="outlined" required class="mb-4" />
            <v-text-field v-model="form.email" label="Email *" type="email" variant="outlined" required class="mb-4" />
            <v-text-field
              v-model="form.password"
              :label="isEdit ? 'New Password (leave blank to keep)' : 'Password *'"
              :type="showPassword ? 'text' : 'password'"
              variant="outlined"
              :required="!isEdit"
              class="mb-4"
            >
              <template v-slot:append-inner>
                <v-icon @click="showPassword = !showPassword" style="opacity:0.5;cursor:pointer">{{ showPassword ? 'mdi-eye-off' : 'mdi-eye' }}</v-icon>
              </template>
            </v-text-field>
            <p v-if="error" class="text-error text-body-2 mb-4">{{ error }}</p>
          </v-form>
        </v-card-text>
      </v-card>

      <div class="d-flex justify-space-between mt-6">
        <v-btn color="primary" variant="flat" rounded="pill" to="/admins">
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
    const form = ref({ name: '', email: '', password: '' }); const error = ref(''); const loading = ref(false); const showPassword = ref(false)
    const isEdit = computed(() => !!route.params.id)

    onMounted(async () => {
      if (!isEdit.value) return
      try { const { data } = await api.getAdmin(route.params.id); form.value.name = data.name; form.value.email = data.email }
      catch { error.value = 'Failed to load admin' }
    })

    const handleSubmit = async () => {
      error.value = ''; loading.value = true
      try {
        const payload = { name: form.value.name, email: form.value.email }
        if (form.value.password) payload.password = form.value.password
        if (isEdit.value) {
          const { data } = await api.updateAdmin(route.params.id, payload)
          const current = JSON.parse(localStorage.getItem('admin') || '{}')
          if (current.id === route.params.id) {
            localStorage.setItem('admin', JSON.stringify(data))
            window.dispatchEvent(new Event('storage-updated'))
          }
        } else {
          await api.createAdmin(payload)
        }
        router.push('/admins')
      } catch (err) { error.value = err.response?.data?.message || 'Failed to save' }
      finally { loading.value = false }
    }
    return { form, error, loading, isEdit, showPassword, handleSubmit }
  }
}
</script>
