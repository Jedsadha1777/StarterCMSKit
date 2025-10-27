import { createRouter, createWebHistory } from 'vue-router'
import Login from './views/Login.vue'
import Dashboard from './views/Dashboard.vue'
import Articles from './views/Articles.vue'
import ArticleForm from './views/ArticleForm.vue'
import Users from './views/Users.vue'
import UserForm from './views/UserForm.vue'
import Profile from './views/Profile.vue'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: Login,
    meta: { guest: true }
  },
  {
    path: '/',
    name: 'Dashboard',
    component: Dashboard,
    meta: { requiresAuth: true }
  },
  {
    path: '/articles',
    name: 'Articles',
    component: Articles,
    meta: { requiresAuth: true }
  },
  {
    path: '/articles/new',
    name: 'ArticleNew',
    component: ArticleForm,
    meta: { requiresAuth: true }
  },
  {
    path: '/articles/:id/edit',
    name: 'ArticleEdit',
    component: ArticleForm,
    meta: { requiresAuth: true }
  },
  {
    path: '/users',
    name: 'Users',
    component: Users,
    meta: { requiresAuth: true }
  },
  {
    path: '/users/new',
    name: 'UserNew',
    component: UserForm,
    meta: { requiresAuth: true }
  },
  {
    path: '/users/:id/edit',
    name: 'UserEdit',
    component: UserForm,
    meta: { requiresAuth: true }
  },
  {
    path: '/profile',
    name: 'Profile',
    component: Profile,
    meta: { requiresAuth: true }
  },
  {
    path: '/:pathMatch(.*)*',
    redirect: '/'
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const hasToken = localStorage.getItem('access_token')
  const hasRefreshToken = localStorage.getItem('refresh_token')

  // ป้องกัน redirect loop
  if (to.path === from.path) {
    next()
    return
  }

  // Route ที่ต้อง auth
  if (to.meta.requiresAuth) {
    if (!hasToken || !hasRefreshToken) {
      next('/login')
    } else {
      next()
    }
  }
  // Route สำหรับ guest (login page)
  else if (to.meta.guest) {
    if (hasToken && hasRefreshToken) {
      next('/')
    } else {
      next()
    }
  }
  // Route อื่นๆ
  else {
    next()
  }
})

export default router