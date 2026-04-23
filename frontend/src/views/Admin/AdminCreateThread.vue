<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import api from '../../api'

const router = useRouter()
const categories = ref([])
const form = ref({
  title: '',
  content: '',
  categoryId: '',
  pinned: false
})

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
    'ql-bold': 'In đậm', 'ql-italic': 'In nghiêng', 'ql-underline': 'Gạch chân', 'ql-strike': 'Gạch ngang',
    'ql-blockquote': 'Trích dẫn', 'ql-code-block': 'Chèn mã', 'ql-list[value="ordered"]': 'Số thứ tự',
    'ql-list[value="bullet"]': 'Dấu chấm', 'ql-indent[value="-1"]': 'Giảm thụt lề', 'ql-indent[value="+1"]': 'Tăng thụt lề',
    'ql-color': 'Màu chữ', 'ql-background': 'Màu nền', 'ql-align': 'Căn lề', 'ql-link': 'Liên kết',
    'ql-image': 'Ảnh', 'ql-video': 'Video', 'ql-clean': 'Xóa định dạng'
  };
  for (let key in tooltips) {
    const el = document.querySelector(`.admin-create-thread .${key}`);
    if (el) el.setAttribute('title', tooltips[key]);
  }
};

const fetchCategories = async () => {
  const response = await api.get('/categories')
  categories.value = response.data
}

const handlePost = async () => {
  try {
    const payload = {
      title: form.value.title,
      content: form.value.content,
      category: { id: form.value.categoryId },
      pinned: form.value.pinned
    }
    await api.post('/threads', payload)
    router.push('/admin/threads')
  } catch (error) {
    alert('Lỗi khi đăng bài')
  }
}

onMounted(() => {
  fetchCategories();
  setTimeout(addTooltips, 500);
})
</script>

<template>
  <div class="admin-create-thread">
    <div class="card">
      <div class="card-header">TẠO BÀI VIẾT MỚI (QUẢN TRỊ)</div>
      <div class="admin-form" style="padding: 2rem;">
        <div class="form-group">
          <label>Tiêu đề bài viết:</label>
          <input v-model="form.title" class="admin-input-large" placeholder="Nhập tiêu đề..." required>
        </div>

        <div class="form-row" style="display: flex; gap: 2rem; margin-bottom: 1.5rem;">
          <div class="form-group" style="flex: 1;">
            <label>Chuyên mục:</label>
            <select v-model="form.categoryId" class="admin-input" required>
              <option value="">-- Chọn chuyên mục --</option>
              <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
            </select>
          </div>
          <div class="form-group" style="padding-top: 2rem;">
            <label style="display: flex; align-items: center; gap: 10px; cursor: pointer;">
              <input type="checkbox" v-model="form.pinned"> Ghim bài viết lên đầu
            </label>
          </div>
        </div>

        <div class="form-group">
          <label>Nội dung bài viết:</label>
          <div class="editor-wrapper">
            <QuillEditor 
              v-model:content="form.content" 
              contentType="html" 
              theme="snow" 
              :toolbar="toolbarOptions"
              placeholder="Nhập nội dung bài viết..."
              style="height: 450px;"
            />
          </div>
        </div>

        <div class="form-actions" style="margin-top: 2rem; display: flex; gap: 1rem; justify-content: flex-end;">
          <button @click="$router.push('/admin/threads')" class="btn-cancel">Hủy bỏ</button>
          <button @click="handlePost" class="btn-save">Đăng bài ngay</button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.admin-input-large {
  width: 100%;
  padding: 1rem;
  font-size: 1.2rem;
  border: 1px solid #ddd;
  border-radius: 4px;
}
.admin-input {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 4px;
}
.btn-save {
  background-color: #27ae60;
  color: white;
  border: none;
  padding: 12px 30px;
  border-radius: 4px;
  font-weight: bold;
  cursor: pointer;
}
.btn-cancel {
  background-color: #95a5a6;
  color: white;
  border: none;
  padding: 12px 20px;
  border-radius: 4px;
  cursor: pointer;
}
.form-group label {
    font-weight: bold;
    display: block;
    margin-bottom: 0.5rem;
}
</style>
