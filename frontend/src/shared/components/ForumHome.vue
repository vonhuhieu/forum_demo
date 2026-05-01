<template>
  <div class="forum-home">
    <!-- Anchor Navigation -->
    <div class="anchor-nav">
      <div class="container">
        <a href="#moi-ra-lo" class="anchor-link">Mới ra lò</a>
        <a v-for="group in activeGroups" :key="group.id" :href="'#group-' + group.id" class="anchor-link">
          {{ group.name }}
        </a>
      </div>
    </div>

    <!-- Section 1: Mới ra lò -->
    <section id="moi-ra-lo" class="forum-section card">
      <div class="card-header section-header">
        <span class="header-title">Mới ra lò</span>
      </div>
      
      <div class="thread-list">
        <div v-for="thread in latestThreads" :key="thread.id" class="thread-row">
          <div class="thread-avatar">
            {{ thread.author ? thread.author.username.charAt(0).toUpperCase() : 'A' }}
          </div>
          <div class="thread-main">
            <div class="thread-title-wrapper">
              <span v-if="thread.pinned" class="badge-pinned">GHIM</span>
              <router-link :to="{ name: 'ThreadDetail', params: { id: thread.id } }" class="thread-title">
                {{ thread.title }}
              </router-link>
            </div>
            <div class="thread-meta">
              <span class="author-name">{{ thread.author ? thread.author.username : 'Ẩn danh' }}</span>
              <span class="dot">•</span>
              <span>{{ formatDate(thread.createdAt) }}</span>
              <span class="dot">•</span>
              <router-link :to="{ name: 'CategoryDetail', params: { id: thread.category?.id } }" class="forum-tag">
                {{ thread.category?.name }}
              </router-link>
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
            <span class="last-post-time">{{ formatDate(thread.createdAt) }}</span>
            <span class="last-post-author">{{ thread.author ? thread.author.username : 'Ẩn danh' }}</span>
          </div>
        </div>
      </div>
      
      <div class="card-footer">
        <button class="btn-view-more" @click="$router.push({ name: 'AdminThreads' })">Xem thêm...</button>
      </div>
    </section>

    <!-- Grouped Sections -->
    <section v-for="group in activeGroups" :key="group.id" :id="'group-' + group.id" class="forum-section card">
      <div class="card-header section-header group-header">
        <span class="header-title">{{ group.name }}</span>
      </div>
      
      <div class="category-list">
        <div v-for="cat in group.categories" :key="cat.id" class="category-row">
          <div class="category-icon">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon-msg"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg>
          </div>
          <div class="category-info">
            <router-link :to="{ name: 'CategoryDetail', params: { id: cat.id } }" class="category-name">
              {{ cat.name }}
            </router-link>
            <div v-if="cat.subCategories && cat.subCategories.length > 0" class="sub-categories-trigger">
              Chuyên mục con <span class="arrow">▼</span>
              <div class="sub-categories-dropdown">
                <router-link v-for="sub in cat.subCategories" :key="sub.id" :to="{ name: 'CategoryDetail', params: { id: sub.id } }">
                  {{ sub.name }}
                </router-link>
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
              <router-link :to="{ name: 'ThreadDetail', params: { id: lastThreadByCat[cat.id].id } }" class="last-thread-title">
                {{ lastThreadByCat[cat.id].title }}
              </router-link>
              <div class="last-thread-meta">
                <span>{{ formatDate(lastThreadByCat[cat.id].createdAt) }}</span>
                <span class="dot">•</span>
                <span class="author">{{ lastThreadByCat[cat.id].author?.username }}</span>
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
        this.latestThreads = latestRes.data

        // Fetch Groups with nested categories
        const groupRes = await api.get('/category-groups')
        this.categoryGroups = groupRes.data

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
.anchor-nav {
  background: white;
  border-bottom: 1px solid #dee2e6;
  padding: 10px 0;
  margin-bottom: 1rem;
  position: sticky;
  top: 0;
  z-index: 100;
  box-shadow: 0 2px 4px rgba(0,0,0,0.05);
}

.anchor-link {
  text-decoration: none;
  color: #1a507a;
  font-weight: 500;
  margin-right: 20px;
  font-size: 0.95rem;
  transition: color 0.2s;
}

.anchor-link:hover {
  color: #f39c12;
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

.header-title {
  font-size: 1.1rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.5px;
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
  width: 250px;
  padding-left: 15px;
  border-left: 1px solid #eee;
}

.last-thread-title {
  display: block;
  font-size: 0.9rem;
  font-weight: 500;
  color: #1a507a;
  text-decoration: none;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.last-thread-meta {
  font-size: 0.8rem;
  color: #888;
}

.sub-categories-trigger {
  font-size: 0.8rem;
  color: #888;
  cursor: pointer;
  position: relative;
  display: inline-block;
  margin-top: 4px;
}

.sub-categories-trigger:hover .sub-categories-dropdown {
  display: block;
}

.sub-categories-dropdown {
  display: none;
  position: absolute;
  top: 100%;
  left: 0;
  background: white;
  border: 1px solid #ddd;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  min-width: 200px;
  z-index: 10;
  border-radius: 4px;
  padding: 5px 0;
}

.sub-categories-dropdown a {
  display: block;
  padding: 8px 15px;
  color: #333;
  text-decoration: none;
}

.sub-categories-dropdown a:hover {
  background: #f8f9fa;
  color: #1a507a;
}
</style>
