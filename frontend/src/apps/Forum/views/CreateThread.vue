<template>
  <div class="create-thread-page container">
    <div class="breadcrumb" style="padding: 1rem 0;">
      <router-link to="/">Trang nhất</router-link>
      <span v-if="category"> » {{ category.name }}</span>
    </div>

    <div class="card">
      <div class="card-header">ĐĂNG BÀI</div>
      <div class="post-form" style="padding: 2rem;">
        <div class="form-group" style="margin-bottom: 1.5rem;">
          <input v-model="form.title" class="title-input" placeholder="Tiêu đề bài viết..." required>
        </div>

        <div class="editor-container" style="margin-bottom: 1.5rem;">
          <CustomEditor v-model="form.content" />
        </div>

        <div class="form-actions" style="display: flex; justify-content: flex-end; gap: 10px;">
          <button @click="$router.push('/')" class="btn-cancel">Hủy bỏ</button>
          <button @click="handlePost" class="btn-post">Đăng bài</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import api from '@/shared/services/api.service'
import { alertSuccess, alertError } from '@/shared/utils/swal'
import CustomEditor from '@/shared/components/CustomEditor.vue'

export default {
  name: 'CreateThread',
  components: {
    CustomEditor
  },
  data() {
    return {
      catId: this.$route.query.catId,
      category: null,
      form: { title: '', content: '', categoryId: '' }
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
        this.$router.push('/')
      } catch (error) {
        alertError('Lỗi khi đăng bài')
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

:deep(.ck-editor__editable) {
  min-height: 400px;
  font-size: 16px;
}
</style>
