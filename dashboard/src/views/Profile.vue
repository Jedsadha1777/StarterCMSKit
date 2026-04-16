<template>
  <div>
    <PageBanner title="Profile" />

    <v-container style="max-width: 720px">

      <!-- Account -->
      <div class="d-flex align-center py-4">
        <v-avatar size="64" class="mr-4">
          <v-icon color="grey-darken-1" size="64">mdi-account-circle</v-icon>
        </v-avatar>
        <div>
          <div class="text-h6">{{ admin.name }}</div>
          <div class="text-body-2 text-grey">{{ admin.email }}</div>
          <div v-if="admin.company_name" class="text-body-2 text-grey"><v-icon size="small" class="mr-1">mdi-domain</v-icon>{{ admin.company_name }}</div>
        </div>
      </div>

      <v-divider />

      <!-- Edit Name -->
      <div class="py-4" @click="showName = !showName" style="cursor:pointer">
        <div class="d-flex align-center justify-space-between">
          <div class="d-flex align-center">
            <v-icon class="mr-3" color="grey-darken-1">mdi-account-edit-outline</v-icon>
            <div>
              <div class="text-body-1 font-weight-medium">Name</div>
              <div class="text-body-2 text-grey">{{ admin.name }}</div>
            </div>
          </div>
          <v-icon>{{ showName ? 'mdi-chevron-up' : 'mdi-chevron-down' }}</v-icon>
        </div>
      </div>

      <v-expand-transition>
        <div v-show="showName" class="pl-10 pb-4">
          <v-form @submit.prevent="handleChangeName" style="max-width:400px">
            <v-text-field v-model="newName" label="New Name" variant="outlined" density="compact" required class="mb-2" />
            <p v-if="nameError" class="text-error text-body-2 mb-2">{{ nameError }}</p>
            <p v-if="nameSuccess" class="text-success text-body-2 mb-2">{{ nameSuccess }}</p>
            <v-btn type="submit" color="success" variant="flat" size="small" :loading="nameLoading">Save</v-btn>
          </v-form>
        </div>
      </v-expand-transition>

      <v-divider />

      <!-- Change Password -->
      <div class="py-4" @click="showPassword = !showPassword" style="cursor:pointer">
        <div class="d-flex align-center justify-space-between">
          <div class="d-flex align-center">
            <v-icon class="mr-3" color="grey-darken-1">mdi-lock-outline</v-icon>
            <div>
              <div class="text-body-1 font-weight-medium">Password</div>
              <div class="text-body-2 text-grey">Change your password</div>
            </div>
          </div>
          <v-icon>{{ showPassword ? 'mdi-chevron-up' : 'mdi-chevron-down' }}</v-icon>
        </div>
      </div>

      <v-expand-transition>
        <div v-show="showPassword" class="pl-10 pb-4">
          <v-form @submit.prevent="handleChangePassword" style="max-width:400px">
            <v-text-field v-model="pf.oldPassword" label="Current Password" type="password" variant="outlined" density="compact" required class="mb-2" />
            <v-text-field v-model="pf.newPassword" label="New Password" type="password" variant="outlined" density="compact" required minlength="6" class="mb-2" />
            <v-text-field v-model="pf.confirmPassword" label="Confirm New Password" type="password" variant="outlined" density="compact" required class="mb-2" />
            <p v-if="pwError" class="text-error text-body-2 mb-2">{{ pwError }}</p>
            <p v-if="pwSuccess" class="text-success text-body-2 mb-2">{{ pwSuccess }}</p>
            <v-btn type="submit" color="success" variant="flat" size="small" :loading="pwLoading">Save</v-btn>
          </v-form>
        </div>
      </v-expand-transition>

      <v-divider />

      <!-- Delete Account -->
      <div class="py-4" @click="showDelete = !showDelete" style="cursor:pointer">
        <div class="d-flex align-center justify-space-between">
          <div class="d-flex align-center">
            <v-icon class="mr-3" color="error">mdi-delete-outline</v-icon>
            <div>
              <div class="text-body-1 font-weight-medium text-error">Delete Account</div>
              <div class="text-body-2 text-grey">Permanently delete your admin account</div>
            </div>
          </div>
          <v-icon>{{ showDelete ? 'mdi-chevron-up' : 'mdi-chevron-down' }}</v-icon>
        </div>
      </div>

      <v-expand-transition>
        <div v-show="showDelete" class="pl-10 pb-4">
          <p class="text-warning text-body-2 mb-3" style="max-width:400px">This action is permanent and cannot be undone.</p>
          <div style="max-width:400px">
            <v-text-field v-model="deletePassword" label="Enter password to confirm" type="password" variant="outlined" density="compact" class="mb-2" />
            <p v-if="deleteError" class="text-error text-body-2 mb-2">{{ deleteError }}</p>
            <v-btn color="error" variant="flat" size="small" :loading="deleteLoading" @click="handleDeleteAccount">Delete My Account</v-btn>
          </div>
        </div>
      </v-expand-transition>

      <v-divider />

      <div class="pt-4">
        <v-btn color="primary" variant="flat" rounded="pill" to="/">
          <v-icon start>mdi-arrow-left</v-icon>Back
        </v-btn>
      </div>

    </v-container>
  </div>
</template>

<script>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import api from '../api'
import PageBanner from '../components/PageBanner.vue'
import { useAdmin } from '../composables/useAdmin'

export default {
  components: { PageBanner },
  setup() {
    const router = useRouter()
    const { admin, save } = useAdmin()

    // Name
    const showName = ref(false)
    const newName = ref(admin.name || '')
    const nameError = ref(''); const nameSuccess = ref(''); const nameLoading = ref(false)

    const handleChangeName = async () => {
      nameError.value = ''; nameSuccess.value = ''
      if (!newName.value.trim()) { nameError.value = 'Name is required'; return }
      nameLoading.value = true
      try {
        const { data } = await api.updateProfile({ name: newName.value.trim() })
        save(data)
        nameSuccess.value = 'Name updated'
      } catch (err) { nameError.value = err.response?.data?.message || 'Failed' }
      finally { nameLoading.value = false }
    }

    // Password
    const showPassword = ref(false)
    const pf = ref({ oldPassword: '', newPassword: '', confirmPassword: '' })
    const pwError = ref(''); const pwSuccess = ref(''); const pwLoading = ref(false)

    const handleChangePassword = async () => {
      pwError.value = ''; pwSuccess.value = ''
      if (pf.value.newPassword !== pf.value.confirmPassword) { pwError.value = 'Passwords do not match'; return }
      if (pf.value.newPassword.length < 6) { pwError.value = 'Min 6 characters'; return }
      pwLoading.value = true
      try {
        await api.changePassword(pf.value.oldPassword, pf.value.newPassword)
        pwSuccess.value = 'Password changed'
        pf.value = { oldPassword: '', newPassword: '', confirmPassword: '' }
      } catch (err) { pwError.value = err.response?.data?.message || 'Failed' }
      finally { pwLoading.value = false }
    }

    // Delete
    const showDelete = ref(false)
    const deletePassword = ref(''); const deleteError = ref(''); const deleteLoading = ref(false)

    const handleDeleteAccount = async () => {
      deleteError.value = ''
      if (!deletePassword.value) { deleteError.value = 'Please enter your password'; return }
      if (!confirm('Are you sure? This action cannot be undone.')) return
      deleteLoading.value = true
      try {
        await api.deleteAccount(deletePassword.value)
        localStorage.clear()
        router.push('/login')
      } catch (err) { deleteError.value = err.response?.data?.message || 'Failed' }
      finally { deleteLoading.value = false }
    }

    return {
      admin, showName, newName, nameError, nameSuccess, nameLoading, handleChangeName,
      showPassword, pf, pwError, pwSuccess, pwLoading, handleChangePassword,
      showDelete, deletePassword, deleteError, deleteLoading, handleDeleteAccount,
    }
  }
}
</script>
