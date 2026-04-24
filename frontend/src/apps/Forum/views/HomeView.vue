<template>
  <div class="app-wrapper">
    <header>
      <div class="header-top">
        <div class="container">
          <div class="logo">HTXHS</div>
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
              <span style="color: white; margin-right: 15px;">Chào, {{ currentUser.username }}</span>
              <button @click="handleLogout" style="background: none; border: 1px solid white; color: white; padding: 2px 8px; border-radius: 4px; cursor: pointer;">Thoát</button>
            </template>
            <template v-else>
              <router-link to="/login">Đăng nhập</router-link>
              <router-link to="/register">Đăng ký</router-link>
            </template>
            <div class="btn-search">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
              <span>Tìm kiếm</span>
            </div>
          </div>
        </div>
      </div>
    </header>

    <main class="container">
      <div class="banner-box" style="margin-top: 1rem;">
        <img src="/675456323_122106804740812631_4737388993277477397_n.jpg" alt="HTXHS Banner">
      </div>

      <div class="home-action-bar container" style="display: flex; justify-content: space-between; align-items: center; padding: 1rem 0;">
        <div class="forum-slogan" style="font-weight: bold; color: #1a507a; font-size: 1.1rem;">
          HỢP TÁC XÃ HÓA SINH
        </div>
        <div v-if="isLoggedIn" class="user-actions">
          <button @click="openPostModal" class="btn-post-thread">Đăng bài...</button>
        </div>
      </div>

      <div class="main-wrapper">
        <div class="content-left">
          <ForumHome />
        </div>
        
        <aside class="content-right">
          <div class="card">
            <div class="card-header">Con sò mới</div>
            <div class="card-body" style="padding: 1rem;">
              <p style="font-size: 0.9rem; color: #666;">Danh sách bài viết mới...</p>
            </div>
          </div>
          <div class="card">
            <div class="card-header">Thống kê</div>
            <div class="card-body" style="padding: 1rem;">
              <p>Chủ đề: 226,842</p>
            </div>
          </div>
        </aside>
      </div>
    </main>
  </div>
</template>

<script>
import ForumHome from '@/shared/components/ForumHome.vue'
import api from '@/shared/services/api.service'

export default {
  name: 'HomeView',
  components: {
    ForumHome
  },
  data() {
    return {
      menus: [],
      isLoggedIn: false,
      currentUser: null,
      categories: []
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
        { id: 1, title: 'Trang nhất', url: '/' },
        { id: 2, title: 'Lều báo', url: '#' },
        { id: 3, title: 'Quán con sò say', url: '#' }
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
    },
    async openPostModal() {
      const response = await api.get('/categories')
      this.categories = response.data
    }
  }
}
</script>
