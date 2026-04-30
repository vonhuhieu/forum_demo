<template>
  <div class="thread-detail-page app-wrapper" v-if="!loading && thread">
    <ForumHeader />

    <main class="container" style="padding-top: 2rem;">
      <Breadcrumb :items="breadcrumbItems" />

      <div class="thread-header card">
        <h1 class="thread-title-full">{{ thread.title }}</h1>
        <div class="thread-meta-bar">
          <div class="author-info">
            <div class="avatar-small">
              {{ thread.author ? thread.author.username.charAt(0).toUpperCase() : 'A' }}
            </div>
            <span class="author-name">{{ thread.author ? thread.author.username : 'Ẩn danh' }}</span>
          </div>
          <div class="post-time">
            Đăng lúc: {{ formatDate(thread.createdAt) }}
          </div>
        </div>
      </div>

      <div class="thread-content-card card">
        <div class="content-body ql-editor" v-html="thread.content"></div>
      </div>

      <div class="thread-actions" style="margin-top: 1rem; display: flex; gap: 10px;">
        <button class="btn-reply">Trả lời</button>
        <button class="btn-back" @click="$router.back()">Quay lại</button>
      </div>
    </main>
  </div>
  
  <div v-else-if="loading" class="container" style="padding: 3rem; text-align: center;">
    Đang tải bài viết...
  </div>
</template>

<script>
import api from '@/shared/services/api.service'
import ForumHeader from '@/shared/components/ForumHeader.vue'
import Breadcrumb from '@/shared/components/Breadcrumb.vue'
import { formatForumDate } from '@/shared/utils/date'

export default {
  name: 'ThreadDetail',
  components: {
    ForumHeader,
    Breadcrumb
  },
  data() {
    return {
      thread: null,
      loading: true
    }
  },
  computed: {
    breadcrumbItems() {
      const items = [{ title: 'Trang nhất', to: { name: 'Home' } }]
      if (this.thread && this.thread.category) {
        items.push({ 
          title: this.thread.category.name, 
          to: { name: 'CategoryDetail', params: { id: this.thread.category.id } } 
        })
      }
      if (this.thread) {
        items.push({ title: this.thread.title })
      }
      return items
    }
  },
  async mounted() {
    await this.fetchThread()
  },
  methods: {
    async fetchThread() {
      try {
        const response = await api.get(`/threads/${this.$route.params.id}`)
        let content = response.data.content || ''
        
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
      } catch (error) {
        console.error('Lỗi khi tải chi tiết bài viết:', error)
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
.thread-title-full {
  padding: 1.5rem;
  margin: 0;
  font-size: 1.8rem;
  color: #1a507a;
  border-bottom: 1px solid #eee;
}
.thread-meta-bar {
  padding: 0.75rem 1.5rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #f8f9fa;
  font-size: 0.9rem;
  color: #666;
}
.author-info { display: flex; align-items: center; gap: 10px; }
.avatar-small {
  width: 30px; height: 30px;
  background-color: #1a507a; color: white;
  border-radius: 4px; display: flex;
  align-items: center; justify-content: center;
  font-weight: bold;
}
.thread-content-card { margin-top: 1.5rem; padding: 2rem; min-height: 300px; }
.content-body { font-size: 1.1rem; line-height: 1.8; color: #333; }
.btn-reply {
  background-color: #f39c12; color: white;
  border: none; padding: 10px 25px;
  border-radius: 4px; font-weight: bold; cursor: pointer;
}
.btn-back {
  background-color: #6c757d; color: white;
  border: none; padding: 10px 25px;
  border-radius: 4px; font-weight: bold; cursor: pointer;
}
:deep(.ql-editor img), :deep(.ql-editor video) { max-width: 100%; height: auto; min-width: 100% !important }
:deep(.ql-editor table) { border-collapse: collapse; width: 100%; margin: 1rem 0; }
:deep(.ql-editor td) { border: 1px solid #ccc; padding: 8px; }
</style>
