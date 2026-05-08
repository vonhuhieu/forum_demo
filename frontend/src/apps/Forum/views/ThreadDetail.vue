<template>
  <div class="thread-detail-page app-wrapper" v-if="!loading && thread">
    <ForumHeader />

    <main class="container" style="padding-top: 2rem;">
      <Breadcrumb :items="breadcrumbItems" />

      <div class="thread-header card">
        <div class="thread-title-full">
          <span v-if="thread.label" class="label-tag" :style="{ backgroundColor: thread.label.colorCode, color: thread.label.textColor, borderColor: thread.label.borderColor || 'transparent' }">{{ thread.label.name }}</span>
          <h1>{{ thread.title }}</h1>
        </div>
        <div class="thread-meta-bar">
          <div class="author-info">
            <svg class="meta-icon" xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
            <span class="author-name">{{ thread.author ? thread.author.username : 'Ẩn danh' }}</span>
            <span class="meta-dot">·</span>
            <svg class="meta-icon" xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
            <span class="post-time">{{ formatDate(thread.createdAt) }}</span>
          </div>
        </div>
      </div>

      <!-- Poll Box -->
      <div v-if="thread.poll" class="poll-wrapper">
        <PollDisplay :pollData="thread.poll" @vote-updated="handleVoteUpdated" />
      </div>

      <div class="thread-content-card card">
        <div class="post-layout">
          <div class="post-sidebar">
            <div class="avatar-large" :style="{ backgroundColor: thread.author && thread.author.avatar ? thread.author.avatar : '#ccc', color: '#fff' }">
              {{ thread.author ? thread.author.username.charAt(0).toUpperCase() : 'A' }}
            </div>
            <div class="author-name-large">{{ thread.author ? thread.author.username : 'Ẩn danh' }}</div>
            <div class="author-title">Yếu sinh lý</div>
          </div>
          
          <div class="post-main">
            <div class="post-meta-top">
              <span class="post-time-top">{{ formatDate(thread.createdAt) }}</span>
              <div class="post-actions-top">
                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="18" cy="5" r="3"></circle><circle cx="6" cy="12" r="3"></circle><circle cx="18" cy="19" r="3"></circle><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"></line><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"></line></svg>
                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path></svg>
                <span class="post-number">#1</span>
              </div>
            </div>
            
            <div class="content-body ql-editor" v-html="thread.content" @click="handleContentClick"></div>
            
            <div class="post-meta-bottom">
              <div class="left-actions">
                <a href="#" class="action-link" @click.prevent>Báo cáo</a>
                <a href="#" class="action-link" @click.prevent>Sửa</a>
              </div>
              <div class="right-actions">
                <a href="#" class="action-link reply-link" @click.prevent>
                  <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 17 4 12 9 7"></polyline><path d="M20 18v-2a4 4 0 0 0-4-4H4"></path></svg>
                  Trả lời
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
  
  <div v-else-if="loading" class="container" style="padding: 3rem; text-align: center;">
    Đang tải bài viết...
  </div>

  <!-- Lightbox Modal -->
  <div v-if="showLightbox" class="lightbox-modal" @click="closeLightbox">
    <div class="lightbox-content">
      <button class="btn-close-lightbox" @click="closeLightbox">&times;</button>
      <div class="lightbox-main">
        <div class="lightbox-image-wrapper">
          <img :src="activeImageUrl" class="main-lightbox-img" @click.stop />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import api from '@/shared/services/api.service'
import ForumHeader from '@/shared/components/ForumHeader.vue'
import Breadcrumb from '@/shared/components/Breadcrumb.vue'
import PollDisplay from '@/shared/components/PollDisplay.vue'
import { formatForumDate } from '@/shared/utils/date'

export default {
  name: 'ThreadDetail',
  components: {
    ForumHeader,
    Breadcrumb,
    PollDisplay
  },
  data() {
    return {
      thread: null,
      categoryGroup: null,
      allCategories: [],
      loading: true,
      showLightbox: false,
      activeImageUrl: ''
    }
  },
  computed: {
    breadcrumbItems() {
      const items = [{ title: 'Trang chủ', to: { name: 'Home' } }]
      
      if (this.thread && this.thread.category && this.thread.category.categoryGroupId) {
        if (this.categoryGroup) {
           items.push({ 
             title: this.categoryGroup.name, 
             to: { name: 'Home', hash: `#group-${this.categoryGroup.id}` } 
           })
        }
      }

      if (this.thread && this.thread.category && this.allCategories && this.allCategories.length > 0) {
         let parents = [];
         let currentParentId = this.thread.category.parentCategoryId;
         while (currentParentId) {
             const parent = this.allCategories.find(c => c.id === currentParentId);
             if (parent) {
                 parents.unshift(parent);
                 currentParentId = parent.parentCategoryId;
             } else {
                 break;
             }
         }
         parents.forEach(p => {
             items.push({
                 title: p.name,
                 to: { name: 'CategoryDetail', params: { id: p.id } }
             })
         });
         
         items.push({ 
           title: this.thread.category.name, 
           to: { name: 'CategoryDetail', params: { id: this.thread.category.id } } 
         })
      } else if (this.thread && this.thread.category) {
        items.push({ 
          title: this.thread.category.name, 
          to: { name: 'CategoryDetail', params: { id: this.thread.category.id } } 
        })
      }

      if (this.thread) {
        items.push({ title: this.thread.title })
      }
      return items
    },
    attachedImages() {
      if (this.thread && this.thread.attachedImages) {
        try {
          return JSON.parse(this.thread.attachedImages)
        } catch (e) {
          console.error('Error parsing attached images:', e)
          return []
        }
      }
      return []
    }
  },
  async mounted() {
    await this.fetchThread()
  },
  methods: {
    async fetchThread() {
      try {
        const response = await api.get(`/threads/${this.$route.params.id}`)
        this.thread = response.data
        
        let content = this.thread.content || ''
        
        // Transform <oembed> tags (legacy CKEditor format) to <iframe>
        content = content.replace(/<oembed\s+url="([^"]+)"><\/oembed>/gi, (match, url) => {
          const youtubeRegex = /(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})/i
          const ytMatch = url.match(youtubeRegex)
          if (ytMatch && ytMatch[1]) {
            return `<iframe width="100%" height="450" src="https://www.youtube.com/embed/${ytMatch[1]}" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>`
          }
          
          if (url.match(/\.(mp4|webm|ogg|avi|mov)(\?.*)?$/i)) {
             let fixedUrl = url;
             const uploadsIndex = fixedUrl.indexOf('/uploads/');
             if (uploadsIndex !== -1) {
                 fixedUrl = fixedUrl.substring(uploadsIndex);
             }
             return `<figure class="media"><video controls style="width: 100%; max-height: 500px; object-fit: contain; background: #000;" src="${fixedUrl}"></video></figure>`
          }

          return `<a href="${url}" target="_blank">${url}</a>`
        })

        this.thread = { ...response.data, content }

        // Fetch Group Name
        if (this.thread.category && this.thread.category.categoryGroupId) {
          try {
            const [catRes, groupRes] = await Promise.all([
               api.get('/categories'),
               api.get('/category-groups')
            ])
            this.allCategories = catRes.data
            this.categoryGroup = groupRes.data.find(g => g.id === this.thread.category.categoryGroupId)
          } catch (e) {
            console.error('Lỗi khi tải nhóm chuyên mục:', e)
          }
        }
      } catch (error) {
        console.error('Lỗi khi tải chi tiết bài viết:', error)
      } finally {
        this.loading = false
      }
    },
    formatDate(dateStr) {
      return formatForumDate(dateStr)
    },
    handleVoteUpdated(updatedPoll) {
      if (this.thread) {
        this.thread.poll = updatedPoll
      }
    },
    handleContentClick(e) {
      if (e.target.tagName === 'IMG') {
        this.openLightbox(e.target.src)
      }
    },
    openLightbox(url) {
      this.activeImageUrl = url
      this.showLightbox = true
      document.body.style.overflow = 'hidden'
    },
    closeLightbox() {
      this.showLightbox = false
      this.activeImageUrl = ''
      document.body.style.overflow = ''
    }
  }
}
</script>

<style scoped>
.thread-title-full {
  padding: 1.2rem 1.5rem;
  margin: 0;
  display: flex;
  align-items: center;
  gap: 10px;
  border-bottom: 1px solid #eee;
}

.thread-title-full h1 {
  margin: 0;
  font-size: 1.4rem;
  color: #333;
  font-weight: 500;
}

.label-tag {
  padding: 2px 8px;
  font-size: 0.85rem;
  border-radius: 4px;
  font-weight: 600;
  display: inline-block;
  margin-bottom: 10px;
  border: 1px solid transparent;
}

.thread-meta-bar {
  padding: 8px 1.5rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #f8f9fa;
  font-size: 0.85rem;
  color: #666;
}

.author-info {
  display: flex;
  align-items: center;
  gap: 6px;
}

.meta-icon {
  color: #999;
}

.meta-dot {
  margin: 0 4px;
}

.poll-wrapper {
  margin-top: 15px;
}

.thread-content-card {
  margin-top: 15px;
  min-height: 200px;
}

.post-layout {
  display: flex;
}

.post-sidebar {
  width: 150px;
  background: #f5f5f5;
  padding: 15px;
  display: flex;
  flex-direction: column;
  align-items: center;
  border-right: 1px solid #e0e0e0;
}

.avatar-large {
  width: 80px;
  height: 80px;
  background-color: #73c6b6;
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 2.5rem;
  margin-bottom: 10px;
}

.author-name-large {
  font-weight: bold;
  color: #2980b9;
  font-size: 1rem;
  text-align: center;
  margin-bottom: 5px;
}

.author-title {
  font-size: 0.8rem;
  color: #7f8c8d;
  text-align: center;
}

.post-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-height: 200px;
}

.post-meta-top {
  padding: 10px 15px;
  display: flex;
  justify-content: space-between;
  border-bottom: 1px solid #eee;
  color: #999;
  font-size: 0.85rem;
}

.post-actions-top {
  display: flex;
  align-items: center;
  gap: 10px;
}

.post-number {
  font-weight: bold;
}

.content-body {
  padding: 15px;
  flex: 1;
  font-size: 1rem;
  line-height: 1.6;
  color: #333;
}

.post-meta-bottom {
  padding: 10px 15px;
  display: flex;
  justify-content: space-between;
  border-top: 1px solid #eee;
  background: #fcfcfc;
}

.action-link {
  color: #3498db;
  text-decoration: none;
  font-size: 0.85rem;
  display: inline-flex;
  align-items: center;
  gap: 5px;
}

.action-link:hover {
  text-decoration: underline;
}

.left-actions {
  display: flex;
  gap: 15px;
}

.reply-link {
  font-weight: 600;
}

:deep(.ql-editor img), :deep(.ql-editor video) { max-width: 100%; height: auto; }
:deep(.ql-editor .image-inline img) {
  width: 200px !important;
  height: 200px !important;
  object-fit: cover !important;
}
:deep(.ql-editor table) { border-collapse: collapse; width: 100%; margin: 1rem 0; }
:deep(.ql-editor td) { border: 1px solid #ccc; padding: 8px; }

.attached-section {
  margin-top: 1.5rem;
  border-top: 1px dashed #ddd;
  padding-top: 1.5rem;
  padding-left: 15px; /* Cân lề ngang với phần text content */
}

.attached-label {
  font-weight: bold;
  color: #1a507a;
  margin-bottom: 1rem;
  font-size: 0.95rem;
}

.attached-list {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
}

.attached-item img {
  max-width: 200px;
  max-height: 200px;
  object-fit: cover;
  border: 1px solid #eee;
  border-radius: 4px;
  cursor: zoom-in;
  transition: transform 0.2s;
}

.attached-item img:hover {
  transform: scale(1.02);
}

/* Lightbox Styles */
.lightbox-modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.9);
  z-index: 9999;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
}

.lightbox-content {
  position: relative;
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.btn-close-lightbox {
  position: absolute;
  top: 20px;
  right: 20px;
  background: transparent;
  border: none;
  color: white;
  font-size: 40px;
  cursor: pointer;
  z-index: 10001;
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.lightbox-main {
  flex: 1;
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 20px;
}

.lightbox-image-wrapper {
  flex: 1;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.main-lightbox-img {
  max-width: 100%;
  max-height: calc(100% - 60px);
  object-fit: contain;
  transition: transform 0.3s;
}
</style>
