<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import api from '../api'

const route = useRoute()
const thread = ref(null)
const loading = ref(true)

const fetchThread = async () => {
  try {
    const response = await api.get(`/threads/${route.params.id}`)
    thread.value = response.data
  } catch (error) {
    console.error('Lỗi khi tải chi tiết bài viết:', error)
  } finally {
    loading.value = false
  }
}

const formatDate = (dateStr) => {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  return date.toLocaleString('vi-VN')
}

onMounted(() => {
  fetchThread()
})
</script>

<template>
  <div class="thread-detail-page container" v-if="!loading && thread">
    <div class="breadcrumb" style="padding: 1rem 0;">
      <router-link to="/">Trang nhất</router-link> 
      <span v-if="thread.category"> » {{ thread.category.name }}</span>
    </div>

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
      <!-- QUAN TRỌNG: Sử dụng class ql-editor để các style của Quill (bảng, căn lề, kích thước) được áp dụng đúng -->
      <div class="content-body ql-editor" v-html="thread.content"></div>
    </div>

    <div class="thread-actions" style="margin-top: 1rem; display: flex; gap: 10px;">
       <button class="btn-reply">Trả lời</button>
    </div>
  </div>
  
  <div v-else-if="loading" class="container" style="padding: 3rem; text-align: center;">
    Đang tải bài viết...
  </div>
</template>

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
.author-info {
  display: flex;
  align-items: center;
  gap: 10px;
}
.avatar-small {
  width: 30px;
  height: 30px;
  background-color: #1a507a;
  color: white;
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
}
.thread-content-card {
  margin-top: 1.5rem;
  padding: 2rem;
  min-height: 300px;
}

/* Tùy chỉnh hiển thị nội dung từ Quill */
.content-body {
  font-size: 1.1rem;
  line-height: 1.8;
  color: #333;
}

.btn-reply {
  background-color: #f39c12;
  color: white;
  border: none;
  padding: 10px 25px;
  border-radius: 4px;
  font-weight: bold;
  cursor: pointer;
}

/* Đảm bảo ảnh/video không vượt quá chiều ngang */
:deep(.ql-editor img), :deep(.ql-editor video) {
  max-width: 100%;
  height: auto;
}

:deep(.ql-editor table) {
  border-collapse: collapse;
  width: 100%;
  margin: 1rem 0;
}
:deep(.ql-editor td) {
  border: 1px solid #ccc;
  padding: 8px;
}
</style>
