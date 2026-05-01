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
            <div class="card-header section-header">
              <a @click="$router.push({ name: 'LatestThreads' })" class="header-link">Con sò mới</a>
            </div>
            <div class="card-body" style="padding: 0;">
              <div v-if="loadingLatest" style="padding: 1rem; text-align: center; color: #666; font-size: 0.9rem;">
                Đang tải...
              </div>
              <div v-else class="latest-threads-list">
                <div v-for="thread in latestThreads" :key="thread.id" class="latest-thread-item">
                  <div class="lt-avatar">
                    <span v-if="!thread.author?.avatarUrl">{{ thread.author ? thread.author.username.charAt(0).toUpperCase() : 'A' }}</span>
                    <img v-else :src="thread.author.avatarUrl" alt="Avatar" />
                  </div>
                  <div class="lt-content">
                    <div class="lt-title">
                      <router-link :to="{ name: 'ThreadDetail', params: { id: thread.id } }" :title="thread.title">{{ thread.title }}</router-link>
                    </div>
                    <div class="lt-meta">
                      Mới nhất: {{ thread.author ? thread.author.username : 'Ẩn danh' }} &middot; {{ formatDate(thread.createdAt) }}
                    </div>
                    <div class="lt-category">
                      <router-link :to="{ name: 'CategoryDetail', params: { id: thread.category?.id } }">{{ thread.category?.name || 'Không rõ' }}</router-link>
                    </div>
                  </div>
                </div>
                <div v-if="latestThreads.length === 0" style="padding: 1rem; text-align: center; color: #999; font-size: 0.9rem;">
                  Chưa có bài viết nào.
                </div>
              </div>
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
          <div class="banner-right" style="margin-top: 1rem;">
            <img src="/banner_block_phai.jpg" alt="Banner" style="width: 100%; border-radius: 4px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);" />
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
import { formatForumDate } from '@/shared/utils/date'

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
      latestThreads: [],
      loadingLatest: false,
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
    this.fetchLatestThreads()
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
    },
    async fetchLatestThreads() {
      this.loadingLatest = true
      try {
        const response = await api.get('/threads')
        if (response.data) {
          this.latestThreads = response.data.slice(0, 15)
        }
      } catch (error) {
        console.error('Lỗi khi tải bài viết mới nhất:', error)
      } finally {
        this.loadingLatest = false
      }
    },
    formatDate(dateStr) {
      return formatForumDate(dateStr)
    }
  }
}
</script>

<style scoped>
.header-link {
  cursor: pointer;
  text-decoration: none;
  color: inherit;
  transition: all 0.2s;
}
.header-link:hover {
  text-decoration: underline;
}

.latest-threads-list {
  display: flex;
  flex-direction: column;
}

.latest-thread-item {
  display: flex;
  padding: 12px 16px;
  border-bottom: 1px solid #f0f0f0;
  transition: background-color 0.2s;
}

.latest-thread-item:last-child {
  border-bottom: none;
}

.latest-thread-item:hover {
  background-color: #f9f9f9;
}

.lt-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: #e0e0e0;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  color: #555;
  margin-right: 12px;
  flex-shrink: 0;
  overflow: hidden;
}

.lt-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.lt-content {
  flex: 1;
  min-width: 0;
}

.lt-title {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  font-weight: 500;
  margin-bottom: 4px;
  font-size: 0.95rem;
}

.lt-title a {
  color: #2c3e50;
  text-decoration: none;
}

.lt-title a:hover {
  color: #1a507a;
  text-decoration: underline;
}

.lt-meta {
  font-size: 0.8rem;
  color: #666;
  margin-bottom: 3px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.lt-category {
  font-size: 0.8rem;
}

.lt-category a {
  color: #999;
  text-decoration: none;
}

.lt-category a:hover {
  color: #1a507a;
  text-decoration: underline;
}
</style>
