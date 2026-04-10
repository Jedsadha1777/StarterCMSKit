<template>
  <div>
    <PageBanner title="Settings" />

    <v-container style="max-width: 720px">
      <v-card-text v-if="loadingPage" class="text-center py-8">
        <v-progress-circular indeterminate color="primary" />
      </v-card-text>

      <template v-else>
        <!-- General -->
        <div class="text-subtitle-1 font-weight-bold mb-2 mt-2">General</div>
        <v-card variant="outlined" class="mb-6" style="border-width:thin;border-color:rgba(0,0,0,0.12)">
          <v-card-text>
            <v-text-field v-model="form.site_title" label="Site Title" variant="outlined" density="compact" hide-details class="mb-4" />

            <div class="mb-4">
              <div class="text-body-2 font-weight-medium mb-1">Primary Color</div>
              <div class="d-flex align-center ga-3">
                <input type="color" v-model="form.primary_color" style="width:40px;height:40px;border:1px solid #ddd;border-radius:4px;cursor:pointer;padding:2px" />
                <v-text-field v-model="form.primary_color" variant="outlined" density="compact" hide-details style="max-width:150px" placeholder="#c4193c" />
              </div>
            </div>

            <div class="mb-4">
              <div class="text-body-2 font-weight-medium mb-1">Logo</div>
              <div class="d-flex align-center ga-3">
                <img v-if="form.logo" :src="apiBase + form.logo" alt="Logo" style="height:40px;max-width:200px;object-fit:contain" />
                <span v-else class="text-body-2 text-grey">No logo uploaded</span>
                <v-btn size="small" variant="tonal" @click="$refs.logoInput.click()">
                  <v-icon start size="small">mdi-upload</v-icon>Upload
                </v-btn>
                <v-btn v-if="form.logo" size="small" variant="tonal" color="error" @click="removeLogo">
                  <v-icon start size="small">mdi-close</v-icon>Remove
                </v-btn>
                <input ref="logoInput" type="file" accept="image/*" hidden @change="uploadFile('logo', $event)" />
              </div>
            </div>

            <div>
              <div class="text-body-2 font-weight-medium mb-1">Favicon</div>
              <div class="d-flex align-center ga-3">
                <img v-if="form.favicon" :src="apiBase + form.favicon" alt="Favicon" style="height:32px;width:32px;object-fit:contain" />
                <span v-else class="text-body-2 text-grey">No favicon uploaded</span>
                <v-btn size="small" variant="tonal" @click="$refs.faviconInput.click()">
                  <v-icon start size="small">mdi-upload</v-icon>Upload
                </v-btn>
                <v-btn v-if="form.favicon" size="small" variant="tonal" color="error" @click="removeFavicon">
                  <v-icon start size="small">mdi-close</v-icon>Remove
                </v-btn>
                <input ref="faviconInput" type="file" accept="image/*,.ico" hidden @change="uploadFile('favicon', $event)" />
              </div>
            </div>
          </v-card-text>
        </v-card>

        <!-- Content -->
        <div class="text-subtitle-1 font-weight-bold mb-2">Content</div>
        <v-card variant="outlined" class="mb-6" style="border-width:thin;border-color:rgba(0,0,0,0.12)">
          <v-card-text>
            <v-text-field v-model="form.posts_per_page" label="Posts per page" variant="outlined" density="compact" hide-details type="number" min="1" max="100" class="mb-4" style="max-width:200px" />
            <v-select v-model="form.date_format" :items="dateFormats" label="Date Format" variant="outlined" density="compact" hide-details style="max-width:300px" />
          </v-card-text>
        </v-card>

        <!-- Save -->
        <div class="d-flex justify-end">
          <p v-if="error" class="text-error text-body-2 mr-4 align-self-center">{{ error }}</p>
          <p v-if="success" class="text-success text-body-2 mr-4 align-self-center">{{ success }}</p>
          <v-btn color="success" variant="flat" :loading="saving" @click="save">
            <v-icon start>mdi-content-save</v-icon>Save Settings
          </v-btn>
        </div>
      </template>
    </v-container>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import api from '../api'
import PageBanner from '../components/PageBanner.vue'
import { useSiteSettings } from '../composables/useSiteSettings'

const API_BASE_URL = 'http://127.0.0.1:5000'

export default {
  components: { PageBanner },
  setup() {
    const { loadSettings: reloadGlobal } = useSiteSettings()
    const apiBase = API_BASE_URL
    const loadingPage = ref(true)
    const saving = ref(false)
    const error = ref('')
    const success = ref('')

    const form = ref({
      site_title: '',
      logo: '',
      favicon: '',
      posts_per_page: '10',
      date_format: 'YYYY-MM-DD',
      primary_color: '#c4193c',
    })

    const dateFormats = [
      'YYYY-MM-DD',
      'DD/MM/YYYY',
      'DD-MM-YYYY',
    ]

    const loadSettings = async () => {
      loadingPage.value = true
      try {
        const { data } = await api.getSettings()
        form.value = { ...form.value, ...data }
      } catch {}
      finally { loadingPage.value = false }
    }

    const save = async () => {
      error.value = ''; success.value = ''; saving.value = true
      try {
        const { data } = await api.updateSettings({
          site_title: form.value.site_title,
          posts_per_page: form.value.posts_per_page,
          date_format: form.value.date_format,
          primary_color: form.value.primary_color,
        })
        form.value = { ...form.value, ...data }
        await reloadGlobal()
        success.value = 'Settings saved'
      } catch (err) { error.value = err.response?.data?.message || 'Failed to save' }
      finally { saving.value = false }
    }

    const uploadFile = async (field, event) => {
      const file = event.target.files[0]
      if (!file) return
      error.value = ''; success.value = ''
      try {
        const { data } = await api.uploadSettingFile(field, file)
        form.value[field] = data.url
        await reloadGlobal()
        success.value = `${field} uploaded`
      } catch (err) { error.value = err.response?.data?.message || 'Upload failed' }
      event.target.value = ''
    }

    const removeLogo = async () => {
      form.value.logo = ''
      await api.updateSettings({ logo: '' })
    }

    const removeFavicon = async () => {
      form.value.favicon = ''
      await api.updateSettings({ favicon: '' })
    }

    onMounted(loadSettings)

    return { apiBase, loadingPage, saving, error, success, form, dateFormats, save, uploadFile, removeLogo, removeFavicon }
  }
}
</script>
