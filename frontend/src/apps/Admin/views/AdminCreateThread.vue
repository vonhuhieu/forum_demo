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
            <label>Nhóm chuyên mục:</label>
            <select 
              v-model="selectedGroupId" 
              @change="form.categoryId = ''"
              class="admin-input" 
              required
              :disabled="isViewMode"
            >
              <option value="">-- Chọn nhóm chuyên mục --</option>
              <option v-for="group in categoryGroups" :key="group.id" :value="group.id">{{ group.name }}</option>
            </select>
          </div>
          <div class="form-group" style="flex: 1;">
            <label>Chuyên mục:</label>
            <select 
              v-model="form.categoryId" 
              class="admin-input" 
              required
              :disabled="isViewMode || !selectedGroupId"
            >
              <option value="">-- Chọn chuyên mục --</option>
              <option v-for="cat in filteredCategories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
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

            <!-- Tabs (hiển thị để biết loại bài viết, disabled ở view mode) -->
            <div class="post-type-tabs" :class="{ 'disabled-tabs': isViewMode }">
              <button
                :class="['tab-btn', postType === 'discussion' ? 'active' : '']"
                @click="!isViewMode && (postType = 'discussion')"
              >
                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg>
                Thảo luận
              </button>
              <button
                :class="['tab-btn', postType === 'poll' ? 'active' : '']"
                @click="!isViewMode && (postType = 'poll')"
              >
                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="20" x2="18" y2="10"></line><line x1="12" y1="20" x2="12" y2="4"></line><line x1="6" y1="20" x2="6" y2="14"></line></svg>
                Bình chọn
              </button>
            </div>

            <div class="editor-inner">
              <CustomEditor 
                v-if="!isViewMode"
                ref="editor"
                v-model="form.content" 
                @image-uploaded="handleImageUploaded"
              />
              <ImageUploaderPanel ref="uploaderPanel" @insert-images="handleInsertImages" :disabled="isViewMode" />
              <div v-if="isViewMode" class="ck-content readonly-content" v-html="form.content"></div>
            </div>

            <!-- Poll Form (for Edit/Create) -->
            <div v-if="!isViewMode && postType === 'poll'" style="margin-top: 0;">
              <PollForm v-model="form.poll" />
            </div>

            <!-- Poll Config Display (cho View Mode) -->
            <div v-if="isViewMode && form.poll" style="margin-top: 1.5rem;">
              <PollForm :modelValue="form.poll" disabled />
            </div>
          </div>
        </div>

        <div class="form-actions" style="margin-top: 2rem; display: flex; gap: 1rem; justify-content: flex-end;">
          <button @click="$router.push({ name: 'AdminThreads' })" class="btn-cancel">
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
import ImageUploaderPanel from '@/shared/components/ImageUploaderPanel.vue'
import PollForm from '@/shared/components/PollForm.vue'

export default {
  name: 'AdminCreateThread',
  components: {
    CustomEditor,
    ImageUploaderPanel,
    PollForm
  },
  data() {
    return {
      categories: [],
      categoryGroups: [],
      selectedGroupId: '',
      postType: 'discussion',
      form: { title: '', content: '', categoryId: '', pinned: false, poll: null }
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
    },
    filteredCategories() {
      if (!this.selectedGroupId) return [];
      const rawCategories = this.categories.filter(c => c.categoryGroupId == this.selectedGroupId);
      return this.formatCategoriesHierarchy(rawCategories);
    }
  },
  async mounted() {
    await this.fetchCategoryGroups()
    await this.fetchCategories()
    if (this.threadId) {
      await this.fetchThread()
    }
  },
  methods: {
    async fetchCategoryGroups() {
      try {
        const response = await AdminService.getCategoryGroups()
        this.categoryGroups = response.data
      } catch (error) {
        console.error('Error fetching groups:', error)
      }
    },
    async fetchCategories() {
      try {
        const response = await AdminService.getCategories()
        this.categories = response.data
      } catch (error) {
        console.error('Error fetching categories:', error)
      }
    },
    formatCategoriesHierarchy(flatCategories) {
      if (!flatCategories || flatCategories.length === 0) return [];
      
      const categoryMap = {};
      const roots = [];
      
      flatCategories.forEach(cat => {
        categoryMap[cat.id] = { ...cat, children: [] };
      });
      
      flatCategories.forEach(cat => {
        if (cat.parentCategoryId && categoryMap[cat.parentCategoryId]) {
          categoryMap[cat.parentCategoryId].children.push(categoryMap[cat.id]);
        } else {
          roots.push(categoryMap[cat.id]);
        }
      });
      
      const result = [];
      const flatten = (nodes, prefix = '') => {
        nodes.forEach(node => {
          result.push({
            ...node,
            name: prefix + node.name
          });
          if (node.children && node.children.length > 0) {
            flatten(node.children, prefix + '\u00A0\u00A0\u00A0\u00A0└─ ');
          }
        });
      };
      
      flatten(roots);
      return result;
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
          pinned: thread.pinned || false,
          poll: thread.poll || null
        }
        
        if (thread.poll) {
          this.postType = 'poll'
        } else {
          this.postType = 'discussion'
        }
        
        // Tự động chọn nhóm chuyên mục dựa trên chuyên mục của bài viết
        if (thread.category && thread.category.categoryGroupId) {
          this.selectedGroupId = thread.category.categoryGroupId
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
        
        if (this.postType === 'poll' && this.form.poll) {
          payload.poll = this.form.poll
        }
        
        if (this.isEditMode) {
          await api.put(`/threads/${this.threadId}`, payload)
          await alertSuccess('Cập nhật bài viết thành công')
        } else {
          await api.post('/threads', payload)
          await alertSuccess('Đăng bài viết thành công')
        }
        
        this.$router.push({ name: 'AdminThreads' })
      } catch (error) {
        alertError(this.isEditMode ? 'Lỗi khi cập nhật bài viết' : 'Lỗi khi đăng bài')
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
.admin-input-large { width: 100%; padding: 1rem; font-size: 1.2rem; border: 1px solid #ddd; border-radius: 4px; }
.admin-input { width: 100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 4px; }
.btn-save { background-color: #27ae60; color: white; border: none; padding: 12px 30px; border-radius: 4px; font-weight: bold; cursor: pointer; }
.btn-cancel { background-color: #95a5a6; color: white; border: none; padding: 12px 20px; border-radius: 4px; cursor: pointer; }
.form-group label { font-weight: bold; display: block; margin-bottom: 0.5rem; }

.post-type-tabs {
  display: flex;
  gap: 0;
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

.editor-wrapper {
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  background: white;
}

.disabled-tabs {
  pointer-events: none;
  opacity: 0.8;
}
.disabled-tabs .tab-btn:not(.active) {
  opacity: 0.5;
}

.editor-inner {
  border-top: 1px solid #ddd;
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
