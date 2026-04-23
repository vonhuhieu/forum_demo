import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import AdminLayout from '../views/Admin/AdminLayout.vue'
import MenuConfig from '../views/Admin/MenuConfig.vue'
import CategoryConfig from '../views/Admin/CategoryConfig.vue'
import ThreadManagement from '../views/Admin/ThreadManagement.vue'
import AdminCreateThread from '../views/Admin/AdminCreateThread.vue'
import Login from '../views/Login.vue'
import Register from '../views/Register.vue'
import CreateThread from '../views/CreateThread.vue'
import ThreadDetail from '../views/ThreadDetail.vue'

const routes = [
  {
    path: '/',
    name: 'home',
    component: HomeView
  },
  {
    path: '/thread/:id',
    name: 'thread-detail',
    component: ThreadDetail
  },
  {
    path: '/login',
    name: 'login',
    component: Login
  },
  {
    path: '/register',
    name: 'register',
    component: Register
  },
  {
    path: '/create-thread',
    name: 'create-thread',
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
        name: 'Quản lý Menu Header',
        component: MenuConfig
      },
      {
        path: 'category',
        name: 'Quản lý Chuyên mục',
        component: CategoryConfig
      },
      {
        path: 'threads',
        name: 'Quản lý Bài viết',
        component: ThreadManagement
      },
      {
        path: 'threads/create',
        name: 'Đăng bài mới',
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
