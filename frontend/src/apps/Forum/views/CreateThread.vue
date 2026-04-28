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
          <input v-model="title" class="title-input" placeholder="Tiêu đề bài viết..." required>
        </div>

        <div class="editor-container" style="margin-bottom: 1.5rem;">
          <ckeditor 
            :editor="editor" 
            v-model="content" 
            :config="editorConfig"
          ></ckeditor>
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
import { Ckeditor } from '@ckeditor/ckeditor5-vue'
import {
  ClassicEditor,
  Essentials,
  Paragraph,
  Heading,
  Bold,
  Italic,
  Underline,
  Strikethrough,
  Font,
  Alignment,
  Link,
  List,
  Indent,
  IndentBlock,
  Image,
  ImageUpload,
  Table,
  MediaEmbed,
  BlockQuote,
  FileRepository,
  TableToolbar,
  TableColumnResize,
  Undo
} from 'ckeditor5'
import 'ckeditor5/ckeditor5.css'
import api from '@/shared/services/api.service'

class MyUploadAdapter {
  constructor(loader) {
    this.loader = loader
  }
  upload() {
    return this.loader.file.then(file => new Promise((resolve, reject) => {
      const formData = new FormData()
      formData.append('file', file)
      api.post('/upload', formData, {
        headers: { 'Content-Type': 'multipart/form-data' }
      })
      .then(res => resolve({ default: res.data.url }))
      .catch(err => reject(err))
    }))
  }
  abort() {}
}

function MyCustomUploadAdapterPlugin(editor) {
  editor.plugins.get('FileRepository').createUploadAdapter = (loader) => {
    return new MyUploadAdapter(loader)
  }
}

export default {
  name: 'CreateThread',
  components: {
    ckeditor: Ckeditor
  },
  data() {
    return {
      catId: this.$route.query.catId,
      category: null,
      title: '',
      content: '',
      editor: ClassicEditor,
      editorConfig: {
        licenseKey: 'GPL',
        mediaEmbed: {
          previewsInData: true
        },
        fontSize: {
          options: [
            9, 10, 11, 12, 13, 'default', 15, 16, 18, 20, 22, 24, 28, 32, 36
          ]
        },
        plugins: [
          Essentials, Paragraph, Heading, Bold, Italic, Underline, Strikethrough,
          Font, Alignment, Link, List, Indent, IndentBlock, Image, ImageUpload, Table,
          MediaEmbed, BlockQuote, FileRepository, TableToolbar, TableColumnResize, Undo,
          MyCustomUploadAdapterPlugin
        ],
        toolbar: {
          items: [
            'heading', '|', 'bold', 'italic', 'underline', 'strikethrough', '|',
            'fontSize', 'fontFamily', 'fontColor', 'fontBackgroundColor', '|',
            'alignment', '|',
            'link', 'bulletedList', 'numberedList', '|',
            'outdent', 'indent', '|', 'imageUpload', 'insertTable', 'mediaEmbed', 'blockQuote', '|',
            'undo', 'redo'
          ]
        },
        language: 'vi'
      }
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
      if (!this.title || !this.content) {
        alert('Vui lòng nhập đầy đủ tiêu đề và nội dung')
        return
      }
      try {
        await api.post('/threads', {
          title: this.title,
          content: this.content,
          category: { id: this.catId }
        })
        this.$router.push('/')
      } catch (error) {
        alert('Lỗi khi đăng bài')
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
