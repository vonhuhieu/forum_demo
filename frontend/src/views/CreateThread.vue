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
const quillRef = ref(null)

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
  blotFormatter: {}, // Enable resizing and alignment
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
    'ql-table': 'Chèn bảng',
    'ql-attachment': 'Đính kèm tệp tin (PDF, Word, Excel...)',
    'ql-clean': 'Xóa định dạng'
  };
  
  for (let key in tooltips) {
    const els = document.querySelectorAll(`.${key}`);
    els.forEach(el => el.setAttribute('title', tooltips[key]));
  }

  const attachBtn = document.querySelector('.ql-attachment');
  if (attachBtn) {
    attachBtn.innerHTML = '<svg viewBox="0 0 24 24" style="width:18px;height:18px;"><path fill="currentColor" d="M16.5,6V17.5A4,4 0 0,1 12.5,21.5A4,4 0 0,1 8.5,17.5V5A2.5,2.5 0 0,1 11,2.5A2.5,2.5 0 0,1 13.5,5V15.5A1,1 0 0,1 12.5,16.5A1,1 0 0,1 11.5,15.5V6H10V15.5A2.5,2.5 0 0,0 12.5,18A2.5,2.5 0 0,0 15,15.5V5A4,4 0 0,0 11,1A4,4 0 0,0 7,5V17.5A5.5,5.5 0 0,0 12.5,23A5.5,5.5 0 0,0 18,17.5V6H16.5Z" /></svg>';
  }
};

const fetchCategory = async () => {
  if (!catId.value) return
  const response = await api.get('/categories')
  category.value = response.data.find(c => c.id == catId.value)
}

const handlePost = async () => {
  if (!title.value || !content.value) {
    alert('Vui lòng nhập đầy đủ tiêu đề và nội dung');
    return;
  }
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
  setTimeout(addTooltips, 500);
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
            ref="quillRef"
            v-model:content="content" 
            contentType="html" 
            theme="snow" 
            :modules="modules"
            placeholder="Viết nội dung bài viết vào đây..."
            style="height: 500px;"
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
  padding: 12px 35px;
  border-radius: 4px;
  font-weight: bold;
  cursor: pointer;
  transition: background 0.3s;
}
.btn-post:hover { background-color: #2980b9; }
.btn-cancel {
  background-color: #ecf0f1;
  color: #333;
  border: none;
  padding: 12px 25px;
  border-radius: 4px;
  cursor: pointer;
}

:deep(.ql-editor) {
  font-size: 16px;
  line-height: 1.6;
}

:deep(.ql-editor table) {
  border-collapse: collapse;
  margin: 0;
  padding: 0;
  width: 100%;
}
:deep(.ql-editor td) {
  border: 1px solid #ccc;
  padding: 8px;
}

:deep(.ql-toolbar button:hover) {
  position: relative;
}
</style>
