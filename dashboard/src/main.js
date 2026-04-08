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

// Striped table rows
const style = document.createElement('style')
style.textContent = `
  .v-table tbody tr:nth-child(even) { background: #f5f5f5; }
  .v-table tbody tr:hover { background: #e8e8e8 !important; }
`
document.head.appendChild(style)
