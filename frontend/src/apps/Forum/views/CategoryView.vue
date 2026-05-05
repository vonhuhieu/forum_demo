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

          <div class="pagination-wrapper" style="padding: 1rem; border-top: 1px solid #eee;">
            <ForumPagination 
              :current-page="currentPage" 
              :total-pages="totalPages" 
              @page-changed="currentPage = $event"
            />
          </div>

          <!-- Sub-categories block (New) -->
          <div v-if="category && category.subCategories && category.subCategories.length > 0" class="sub-categories-block">
            <div class="sub-cat-grid">
              <router-link v-for="sub in category.subCategories" :key="sub.id" 
                :to="{ name: 'CategoryDetail', params: { id: sub.id } }" class="sub-cat-item">
                <span class="sub-cat-icon">📁</span>
                <span class="sub-cat-name">{{ sub.name }}</span>
              </router-link>
            </div>
          </div>
          
          <div class="thread-list">
            <div v-for="thread in paginatedThreads" :key="thread.id" class="thread-row">
              <div class="thread-avatar" :style="{ backgroundColor: thread.author && thread.author.avatar ? thread.author.avatar : '#ccc', color: '#fff' }">
                {{ thread.author ? thread.author.username.charAt(0).toUpperCase() : 'A' }}
              </div>
              <div class="thread-main">
                <div class="thread-title">
                  <span v-if="thread.pinned" class="badge-pinned">GHIM</span>
                  <span v-if="thread.label" class="label-tag" :style="{ backgroundColor: thread.label.colorCode, color: thread.label.textColor, borderColor: thread.label.borderColor || 'transparent' }">
                    {{ thread.label.name }}
                  </span>
                  <router-link :to="{ name: 'ThreadDetail', params: { id: thread.id } }">{{ thread.title }}</router-link>
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
                  <span class="stat-value">{{ thread.replyCount || 0 }}</span>
                </div>
                <div class="stat-block">
                  <span class="stat-label">Xem:</span>
                  <span class="stat-value">{{ thread.viewCount || 0 }}</span>
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
import { formatForumDate } from '@/shared/utils/date'

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
      categoryGroup: null,
      threads: [],
      loading: true,
      currentPage: 1,
      itemsPerPage: 10
    }
  },
  computed: {
    breadcrumbItems() {
      const items = [{ title: 'Trang chủ', to: { name: 'Home' } }]
      
      if (this.categoryGroup) {
        items.push({ 
          title: this.categoryGroup.name, 
          to: { name: 'Home', hash: `#group-${this.categoryGroup.id}` } 
        })
      }
      
      items.push({ title: this.category ? this.category.name : 'Chuyên mục' })
      return items
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
        const [catRes, groupRes] = await Promise.all([
          api.get('/categories'),
          api.get('/category-groups')
        ])
        
        const categories = catRes.data
        this.category = categories.find(c => c.id == categoryId)

        if (this.category && this.category.categoryGroupId) {
          this.categoryGroup = groupRes.data.find(g => g.id === this.category.categoryGroupId)
        }

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

.sub-categories-block {
  padding: 1rem;
  background-color: #f8f9fa;
  border-bottom: 1px solid #eee;
}

.sub-cat-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 10px;
}

.sub-cat-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 15px;
  background: white;
  border: 1px solid #dee2e6;
  border-radius: 4px;
  text-decoration: none;
  color: #1a507a;
  font-weight: 500;
  transition: all 0.2s;
}

.sub-cat-item:hover {
  border-color: #1a507a;
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
  transform: translateY(-2px);
}

.sub-cat-icon {
  font-size: 1.2rem;
  color: #f39c12;
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

.thread-title {
  margin-bottom: 4px;
  display: block;
}

.thread-title a {
  text-decoration: none;
  color: #1a507a;
  font-weight: 500;
  font-size: 1.05rem;
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
