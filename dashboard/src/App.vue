<template>
  <v-app>
    <template v-if="isAuthenticated">
      <!-- Top App Bar -->
      <v-app-bar color="white" elevation="2" density="comfortable">
        <v-app-bar-nav-icon @click="drawer = !drawer" />

        <router-link to="/" class="d-flex align-center text-decoration-none ml-1" style="cursor:pointer">
          <img src="@/assets/logo.png" alt="Logo" style="height:28px" class="mr-2" />
          <span class="text-h6 font-weight-bold" style="color:#2c3e50">Service Report Tool Admin</span>
        </router-link>

        <v-spacer />

        <v-menu offset-y>
          <template v-slot:activator="{ props }">
            <v-btn v-bind="props" variant="text" class="mr-2 text-none">
              <v-avatar size="32" class="mr-2">
                <v-icon color="grey-darken-1" size="32">mdi-account-circle</v-icon>
              </v-avatar>
              <span class="d-none d-sm-inline text-body-2">{{ adminName || adminEmail }}</span>
              <v-icon end size="small">mdi-chevron-down</v-icon>
            </v-btn>
          </template>

          <v-list density="compact" min-width="180">
            <v-list-item to="/profile" prepend-icon="mdi-account-circle">
              <v-list-item-title>Profile</v-list-item-title>
            </v-list-item>
            <v-divider />
            <v-list-item @click="doLogout" prepend-icon="mdi-logout" base-color="error">
              <v-list-item-title>Logout</v-list-item-title>
            </v-list-item>
          </v-list>
        </v-menu>
      </v-app-bar>

      <!-- Sidebar -->
      <v-navigation-drawer v-model="drawer" :rail="rail" @click="rail = false">
        <v-list-item
          :prepend-icon="rail ? 'mdi-chevron-right' : 'mdi-chevron-left'"
          @click.stop="rail = !rail"
          class="mb-1"
        >
          <v-list-item-title v-if="!rail" class="text-body-2 text-grey">Collapse</v-list-item-title>
        </v-list-item>

        <v-divider />

        <v-list nav density="compact">
          <v-list-item
            v-for="item in navItems"
            :key="item.to"
            :to="item.to"
            :prepend-icon="item.icon"
            :title="item.title"
            :active="isActive(item)"
            color="primary"
          />
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
    const drawer = ref(true)
    const rail = ref(false)

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
      { to: '/profile',   icon: 'mdi-account-circle',  title: 'Profile',    match: '/profile' },
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

    return { isAuthenticated, drawer, rail, adminName, adminEmail, navItems, isActive, doLogout, sessionReplaced }
  }
}
</script>
