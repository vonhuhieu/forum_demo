<template>
  <div class="app-wrapper">
    <ForumHeader @logout="checkAuth" />

    <main class="container">
      <div class="banner-box" style="margin-top: 1rem;">
        <img src="/675456323_122106804740812631_4737388993277477397_n.jpg" alt="HTXHS Banner">
      </div>

      <div class="home-action-bar container" style="display: flex; justify-content: space-between; align-items: center; padding: 1rem 0;">
        <div class="forum-slogan" style="font-weight: bold; color: #1a507a; font-size: 1.1rem;">
          HỢP TÁC XÃ SINH LÝ
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
import ForumHeader from '@/shared/components/ForumHeader.vue'
import ForumHome from '@/shared/components/ForumHome.vue'
import api from '@/shared/services/api.service'

export default {
  name: 'HomeView',
  components: {
    ForumHeader,
    ForumHome
  },
  data() {
    return {
      isLoggedIn: false,
      currentUser: null,
      categories: []
    }
  },
  mounted() {
    this.checkAuth()
  },
  methods: {
    checkAuth() {
      const user = localStorage.getItem('user')
      if (user) {
        this.isLoggedIn = true
        this.currentUser = JSON.parse(user)
      } else {
        this.isLoggedIn = false
        this.currentUser = null
      }
    },
    async openPostModal() {
      const response = await api.get('/categories')
      this.categories = response.data
    }
  }
}
</script>
