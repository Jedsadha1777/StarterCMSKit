import { createRouter, createWebHistory } from 'vue-router'
import { useAdmin } from './composables/useAdmin'
import { useSiteSettings } from './composables/useSiteSettings'
import Login from './views/Login.vue'
import Dashboard from './views/Dashboard.vue'
import Articles from './views/Articles.vue'
import ArticleForm from './views/ArticleForm.vue'
import Users from './views/Users.vue'
import UserForm from './views/UserForm.vue'
import Admins from './views/Admins.vue'
import AdminForm from './views/AdminForm.vue'
import Customers from './views/Customers.vue'
import CustomerForm from './views/CustomerForm.vue'
import InspectionItems from './views/InspectionItems.vue'
import InspectionItemForm from './views/InspectionItemForm.vue'
import MachineModels from './views/MachineModels.vue'
import MachineModelForm from './views/MachineModelForm.vue'
import Reports from './views/Reports.vue'
import Profile from './views/Profile.vue'
import Settings from './views/Settings.vue'

const routes = [
  { path: '/login', name: 'Login', component: Login, meta: { guest: true, title: 'Login' } },
  { path: '/', name: 'Dashboard', component: Dashboard, meta: { requiresAuth: true, title: 'Dashboard' } },
  { path: '/articles', name: 'Articles', component: Articles, meta: { requiresAuth: true, requires: 'articles.view', title: 'Articles' } },
  { path: '/articles/new', name: 'ArticleNew', component: ArticleForm, meta: { requiresAuth: true, requires: 'articles.create', title: 'New Article' } },
  { path: '/articles/:id/edit', name: 'ArticleEdit', component: ArticleForm, meta: { requiresAuth: true, requires: 'articles.edit', title: 'Edit Article' } },
  { path: '/users', name: 'Users', component: Users, meta: { requiresAuth: true, requires: 'users.view', title: 'Users' } },
  { path: '/users/new', name: 'UserNew', component: UserForm, meta: { requiresAuth: true, requires: 'users.create', title: 'New User' } },
  { path: '/users/:id/edit', name: 'UserEdit', component: UserForm, meta: { requiresAuth: true, requires: 'users.edit', title: 'Edit User' } },
  { path: '/admins', name: 'Admins', component: Admins, meta: { requiresAuth: true, requires: 'admins.view', title: 'Admins' } },
  { path: '/admins/new', name: 'AdminNew', component: AdminForm, meta: { requiresAuth: true, requires: 'admins.create', title: 'New Admin' } },
  { path: '/admins/:id/edit', name: 'AdminEdit', component: AdminForm, meta: { requiresAuth: true, requires: 'admins.edit', title: 'Edit Admin' } },
  { path: '/customers', name: 'Customers', component: Customers, meta: { requiresAuth: true, requires: 'customers.view', title: 'Customers' } },
  { path: '/customers/new', name: 'CustomerNew', component: CustomerForm, meta: { requiresAuth: true, requires: 'customers.create', title: 'New Customer' } },
  { path: '/customers/:id/edit', name: 'CustomerEdit', component: CustomerForm, meta: { requiresAuth: true, requires: 'customers.edit', title: 'Edit Customer' } },
  { path: '/inspection-items', name: 'InspectionItems', component: InspectionItems, meta: { requiresAuth: true, requires: 'inspection_items.view', title: 'Inspection Items' } },
  { path: '/inspection-items/new', name: 'InspectionItemNew', component: InspectionItemForm, meta: { requiresAuth: true, requires: 'inspection_items.create', title: 'New Inspection Item' } },
  { path: '/inspection-items/:id/edit', name: 'InspectionItemEdit', component: InspectionItemForm, meta: { requiresAuth: true, requires: 'inspection_items.edit', title: 'Edit Inspection Item' } },
  { path: '/machine-models', name: 'MachineModels', component: MachineModels, meta: { requiresAuth: true, requires: 'machine_models.view', title: 'Machine Models' } },
  { path: '/machine-models/new', name: 'MachineModelNew', component: MachineModelForm, meta: { requiresAuth: true, requires: 'machine_models.create', title: 'New Machine Model' } },
  { path: '/machine-models/:id/edit', name: 'MachineModelEdit', component: MachineModelForm, meta: { requiresAuth: true, requires: 'machine_models.edit', title: 'Edit Machine Model' } },
  { path: '/reports', name: 'Reports', component: Reports, meta: { requiresAuth: true, requires: 'reports.view', title: 'Reports' } },
  { path: '/settings', name: 'Settings', component: Settings, meta: { requiresAuth: true, requires: 'settings.view', title: 'Settings' } },
  { path: '/profile', name: 'Profile', component: Profile, meta: { requiresAuth: true, title: 'Profile' } },
  { path: '/:pathMatch(.*)*', redirect: '/' }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const hasToken = localStorage.getItem('access_token')

  if (to.path === from.path) { next(); return }

  if (to.meta.requiresAuth) {
    if (!hasToken) { next('/login'); return }
    if (to.meta.requires) {
      const [resource, action] = to.meta.requires.split('.')
      const { can } = useAdmin()
      if (!can(resource, action)) { next('/'); return }
    }
    next()
  } else if (to.meta.guest) {
    if (hasToken) next('/')
    else next()
  } else {
    next()
  }
})

router.afterEach((to) => {
  const { settings } = useSiteSettings()
  const base = settings.site_title || 'Admin Panel'
  document.title = to.meta.title ? `${to.meta.title} | ${base}` : base
})

export default router
