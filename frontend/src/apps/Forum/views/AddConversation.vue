<template>
  <div class="add-conversation-page app-wrapper">
    <ForumHeader />
    
    <main class="container" style="padding-top: 2rem;">
      <div class="breadcrumb" style="margin-bottom: 1rem; font-size: 0.9rem; color: #666;">
        <router-link :to="{ name: 'Home' }" style="color: #1a507a; text-decoration: none;">Trang chủ</router-link>
        <span style="margin: 0 5px;">&gt;</span>
        <span style="color: #666;">Đối thoại</span>
      </div>

      <div class="card">
        <div class="card-header">Bắt đầu đối thoại</div>
        
        <div class="post-form" style="padding: 2rem;">
          <!-- Người nhận -->
          <div class="form-group" style="margin-bottom: 1.5rem;">
            <label style="display: block; margin-bottom: 0.5rem; font-weight: bold; color: #1a507a;">Người nhận:</label>
            <div class="recipient-input-container">
              <div class="recipient-tag">
                {{ recipientName }}
              </div>
              <input 
                type="text" 
                class="recipient-dummy-input" 
                disabled 
                placeholder=""
              />
            </div>
            <small style="color: #888; font-size: 0.85rem; margin-top: 4px; display: block;">Dẫn cách tên bằng dấu phẩy(,).</small>
          </div>

          <!-- Tiêu đề -->
          <div class="form-group" style="margin-bottom: 1.5rem;">
            <input 
              v-model="form.title" 
              class="title-input" 
              style="width: 100%;" 
              placeholder="Tiêu đề..." 
              required
            />
          </div>

          <!-- Nội dung đối thoại -->
          <div class="editor-block" style="margin-bottom: 1.5rem; border: 1px solid #ddd; border-radius: 4px; overflow: hidden;">
            <div class="editor-container">
              <CustomEditor ref="editor" v-model="form.content" />
            </div>
          </div>

          <!-- Actions -->
          <div class="form-actions" style="display: flex; justify-content: flex-end; gap: 10px; border-top: 1px solid #eee; padding-top: 1.5rem;">
            <button @click="$router.push({ name: 'Home' })" class="btn-cancel">Hủy bỏ</button>
            <button @click="handleSubmit" class="btn-post" :disabled="submitting">
              <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 5px; vertical-align: middle;"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg>
              Bắt đầu đối thoại
            </button>
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

export default {
  name: 'AddConversation',
  components: {
    ForumHeader,
    CustomEditor
  },
  data() {
    return {
      recipientName: this.$route.query.to || '',
      submitting: false,
      form: {
        title: '',
        content: ''
      }
    }
  },
  async mounted() {
    if (!this.recipientName) {
      alertError('Không chỉ định người nhận cuộc đối thoại')
      this.$router.push({ name: 'Home' })
    }
  },
  methods: {
    async handleSubmit() {
      if (!this.form.title || !this.form.title.trim()) {
        alertError('Vui lòng nhập tiêu đề cuộc đối thoại')
        return
      }
      if (!this.form.content || !this.form.content.trim()) {
        alertError('Vui lòng nhập nội dung đối thoại')
        return
      }

      this.submitting = true
      try {
        const payload = {
          recipientDisplayName: this.recipientName,
          title: this.form.title,
          content: this.form.content
        }

        const res = await api.post('/conversations', payload)
        if (res.data && res.data.status === 1) {
          alertSuccess('Bắt đầu cuộc đối thoại thành công')
          this.$router.push({ name: 'Home' })
        } else {
          alertError(res.data?.message || 'Có lỗi xảy ra khi bắt đầu đối thoại')
        }
      } catch (error) {
        console.error(error)
        alertError(error.response?.data?.message || 'Lỗi hệ thống khi bắt đầu đối thoại')
      } finally {
        this.submitting = false
      }
    }
  }
}
</script>

<style scoped>
.add-conversation-page {
  padding-bottom: 5rem;
}

.recipient-input-container {
  display: flex;
  align-items: center;
  border: 1px solid #ddd;
  border-radius: 4px;
  padding: 8px 12px;
  background-color: #fafafa;
  min-height: 48px;
}

.recipient-tag {
  background-color: #f1f3f5;
  border: 1px solid #ced4da;
  border-radius: 3px;
  padding: 4px 10px;
  color: #495057;
  font-size: 0.9rem;
  font-weight: 500;
  margin-right: 8px;
  user-select: none;
  box-shadow: 0 1px 2px rgba(0,0,0,0.05);
}

.recipient-dummy-input {
  border: none;
  background: transparent;
  flex: 1;
  outline: none;
  font-size: 0.95rem;
  color: #888;
  cursor: not-allowed;
}

.title-input {
  padding: 12px 15px;
  font-size: 1.1rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  outline: none;
  font-weight: bold;
}

.title-input:focus {
  border-color: #3498db;
}

.btn-post {
  background-color: #3498db;
  color: white;
  border: none;
  padding: 12px 35px;
  border-radius: 4px;
  font-weight: bold;
  cursor: pointer;
  transition: background 0.3s;
  font-size: 0.95rem;
  display: inline-flex;
  align-items: center;
}

.btn-post:hover:not(:disabled) {
  background-color: #2980b9;
}

.btn-post:disabled {
  background-color: #bdc3c7;
  cursor: not-allowed;
}

.btn-cancel {
  background-color: #ecf0f1;
  color: #333;
  border: none;
  padding: 12px 25px;
  border-radius: 4px;
  cursor: pointer;
  font-weight: 500;
  font-size: 0.95rem;
}

.btn-cancel:hover {
  background-color: #bdc3c7;
}

:deep(.ck-editor__editable) {
  min-height: 350px;
  font-size: 16px;
}
</style>
