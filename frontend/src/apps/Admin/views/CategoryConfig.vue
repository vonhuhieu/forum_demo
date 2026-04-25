<template>
  <div class="page-content">
    <DataTable
      title="Danh sách chuyên mục diễn đàn"
      placeholder="Tìm kiếm tên, mô tả..."
      addButtonLabel="Thêm chuyên mục"
      :headers="headers"
      :items="displayCategories"
      :totalItems="filteredCategories.length"
      v-model:pageSize="pageSize"
      v-model:currentPage="currentPage"
      :loading="loading"
      @search="handleSearch"
      @add="openAddModal"
      @edit="openEditModal"
      @delete="deleteCategory"
      @view="openEditModal"
    >
      <template #item-name="{ item }">
        <strong>{{ item.name }}</strong>
      </template>

      <template #item-active="{ item }">
        <span :class="['badge', item.active ? 'badge-success' : 'badge-danger']">
          {{ item.active ? 'Hoạt động' : 'Tắt' }}
        </span>
      </template>
    </DataTable>

    <!-- Modal Form -->
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

<script>
import AdminService from '@/apps/Admin/services/admin.service'
import DataTable from '@/shared/components/DataTable.vue'
import { alertConfirm, toastSuccess, toastError } from '@/shared/utils/swal'

export default {
  name: 'CategoryConfig',
  components: { DataTable },
  data() {
    return {
      categories: [],
      loading: false,
      keyword: '',
      pageSize: 10,
      currentPage: 1,
      showModal: false,
      isEditing: false,
      headers: [
        { text: 'Tên chuyên mục', value: 'name', sortable: true },
        { text: 'Mô tả', value: 'description', sortable: true },
        { text: 'Thứ tự', value: 'positionOrder', sortable: true, width: '100px' },
        { text: 'Trạng thái', value: 'active', sortable: true, width: '120px' }
      ],
      form: { id: null, name: '', description: '', positionOrder: 0, active: true }
    }
  },
  computed: {
    filteredCategories() {
      if (!this.keyword) return this.categories
      const k = this.keyword.toLowerCase()
      return this.categories.filter(c => 
        (c.name && c.name.toLowerCase().includes(k)) ||
        (c.description && c.description.toLowerCase().includes(k))
      )
    },
    displayCategories() {
      const start = (this.currentPage - 1) * this.pageSize
      const end = start + this.pageSize
      return this.filteredCategories.slice(start, end)
    }
  },
  mounted() {
    this.fetchCategories()
  },
  methods: {
    async fetchCategories() {
      this.loading = true
      const response = await AdminService.getCategories()
      this.categories = response.data
      this.loading = false
    },
    handleSearch(k) {
      this.keyword = k
      this.currentPage = 1
    },
    openAddModal() {
      this.resetForm()
      this.showModal = true
    },
    openEditModal(item) {
      this.form = { ...item }
      this.isEditing = true
      this.showModal = true
    },
    async handleSubmit() {
      try {
        if (this.isEditing) {
          await AdminService.updateCategory(this.form.id, this.form)
          toastSuccess('Cập nhật chuyên mục thành công')
        } else {
          await AdminService.createCategory(this.form)
          toastSuccess('Thêm chuyên mục thành công')
        }
        this.showModal = false
        this.fetchCategories()
      } catch (error) {
        toastError('Lỗi khi lưu dữ liệu')
      }
    },
    async deleteCategory(item) {
      const result = await alertConfirm('Xóa chuyên mục', `Bạn có chắc chắn muốn xóa chuyên mục "${item.name}"?`)
      if (result.isConfirmed) {
        try {
          await AdminService.deleteCategory(item.id)
          toastSuccess('Đã xóa chuyên mục')
          this.fetchCategories()
        } catch (error) {
          toastError('Lỗi khi xóa chuyên mục')
        }
      }
    },
    resetForm() {
      this.form = { id: null, name: '', description: '', positionOrder: 0, active: true }
      this.isEditing = false
    }
  }
}
</script>

<style scoped>
.badge { padding: 4px 8px; border-radius: 12px; font-size: 0.75rem; font-weight: bold; }
.badge-success { background: #d4edda; color: #155724; }
.badge-danger { background: #f8d7da; color: #721c24; }

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

