<template>
  <div>
    <PageBanner title="Articles" />

    <v-container>
      <div class="d-flex align-center ga-3 mb-2">
        <span class="text-body-2 font-weight-medium">Title:</span>
        <v-text-field v-model="searchTitle" variant="outlined" density="compact" hide-details clearable style="flex:1" @update:model-value="handleSearch" />
        <span class="text-body-2 font-weight-medium">Content:</span>
        <v-text-field v-model="searchContent" variant="outlined" density="compact" hide-details clearable style="flex:1" @update:model-value="handleSearch" />
      </div>
      <div class="d-flex align-center ga-3 mb-4">
        <span class="text-body-2 font-weight-medium">From:</span>
        <v-text-field v-model="dateFrom" type="date" variant="outlined" density="compact" hide-details clearable style="max-width:200px;min-width:170px" @update:model-value="handleSearch" />
        <span class="text-body-2 font-weight-medium">To:</span>
        <v-text-field v-model="dateTo" type="date" variant="outlined" density="compact" hide-details clearable style="max-width:200px;min-width:170px" @update:model-value="handleSearch" />
        <v-spacer />
        <v-btn color="primary" variant="flat" @click="loadArticles">Search</v-btn>
      </div>

      <v-card variant="outlined">
        <v-table v-if="!loading && articles.length > 0" density="comfortable">
          <thead>
            <tr class="bg-grey-lighten-3">
              <th class="text-center font-weight-bold" style="width:40px">No.</th>
              <th class="font-weight-bold" style="width:80px">ID</th>
              <th class="font-weight-bold" style="cursor:pointer" @click="toggleSort('title')">Title <v-icon size="x-small">{{ sortIcon('title') }}</v-icon></th>
              <th class="font-weight-bold text-no-wrap" style="width:100px;cursor:pointer" @click="toggleSort('status')">Status <v-icon size="x-small">{{ sortIcon('status') }}</v-icon></th>
              <th class="font-weight-bold text-no-wrap" style="width:140px;cursor:pointer" @click="toggleSort('publish_date')">Publish Date <v-icon size="x-small">{{ sortIcon('publish_date') }}</v-icon></th>
              <th class="font-weight-bold text-no-wrap" style="width:120px">Author</th>
              <th class="font-weight-bold text-no-wrap" style="width:140px;white-space:nowrap;cursor:pointer" @click="toggleSort('created_at')">Created <v-icon size="x-small">{{ sortIcon('created_at') }}</v-icon></th>
              <th class="text-center font-weight-bold" style="width:200px">Settings</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(article, idx) in articles" :key="article.id">
              <td class="text-center">{{ (page - 1) * 10 + idx + 1 }}</td>
              <td class="text-caption"><v-tooltip :text="article.id" location="top"><template v-slot:activator="{ props }"><span v-bind="props" style="cursor:help">{{ article.id.substring(0, 8) }}</span></template></v-tooltip></td>
              <td>{{ article.title }}</td>
              <td><v-chip :color="article.status === 'published' ? 'success' : 'grey'" size="small" variant="tonal">{{ article.status }}</v-chip></td>
              <td>{{ article.publish_date ? formatDate(article.publish_date) : '-' }}</td>
              <td>{{ article.author_email }}</td>
              <td>{{ formatDate(article.created_at) }}</td>
              <td class="text-center">
                <v-btn size="small" color="info" variant="tonal" class="mr-2" :to="`/articles/${article.id}/edit`">Edit</v-btn>
                <v-btn size="small" color="error" variant="tonal" @click="deleteArticle(article.id)">Delete</v-btn>
              </td>
            </tr>
          </tbody>
        </v-table>

        <v-card-text v-if="loading" class="text-center py-8">
          <v-progress-circular indeterminate color="primary" />
        </v-card-text>
        <v-card-text v-else-if="articles.length === 0" class="text-center py-8 text-grey">No articles found</v-card-text>
      </v-card>

      <div class="d-flex justify-space-between align-center mt-6">
        <v-btn color="primary" variant="flat" rounded="pill" to="/">
          <v-icon start>mdi-arrow-left</v-icon>Back
        </v-btn>
        <div v-if="articles.length > 0" class="d-flex align-center ga-3">
          <v-btn size="small" :disabled="page === 1" @click="goToPage(page - 1)">
            <v-icon>mdi-chevron-left</v-icon>
          </v-btn>
          <span class="text-body-2 text-grey">Page {{ page }} / {{ totalPages }} ({{ total }})</span>
          <v-btn size="small" :disabled="page === totalPages" @click="goToPage(page + 1)">
            <v-icon>mdi-chevron-right</v-icon>
          </v-btn>
        </div>
        <v-btn color="success" variant="flat" rounded="pill" to="/articles/new">
          <v-icon start>mdi-plus</v-icon>Create Article
        </v-btn>
      </div>
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
    const articles = ref([])
    const loading = ref(true)
    const searchTitle = ref('')
    const searchContent = ref('')
    const dateFrom = ref('')
    const dateTo = ref('')
    const page = ref(1)
    const total = ref(0)
    const totalPages = ref(0)
    const sortBy = ref('created_at')
    const sortDir = ref('desc')
    let searchTimeout = null

    const toggleSort = (field) => {
      if (sortBy.value === field) sortDir.value = sortDir.value === 'asc' ? 'desc' : 'asc'
      else { sortBy.value = field; sortDir.value = 'asc' }
      page.value = 1; loadArticles()
    }
    const sortIcon = (field) => {
      if (sortBy.value !== field) return 'mdi-unfold-more-horizontal'
      return sortDir.value === 'asc' ? 'mdi-arrow-up' : 'mdi-arrow-down'
    }

    const loadArticles = async () => {
      loading.value = true
      try {
        const params = { page: page.value, per_page: 10 }
        if (searchTitle.value) params.title = searchTitle.value
        if (searchContent.value) params.content = searchContent.value
        if (dateFrom.value) params.created_at_min = dateFrom.value + 'T00:00:00'
        if (dateTo.value) params.created_at_max = dateTo.value + 'T23:59:59'
        params.sort_by = (sortDir.value === 'desc' ? '-' : '') + sortBy.value
        const { data } = await api.getArticles(params)
        articles.value = data.articles; total.value = data.total; totalPages.value = data.pages
      } catch { alert('Failed to load articles') }
      finally { loading.value = false }
    }
    const handleSearch = () => { clearTimeout(searchTimeout); searchTimeout = setTimeout(() => { page.value = 1; loadArticles() }, 500) }
    const goToPage = (p) => { page.value = p; loadArticles() }
    const deleteArticle = async (id) => {
      if (!confirm('Delete this article?')) return
      try { await api.deleteArticle(id); loadArticles() } catch { alert('Failed to delete') }
    }
    const formatDate = (d) => {
      const date = new Date(d)
      return date.toLocaleDateString() + ' ' + date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', hour12: false })
    }
    onMounted(loadArticles)
    return { articles, loading, searchTitle, searchContent, dateFrom, dateTo, page, total, totalPages, sortBy, sortDir, handleSearch, goToPage, deleteArticle, formatDate, loadArticles, toggleSort, sortIcon }
  }
}
</script>
