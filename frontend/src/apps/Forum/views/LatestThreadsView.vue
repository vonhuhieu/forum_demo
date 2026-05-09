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
          <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
            <span>Mới ra lò - Danh sách bài viết mới nhất</span>
            <button v-if="isLoggedIn" class="btn-post-thread" @click="openPostModal">Đăng bài...</button>
          </div>

          <div class="pagination-wrapper" style="padding: 1rem; border-top: 1px solid #eee;">
            <ForumPagination 
              :current-page="currentPage" 
              :total-pages="totalPages" 
              @page-changed="currentPage = $event"
            />
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

        <Breadcrumb :items="breadcrumbItems" />
      </div>
    </main>

    <!-- Modal chọn chuyên mục -->
    <div v-if="showModal" class="modal-overlay" @click.self="showModal = false">
      <div class="modal-card" style="width: 750px; max-width: 95vw; background: #f5f8fa; padding: 0; border-radius: 6px; overflow: hidden;">
        <div class="card-header" style="display: flex; justify-content: space-between; align-items: center; background: #e6f2fa; color: #1a507a; padding: 12px 20px; border-bottom: 1px solid #d0e3f0;">
          <span style="font-size: 1.15rem; font-weight: normal;">Đăng bài trong...</span>
          <button @click="showModal = false" style="background: none; border: none; color: #7cb3db; cursor: pointer; font-size: 1.5rem; line-height: 1;">&times;</button>
        </div>
        <div class="modal-body" style="max-height: 70vh; overflow-y: auto; padding: 0;">
          <div v-for="group in activeModalGroups" :key="group.id" class="modal-group" style="margin-bottom: 15px; box-shadow: 0 1px 3px rgba(0,0,0,0.05);">
            <div class="modal-group-header">
              {{ group.name }}
            </div>
            <div class="modal-category-list">
              <template v-for="cat in group.categories.filter(c => !c.parentCategoryId)" :key="cat.id">
                <div class="modal-category-item" @click="selectCategory(cat.id)">
                  <div class="modal-cat-info">
                    <div class="modal-cat-name">{{ cat.name }}</div>
                    <div v-if="cat.description" class="modal-cat-desc">{{ cat.description }}</div>
                  </div>
                  <div class="modal-cat-stats">
                    <div class="modal-stat-label">Chủ đề</div>
                    <div class="modal-stat-value">{{ formatNumber(cat.threadCount || 0) }}</div>
                  </div>
                </div>
                <div v-for="sub in (cat.subCategories && cat.subCategories.length ? cat.subCategories : group.categories.filter(c => c.parentCategoryId === cat.id))" :key="'sub-' + sub.id" class="modal-category-item modal-sub-category" @click="selectCategory(sub.id)">
                  <div class="modal-cat-info" style="padding-left: 30px; position: relative;">
                    <div style="position: absolute; left: 10px; top: 12px; width: 15px; height: 15px; border-left: 2px solid #d0e3f0; border-bottom: 2px solid #d0e3f0; border-bottom-left-radius: 4px;"></div>
                    <div class="modal-cat-name" style="font-size: 0.95rem;">{{ sub.name }}</div>
                    <div v-if="sub.description" class="modal-cat-desc">{{ sub.description }}</div>
                  </div>
                  <div class="modal-cat-stats">
                    <div class="modal-stat-label">Chủ đề</div>
                    <div class="modal-stat-value">{{ formatNumber(sub.threadCount || 0) }}</div>
                  </div>
                </div>
              </template>
            </div>
          </div>
        </div>
      </div>
    </div>
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
      itemsPerPage: 10,
      isLoggedIn: false,
      showModal: false,
      categoryGroupsModal: []
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
    },
    activeModalGroups() {
      if (!this.categoryGroupsModal || !Array.isArray(this.categoryGroupsModal)) return []
      return this.categoryGroupsModal.filter(g => g.active && g.categories && g.categories.length > 0)
    }
  },
  async mounted() {
    this.checkAuth()
    await this.fetchData()
  },
  methods: {
    checkAuth() {
      const user = localStorage.getItem('user')
      this.isLoggedIn = !!user
    },
    async openPostModal() {
      try {
        const response = await api.get('/category-groups')
        this.categoryGroupsModal = response.data
        this.showModal = true
      } catch (error) {
        console.error('Lỗi khi tải nhóm chuyên mục:', error)
      }
    },
    selectCategory(catId) {
      this.showModal = false
      this.$router.push({ name: 'CreateThread', query: { catId } })
    },
    formatNumber(num) {
      if (!num) return 0
      return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
    },
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

/* Modal Post Styles */
.modal-overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.5); display: flex; align-items: center; justify-content: center; z-index: 1000; }
.modal-group { margin-bottom: 5px; }
.modal-group-header { background: #f0f7fb; color: #3498db; padding: 8px 20px; font-weight: 600; font-size: 0.95rem; border-bottom: 1px solid #e1eef7; }
.modal-category-list { background: #ffffff; }
.modal-category-item { display: flex; justify-content: space-between; align-items: center; padding: 12px 20px; border-bottom: 1px solid #f0f0f0; cursor: pointer; transition: background 0.2s; }
.modal-category-item:hover { background: #f9fbfc; }
.modal-category-item:last-child { border-bottom: none; }
.modal-cat-name { color: #3498db; font-size: 1.05rem; font-weight: 500; }
.modal-category-item:hover .modal-cat-name { text-decoration: underline; }
.modal-cat-desc { font-size: 0.8rem; color: #888; margin-top: 3px; }
.modal-cat-stats { text-align: right; color: #666; min-width: 60px; }
.modal-stat-label { font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.5px; color: #999; }
.modal-stat-value { font-size: 0.95rem; font-weight: 500; margin-top: 2px; }
</style>
