import { createApp } from 'vue'
import { createVuetify } from 'vuetify'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'
import 'vuetify/styles'
import '@mdi/font/css/materialdesignicons.css'
import App from './App.vue'
import router from './router'

const vuetify = createVuetify({
  components,
  directives,
  theme: {
    defaultTheme: 'light',
    themes: {
      light: {
        colors: {
          primary: '#c4193c',
          secondary: '#1a3a5c',
          error: '#c4193c',
          info: '#1a3a5c',
          success: '#2e7d32',
          warning: '#f39c12',
          banner: '#c4193c',
        },
      },
    },
  },
})

const app = createApp(App)
app.use(router)
app.use(vuetify)
app.mount('#app')

// Table styles
const style = document.createElement('style')
style.textContent = `
  .v-table tbody tr:hover { background: #e8e8e8 !important; }
  .v-table tbody td { padding-top: 12px !important; padding-bottom: 12px !important; }
  .v-toolbar__content { padding-left: 16px !important; padding-right: 16px !important; }
`
document.head.appendChild(style)
