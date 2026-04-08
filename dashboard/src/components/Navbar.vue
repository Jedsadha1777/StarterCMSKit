<template>
  <v-app-bar color="white" elevation="2" density="comfortable">
    <div class="d-flex align-center ml-4">
      <img src="@/assets/logo.png" alt="Logo" style="height:28px" class="mr-2" />
      <span class="text-h6 font-weight-bold text-primary">Service Report Tool Admin</span>
    </div>

    <v-spacer />

    <span class="text-body-1 font-weight-bold mr-4">
      Welcome {{ adminEmail }}!
    </span>

    <v-btn
      color="primary"
      variant="flat"
      rounded="pill"
      class="mr-4"
      @click="logout"
    >
      Logout
    </v-btn>
  </v-app-bar>
</template>

<script>
import { computed } from 'vue'
import { useRouter } from 'vue-router'

export default {
  setup() {
    const router = useRouter()
    const adminEmail = computed(() => {
      try { return JSON.parse(localStorage.getItem('admin') || '{}').email || 'admin' }
      catch { return 'admin' }
    })

    const logout = () => {
      localStorage.clear()
      router.push('/login')
    }

    return { adminEmail, logout }
  }
}
</script>
