<template>
  <v-app>
    <template v-if="isAuthenticated">
      <!-- Top App Bar -->
      <v-app-bar color="white" elevation="2" density="comfortable">

        <router-link to="/" class="d-flex align-center text-decoration-none ml-1" style="cursor:pointer">
          <img src="@/assets/logo.png" alt="Logo" style="height:28px" class="mr-2" />
          <span class="text-h6 font-weight-bold" style="color:#2c3e50">Service Report Tool Admin</span>
        </router-link>

        <v-spacer />

        <v-btn variant="text" class="text-none mr-2" to="/profile">
          <v-avatar size="32" class="mr-2">
            <v-icon color="grey-darken-1" size="32">mdi-account-circle</v-icon>
          </v-avatar>
          <span class="d-none d-sm-inline text-body-2">{{ adminName || adminEmail }}</span>
        </v-btn>

        <v-btn variant="text" color="error" class="text-none" @click="doLogout">
          <v-icon start>mdi-logout</v-icon>
          Log out
        </v-btn>
      </v-app-bar>

      <!-- Sidebar -->
      <v-navigation-drawer permanent width="100">
        <v-list nav class="d-flex flex-column align-center pa-2" style="gap: 0;">
          <template v-for="(item, index) in navItems" :key="item.to">
            <v-list-item
              :to="item.to"
              :active="isActive(item)"
              color="primary"
              class="sidebar-item text-center pa-2"
              rounded="lg"
            >
              <div class="d-flex flex-column align-center">
                <v-icon size="24">{{ item.icon }}</v-icon>
                <span class="text-caption mt-1">{{ item.title }}</span>
              </div>
            </v-list-item>
            <v-divider class="my-1" style="width: 100%;" />
          </template>

          <v-list-item
            to="/profile"
            :active="$route.path === '/profile'"
            color="primary"
            class="sidebar-item text-center pa-2"
            rounded="lg"
          >
            <div class="d-flex flex-column align-center">
              <v-icon size="24">mdi-account-circle</v-icon>
              <span class="text-caption mt-1">Profile</span>
            </div>
          </v-list-item>
        </v-list>
      </v-navigation-drawer>
    </template>

    <v-main>
      <router-view />
    </v-main>

    <SessionReplacedModal
      :visible="sessionReplaced.visible"
      :message="sessionReplaced.message"
      :ip="sessionReplaced.ip"
      :graceSeconds="sessionReplaced.graceSeconds"
      @expired="sessionReplaced.visible = false"
    />
  </v-app>
</template>

<script>
import { computed, ref, watch, onBeforeUnmount } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'
import SessionReplacedModal from './components/SessionReplacedModal.vue'

const API_BASE_URL = 'http://127.0.0.1:5000/admin-api'
const SSE_RECONNECT_DELAY = 3000
const SSE_MAX_RETRIES = 10

export default {
  components: { SessionReplacedModal },
  setup() {
    const route = useRoute()
    const router = useRouter()
    const isAuthenticated = computed(() => route.meta.requiresAuth)

    const adminName = ref('')
    const adminEmail = ref('admin')

    const refreshAdminInfo = () => {
      try {
        const data = JSON.parse(localStorage.getItem('admin') || '{}')
        adminName.value = data.name || ''
        adminEmail.value = data.email || 'admin'
      } catch { /* ignore */ }
    }
    refreshAdminInfo()

    // Listen for localStorage changes (from other components on same tab)
    window.addEventListener('storage-updated', refreshAdminInfo)
    onBeforeUnmount(() => window.removeEventListener('storage-updated', refreshAdminInfo))

    const navItems = [
      { to: '/',          icon: 'mdi-view-dashboard',  title: 'Dashboard',  match: '/' },
      { to: '/articles',  icon: 'mdi-newspaper',       title: 'Articles',   match: '/articles' },
      { to: '/users',     icon: 'mdi-account-group',   title: 'Users',      match: '/users' },
      { to: '/admins',    icon: 'mdi-shield-account',  title: 'Admins',     match: '/admins' },
    ]

    const isActive = (item) => {
      if (item.match === '/') return route.path === '/'
      return route.path.startsWith(item.match)
    }

    const doLogout = () => {
      localStorage.clear()
      router.push('/login')
    }

    // ---- SSE ----
    const sessionReplaced = ref({ visible: false, message: '', ip: '', graceSeconds: 30 })
    let eventSource = null
    let reconnectTimer = null
    let retryCount = 0

    const connectSSE = async () => {
      disconnectSSE()
      const token = localStorage.getItem('access_token')
      if (!token) return
      try {
        const { data } = await axios.post(`${API_BASE_URL}/session/ticket`, {}, {
          headers: { Authorization: `Bearer ${token}` }
        })
        eventSource = new EventSource(`${API_BASE_URL}/session/stream?ticket=${data.ticket}`)
        retryCount = 0
        eventSource.addEventListener('session_replaced', (e) => {
          const d = JSON.parse(e.data)
          sessionReplaced.value = {
            visible: true,
            message: d.message || 'Your account has been logged in from another device.',
            ip: d.replaced_by?.ip_address || '',
            graceSeconds: d.grace_seconds || 30,
          }
          disconnectSSE()
        })
        eventSource.addEventListener('security_alert', () => {
          disconnectSSE(); localStorage.clear(); window.location.href = '/login'
        })
        eventSource.onerror = () => { disconnectSSE(); scheduleReconnect() }
      } catch { scheduleReconnect() }
    }
    const scheduleReconnect = () => {
      if (retryCount >= SSE_MAX_RETRIES || reconnectTimer) return
      retryCount++
      reconnectTimer = setTimeout(() => {
        reconnectTimer = null
        if (isAuthenticated.value && localStorage.getItem('access_token')) connectSSE()
      }, SSE_RECONNECT_DELAY)
    }
    const disconnectSSE = () => {
      if (eventSource) { eventSource.close(); eventSource = null }
      if (reconnectTimer) { clearTimeout(reconnectTimer); reconnectTimer = null }
    }

    // ---- Polling fallback (if SSE is not working) ----
    let pollTimer = null
    const startPolling = () => {
      stopPolling()
      pollTimer = setInterval(async () => {
        if (sessionReplaced.value.visible) return
        const token = localStorage.getItem('access_token')
        if (!token) return
        try {
          const { data } = await axios.get(`${API_BASE_URL}/session/check`, {
            headers: { Authorization: `Bearer ${token}` }
          })
          if (data.valid === false) {
            sessionReplaced.value = {
              visible: true,
              message: 'Your account has been logged in from another device.',
              ip: data.replaced_by?.ip_address || '',
              graceSeconds: 10,
            }
            stopPolling()
            disconnectSSE()
          }
        } catch {}
      }, 10000)
    }
    const stopPolling = () => {
      if (pollTimer) { clearInterval(pollTimer); pollTimer = null }
    }

    watch(isAuthenticated, (v) => {
      if (v) { connectSSE(); startPolling() }
      else { disconnectSSE(); stopPolling() }
    }, { immediate: true })
    onBeforeUnmount(() => { disconnectSSE(); stopPolling() })

    return { isAuthenticated, adminName, adminEmail, navItems, isActive, doLogout, sessionReplaced }
  }
}
</script>

<style scoped>
.sidebar-item {
  width: 80px;
  min-height: auto;
}
.sidebar-item :deep(.v-list-item__content) {
  padding: 0;
}
.sidebar-item.v-list-item--active {
  background-color: rgb(var(--v-theme-primary));
  color: rgb(var(--v-theme-on-primary)) !important;
}
.sidebar-item.v-list-item--active :deep(.v-icon) {
  color: rgb(var(--v-theme-on-primary)) !important;
}
.sidebar-item.v-list-item--active span {
  color: rgb(var(--v-theme-on-primary)) !important;
}
.sidebar-item.v-list-item--active :deep(.v-list-item__overlay) {
  opacity: 0 !important;
}
</style>
