<template>
  <v-sheet color="primary" class="d-flex align-center justify-space-between px-6 py-3">
    <span class="text-white text-h6">{{ title }}</span>
    <v-breadcrumbs :items="crumbs" density="compact" class="pa-0 text-caption">
      <template v-slot:prepend>
        <v-icon size="small" class="mr-1" color="white">mdi-home</v-icon>
      </template>
      <template v-slot:divider>
        <span class="text-white-50">/</span>
      </template>
      <template v-slot:item="{ item }">
        <router-link v-if="item.to" :to="item.to" class="text-white text-decoration-none" style="opacity:0.8">{{ item.title }}</router-link>
        <span v-else class="text-white">{{ item.title }}</span>
      </template>
    </v-breadcrumbs>
  </v-sheet>
</template>

<script>
import { computed } from 'vue'
import { useRoute } from 'vue-router'

const routeLabels = {
  '': 'Dashboard',
  'articles': 'Articles',
  'users': 'Users',
  'admins': 'Admins',
  'settings': 'Settings',
  'profile': 'Profile',
  'new': 'Create',
  'edit': 'Edit',
  'login': 'Login',
}

export default {
  props: {
    title: { type: String, required: true }
  },
  setup() {
    const route = useRoute()

    const crumbs = computed(() => {
      const parts = route.path.split('/').filter(Boolean)
      const items = [{ title: 'Home', to: '/' }]

      let path = ''
      for (let i = 0; i < parts.length; i++) {
        const part = parts[i]
        path += '/' + part

        if (/^\d+$/.test(part) || /^[0-9a-f-]{36}$/.test(part)) continue

        const label = routeLabels[part] || part.charAt(0).toUpperCase() + part.slice(1)
        const isLast = i === parts.length - 1 || (i < parts.length - 1 && /^[0-9a-f-]{36}$|^\d+$/.test(parts[i + 1]))

        items.push({
          title: label,
          to: isLast ? undefined : path,
        })
      }

      return items
    })

    return { crumbs }
  }
}
</script>
