<template>
  <v-app>
    <template v-if="isAuthenticated">
      <!-- Top App Bar -->
      <v-app-bar color="white" elevation="2" density="comfortable">

        <router-link to="/" class="d-flex align-center text-decoration-none ml-1" style="cursor:pointer">
          <img :src="siteLogoUrl || defaultLogo" alt="Logo" style="height:44px" class="mr-2" />
          <span class="text-h6 font-weight-bold" style="color:#2c3e50">{{ siteTitle }}</span>
        </router-link>

        <v-spacer />

        <v-select
          v-if="showCompanySelect"
          v-model="activeCompanyId"
          :items="companies"
          item-title="name"
          item-value="id"
          variant="outlined"
          density="compact"
          hide-details
          style="max-width: 220px"
          class="mr-3"
          @update:model-value="handleCompanyChange"
        />
        <span v-else-if="admin.company_name" class="text-body-2 text-grey mr-3">
          <v-icon size="small" class="mr-1">mdi-domain</v-icon>{{ admin.company_name }}
        </span>

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

          <v-divider class="my-1" style="width: 100%;" />

          <v-list-item
            v-if="hasPermission('settings', 'view')"
            to="/settings"
            :active="$route.path === '/settings'"
            color="primary"
            class="sidebar-item text-center pa-2"
            rounded="lg"
          >
            <div class="d-flex flex-column align-center">
              <v-icon size="24">mdi-cog</v-icon>
              <span class="text-caption mt-1">Settings</span>
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
import { useTheme } from 'vuetify'
import { useSiteSettings } from './composables/useSiteSettings'
import { useAdmin } from './composables/useAdmin'
import api from './api'
import { API_BASE_URL } from './config'
import defaultLogoImg from '@/assets/logo.png'
const SSE_RECONNECT_DELAY = 3000
const SSE_MAX_RETRIES = 10

export default {
  components: { SessionReplacedModal },
  setup() {
    const route = useRoute()
    const router = useRouter()
    // isAuthenticated เป็น ref (ไม่ใช่ computed) เพราะ sessionStorage/localStorage
    // ไม่ใช่ reactive data — Vue ไม่ track การเปลี่ยนแปลงของมัน
    // syncAuthState() ถูกเรียกเมื่อ auth เปลี่ยน (login/logout/token clear)
    const isAuthenticated = ref(
      !!(sessionStorage.getItem('access_token') && localStorage.getItem('refresh_token'))
    )
    const syncAuthState = () => {
      isAuthenticated.value = !!(sessionStorage.getItem('access_token') && localStorage.getItem('refresh_token'))
    }
    window.addEventListener('auth-changed', syncAuthState)
    const { settings, loadSettings, logoUrl, setThemeRef } = useSiteSettings()
    setThemeRef(useTheme())
    const defaultLogo = defaultLogoImg
    const siteTitle = computed(() => settings.site_title || 'Admin Panel')
    const siteLogoUrl = computed(() => logoUrl())

    const { admin, companies, activeCompanyId, setActiveCompany, can: hasPermission, sync: syncAdminInfo } = useAdmin()
    const adminName = computed(() => admin.name || '')
    const adminEmail = computed(() => admin.email || 'admin')
    const showCompanySelect = computed(() => admin.is_super_admin && companies.value.length > 0)

    const handleCompanyChange = (id) => {
      setActiveCompany(id)
      window.location.reload()
    }

    const allNavItems = [
      { to: '/',          icon: 'mdi-view-dashboard',  title: 'Dashboard',  match: '/' },
      { to: '/articles',  icon: 'mdi-newspaper',       title: 'Articles',   match: '/articles',  requires: 'articles.view' },
      { to: '/users',     icon: 'mdi-account-group',   title: 'Users',      match: '/users',     requires: 'users.view' },
      { to: '/admins',    icon: 'mdi-shield-account',  title: 'Admins',     match: '/admins',    requires: 'admins.view' },
      { to: '/customers', icon: 'mdi-account-multiple', title: 'Customers',  match: '/customers', requires: 'customers.view' },
      { to: '/inspection-items', icon: 'mdi-clipboard-check', title: 'Inspection',  match: '/inspection-items', requires: 'inspection_items.view' },
    ]

    const navItems = computed(() =>
      allNavItems.filter(item => {
        if (!item.requires) return true
        const [resource, action] = item.requires.split('.')
        return hasPermission(resource, action)
      })
    )

    const isActive = (item) => {
      if (item.match === '/') return route.path === '/'
      return route.path.startsWith(item.match)
    }

    const doLogout = async () => {
      await api.logout()
    }

    // ---- SSE ----
    const sessionReplaced = ref({ visible: false, message: '', ip: '', graceSeconds: 30 })
    let eventSource = null
    let reconnectTimer = null
    let retryCount = 0
    let isMounted = true  // D3: guard against creating EventSource after unmount

    const connectSSE = async () => {
      disconnectSSE()
      const token = sessionStorage.getItem('access_token')
      if (!token) return
      try {
        const { data } = await axios.post(`${API_BASE_URL}/session/ticket`, {}, {
          headers: { Authorization: `Bearer ${token}` }
        })
        if (!isMounted) return  // component unmounted while awaiting ticket — do not create EventSource
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
          disconnectSSE()
          sessionStorage.removeItem('access_token')
          localStorage.removeItem('refresh_token')
          localStorage.removeItem('admin')
          localStorage.removeItem('companies')
          localStorage.removeItem('active_company_id')
          router.push('/login')
        })
        eventSource.onopen = () => { stopPolling() }
        eventSource.onerror = () => { disconnectSSE(); startPolling(); scheduleReconnect() }
      } catch { startPolling(); scheduleReconnect() }
    }
    const scheduleReconnect = () => {
      if (retryCount >= SSE_MAX_RETRIES || reconnectTimer) return
      retryCount++
      reconnectTimer = setTimeout(() => {
        reconnectTimer = null
        if (isAuthenticated.value && sessionStorage.getItem('access_token')) connectSSE()
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
        const token = sessionStorage.getItem('access_token')
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
      if (v) { connectSSE(); loadSettings(); syncAdminInfo() }
      else { disconnectSSE(); stopPolling() }
    }, { immediate: true })

    // Reload settings when navigating back from settings page
    // also sync auth state on every navigation (catches login redirect)
    watch(() => route.path, (newPath, oldPath) => {
      syncAuthState()
      if (oldPath === '/settings' && newPath !== '/settings') loadSettings()
    })
    onBeforeUnmount(() => {
      isMounted = false
      disconnectSSE()
      stopPolling()
      window.removeEventListener('auth-changed', syncAuthState)
    })

    return { isAuthenticated, siteTitle, siteLogoUrl, defaultLogo, admin, adminName, adminEmail, companies, activeCompanyId, showCompanySelect, handleCompanyChange, navItems, isActive, doLogout, sessionReplaced, hasPermission }
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
