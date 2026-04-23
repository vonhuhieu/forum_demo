<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import api from '../../api'

const router = useRouter()
const categories = ref([])
const quillRef = ref(null)
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
  [{ 'size': ['12px', '14px', '16px', '18px', '20px', '24px', '32px', '48px'] }],
  [{ 'color': [] }, { 'background': [] }],
  [{ 'align': [] }],
  ['link', 'image', 'video'],
  [{ 'table': [] }],
  ['attachment'],
  ['clean']
];

const modules = {
  blotFormatter: {}, 
  table: true,
  toolbar: {
    container: toolbarOptions,
    handlers: {
      image: () => selectFile('image/*'),
      video: () => selectFile('video/*'),
      attachment: () => selectFile('*'),
      table: function() {
        this.quill.getModule('table').insertTable(2, 3);
      }
    }
  }
}

const selectFile = (accept) => {
  const input = document.createElement('input');
  input.setAttribute('type', 'file');
  input.setAttribute('accept', accept);
  input.click();

  input.onchange = async () => {
    const file = input.files[0];
    if (!file) return;

    const formData = new FormData();
    formData.append('file', file);

    try {
      const res = await api.post('/upload', formData, {
        headers: { 'Content-Type': 'multipart/form-data' }
      });
      
      const url = res.data.url;
      const quill = quillRef.value.getQuill();
      const range = quill.getSelection(true);

      if (file.type.startsWith('image/')) {
        quill.insertEmbed(range.index, 'image', url);
      } else if (file.type.startsWith('video/')) {
        quill.insertEmbed(range.index, 'video', url);
      } else {
        quill.insertText(range.index, `📎 ${file.name} `, {
          'link': url,
          'bold': true,
          'color': '#2980b9'
        });
      }
      quill.setSelection(range.index + 1);
    } catch (error) {
      alert('Lỗi khi tải file lên');
    }
  };
};

const addTooltips = () => {
  const tooltips = {
    'ql-bold': 'In đậm', 'ql-italic': 'In nghiêng', 'ql-underline': 'Gạch chân', 'ql-strike': 'Gạch ngang',
    'ql-blockquote': 'Trích dẫn', 'ql-code-block': 'Chèn mã', 'ql-list[value="ordered"]': 'Số thứ tự',
    'ql-list[value="bullet"]': 'Dấu chấm', 'ql-indent[value="-1"]': 'Giảm thụt lề', 'ql-indent[value="+1"]': 'Tăng thụt lề',
    'ql-color': 'Màu chữ', 'ql-background': 'Màu nền', 'ql-align': 'Căn lề', 'ql-link': 'Liên kết',
    'ql-image': 'Ảnh', 'ql-video': 'Video', 'ql-table': 'Chèn bảng', 'ql-attachment': 'Đính kèm tệp tin', 'ql-clean': 'Xóa định dạng'
  };
  for (let key in tooltips) {
    const els = document.querySelectorAll(`.admin-create-thread .${key}`);
    els.forEach(el => el.setAttribute('title', tooltips[key]));
  }

  const attachBtn = document.querySelector('.admin-create-thread .ql-attachment');
  if (attachBtn) {
    attachBtn.innerHTML = '<svg viewBox="0 0 24 24" style="width:18px;height:18px;"><path fill="currentColor" d="M16.5,6V17.5A4,4 0 0,1 12.5,21.5A4,4 0 0,1 8.5,17.5V5A2.5,2.5 0 0,1 11,2.5A2.5,2.5 0 0,1 13.5,5V15.5A1,1 0 0,1 12.5,16.5A1,1 0 0,1 11.5,15.5V6H10V15.5A2.5,2.5 0 0,0 12.5,18A2.5,2.5 0 0,0 15,15.5V5A4,4 0 0,0 11,1A4,4 0 0,0 7,5V17.5A5.5,5.5 0 0,0 12.5,23A5.5,5.5 0 0,0 18,17.5V6H16.5Z" /></svg>';
  }
};

const fetchCategories = async () => {
  const response = await api.get('/categories')
  categories.value = response.data
}

const handlePost = async () => {
  if (!form.value.title || !form.value.content || !form.value.categoryId) {
    alert('Vui lòng điền đầy đủ thông tin');
    return;
  }
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
              ref="quillRef"
              v-model:content="form.content" 
              contentType="html" 
              theme="snow" 
              :modules="modules"
              placeholder="Nhập nội dung bài viết..."
              style="height: 500px;"
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

:deep(.ql-editor) {
  font-size: 16px;
}
:deep(.ql-editor table) {
  border-collapse: collapse;
  width: 100%;
}
:deep(.ql-editor td) {
  border: 1px solid #ccc;
  padding: 8px;
}
</style>
