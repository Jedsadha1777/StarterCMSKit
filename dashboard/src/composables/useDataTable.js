import { ref, computed } from 'vue'
import { useSiteSettings } from './useSiteSettings'

export function useDataTable(loadFn) {
  const { formatDate, perPage } = useSiteSettings()
  const items = ref([])
  const loading = ref(true)
  const page = ref(1)
  const total = ref(0)
  const totalPages = ref(0)
  const sortBy = ref('created_at')
  const sortDir = ref('desc')
  let searchTimeout = null

  const toggleSort = (field) => {
    if (sortBy.value === field) sortDir.value = sortDir.value === 'asc' ? 'desc' : 'asc'
    else { sortBy.value = field; sortDir.value = 'asc' }
    page.value = 1
    loadFn()
  }

  const sortIcon = (field) => {
    if (sortBy.value !== field) return 'mdi-unfold-more-horizontal'
    return sortDir.value === 'asc' ? 'mdi-arrow-up' : 'mdi-arrow-down'
  }

  const visiblePages = computed(() => {
    const pages = []
    const start = Math.max(1, page.value - 2)
    const end = Math.min(totalPages.value, page.value + 2)
    for (let i = start; i <= end; i++) pages.push(i)
    return pages
  })

  const goToPage = (p) => { page.value = p; loadFn() }

  const handleSearch = () => {
    clearTimeout(searchTimeout)
    searchTimeout = setTimeout(() => { page.value = 1; loadFn() }, 500)
  }

  const sortParam = computed(() => (sortDir.value === 'desc' ? '-' : '') + sortBy.value)

  return {
    items, loading, page, total, totalPages, sortBy, sortDir,
    toggleSort, sortIcon, visiblePages, goToPage, handleSearch, sortParam, formatDate, perPage,
  }
}
