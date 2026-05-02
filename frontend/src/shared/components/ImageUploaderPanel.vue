<template>
  <div class="image-uploader-panel">
    <div class="uploader-actions">
      <button class="btn-upload" @click="triggerFileInput" :disabled="isUploading">
        <svg v-if="!isUploading" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon-paperclip">
          <path d="M21.44 11.05l-9.19 9.19a6 6 0 0 1-8.49-8.49l9.19-9.19a4 4 0 0 1 5.66 5.66l-9.2 9.19a2 2 0 0 1-2.83-2.83l8.49-8.48"></path>
        </svg>
        <span v-else class="spinner"></span>
        {{ isUploading ? 'Đang tải...' : 'Up Ảnh' }}
      </button>
      <input 
        type="file" 
        ref="fileInput" 
        multiple 
        accept="image/*" 
        style="display: none" 
        @change="onFileChange"
      />
    </div>

    <div v-if="uploadedImages.length > 0" class="uploaded-images-container">
      <div v-for="(img, index) in uploadedImages" :key="index" class="image-thumbnail-wrapper">
        <img :src="img.url" :alt="img.name" class="image-thumbnail" @click="enlargeImage(img.url)" title="Click để xem ảnh lớn" />
        <div class="thumbnail-overlay">
          <button class="btn-insert-over" @click="insertImage(img.url)">Chèn...</button>
          <button class="btn-delete-over" @click="removeImage(index)" title="Xóa ảnh">
            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path><line x1="10" y1="11" x2="10" y2="17"></line><line x1="14" y1="11" x2="14" y2="17"></line></svg>
          </button>
        </div>
        <div class="thumbnail-name" :title="img.name">{{ img.name }}</div>
      </div>
    </div>

    <div v-if="uploadedImages.length > 0" class="multiple-actions">
      <button class="btn-insert-multiple" @click="insertAll">Insert multiple...</button>
    </div>
  </div>
</template>

<script>
import api from '@/shared/services/api.service'

export default {
  name: 'ImageUploaderPanel',
  data() {
    return {
      isUploading: false,
      uploadedImages: []
    }
  },
  methods: {
    triggerFileInput() {
      this.$refs.fileInput.click()
    },
    async onFileChange(event) {
      const files = Array.from(event.target.files)
      if (files.length === 0) return

      this.isUploading = true
      const formData = new FormData()
      files.forEach(file => formData.append('files', file))

      try {
        const res = await api.post('/upload/multiple', formData, {
          headers: { 'Content-Type': 'multipart/form-data' }
        })
        
        const validResults = res.data || []
        // Chỉ lưu những file là ảnh
        const newImages = validResults.filter(result => result.type && result.type.startsWith('image/'))
        
        this.uploadedImages.push(...newImages)
        
        // Reset input để có thể chọn lại file vừa tải
        this.$refs.fileInput.value = ''
      } catch (err) {
        console.error('Lỗi khi tải ảnh:', err)
        alert('Không thể tải ảnh. Vui lòng thử lại sau.')
      } finally {
        this.isUploading = false
      }
    },
    insertImage(url) {
      this.$emit('insert-images', [url])
    },
    insertAll() {
      const urls = this.uploadedImages.map(img => img.url)
      this.$emit('insert-images', urls)
    },
    removeImage(index) {
      this.uploadedImages.splice(index, 1)
    },
    enlargeImage(url) {
      window.open(url, '_blank')
    }
  }
}
</script>

<style scoped>
.image-uploader-panel {
  margin-top: 10px;
  border: 1px solid #ddd;
  padding: 10px;
  background: #f9f9f9;
  border-radius: 4px;
}

.btn-upload {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  background: white;
  border: 1px solid #ccc;
  padding: 6px 12px;
  border-radius: 4px;
  cursor: pointer;
  color: #3498db;
  font-weight: 500;
  transition: all 0.2s;
}

.btn-upload:hover:not(:disabled) {
  background: #f0f7fb;
  border-color: #3498db;
}

.btn-upload:disabled {
  opacity: 0.7;
  cursor: not-allowed;
  color: #888;
}

.icon-paperclip {
  color: #3498db;
}

.spinner {
  display: inline-block;
  width: 14px;
  height: 14px;
  border: 2px solid rgba(0, 0, 0, 0.1);
  border-top-color: #3498db;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.uploaded-images-container {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 15px;
}

.image-thumbnail-wrapper {
  position: relative;
  width: 150px;
  height: 150px;
  background: #eee;
  border: 1px solid #ddd;
  border-radius: 4px;
  overflow: hidden;
}

.image-thumbnail {
  width: 100%;
  height: calc(100% - 24px); /* Chừa chỗ cho tên file */
  object-fit: cover;
  cursor: zoom-in;
  display: block;
}

.thumbnail-overlay {
  position: absolute;
  top: 5px;
  left: 0;
  right: 0;
  display: flex;
  justify-content: space-between;
  padding: 0 5px;
}

.btn-insert-over {
  background: rgba(0, 0, 0, 0.6);
  color: white;
  border: none;
  border-radius: 3px;
  padding: 4px 8px;
  font-size: 11px;
  cursor: pointer;
  transition: background 0.2s;
}

.btn-insert-over:hover {
  background: rgba(52, 152, 219, 0.9);
}

.btn-delete-over {
  background: rgba(0, 0, 0, 0.6);
  color: white;
  border: none;
  border-radius: 3px;
  padding: 4px 6px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background 0.2s;
}

.btn-delete-over:hover {
  background: rgba(231, 76, 60, 0.9);
}

.thumbnail-name {
  height: 24px;
  background: rgba(0, 0, 0, 0.6);
  color: white;
  font-size: 11px;
  line-height: 24px;
  padding: 0 5px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  position: absolute;
  bottom: 0;
  width: 100%;
  box-sizing: border-box;
}

.multiple-actions {
  margin-top: 15px;
}

.btn-insert-multiple {
  background: white;
  border: 1px solid #ccc;
  padding: 6px 15px;
  border-radius: 4px;
  cursor: pointer;
  color: #3498db;
  transition: all 0.2s;
  font-size: 0.9rem;
}

.btn-insert-multiple:hover {
  background: #f0f7fb;
  border-color: #3498db;
}
</style>
