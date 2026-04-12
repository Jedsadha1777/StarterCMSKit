<template>
  <v-container class="fill-height" fluid>
    <v-row justify="center" align="center">
      <v-col cols="12" sm="6" md="4" lg="3">
        <v-card elevation="4" class="pa-8">
          <div class="text-center mb-8">
            <img :src="savedLogo || defaultLogo" alt="Logo" style="height:64px" />
            <div class="text-h5 font-weight-bold mt-2" style="color:#2c3e50">{{ savedTitle }}</div>
            <div class="text-body-2 text-grey">web control panel</div>
          </div>

          <v-form @submit.prevent="handleLogin">
            <div class="text-body-1 font-weight-medium mb-1">Username</div>
            <v-text-field
              v-model="email"
              placeholder="admin"
              variant="solo-filled"
              flat
              bg-color="grey-lighten-4"
              required
              class="mb-4"
              hide-details
            />

            <div class="text-body-1 font-weight-medium mb-1">Password</div>
            <v-text-field
              v-model="password"
              placeholder="Enter password"
              variant="solo-filled"
              flat
              bg-color="grey-lighten-4"
              :type="showPassword ? 'text' : 'password'"
              required
              hide-details
            >
              <template v-slot:append-inner>
                <v-icon
                  @click="showPassword = !showPassword"
                  style="opacity:0.5;cursor:pointer"
                >{{ showPassword ? 'mdi-eye-off' : 'mdi-eye' }}</v-icon>
              </template>
            </v-text-field>

            <p v-if="error" class="text-error text-body-2 mt-4">{{ error }}</p>

            <v-btn
              type="submit"
              color="primary"
              variant="flat"
              block
              size="x-large"
              rounded="pill"
              class="mt-8"
              :loading="loading"
            >
              Log in
            </v-btn>
          </v-form>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import api from '../api'
import { useSiteSettings } from '../composables/useSiteSettings'
import { useAdmin } from '../composables/useAdmin'
import defaultLogoImg from '@/assets/logo.png'

import { API_BASE } from '../config'

export default {
  setup() {
    const router = useRouter()
    const { settings, loadSettings } = useSiteSettings()
    const { save: saveAdmin } = useAdmin()
    const defaultLogo = defaultLogoImg
    const savedTitle = computed(() => settings.site_title || 'Admin Panel')
    const savedLogo = computed(() => settings.logo ? API_BASE + settings.logo : '')
    const email = ref('')
    const password = ref('')
    const showPassword = ref(false)
    const error = ref('')
    const loading = ref(false)

    const handleLogin = async () => {
      error.value = ''
      loading.value = true
      try {
        const { data } = await api.login(email.value, password.value)
        sessionStorage.setItem('access_token', data.access_token)
        localStorage.setItem('refresh_token', data.refresh_token)
        saveAdmin(data.admin)           // เก็บเฉพาะ name/email ลง localStorage (D1)
        window.dispatchEvent(new Event('auth-changed'))  // แจ้ง App.vue ให้ sync isAuthenticated
        await loadSettings()
        router.push('/')
      } catch (err) {
        error.value = err.response?.data?.message || 'Login failed'
      } finally {
        loading.value = false
      }
    }

    return { defaultLogo, savedTitle, savedLogo, email, password, showPassword, error, loading, handleLogin }
  }
}
</script>

<style scoped>
:deep(input:-webkit-autofill),
:deep(input:-webkit-autofill:hover),
:deep(input:-webkit-autofill:focus) {
  -webkit-box-shadow: 0 0 0 1000px #f5f5f5 inset !important;
  -webkit-text-fill-color: #212121 !important;
}
</style>
