import { createRouter, createWebHistory } from 'vue-router'
import { useAdmin } from './composables/useAdmin'
import Login from './views/Login.vue'
import Dashboard from './views/Dashboard.vue'
import Articles from './views/Articles.vue'
import ArticleForm from './views/ArticleForm.vue'
import Users from './views/Users.vue'
import UserForm from './views/UserForm.vue'
import Admins from './views/Admins.vue'
import AdminForm from './views/AdminForm.vue'
import Profile from './views/Profile.vue'
import Settings from './views/Settings.vue'

const routes = [
  { path: '/login', name: 'Login', component: Login, meta: { guest: true } },
  { path: '/', name: 'Dashboard', component: Dashboard, meta: { requiresAuth: true } },
  { path: '/articles', name: 'Articles', component: Articles, meta: { requiresAuth: true, requires: 'articles.view' } },
  { path: '/articles/new', name: 'ArticleNew', component: ArticleForm, meta: { requiresAuth: true, requires: 'articles.create' } },
  { path: '/articles/:id/edit', name: 'ArticleEdit', component: ArticleForm, meta: { requiresAuth: true, requires: 'articles.edit' } },
  { path: '/users', name: 'Users', component: Users, meta: { requiresAuth: true, requires: 'users.view' } },
  { path: '/users/new', name: 'UserNew', component: UserForm, meta: { requiresAuth: true, requires: 'users.create' } },
  { path: '/users/:id/edit', name: 'UserEdit', component: UserForm, meta: { requiresAuth: true, requires: 'users.edit' } },
  { path: '/admins', name: 'Admins', component: Admins, meta: { requiresAuth: true, requires: 'admins.view' } },
  { path: '/admins/new', name: 'AdminNew', component: AdminForm, meta: { requiresAuth: true, requires: 'admins.create' } },
  { path: '/admins/:id/edit', name: 'AdminEdit', component: AdminForm, meta: { requiresAuth: true, requires: 'admins.edit' } },
  { path: '/settings', name: 'Settings', component: Settings, meta: { requiresAuth: true, requires: 'settings.view' } },
  { path: '/profile', name: 'Profile', component: Profile, meta: { requiresAuth: true } },
  { path: '/:pathMatch(.*)*', redirect: '/' }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const hasToken = localStorage.getItem('access_token')
  const hasRefreshToken = localStorage.getItem('refresh_token')

  if (to.path === from.path) { next(); return }

  if (to.meta.requiresAuth) {
    if (!hasToken || !hasRefreshToken) { next('/login'); return }
    if (to.meta.requires) {
      const [resource, action] = to.meta.requires.split('.')
      const { can } = useAdmin()
      if (!can(resource, action)) { next('/'); return }
    }
    next()
  } else if (to.meta.guest) {
    if (hasToken && hasRefreshToken) next('/')
    else next()
  } else {
    next()
  }
})

export default router
