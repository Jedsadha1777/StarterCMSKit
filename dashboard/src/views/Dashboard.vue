<template>
  <div>
    <PageBanner title="Dashboard" />

    <v-container>
      <v-row class="mb-8">
        <v-col cols="12" sm="3">
          <v-card variant="outlined">
            <v-card-text class="text-center">
              <div class="text-h3 text-primary font-weight-bold">{{ stats.articles }}</div>
              <div class="text-overline">Articles</div>
            </v-card-text>
          </v-card>
        </v-col>
        <v-col cols="12" sm="3">
          <v-card variant="outlined">
            <v-card-text class="text-center">
              <div class="text-h3 text-primary font-weight-bold">{{ stats.users }}</div>
              <div class="text-overline">Users</div>
            </v-card-text>
          </v-card>
        </v-col>
        <v-col cols="12" sm="3">
          <v-card variant="outlined">
            <v-card-text class="text-center">
              <div class="text-h3 text-primary font-weight-bold">{{ stats.customers }}</div>
              <div class="text-overline">Customers</div>
            </v-card-text>
          </v-card>
        </v-col>
        <v-col cols="12" sm="3">
          <v-card variant="outlined">
            <v-card-text class="text-center">
              <div class="text-h3 text-primary font-weight-bold">{{ stats.inspection_items }}</div>
              <div class="text-overline">Machine Inspection</div>
            </v-card-text>
          </v-card>
        </v-col>
      </v-row>

      <v-row>
        <v-col cols="6" sm="3">
          <v-btn color="primary" variant="flat" block size="large" to="/articles" class="mb-3">
            <v-icon start>mdi-newspaper</v-icon>Articles
          </v-btn>
        </v-col>
        <v-col cols="6" sm="3">
          <v-btn color="primary" variant="flat" block size="large" to="/users" class="mb-3">
            <v-icon start>mdi-account-group</v-icon>Users
          </v-btn>
        </v-col>
        <v-col cols="6" sm="3">
          <v-btn color="primary" variant="flat" block size="large" to="/customers" class="mb-3">
            <v-icon start>mdi-account-multiple</v-icon>Customers
          </v-btn>
        </v-col>
        <v-col cols="6" sm="3">
          <v-btn color="primary" variant="flat" block size="large" to="/inspection-items" class="mb-3">
            <v-icon start>mdi-clipboard-check</v-icon>Inspection
          </v-btn>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import api from '../api'
import PageBanner from '../components/PageBanner.vue'

export default {
  components: { PageBanner },
  setup() {
    const stats = ref({ articles: 0, users: 0, customers: 0, inspection_items: 0 })

    onMounted(async () => {
      try {
        const { data } = await api.getSummary()
        stats.value.articles = data.articles
        stats.value.users = data.users
        stats.value.customers = data.customers || 0
        stats.value.inspection_items = data.inspection_items || 0
      } catch {}
    })

    return { stats }
  }
}
</script>
