<template>
  <div class="forum-home">
    <!-- Section 1: Mới ra lò -->
    <section id="moi-ra-lo" class="forum-section card">
      <div class="card-header section-header">
        <a @click="$router.push({ name: 'LatestThreads' })" class="header-link">Mới ra lò</a>
      </div>
      
      <div class="thread-list">
        <div v-for="thread in latestThreads" :key="thread.id" class="thread-row">
          <div class="thread-avatar" :style="{ backgroundColor: thread.author && thread.author.avatar ? thread.author.avatar : '#ccc', color: '#fff' }">
            {{ thread.author ? thread.author.username.charAt(0).toUpperCase() : 'A' }}
          </div>
          <div class="thread-main">
            <div class="thread-title-wrapper">
              <span v-if="thread.pinned" class="badge-pinned">GHIM</span>
              <span v-if="thread.label" class="label-tag" :style="{ backgroundColor: thread.label.colorCode, color: thread.label.textColor, borderColor: thread.label.borderColor || 'transparent' }">
                {{ thread.label.name }}
              </span>
              <router-link :to="{ name: 'ThreadDetail', params: { id: thread.id } }" class="thread-title">
                {{ thread.title }}
              </router-link>
            </div>
            <div class="thread-meta">
              <span class="author-name">{{ thread.author ? thread.author.username : 'Ẩn danh' }}</span>
              <span>{{ formatDate(thread.createdAt) }}</span>
              <span class="meta-category">{{ thread.category ? thread.category.name : 'N/A' }}</span>
            </div>
          </div>
          <div class="thread-stats">
            <div class="stat-block">
              <span class="stat-label">Trả lời:</span>
              <span class="stat-value">{{ formatNumber(thread.replyCount) }}</span>
            </div>
            <div class="stat-block">
              <span class="stat-label">Xem:</span>
              <span class="stat-value">{{ formatNumber(thread.viewCount) }}</span>
            </div>
          </div>
          <div class="thread-last-post">
            <div class="last-post-info">
              <span class="last-post-time">{{ formatDate(thread.createdAt) }}</span>
              <span class="last-post-author">{{ thread.author ? thread.author.username : 'Ẩn danh' }}</span>
            </div>
            <div class="last-post-avatar" :style="{ backgroundColor: thread.author && thread.author.avatar ? thread.author.avatar : '#ccc', color: '#fff' }">
              {{ thread.author ? thread.author.username.charAt(0).toUpperCase() : 'A' }}
            </div>
          </div>
        </div>
      </div>
      
      <div class="card-footer">
        <button class="btn-view-more" @click="$router.push({ name: 'LatestThreads' })">Xem thêm...</button>
      </div>
    </section>

    <!-- Grouped Sections -->
    <section v-for="group in activeGroups" :key="group.id" :id="'group-' + group.id" class="forum-section card">
      <div class="card-header section-header group-header">
        <a :href="'#group-' + group.id" class="header-link">{{ group.name }}</a>
      </div>
      
      <div class="category-list">
        <div v-for="cat in group.categories.filter(c => !c.parentCategoryId)" :key="cat.id" class="category-row">
          <div class="category-icon">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon-msg"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg>
          </div>
          <div class="category-info">
            <div class="cat-name-row">
              <router-link :to="{ name: 'CategoryDetail', params: { id: cat.id } }" class="category-name">
                {{ cat.name }}
              </router-link>
            </div>
            
            <div v-if="cat.subCategories && cat.subCategories.length > 0" class="sub-categories-trigger">
              <span class="sub-trigger-text">Chuyên mục con</span>
              <span class="arrow">▼</span>
              
              <div class="sub-categories-dropdown">
                <div class="dropdown-arrow-up"></div>
                <div class="dropdown-header">Chuyên mục con</div>
                <div class="dropdown-body">
                  <router-link v-for="sub in cat.subCategories" :key="sub.id" :to="{ name: 'CategoryDetail', params: { id: sub.id } }" class="sub-item">
                    <span class="sub-icon">💬</span>
                    {{ sub.name }}
                  </router-link>
                </div>
              </div>
            </div>
          </div>
          <div class="category-stats">
            <div class="stat-item">
              <span class="stat-label">Chủ đề</span>
              <span class="stat-value">{{ formatNumber(cat.threadCount || 0) }}</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">Bài viết</span>
              <span class="stat-value">{{ formatNumber(cat.postCount || 0) }}</span>
            </div>
          </div>
          <div class="category-last-thread">
            <div v-if="lastThreadByCat[cat.id]" class="last-thread-box">
              <div class="last-thread-avatar" :style="{ backgroundColor: lastThreadByCat[cat.id].author && lastThreadByCat[cat.id].author.avatar ? lastThreadByCat[cat.id].author.avatar : '#ccc', color: '#fff' }">
                {{ lastThreadByCat[cat.id].author?.username?.charAt(0).toUpperCase() || 'A' }}
              </div>
              <div class="last-thread-info">
                <router-link :to="{ name: 'ThreadDetail', params: { id: lastThreadByCat[cat.id].id } }" class="last-thread-title">
                  {{ lastThreadByCat[cat.id].title }}
                </router-link>
                <div class="last-thread-meta">
                  <span>{{ formatDate(lastThreadByCat[cat.id].createdAt) }}</span>
                  <span class="dot">•</span>
                  <span class="author">{{ lastThreadByCat[cat.id].author?.username }}</span>
                </div>
              </div>
            </div>
            <div v-else class="no-thread">Chưa có bài viết</div>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
import api from '@/shared/services/api.service'
import { formatForumDate } from '@/shared/utils/date'

export default {
  name: 'ForumHome',
  data() {
    return {
      categoryGroups: [],
      latestThreads: [],
      lastThreadByCat: {},
      loading: true
    }
  },
  computed: {
    activeGroups() {
      if (!this.categoryGroups || !Array.isArray(this.categoryGroups)) return []
      return this.categoryGroups.filter(g => g.active && g.categories && g.categories.length > 0)
    }
  },
  async mounted() {
    await this.fetchData()
  },
  methods: {
    async fetchData() {
      this.loading = true
      try {
        // Fetch Mới ra lò
        const latestRes = await api.get('/threads/latest')
        this.latestThreads = latestRes.data || []

        // Fetch Groups with nested categories
        const groupRes = await api.get('/category-groups')
        this.categoryGroups = groupRes.data || []

        // Fetch last thread for each category (this could be optimized in backend)
        for (const group of this.categoryGroups) {
          for (const cat of group.categories) {
            this.fetchLastThread(cat.id)
          }
        }
      } catch (error) {
        console.error('Lỗi khi tải dữ liệu trang chủ:', error)
      } finally {
        this.loading = false
      }
    },
    async fetchLastThread(catId) {
      try {
        const res = await api.get('/threads', { params: { categoryId: catId, limit: 1 } })
        if (res.data && res.data.length > 0) {
          this.lastThreadByCat = { ...this.lastThreadByCat, [catId]: res.data[0] }
        }
      } catch (e) {
        console.error(e)
      }
    },
    formatDate(dateStr) {
      return formatForumDate(dateStr)
    },
    formatNumber(num) {
      if (!num) return 0
      if (num >= 1000000) return (num / 1000000).toFixed(1) + 'M'
      if (num >= 1000) return (num / 1000).toFixed(1) + 'K'
      return num
    }
  }
}
</script>

<style scoped>
.header-link {
  font-size: 1.1rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  text-decoration: none;
  color: #1a507a;
  cursor: pointer;
  display: inline-block;
}

.header-link:hover {
  text-decoration: underline;
}

.section-header {
  background: #f8f9fa;
  border-bottom: 1px solid #dee2e6;
  color: #1a507a;
  padding: 10px 15px;
}

.group-header {
  background: #ebf2f7;
}

.card-footer {
  padding: 10px;
  text-align: center;
  border-top: 1px solid #eee;
}

.btn-view-more {
  background: #1a507a;
  color: white;
  border: none;
  padding: 6px 15px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 0.9rem;
}

/* Category Row Styles */
.category-row {
  display: flex;
  padding: 12px 15px;
  border-bottom: 1px solid #f0f2f5;
  align-items: center;
}

.category-icon {
  width: 40px;
  color: #f39c12;
  display: flex;
  align-items: center;
}

.category-info {
  flex: 1;
  min-width: 0;
}

.category-name {
  font-weight: 600;
  color: #1a507a;
  text-decoration: none;
  font-size: 1.05rem;
}

.category-name:hover {
  text-decoration: underline;
}

.category-stats {
  display: flex;
  width: 150px;
  text-align: center;
  gap: 15px;
}

.stat-item {
  display: flex;
  flex-direction: column;
}

.category-last-thread {
  width: 320px;
  padding-left: 15px;
  border-left: 1px solid #eee;
}

.last-thread-box {
  display: flex;
  align-items: center;
  gap: 12px;
}

.last-thread-avatar {
  width: 36px;
  height: 36px;
  background: #5c6bc0;
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
  font-size: 1rem;
  flex-shrink: 0;
}

.last-thread-info {
  flex: 1;
  min-width: 0;
}

.last-thread-title {
  display: block;
  font-size: 0.95rem;
  font-weight: 500;
  color: #1a507a;
  text-decoration: none;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  margin-bottom: 2px;
}

.last-thread-meta {
  font-size: 0.8rem;
  color: #888;
}

.sub-categories-trigger {
  font-size: 0.85rem;
  color: #999;
  cursor: pointer;
  position: relative;
  display: inline-flex;
  align-items: center;
  gap: 4px;
  margin-top: 2px;
  padding: 2px 4px;
  transition: all 0.2s;
}

.sub-trigger-text {
  font-weight: 400;
}

.sub-categories-trigger:hover {
  color: #1a507a;
}

.sub-categories-trigger:hover .sub-categories-dropdown {
  display: block;
}

.sub-categories-dropdown {
  display: none;
  position: absolute;
  top: calc(100% + 8px);
  left: 0;
  background: white;
  border: 1px solid #3498db;
  box-shadow: 0 5px 15px rgba(0,0,0,0.15);
  min-width: 220px;
  z-index: 100;
  border-radius: 4px;
  animation: fadeIn 0.2s ease;
}

/* Cầu nối để không bị mất hover khi di chuột xuống */
.sub-categories-dropdown::before {
  content: '';
  position: absolute;
  top: -15px;
  left: 0;
  right: 0;
  height: 15px;
  background: transparent;
}

.dropdown-arrow-up {
  position: absolute;
  top: -8px;
  left: 20px;
  width: 0;
  height: 0;
  border-left: 8px solid transparent;
  border-right: 8px solid transparent;
  border-bottom: 8px solid #3498db;
}

.dropdown-header {
  background: #ebf5fb;
  padding: 8px 12px;
  color: #2980b9;
  font-size: 0.9rem;
  font-weight: 600;
  border-bottom: 1px solid #d4e6f1;
  border-radius: 4px 4px 0 0;
}

.dropdown-body {
  padding: 5px 0;
}

.sub-item {
  display: flex;
  align-items: center;
  padding: 8px 15px;
  color: #444;
  text-decoration: none;
  font-size: 0.9rem;
  transition: background 0.2s;
  gap: 8px;
}

.sub-item:hover {
  background: #f8f9fa;
  color: #1a507a;
}

.sub-icon {
  font-size: 0.8rem;
  color: #f39c12;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(5px); }
  to { opacity: 1; transform: translateY(0); }
}

.category-name {
  font-weight: 700;
  color: #1a507a;
  text-decoration: none;
  font-size: 1.1rem;
  display: block;
}

.label-tag {
  padding: 2px 6px;
  font-size: 0.75rem;
  border-radius: 3px;
  font-weight: 600;
  display: inline-block;
  border: 1px solid transparent;
  margin-right: 8px;
  white-space: nowrap;
  vertical-align: middle;
  line-height: 1;
}

.thread-title-wrapper {
  margin-bottom: 4px;
  display: block;
}

.thread-title {
  font-weight: 500;
  font-size: 1.05rem;
  color: #1a507a;
  text-decoration: none;
  margin-bottom: 0;
  line-height: 1.5;
  display: inline;
}

.thread-meta {
  font-size: 0.85rem;
  color: #8c8c8c;
  display: flex;
  align-items: center;
  gap: 5px;
}

.meta-category {
  color: #666;
}

.thread-last-post {
  width: 180px;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 10px;
  text-align: right;
}

.last-post-info {
  display: flex;
  flex-direction: column;
}

.last-post-avatar {
  width: 32px;
  height: 32px;
  background-color: #5c6bc0;
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
  font-size: 0.85rem;
  flex-shrink: 0;
  border: 1px solid #dee2e6;
}
</style>
