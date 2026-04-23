<script setup>
import { ref, onMounted } from 'vue'
import api from '../../api'

const threads = ref([])
const categories = ref([])
const loading = ref(false)
const filter = ref({ categoryId: '', title: '' })

// Modal state
const showModal = ref(false)
const form = ref({ title: '', content: '', categoryId: '', pinned: false })

const fetchCategories = async () => {
  const response = await api.get('/categories')
  categories.value = response.data
}

const openAddModal = () => {
  form.value = { title: '', content: '', categoryId: '', pinned: false }
  showModal.value = true
}

const handleSubmit = async () => {
  try {
    const payload = {
      title: form.value.title,
      content: form.value.content,
      category: { id: form.value.categoryId },
      pinned: form.value.pinned
    }
    await api.post('/threads', payload)
    showModal.value = false
    fetchThreads()
  } catch (error) {
    alert('Lỗi khi đăng bài viết')
  }
}

const fetchThreads = async () => {
  loading.value = true
  const params = {}
  if (filter.value.categoryId) params.categoryId = filter.value.categoryId
  
  const response = await api.get('/threads', { params })
  threads.value = response.data
  loading.value = false
}

const deleteThread = async (id) => {
  if (confirm('Bạn có chắc chắn muốn xóa bài viết này?')) {
    await api.delete(`/threads/${id}`)
    fetchThreads()
  }
}

const togglePin = async (id) => {
  await api.patch(`/threads/${id}/pin`)
  fetchThreads()
}

const formatDate = (dateStr) => {
  return new Date(dateStr).toLocaleString('vi-VN')
}

onMounted(() => {
  fetchCategories()
  fetchThreads()
})
</script>

<template>
  <div class="page-content">
    <div class="card filter-card">
      <div class="filter-row">
        <div class="filter-item">
          <label>Chuyên mục:</label>
          <select v-model="filter.categoryId" @change="fetchThreads">
            <option value="">Tất cả chuyên mục</option>
            <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
          </select>
        </div>
        <div class="filter-item">
          <label>Tìm kiếm tiêu đề:</label>
          <input v-model="filter.title" placeholder="Nhập tiêu đề bài viết...">
        </div>
        <div class="filter-actions">
          <button @click="fetchThreads" class="btn-search">Lọc dữ liệu</button>
          <button @click="$router.push('/admin/threads/create')" class="btn-add">+ Đăng bài mới</button>
        </div>
      </div>
    </div>

    <div class="card table-card">
      <div class="card-header">Quản lý bài viết diễn đàn</div>
      <table class="data-table">
        <thead>
          <tr>
            <th>Tiêu đề</th>
            <th>Tác giả</th>
            <th>Chuyên mục</th>
            <th>Ngày đăng</th>
            <th>Lượt xem</th>
            <th class="text-center">Thao tác</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="thread in threads" :key="thread.id">
            <td>
              <span v-if="thread.pinned" class="badge badge-warning" style="margin-right: 5px;">GHIM</span>
              <strong>{{ thread.title }}</strong>
            </td>
            <td>{{ thread.author ? thread.author.username : 'Ẩn danh' }}</td>
            <td><span class="category-tag">{{ thread.category ? thread.category.name : 'N/A' }}</span></td>
            <td>{{ formatDate(thread.createdAt) }}</td>
            <td>{{ thread.viewCount }}</td>
            <td class="actions">
              <button @click="togglePin(thread.id)" class="action-btn" :title="thread.pinned ? 'Bỏ ghim' : 'Ghim bài'">
                {{ thread.pinned ? '📍' : '📌' }}
              </button>
              <button @click="deleteThread(thread.id)" class="action-btn delete-btn" title="Xóa">🗑</button>
            </td>
          </tr>
        </tbody>
      </table>

      <div v-if="threads.length === 0" style="padding: 3rem; text-align: center; color: #999;">
        Không tìm thấy bài viết nào.
      </div>
    </div>
  </div>
</template>

<style scoped>
.filter-card { padding: 1.5rem; margin-bottom: 1.5rem; }
.filter-row { display: flex; align-items: flex-end; gap: 2rem; }
.filter-item { flex: 1; }
.filter-item label { display: block; margin-bottom: 0.5rem; font-weight: bold; }
.filter-item input, .filter-item select { width: 100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 4px; }

.btn-search { background: #34495e; color: white; border: none; padding: 0.75rem 2rem; border-radius: 4px; cursor: pointer; }
.btn-add { background: #27ae60; color: white; border: none; padding: 0.75rem 1.5rem; border-radius: 4px; cursor: pointer; margin-left: 10px; font-weight: bold; }

.table-card { padding: 0; }
.data-table { width: 100%; border-collapse: collapse; }
.data-table th { background: #f8f9fa; padding: 1rem; text-align: left; border-bottom: 2px solid #eee; }
.data-table td { padding: 1rem; border-bottom: 1px solid #eee; font-size: 0.9rem; }

.badge-warning { background: #fff3cd; color: #856404; border: 1px solid #ffeeba; }
.category-tag { background: #e8f4fd; color: #007bff; padding: 2px 8px; border-radius: 4px; font-size: 0.8rem; }

.actions { display: flex; justify-content: center; gap: 10px; }
.action-btn { background: none; border: 1px solid #ddd; border-radius: 4px; padding: 4px 8px; cursor: pointer; }
.delete-btn { color: #e74c3c; border-color: #f8d7da; }

/* Modal */
.modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); display: flex; align-items: center; justify-content: center; z-index: 1000; }
.modal-card { background: white; border-radius: 8px; box-shadow: 0 10px 25px rgba(0,0,0,0.2); overflow: hidden; }
.admin-form { padding: 1.5rem; }
.form-group { margin-bottom: 1.5rem; }
.form-group label { display: block; margin-bottom: 0.5rem; font-weight: bold; color: #333; }
.form-group input, .form-group select, .form-group textarea { 
    width: 100%; 
    padding: 0.75rem; 
    border: 1px solid #ddd; 
    border-radius: 4px; 
    font-family: inherit;
}
.checkbox-group { display: flex; align-items: center; gap: 10px; }
.checkbox-group input { width: auto; }
.modal-footer { display: flex; justify-content: flex-end; gap: 10px; margin-top: 1.5rem; }
.btn-save { background: #27ae60; color: white; border: none; padding: 0.75rem 2rem; border-radius: 4px; cursor: pointer; font-weight: bold; }
.btn-cancel { background: #95a5a6; color: white; border: none; padding: 0.75rem 1.5rem; border-radius: 4px; cursor: pointer; }
</style>
