<template>
  <div class="forum-home">
    <div v-for="cat in categories" :key="cat.id" class="card" style="margin-bottom: 2rem;">
      <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
        <span>{{ cat.name }}</span>
        <span style="font-size: 0.8rem; font-weight: normal; opacity: 0.8;">{{ cat.description }}</span>
      </div>
      
      <div class="thread-list">
        <div v-for="thread in threadsByCategory[cat.id]" :key="thread.id" class="thread-row">
          <div class="thread-avatar">
            {{ thread.author ? thread.author.username.charAt(0).toUpperCase() : 'A' }}
          </div>
          <div class="thread-main">
            <div class="thread-title">
              <span v-if="thread.pinned" class="badge-pinned">Ghim</span>
              <router-link :to="'/thread/' + thread.id">{{ thread.title }}</router-link>
            </div>
            <div class="thread-meta">
              <span>{{ thread.author ? thread.author.username : 'Ẩn danh' }}</span>
              <span class="dot">·</span>
              <span>{{ formatDate(thread.createdAt) }}</span>
              <span class="dot">·</span>
              <span class="forum-tag">{{ cat.name }}</span>
            </div>
          </div>
          <div class="thread-stats">
            <div class="stat-item">
              <span class="stat-value">{{ thread.replyCount }}</span>
              <span class="stat-label">Trả lời</span>
            </div>
            <div class="stat-item">
              <span class="stat-value">{{ thread.viewCount }}</span>
              <span class="stat-label">Xem</span>
            </div>
          </div>
        </div>

        <div v-if="!threadsByCategory[cat.id] || threadsByCategory[cat.id].length === 0"
          style="padding: 2rem; text-align: center; color: #999;">
          Chưa có bài viết nào trong mục này.
        </div>
      </div>
      
      <div style="padding: 1rem; text-align: center;">
        <button style="background: #1a507a; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer;">Xem thêm...</button>
      </div>
    </div>
  </div>
</template>

<script>
import api from '@/shared/services/api.service'

export default {
  name: 'ForumHome',
  data() {
    return {
      categories: [],
      threadsByCategory: {}
    }
  },
  async mounted() {
    try {
      const response = await api.get('/categories')
      this.categories = response.data
      this.categories.forEach(cat => {
        this.fetchThreadsForCategory(cat.id)
      })
    } catch (error) {
      console.error('Lỗi khi tải chuyên mục:', error)
    }
  },
  methods: {
    async fetchThreadsForCategory(catId) {
      try {
        const response = await api.get('/threads', { params: { categoryId: catId } })
        this.threadsByCategory = { ...this.threadsByCategory, [catId]: response.data }
      } catch (error) {
        console.error(`Lỗi khi tải bài viết cho chuyên mục ${catId}:`, error)
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
.thread-title-wrapper {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 4px;
}
</style>
