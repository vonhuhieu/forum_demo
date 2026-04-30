import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '@/apps/Forum/views/HomeView.vue'
import AdminLayout from '@/apps/Admin/views/AdminLayout.vue'
import MenuConfig from '@/apps/Admin/views/MenuConfig.vue'
import CategoryConfig from '@/apps/Admin/views/CategoryConfig.vue'
import ThreadManagement from '@/apps/Admin/views/ThreadManagement.vue'
import AdminCreateThread from '@/apps/Admin/views/AdminCreateThread.vue'
import Login from '@/apps/Auth/views/Login.vue'
import Register from '@/apps/Auth/views/Register.vue'
import CreateThread from '@/apps/Forum/views/CreateThread.vue'
import ThreadDetail from '@/apps/Forum/views/ThreadDetail.vue'
import CategoryView from '@/apps/Forum/views/CategoryView.vue'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: HomeView,
    alias: '/trang-chu'
  },
  {
    path: '/category/:id',
    name: 'CategoryDetail',
    component: CategoryView
  },
  {
    path: '/thread/:id',
    name: 'ThreadDetail',
    component: ThreadDetail
  },
  {
    path: '/login',
    name: 'Login',
    component: Login
  },
  {
    path: '/register',
    name: 'Register',
    component: Register
  },
  {
    path: '/create-thread',
    name: 'CreateThread',
    component: CreateThread,
    meta: { requiresAuth: true }
  },
  {
    path: '/admin',
    component: AdminLayout,
    meta: { requiresAuth: true },
    children: [
      {
        path: 'menu',
        name: 'AdminMenu',
        component: MenuConfig
      },
      {
        path: 'category',
        name: 'AdminCategory',
        component: CategoryConfig
      },
      {
        path: 'threads',
        name: 'AdminThreads',
        component: ThreadManagement
      },
      {
        path: 'threads/create',
        name: 'AdminThreadCreate',
        component: AdminCreateThread
      },
      {
        path: 'threads/edit/:id',
        name: 'AdminThreadEdit',
        component: AdminCreateThread
      },
      {
        path: 'threads/view/:id',
        name: 'AdminThreadView',
        component: AdminCreateThread
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  if (to.matched.some(record => record.meta.requiresAuth)) {
    const token = localStorage.getItem('token')
    if (!token) {
      next('/login')
    } else {
      next()
    }
  } else {
    next()
  }
})

export default router
