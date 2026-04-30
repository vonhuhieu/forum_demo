<template>
  <div class="category-page app-wrapper">
    <ForumHeader />

    <main class="container" style="padding-top: 2rem;">
      <div v-if="loading" style="text-align: center; padding: 3rem;">Đang tải...</div>
      
      <div v-else>
        <!-- Block 1: Breadcrumb -->
        <Breadcrumb :items="breadcrumbItems" />

        <!-- Block 2: Danh sách bài viết -->
        <div class="card" style="margin-bottom: 2rem;">
          <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
            <span>{{ category ? category.name : 'Chuyên mục' }}</span>
            <span v-if="category" style="font-size: 0.8rem; font-weight: normal; opacity: 0.8;">{{ category.description }}</span>
          </div>
          
          <div class="thread-list">
            <div v-for="thread in paginatedThreads" :key="thread.id" class="thread-row">
              <div class="thread-avatar">
                {{ thread.author ? thread.author.username.charAt(0).toUpperCase() : 'A' }}
              </div>
              <div class="thread-main">
                <div class="thread-title">
                  <span v-if="thread.pinned" class="badge-pinned">Ghim</span>
                  <router-link :to="{ name: 'ThreadDetail', params: { id: thread.id } }">{{ thread.title }}</router-link>
                </div>
                <div class="thread-meta">
                  <span>{{ thread.author ? thread.author.username : 'Ẩn danh' }}</span>
                  <span class="dot">·</span>
                  <span>{{ formatDate(thread.createdAt) }}</span>
                </div>
              </div>
              <div class="thread-stats">
                <div class="stat-item">
                  <span class="stat-value">{{ thread.replyCount || 0 }}</span>
                  <span class="stat-label">Trả lời</span>
                </div>
                <div class="stat-item">
                  <span class="stat-value">{{ thread.viewCount || 0 }}</span>
                  <span class="stat-label">Xem</span>
                </div>
              </div>
            </div>

            <div v-if="!threads || threads.length === 0"
              style="padding: 2rem; text-align: center; color: #999;">
              Chưa có bài viết nào trong mục này.
            </div>
          </div>
          
          <!-- Phân trang -->
          <div class="pagination-wrapper" style="padding: 1rem; border-top: 1px solid #eee;">
            <ForumPagination 
              :current-page="currentPage" 
              :total-pages="totalPages" 
              @page-changed="currentPage = $event"
            />
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script>
import api from '@/shared/services/api.service'
import ForumHeader from '@/shared/components/ForumHeader.vue'
import Breadcrumb from '@/shared/components/Breadcrumb.vue'
import ForumPagination from '@/shared/components/ForumPagination.vue'

export default {
  name: 'CategoryView',
  components: {
    ForumHeader,
    Breadcrumb,
    ForumPagination
  },
  data() {
    return {
      category: null,
      threads: [],
      loading: true,
      currentPage: 1,
      itemsPerPage: 10
    }
  },
  computed: {
    breadcrumbItems() {
      return [
        { title: 'Trang chủ', to: { name: 'Home' } },
        { title: this.category ? this.category.name : 'Chuyên mục' }
      ]
    },
    totalPages() {
      return Math.ceil(this.threads.length / this.itemsPerPage) || 1
    },
    paginatedThreads() {
      const start = (this.currentPage - 1) * this.itemsPerPage
      const end = start + this.itemsPerPage
      return this.threads.slice(start, end)
    }
  },
  async mounted() {
    await this.fetchData()
  },
  methods: {
    async fetchData() {
      this.loading = true
      const categoryId = this.$route.params.id
      try {
        // Fetch tất cả chuyên mục để tìm tên chuyên mục hiện tại
        const catRes = await api.get('/categories')
        const categories = catRes.data
        this.category = categories.find(c => c.id == categoryId)

        // Fetch danh sách bài viết
        const threadRes = await api.get('/threads', { params: { categoryId } })
        this.threads = threadRes.data
      } catch (error) {
        console.error('Lỗi khi tải dữ liệu chuyên mục:', error)
      } finally {
        this.loading = false
      }
    },
    formatDate(dateStr) {
      if (!dateStr) return ''
      return new Date(dateStr).toLocaleDateString('vi-VN')
    }
  }
}
</script>

<style scoped>
.pagination-wrapper {
  display: flex;
  justify-content: flex-start;
  align-items: center;
}
</style>
