<template>
  <div id="app">
    <Navbar v-if="isAuthenticated" />
    <router-view />
  </div>
</template>

<script>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import Navbar from './components/Navbar.vue'

export default {
  components: { Navbar },
  setup() {
    const route = useRoute()
    const isAuthenticated = computed(() => route.meta.requiresAuth)
    
    return { isAuthenticated }
  }
}
</script>

<style>
#app {
  min-height: 100vh;
}
</style>
