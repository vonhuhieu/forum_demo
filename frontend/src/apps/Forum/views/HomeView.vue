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
            <div class="card-header">Thống kê diễn đàn</div>
            <div class="card-body" style="padding: 1rem;">
              <div class="stat-item" style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                <span>Chuyên mục:</span>
                <strong>{{ formatNumber(stats.totalCategories) }}</strong>
              </div>
              <div class="stat-item" style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                <span>Bài viết:</span>
                <strong>{{ formatNumber(stats.totalPosts) }}</strong>
              </div>
              <div class="stat-item" style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                <span>Thành viên:</span>
                <strong>{{ formatNumber(stats.totalMembers) }}</strong>
              </div>
              <div class="stat-item" style="display: flex; justify-content: space-between;">
                <span>Thành viên mới nhất:</span>
                <strong style="color: #1a507a;">{{ stats.latestMember }}</strong>
              </div>
            </div>
          </div>
        </aside>
      </div>
    </main>

    <!-- Modal chọn chuyên mục -->
    <div v-if="showModal" class="modal-overlay" @click.self="showModal = false">
      <div class="modal-card" style="width: 500px;">
        <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
          <span>CHỌN CHUYÊN MỤC ĐĂNG BÀI</span>
          <button @click="showModal = false" style="background: none; border: none; color: white; cursor: pointer; font-size: 1.2rem;">&times;</button>
        </div>
        <div class="modal-body" style="max-height: 400px; overflow-y: auto;">
          <div 
            v-for="cat in categories" 
            :key="cat.id" 
            class="category-select-item"
            @click="selectCategory(cat.id)"
          >
            <strong>{{ cat.name }}</strong>
            <small style="color: #666;">{{ cat.description }}</small>
          </div>
        </div>
      </div>
    </div>
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
      categories: [],
      showModal: false,
      stats: {
        totalCategories: 0,
        totalThreads: 0,
        totalPosts: 0,
        totalMembers: 0,
        latestMember: ''
      }
    }
  },
  mounted() {
    this.checkAuth()
    this.fetchStatistics()
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
      try {
        const response = await api.get('/categories')
        this.categories = response.data
        this.showModal = true
      } catch (error) {
        console.error('Lỗi khi tải chuyên mục:', error)
      }
    },
    selectCategory(catId) {
      this.showModal = false
      this.$router.push({ name: 'CreateThread', query: { catId } })
    },
    async fetchStatistics() {
      try {
        const response = await api.get('/statistics')
        if (response.data) {
          this.stats = response.data
        }
      } catch (error) {
        console.error('Lỗi khi tải thống kê:', error)
      }
    },
    formatNumber(num) {
      if (!num) return 0
      return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
    }
  }
}
</script>
