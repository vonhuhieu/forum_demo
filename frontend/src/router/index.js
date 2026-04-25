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
      },
      {
        path: 'threads/edit/:id',
        name: 'Chỉnh sửa bài viết',
        component: AdminCreateThread
      },
      {
        path: 'threads/view/:id',
        name: 'Xem bài viết',
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
