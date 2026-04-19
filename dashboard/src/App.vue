<template>
  <v-app>
    <template v-if="isAuthenticated">
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
          <v-icon start>mdi-logout</v-icon>Log out
        </v-btn>
      </v-app-bar>

      <v-navigation-drawer permanent width="100">
        <v-list nav class="d-flex flex-column align-center pa-2" style="gap: 0;">
          <template v-for="item in navItems" :key="item.to">
            <v-list-item :to="item.to" :active="isActive(item)" color="primary" class="sidebar-item text-center pa-2" rounded="lg">
              <div class="d-flex flex-column align-center">
                <v-icon size="24">{{ item.icon }}</v-icon>
                <span class="text-caption mt-1">{{ item.title }}</span>
              </div>
            </v-list-item>
            <v-divider class="my-1" style="width: 100%;" />
          </template>

          <v-list-item to="/profile" :active="$route.path === '/profile'" color="primary" class="sidebar-item text-center pa-2" rounded="lg">
            <div class="d-flex flex-column align-center">
              <v-icon size="24">mdi-account-circle</v-icon>
              <span class="text-caption mt-1">Profile</span>
            </div>
          </v-list-item>
          <v-divider class="my-1" style="width: 100%;" />

          <v-list-item v-if="hasPermission('settings', 'view')" to="/settings" :active="$route.path === '/settings'" color="primary" class="sidebar-item text-center pa-2" rounded="lg">
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
      @expired="onSessionReplacedExpired"
    />
  </v-app>
</template>

<script>
import { ref, watch, onBeforeUnmount } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'
import SessionReplacedModal from './components/SessionReplacedModal.vue'
import { useTheme } from 'vuetify'
import { useSiteSettings } from './composables/useSiteSettings'
import { useAdmin } from './composables/useAdmin'
import api, { clearAuthStorage } from './api'
import { API_BASE_URL, SSE_RECONNECT_DELAY, SSE_MAX_RETRIES, GRACE_SECONDS_DEFAULT } from './config'
import defaultLogoImg from '@/assets/logo.png'

export default {
  components: { SessionReplacedModal },
  setup() {
    const route = useRoute()
    const router = useRouter()

    const isAuthenticated = ref(!!(localStorage.getItem('access_token') && localStorage.getItem('refresh_token')))
    const syncAuth = () => {
      isAuthenticated.value = !!(localStorage.getItem('access_token') && localStorage.getItem('refresh_token'))
    }
    window.addEventListener('auth-cleared', syncAuth)
    window.addEventListener('auth-login', syncAuth)
    window.addEventListener('storage', (event) => {
      if (event.key === 'access_token' || event.key === 'refresh_token') {
        syncAuth()
        if (!isAuthenticated.value) router.push('/login')
      }
    })

    const { settings, loadSettings, logoUrl, setThemeRef } = useSiteSettings()
    setThemeRef(useTheme())
    const defaultLogo = defaultLogoImg
    const siteTitle = ref(settings.site_title || 'Admin Panel')
    const siteLogoUrl = ref(logoUrl())

    const { admin, companies, activeCompanyId, setActiveCompany, can: hasPermission, sync: syncAdminInfo } = useAdmin()
    const adminName = ref(admin.name || '')
    const adminEmail = ref(admin.email || 'admin')
    const showCompanySelect = ref(admin.is_super_admin && companies.value.length > 0)

    watch(() => settings.site_title, (v) => { siteTitle.value = v || 'Admin Panel' })
    watch(() => logoUrl(), (v) => { siteLogoUrl.value = v })
    watch(() => admin.name, (v) => { adminName.value = v || '' })
    watch(() => admin.email, (v) => { adminEmail.value = v || 'admin' })
    watch([() => admin.is_super_admin, companies], () => { showCompanySelect.value = admin.is_super_admin && companies.value.length > 0 })

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
      { to: '/machine-models', icon: 'mdi-cog-outline', title: 'Machine Models', match: '/machine-models', requires: 'machine_models.view' },
      { to: '/reports', icon: 'mdi-file-document-outline', title: 'Reports', match: '/reports', requires: 'reports.view' },
    ]

    const navItems = ref(allNavItems.filter(item => {
      if (!item.requires) return true
      const [resource, action] = item.requires.split('.')
      return hasPermission(resource, action)
    }))

    watch([() => admin.permissions, () => admin.is_super_admin], () => {
      navItems.value = allNavItems.filter(item => {
        if (!item.requires) return true
        const [resource, action] = item.requires.split('.')
        return hasPermission(resource, action)
      })
    })

    const isActive = (item) => {
      if (item.match === '/') return route.path === '/'
      return route.path.startsWith(item.match)
    }

    const doLogout = async () => { await api.logout() }

    // ---- SSE ----
    const sessionReplaced = ref({ visible: false, message: '', ip: '', graceSeconds: GRACE_SECONDS_DEFAULT })
    let eventSource = null
    let reconnectTimer = null
    let retryCount = 0
    let isMounted = true

    const connectSSE = async () => {
      disconnectSSE()
      const token = localStorage.getItem('access_token')
      if (!token) return
      try {
        const { data } = await axios.post(`${API_BASE_URL}/session/ticket`, {}, {
          headers: { Authorization: `Bearer ${token}` }
        })
        if (!isMounted) return
        eventSource = new EventSource(`${API_BASE_URL}/session/stream?ticket=${data.ticket}`)
        retryCount = 0
        eventSource.addEventListener('session_replaced', (e) => {
          disconnectSSE()
          clearAuthStorage()
          const d = JSON.parse(e.data)
          sessionReplaced.value = {
            visible: true,
            message: d.message || 'Your account has been logged in from another device.',
            ip: d.replaced_by?.ip_address || '',
            graceSeconds: d.grace_seconds || GRACE_SECONDS_DEFAULT,
          }
        })
        eventSource.addEventListener('security_alert', () => {
          disconnectSSE()
          clearAuthStorage()
          router.push('/login')
        })
        eventSource.onerror = () => { disconnectSSE(); scheduleReconnect() }
      } catch { scheduleReconnect() }
    }

    const onSessionReplacedExpired = () => {
      sessionReplaced.value.visible = false
      router.push('/login')
    }

    const scheduleReconnect = () => {
      if (retryCount >= SSE_MAX_RETRIES || reconnectTimer) return
      retryCount++
      reconnectTimer = setTimeout(() => {
        reconnectTimer = null
        if (isAuthenticated.value) connectSSE()
      }, SSE_RECONNECT_DELAY)
    }
    const disconnectSSE = () => {
      if (eventSource) { eventSource.close(); eventSource = null }
      if (reconnectTimer) { clearTimeout(reconnectTimer); reconnectTimer = null }
    }

    watch(isAuthenticated, (v) => {
      if (v) { connectSSE(); loadSettings(); syncAdminInfo() }
      else { disconnectSSE() }
    }, { immediate: true })

    watch(() => route.path, (newPath, oldPath) => {
      if (oldPath === '/settings' && newPath !== '/settings') loadSettings()
    })

    onBeforeUnmount(() => {
      isMounted = false
      disconnectSSE()
      window.removeEventListener('auth-cleared', syncAuth)
      window.removeEventListener('auth-login', syncAuth)
    })

    return { isAuthenticated, siteTitle, siteLogoUrl, defaultLogo, admin, adminName, adminEmail, companies, activeCompanyId, showCompanySelect, handleCompanyChange, navItems, isActive, doLogout, sessionReplaced, onSessionReplacedExpired, hasPermission }
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
