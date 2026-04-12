import { reactive } from 'vue'
import api from '../api'
import { API_BASE } from '../config'

const settings = reactive({
  site_title: 'Admin Panel',
  logo: '',
  favicon: '',
  posts_per_page: '10',
  date_format: 'YYYY-MM-DD',
  primary_color: '#c4193c',
  _loaded: false,
})

async function loadSettings() {
  try {
    const { data } = await api.getSettings()
    Object.assign(settings, data)
    settings._loaded = true
    applyTitle()
    applyFavicon()
    applyPrimaryColor()
  } catch {}
}

function applyTitle() {
  document.title = settings.site_title || 'Admin Panel'
}

function applyFavicon() {
  if (!settings.favicon) return
  let link = document.querySelector("link[rel~='icon']")
  if (!link) {
    link = document.createElement('link')
    link.rel = 'icon'
    document.head.appendChild(link)
  }
  link.href = API_BASE + settings.favicon
}

let _vuetifyTheme = null

function setThemeRef(theme) {
  _vuetifyTheme = theme
}

function applyPrimaryColor() {
  const color = settings.primary_color || '#c4193c'
  if (_vuetifyTheme) {
    _vuetifyTheme.themes.value.light.colors.primary = color
    _vuetifyTheme.themes.value.light.colors.error = color
  }
}

function logoUrl() {
  return settings.logo ? API_BASE + settings.logo : ''
}

function formatDate(d) {
  if (!d) return '-'
  // Backend stores naive UTC — append 'Z' so JS treats it as UTC, then convert to Asia/Bangkok
  const utcStr = d.endsWith('Z') ? d : d + 'Z'
  const date = new Date(utcStr)
  const thai = new Date(date.getTime() + 7 * 60 * 60 * 1000)
  const Y = thai.getUTCFullYear()
  const M = String(thai.getUTCMonth() + 1).padStart(2, '0')
  const D = String(thai.getUTCDate()).padStart(2, '0')
  const h = String(thai.getUTCHours()).padStart(2, '0')
  const m = String(thai.getUTCMinutes()).padStart(2, '0')

  const fmt = settings.date_format || 'YYYY-MM-DD'

  const datePart = fmt
    .replace('YYYY', Y)
    .replace('MM', M)
    .replace('DD', D)

  return datePart + ' ' + h + ':' + m
}

function perPage() {
  return parseInt(settings.posts_per_page) || 10
}

export function useSiteSettings() {
  return { settings, loadSettings, logoUrl, formatDate, perPage, applyTitle, applyFavicon, applyPrimaryColor, setThemeRef }
}
