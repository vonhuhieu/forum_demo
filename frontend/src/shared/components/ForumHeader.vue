<template>
  <header>
    <div class="header-top">
      <div class="container">
        <div class="logo" style="cursor: pointer;" @click="$router.push({ name: 'Home' })">HTXSL</div>
      </div>
    </div>
    <div class="header-nav">
      <div class="container nav-container">
        <nav class="nav-links">
          <router-link
            v-for="menu in menus"
            :key="menu.id"
            :to="menu.url"
            active-class="active"
          >
            {{ menu.title }}
          </router-link>
        </nav>
        <div class="nav-right">
          <template v-if="isLoggedIn">
            <div class="user-info-header">
              <span class="user-avatar-small" :style="{ backgroundColor: currentUser.avatar || '#fff', color: currentUser.avatar ? '#fff' : '#1a507a' }">
                {{ currentUser.username.charAt(0).toUpperCase() }}
              </span>
              <span class="user-greeting">Chào, {{ currentUser.username }}</span>
            </div>
            <button @click="handleLogout" class="btn-logout-small">Thoát</button>
          </template>
          <template v-else>
            <router-link :to="{ name: 'Login' }">Đăng nhập</router-link>
            <router-link :to="{ name: 'Register' }">Đăng ký</router-link>
          </template>
          <div class="btn-search">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
            <span>Tìm kiếm</span>
          </div>
        </div>
      </div>
    </div>
  </header>
</template>

<script>
import api from '@/shared/services/api.service'

export default {
  name: 'ForumHeader',
  data() {
    return {
      menus: [],
      isLoggedIn: false,
      currentUser: null
    }
  },
  async mounted() {
    this.checkAuth()
    try {
      const response = await api.get('/menus')
      this.menus = response.data
    } catch (error) {
      console.error('Lỗi khi tải menu:', error)
      this.menus = [
        { id: 1, title: 'Trang nhất', url: '/' }
      ]
    }
  },
  methods: {
    checkAuth() {
      const user = localStorage.getItem('user')
      if (user) {
        this.isLoggedIn = true
        this.currentUser = JSON.parse(user)
      }
    },
    handleLogout() {
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      this.isLoggedIn = false
      this.currentUser = null
      this.$emit('logout')
      if (this.$route.meta.requiresAuth) {
        this.$router.push({ name: 'Home' })
      } else {
        window.location.reload() // Reload to update UI across components
      }
    }
  }
}
</script>

<style scoped>
.user-info-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-right: 15px;
}

.user-avatar-small {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.75rem;
  font-weight: bold;
}

.user-greeting {
  color: white;
  font-size: 0.9rem;
}

.btn-logout-small {
  background: none;
  border: 1px solid white;
  color: white;
  padding: 2px 8px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 0.8rem;
  transition: all 0.2s;
}

.btn-logout-small:hover {
  background: white;
  color: #1a507a;
}
</style>
