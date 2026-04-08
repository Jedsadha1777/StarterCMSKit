<template>
  <div>
    <v-sheet color="primary" class="pa-3 pl-6">
      <span class="text-white text-h6">{{ title }}</span>
    </v-sheet>

    <v-container>
      <v-breadcrumbs :items="crumbs" density="compact" class="px-0 pt-3 pb-0">
        <template v-slot:prepend>
          <v-icon size="small" class="mr-1">mdi-home</v-icon>
        </template>
      </v-breadcrumbs>
    </v-container>
  </div>
</template>

<script>
import { computed } from 'vue'
import { useRoute } from 'vue-router'

const routeLabels = {
  '': 'Dashboard',
  'articles': 'Articles',
  'users': 'Users',
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

        // Skip numeric IDs in breadcrumb text
        if (/^\d+$/.test(part)) continue

        const label = routeLabels[part] || part.charAt(0).toUpperCase() + part.slice(1)
        const isLast = i === parts.length - 1 || (i === parts.length - 2 && /^\d+$/.test(parts[i + 1]))

        items.push({
          title: label,
          to: isLast ? undefined : path,
          disabled: isLast,
        })
      }

      return items
    })

    return { crumbs }
  }
}
</script>
