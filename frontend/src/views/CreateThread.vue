<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '../api'

const route = useRoute()
const router = useRouter()

const catId = ref(route.query.catId)
const category = ref(null)
const title = ref('')
const content = ref('')

const toolbarOptions = [
  ['bold', 'italic', 'underline', 'strike'],        
  ['blockquote', 'code-block'],
  [{ 'header': 1 }, { 'header': 2 }],               
  [{ 'list': 'ordered'}, { 'list': 'bullet' }],
  [{ 'indent': '-1'}, { 'indent': '+1' }],          
  [{ 'size': ['small', false, 'large', 'huge'] }],  
  [{ 'color': [] }, { 'background': [] }],          
  [{ 'align': [] }],
  ['link', 'image', 'video'],
  ['clean']                                         
];

const addTooltips = () => {
  const tooltips = {
    'ql-bold': 'In đậm (Ctrl+B)',
    'ql-italic': 'In nghiêng (Ctrl+I)',
    'ql-underline': 'Gạch chân (Ctrl+U)',
    'ql-strike': 'Gạch ngang',
    'ql-blockquote': 'Trích dẫn',
    'ql-code-block': 'Chèn mã',
    'ql-list[value="ordered"]': 'Danh sách số',
    'ql-list[value="bullet"]': 'Danh sách chấm',
    'ql-indent[value="-1"]': 'Giảm thụt lề',
    'ql-indent[value="+1"]': 'Tăng thụt lề',
    'ql-color': 'Màu chữ',
    'ql-background': 'Màu nền',
    'ql-align': 'Căn lề',
    'ql-link': 'Chèn liên kết',
    'ql-image': 'Chèn ảnh',
    'ql-video': 'Chèn video',
    'ql-clean': 'Xóa định dạng'
  };
  
  for (let key in tooltips) {
    const el = document.querySelector(`.${key}`);
    if (el) el.setAttribute('title', tooltips[key]);
  }
};

const fetchCategory = async () => {
  if (!catId.value) return
  const response = await api.get('/categories')
  category.value = response.data.find(c => c.id == catId.value)
}

const handlePost = async () => {
  try {
    const payload = {
      title: title.value,
      content: content.value,
      category: { id: catId.value }
    }
    await api.post('/threads', payload)
    router.push('/')
  } catch (error) {
    alert('Lỗi khi đăng bài')
  }
}

onMounted(() => {
  fetchCategory();
  setTimeout(addTooltips, 500); // Đợi editor render xong để gán tooltip
})
</script>

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
          <QuillEditor 
            v-model:content="content" 
            contentType="html" 
            theme="snow" 
            :toolbar="toolbarOptions"
            placeholder="Viết nội dung bài viết vào đây..."
            style="height: 400px;"
          />
        </div>

        <div class="form-actions" style="display: flex; justify-content: flex-end; gap: 10px;">
          <button @click="$router.push('/')" class="btn-cancel">Hủy bỏ</button>
          <button @click="handlePost" class="btn-post">Đăng bài</button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.create-thread-page { padding-bottom: 5rem; }
.title-input {
  width: 100%;
  padding: 1rem;
  font-size: 1.2rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-weight: bold;
}
.btn-post {
  background-color: #3498db;
  color: white;
  border: none;
  padding: 10px 30px;
  border-radius: 4px;
  font-weight: bold;
  cursor: pointer;
}
.btn-cancel {
  background-color: #ecf0f1;
  color: #333;
  border: none;
  padding: 10px 20px;
  border-radius: 4px;
  cursor: pointer;
}
</style>
