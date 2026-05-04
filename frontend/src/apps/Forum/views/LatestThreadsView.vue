<template>
  <div class="latest-threads-page app-wrapper">
    <ForumHeader />

    <main class="container" style="padding-top: 2rem;">
      <div v-if="loading" style="text-align: center; padding: 3rem;">Đang tải...</div>
      
      <div v-else>
        <!-- Block 1: Breadcrumb -->
        <Breadcrumb :items="breadcrumbItems" />

        <!-- Block 2: Danh sách bài viết mới nhất -->
        <div class="card" style="margin-bottom: 2rem;">
          <div class="card-header">
            <span>Mới ra lò - Danh sách bài viết mới nhất</span>
          </div>
          
          <div class="thread-list">
            <div v-for="thread in paginatedThreads" :key="thread.id" class="thread-row">
              <div class="thread-avatar">
                {{ thread.author ? thread.author.username.charAt(0).toUpperCase() : 'A' }}
              </div>
              <div class="thread-main">
                <div class="thread-title">
                  <span v-if="thread.pinned" class="badge-pinned">GHIM</span>
                  <router-link :to="{ name: 'ThreadDetail', params: { id: thread.id } }">{{ thread.title }}</router-link>
                </div>
                <div class="thread-meta">
                  <span class="author-name">{{ thread.author ? thread.author.username : 'Ẩn danh' }}</span>
                  <span>{{ formatDate(thread.createdAt) }}</span>
                  <span class="dot" v-if="thread.label">•</span>
                  <span v-if="thread.label" class="label-tag" :style="{ backgroundColor: thread.label.colorCode, color: thread.label.textColor, borderColor: thread.label.borderColor || 'transparent' }">
                    {{ thread.label.name }}
                  </span>
                </div>
              </div>
              <div class="thread-stats">
                <div class="stat-block">
                  <span class="stat-label">Trả lời:</span>
                  <span class="stat-value">{{ thread.replyCount || 0 }}</span>
                </div>
                <div class="stat-block">
                  <span class="stat-label">Xem:</span>
                  <span class="stat-value">{{ thread.viewCount || 0 }}</span>
                </div>
              </div>
              <div class="thread-last-post">
                <span class="last-post-time">{{ formatDate(thread.createdAt) }}</span>
                <span class="last-post-author">{{ thread.author ? thread.author.username : 'Ẩn danh' }}</span>
              </div>
            </div>

            <div v-if="!threads || threads.length === 0"
              style="padding: 2rem; text-align: center; color: #999;">
              Chưa có bài viết nào.
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
import { formatForumDate } from '@/shared/utils/date'

export default {
  name: 'LatestThreadsView',
  components: {
    ForumHeader,
    Breadcrumb,
    ForumPagination
  },
  data() {
    return {
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
        { title: 'Mới ra lò' }
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
      try {
        const res = await api.get('/threads') // Fetch all threads ordered by date
        this.threads = res.data || []
      } catch (error) {
        console.error('Lỗi khi tải dữ liệu bài viết mới nhất:', error)
      } finally {
        this.loading = false
      }
    },
    formatDate(dateStr) {
      return formatForumDate(dateStr)
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
.label-tag {
  padding: 2px 6px;
  font-size: 0.75rem;
  border-radius: 3px;
  font-weight: 600;
  display: inline-block;
  border: 1px solid transparent;
}
</style>
