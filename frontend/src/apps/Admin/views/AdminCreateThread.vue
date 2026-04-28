<template>
  <div class="admin-create-thread">
    <div class="card">
      <div class="card-header">{{ pageTitle }}</div>
      <div class="admin-form" style="padding: 2rem;">
        <div class="form-group">
          <label>Tiêu đề bài viết:</label>
          <input 
            v-model="form.title" 
            class="admin-input-large" 
            placeholder="Nhập tiêu đề..." 
            required
            :disabled="isViewMode"
          >
        </div>

        <div class="form-row" style="display: flex; gap: 2rem; margin-bottom: 1.5rem;">
          <div class="form-group" style="flex: 1;">
            <label>Chuyên mục:</label>
            <select 
              v-model="form.categoryId" 
              class="admin-input" 
              required
              :disabled="isViewMode"
            >
              <option value="">-- Chọn chuyên mục --</option>
              <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
            </select>
          </div>
          <div class="form-group" style="padding-top: 2rem;">
            <label style="display: flex; align-items: center; gap: 10px; cursor: pointer;">
              <input 
                type="checkbox" 
                v-model="form.pinned"
                :disabled="isViewMode"
              > Ghim bài viết lên đầu
            </label>
          </div>
        </div>

        <div class="form-group">
          <label>Nội dung bài viết:</label>
          <div class="editor-wrapper" :class="{ 'disabled-editor': isViewMode }">
            <CustomEditor 
              v-if="!isViewMode"
              v-model="form.content" 
            />
            <div v-else class="ck-content readonly-content" v-html="form.content"></div>
          </div>
        </div>

        <div class="form-actions" style="margin-top: 2rem; display: flex; gap: 1rem; justify-content: flex-end;">
          <button @click="$router.push('/admin/threads')" class="btn-cancel">
            {{ isViewMode ? 'Quay lại' : 'Hủy bỏ' }}
          </button>
          <button v-if="!isViewMode" @click="handlePost" class="btn-save">
            {{ isEditMode ? 'Cập nhật bài viết' : 'Đăng bài ngay' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import AdminService from '@/apps/Admin/services/admin.service'
import { alertSuccess, alertError } from '@/shared/utils/swal'
import api from '@/shared/services/api.service'
import CustomEditor from '@/shared/components/CustomEditor.vue'

export default {
  name: 'AdminCreateThread',
  components: {
    CustomEditor
  },
  data() {
    return {
      categories: [],
      form: { title: '', content: '', categoryId: '', pinned: false }
    }
  },
  computed: {
    isEditMode() {
      return this.$route.path.includes('/threads/edit/')
    },
    isViewMode() {
      return this.$route.path.includes('/threads/view/')
    },
    threadId() {
      return this.$route.params.id
    },
    pageTitle() {
      if (this.isViewMode) return 'XEM CHI TIẾT BÀI VIẾT'
      if (this.isEditMode) return 'CHỈNH SỬA BÀI VIẾT'
      return 'TẠO BÀI VIẾT MỚI'
    }
  },
  async mounted() {
    await this.fetchCategories()
    if (this.threadId) {
      await this.fetchThread()
    }
  },
  methods: {
    async fetchCategories() {
      try {
        const response = await AdminService.getCategories()
        this.categories = response.data
      } catch (error) {
        console.error('Error fetching categories:', error)
      }
    },
    async fetchThread() {
      try {
        const response = await api.get(`/threads/${this.threadId}`)
        const thread = response.data
        let content = thread.content || ''
        
        // Trong chế độ View, cần parse <oembed> ra HTML để v-html hiển thị được
        if (this.isViewMode) {
          content = content.replace(/<oembed\s+url="([^"]+)"><\/oembed>/gi, (match, url) => {
            const youtubeRegex = /(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})/i
            const ytMatch = url.match(youtubeRegex)
            if (ytMatch && ytMatch[1]) {
              return `<iframe width="100%" height="450" src="https://www.youtube.com/embed/${ytMatch[1]}" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>`
            }
            
            // Render video tải lên
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
        } else {
          // Trong chế độ Edit, migration các bài cũ:
          content = content.replace(/<oembed\s+url="https:\/\/uploads\/([^"]+)"><\/oembed>/gi, '<figure class="media"><oembed url="/uploads/$1"></oembed></figure>')
          content = content.replace(/<div[^>]*>\s*<video[^>]*src="([^"]+)"[^>]*><\/video>\s*<\/div>/gi, '<figure class="media"><oembed url="$1"></oembed></figure>')
          content = content.replace(/<video[^>]*src="([^"]+)"[^>]*><\/video>/gi, '<figure class="media"><oembed url="$1"></oembed></figure>')
        }

        this.form = {
          title: thread.title,
          content: content,
          categoryId: thread.category ? thread.category.id : '',
          pinned: thread.pinned || false
        }
      } catch (error) {
        alertError('Không thể tải thông tin bài viết')
      }
    },
    async handlePost() {
      if (!this.form.title || !this.form.content || !this.form.categoryId) {
        alertError('Vui lòng điền đầy đủ thông tin')
        return
      }
      try {
        const payload = {
          title: this.form.title,
          content: this.form.content,
          category: { id: this.form.categoryId },
          pinned: this.form.pinned
        }
        
        if (this.isEditMode) {
          await api.put(`/threads/${this.threadId}`, payload)
          await alertSuccess('Cập nhật bài viết thành công')
        } else {
          await api.post('/threads', payload)
          await alertSuccess('Đăng bài viết thành công')
        }
        
        this.$router.push('/admin/threads')
      } catch (error) {
        alertError(this.isEditMode ? 'Lỗi khi cập nhật bài viết' : 'Lỗi khi đăng bài')
      }
    }
  }
}
</script>

<style scoped>
.admin-input-large { width: 100%; padding: 1rem; font-size: 1.2rem; border: 1px solid #ddd; border-radius: 4px; }
.admin-input { width: 100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 4px; }
.btn-save { background-color: #27ae60; color: white; border: none; padding: 12px 30px; border-radius: 4px; font-weight: bold; cursor: pointer; }
.btn-cancel { background-color: #95a5a6; color: white; border: none; padding: 12px 20px; border-radius: 4px; cursor: pointer; }
.form-group label { font-weight: bold; display: block; margin-bottom: 0.5rem; }

.editor-wrapper {
  background: white;
  min-height: 400px;
}

/* Custom styles for CKEditor content */
:deep(.ck-editor__editable) {
  min-height: 400px;
  font-size: 16px;
  line-height: 1.6;
}

.readonly-content {
  border: 1px solid #ccc;
  padding: 1rem;
  border-radius: 4px;
  background: #f9f9f9;
  min-height: 400px;
}

/* Table styles for CKEditor content */
:deep(.ck-content table) {
  width: 100%;
  border-collapse: collapse;
}

:deep(.ck-content td), :deep(.ck-content th) {
  border: 1px solid #bfbfbf;
  padding: 0.4em;
}
</style>
