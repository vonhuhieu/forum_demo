<template>
  <div class="create-thread-page app-wrapper">
    <ForumHeader />
    
    <main class="container" style="padding-top: 2rem;">
      <Breadcrumb :items="breadcrumbItems" />

      <div class="card">
        <div class="card-header">ĐĂNG BÀI</div>
        <div class="post-form" style="padding: 2rem;">
          <div class="form-group" style="margin-bottom: 1.5rem;">
            <label style="display: block; margin-bottom: 0.5rem; font-weight: bold; color: #1a507a;">Tiêu đề bài viết:</label>
            <input v-model="form.title" class="title-input" placeholder="Nhập tiêu đề bài viết..." required>
          </div>

          <div class="form-group" style="margin-bottom: 1.5rem;">
            <label style="display: block; margin-bottom: 0.5rem; font-weight: bold; color: #1a507a;">Chuyên mục:</label>
            <input 
              :value="category ? category.name : 'Đang tải...'" 
              class="title-input" 
              style="background-color: #f5f5f5; color: #888; font-size: 1rem; cursor: not-allowed;" 
              disabled
            >
          </div>

          <!-- Tabs Thảo luận / Bình chọn -->
          <div class="editor-block">
            <div class="post-type-tabs">
              <button
                :class="['tab-btn', postType === 'discussion' ? 'active' : '']"
                @click="postType = 'discussion'"
              >
                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg>
                Thảo luận
              </button>
              <button
                :class="['tab-btn', postType === 'poll' ? 'active' : '']"
                @click="postType = 'poll'"
              >
                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="20" x2="18" y2="10"></line><line x1="12" y1="20" x2="12" y2="4"></line><line x1="6" y1="20" x2="6" y2="14"></line></svg>
                Bình chọn
              </button>
            </div>

            <div class="editor-container">
              <CustomEditor ref="editor" v-model="form.content" @image-uploaded="handleImageUploaded" />
              <ImageUploaderPanel ref="uploaderPanel" @insert-images="handleInsertImages" />
            </div>

            <!-- Poll Form -->
            <div v-if="postType === 'poll'">
              <PollForm v-model="form.poll" />
            </div>
          </div>

          <div class="form-actions" style="display: flex; justify-content: flex-end; gap: 10px;">
            <button @click="$router.push({ name: 'Home' })" class="btn-cancel">Hủy bỏ</button>
            <button @click="handlePost" class="btn-post">Đăng bài</button>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script>
import api from '@/shared/services/api.service'
import { alertSuccess, alertError } from '@/shared/utils/swal'
import ForumHeader from '@/shared/components/ForumHeader.vue'
import CustomEditor from '@/shared/components/CustomEditor.vue'
import Breadcrumb from '@/shared/components/Breadcrumb.vue'
import ImageUploaderPanel from '@/shared/components/ImageUploaderPanel.vue'
import PollForm from '@/shared/components/PollForm.vue'

export default {
  name: 'CreateThread',
  components: {
    ForumHeader,
    CustomEditor,
    Breadcrumb,
    ImageUploaderPanel,
    PollForm
  },
  data() {
    return {
      catId: this.$route.query.catId,
      category: null,
      postType: 'discussion',
      form: { title: '', content: '', categoryId: '', poll: null }
    }
  },
  computed: {
    breadcrumbItems() {
      const items = [{ title: 'Trang chủ', to: { name: 'Home' } }]
      if (this.category) {
        items.push({ 
          title: this.category.name, 
          to: { name: 'CategoryDetail', params: { id: this.category.id } } 
        })
      }
      items.push({ title: 'Đăng bài mới' })
      return items
    }
  },
  mounted() {
    this.fetchCategory()
  },
  methods: {
    async fetchCategory() {
      if (!this.catId) return
      try {
        const response = await api.get('/categories')
        this.category = response.data.find(c => c.id == this.catId)
      } catch (error) {
        console.error('Error fetching category:', error)
      }
    },
    async handlePost() {
      if (!this.form.title || !this.form.content) {
        alertError('Vui lòng nhập đầy đủ tiêu đề và nội dung')
        return
      }
      try {
        await api.post('/threads', {
          title: this.form.title,
          content: this.form.content,
          category: { id: this.catId }
        })
        this.$router.push({ name: 'Home' })
      } catch (error) {
        alertError('Lỗi khi đăng bài')
      }
    },
    handleInsertImages(urls, type) {
      if (this.$refs.editor && this.$refs.editor.insertImages) {
        this.$refs.editor.insertImages(urls, type)
      }
    },
    handleImageUploaded(image) {
      if (this.$refs.uploaderPanel) {
        this.$refs.uploaderPanel.addImage(image)
      }
    }
  }
}
</script>

<style scoped>
.create-thread-page { padding-bottom: 5rem; }
.title-input { width: 100%; padding: 1rem; font-size: 1.2rem; border: 1px solid #ddd; border-radius: 4px; font-weight: bold; }
.btn-post { background-color: #3498db; color: white; border: none; padding: 12px 35px; border-radius: 4px; font-weight: bold; cursor: pointer; transition: background 0.3s; }
.btn-post:hover { background-color: #2980b9; }
.btn-cancel { background-color: #ecf0f1; color: #333; border: none; padding: 12px 25px; border-radius: 4px; cursor: pointer; }

.post-type-tabs {
  display: flex;
  gap: 0;
  margin-bottom: 0;
  border-bottom: 1px solid #ddd;
  margin-bottom: -1px;
  position: relative;
  z-index: 1;
}

.tab-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 8px 18px;
  border: 1px solid #ddd;
  border-bottom: none;
  background: #f5f5f5;
  color: #666;
  cursor: pointer;
  font-size: 13px;
  border-radius: 4px 4px 0 0;
  transition: all 0.2s;
  margin-right: 4px;
}

.tab-btn.active {
  background: white;
  color: #3498db;
  border-color: #ddd;
  font-weight: 600;
  border-bottom-color: white;
}

.tab-btn:hover:not(.active) {
  background: #ebebeb;
}

.editor-block {
  margin-bottom: 1.5rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  overflow: hidden;
}

.editor-container {
  border-top: 1px solid #ddd;
}

:deep(.ck-editor__editable) {
  min-height: 400px;
  font-size: 16px;
}
</style>
