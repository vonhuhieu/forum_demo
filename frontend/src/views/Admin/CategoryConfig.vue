<script setup>
import { ref, onMounted } from 'vue'
import api from '../../api'

const categories = ref([])
const loading = ref(false)
const filter = ref({ name: '' })

// Form state
const showModal = ref(false)
const isEditing = ref(false)
const form = ref({ id: null, name: '', description: '', positionOrder: 0, active: true })

const fetchCategories = async () => {
  loading.value = true
  const response = await api.get('/categories')
  categories.value = response.data
  loading.value = false
}

const openAddModal = () => {
  resetForm()
  showModal.value = true
}

const openEditModal = (item) => {
  form.value = { ...item }
  isEditing.value = true
  showModal.value = true
}

const handleSubmit = async () => {
  if (isEditing.value) {
    await api.put(`/categories/${form.value.id}`, form.value)
  } else {
    await api.post('/categories', form.value)
  }
  showModal.value = false
  fetchCategories()
}

const deleteCategory = async (id) => {
  if (confirm('Bạn có chắc chắn muốn xóa?')) {
    await api.delete(`/categories/${id}`)
    fetchCategories()
  }
}

const resetForm = () => {
  form.value = { id: null, name: '', description: '', positionOrder: 0, active: true }
  isEditing.value = false
}

onMounted(fetchCategories)
</script>

<template>
  <div class="page-content">
    <!-- Filter Section -->
    <div class="card filter-card">
      <div class="filter-row">
        <div class="filter-item">
          <label>Tìm kiếm tên:</label>
          <input v-model="filter.name" placeholder="Nhập tên chuyên mục...">
        </div>
        <div class="filter-actions">
          <button @click="fetchCategories" class="btn-search">Tìm kiếm</button>
          <button @click="openAddModal" class="btn-add">+ Thêm mới</button>
        </div>
      </div>
    </div>

    <!-- Data Table Section -->
    <div class="card table-card">
      <div class="card-header">Danh sách chuyên mục diễn đàn</div>
      <table class="data-table">
        <thead>
          <tr>
            <th>STT</th>
            <th>Tên chuyên mục</th>
            <th>Mô tả</th>
            <th>Thứ tự</th>
            <th>Trạng thái</th>
            <th class="text-center">Thao tác</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(cat, index) in categories" :key="cat.id">
            <td>{{ index + 1 }}</td>
            <td><strong>{{ cat.name }}</strong></td>
            <td>{{ cat.description }}</td>
            <td>{{ cat.positionOrder }}</td>
            <td>
              <span :class="['badge', cat.active ? 'badge-success' : 'badge-danger']">
                {{ cat.active ? 'Hoạt động' : 'Tắt' }}
              </span>
            </td>
            <td class="actions">
              <button @click="openEditModal(cat)" title="Sửa" class="action-btn edit-btn">✎</button>
              <button @click="deleteCategory(cat.id)" title="Xóa" class="action-btn delete-btn">🗑</button>
            </td>
          </tr>
        </tbody>
      </table>
      
      <!-- Pagination (Mock) -->
      <div class="pagination">
        <span>Hiển thị kết quả từ 1 đến {{ categories.length }} của {{ categories.length }} kết quả</span>
        <div class="page-numbers">
          <button disabled>←</button>
          <button class="active">1</button>
          <button disabled>→</button>
        </div>
      </div>
    </div>

    <!-- Modal Form (Simple Overlay) -->
    <div v-if="showModal" class="modal-overlay">
      <div class="modal-card">
        <div class="card-header">{{ isEditing ? 'CẬP NHẬT CHUYÊN MỤC' : 'THÊM CHUYÊN MỤC MỚI' }}</div>
        <form @submit.prevent="handleSubmit" class="admin-form">
          <div class="form-group">
            <label>Tên chuyên mục:</label>
            <input v-model="form.name" required>
          </div>
          <div class="form-group">
            <label>Mô tả:</label>
            <textarea v-model="form.description" rows="3"></textarea>
          </div>
          <div class="form-group">
            <label>Thứ tự hiển thị:</label>
            <input type="number" v-model="form.positionOrder">
          </div>
          <div class="modal-footer">
            <button type="button" @click="showModal = false" class="btn-cancel">Đóng</button>
            <button type="submit" class="btn-save">{{ isEditing ? 'Cập nhật' : 'Lưu lại' }}</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<style scoped>
.filter-card { padding: 1.5rem; margin-bottom: 1.5rem; }
.filter-row { display: flex; align-items: flex-end; gap: 2rem; }
.filter-item { flex: 1; }
.filter-item label { display: block; margin-bottom: 0.5rem; font-weight: bold; color: #555; }
.filter-item input { width: 100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 4px; }

.btn-search { background: #34495e; color: white; border: none; padding: 0.75rem 1.5rem; border-radius: 4px; cursor: pointer; }
.btn-add { background: #27ae60; color: white; border: none; padding: 0.75rem 1.5rem; border-radius: 4px; cursor: pointer; margin-left: 10px; font-weight: bold; }

/* Table */
.table-card { padding: 0; overflow: hidden; }
.data-table { width: 100%; border-collapse: collapse; }
.data-table th { background: #f8f9fa; padding: 1rem; text-align: left; border-bottom: 2px solid #eee; color: #1a507a; }
.data-table td { padding: 1rem; border-bottom: 1px solid #eee; }

.badge { padding: 4px 8px; border-radius: 12px; font-size: 0.75rem; font-weight: bold; }
.badge-success { background: #d4edda; color: #155724; }
.badge-danger { background: #f8d7da; color: #721c24; }

.actions { text-align: center; display: flex; justify-content: center; gap: 10px; }
.action-btn { width: 32px; height: 32px; border: none; border-radius: 4px; cursor: pointer; font-size: 1rem; }
.edit-btn { background: #e3f2fd; color: #1976d2; }
.delete-btn { background: #ffebee; color: #c62828; }

.pagination { padding: 1rem; display: flex; justify-content: space-between; align-items: center; background: #f9f9f9; font-size: 0.85rem; color: #666; }
.page-numbers button { padding: 4px 10px; margin-left: 5px; border: 1px solid #ddd; background: white; cursor: pointer; }
.page-numbers button.active { background: #1a507a; color: white; border-color: #1a507a; }

/* Modal */
.modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); display: flex; align-items: center; justify-content: center; z-index: 1000; }
.modal-card { background: white; width: 500px; border-radius: 8px; overflow: hidden; }
.admin-form { padding: 1.5rem; }
.form-group { margin-bottom: 1rem; }
.form-group label { display: block; margin-bottom: 0.5rem; font-weight: bold; }
.form-group input, .form-group textarea { width: 100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 4px; }
.modal-footer { display: flex; justify-content: flex-end; gap: 10px; margin-top: 1.5rem; }
.btn-save { background: #27ae60; color: white; border: none; padding: 0.75rem 2rem; border-radius: 4px; cursor: pointer; font-weight: bold; }
.btn-cancel { background: #95a5a6; color: white; border: none; padding: 0.75rem 1.5rem; border-radius: 4px; cursor: pointer; }
</style>
