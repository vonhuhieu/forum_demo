<template>
  <div class="page-content">
    <DataTable
      title="Danh sách Menu trên Header"
      placeholder="Tìm kiếm tiêu đề menu, URL..."
      addButtonLabel="Thêm Menu"
      :headers="headers"
      :items="displayMenus"
      :totalItems="filteredMenus.length"
      v-model:pageSize="pageSize"
      v-model:currentPage="currentPage"
      :loading="loading"
      @search="handleSearch"
      @add="openAddModal"
      @edit="openEditModal"
      @delete="deleteMenu"
      @view="openEditModal"
    >
      <template #item-title="{ item }">
        <strong>{{ item.title }}</strong>
      </template>

      <template #item-url="{ item }">
        <code>{{ item.url }}</code>
      </template>

      <template #item-active="{ item }">
        <span :class="['badge', item.active ? 'badge-success' : 'badge-danger']">
          {{ item.active ? 'Bật' : 'Tắt' }}
        </span>
      </template>
    </DataTable>

    <!-- Modal Form -->
    <div v-if="showModal" class="modal-overlay">
      <div class="modal-card">
        <div class="card-header">{{ isEditing ? 'CẬP NHẬT MENU' : 'THÊM MENU MỚI' }}</div>
        <form @submit.prevent="handleSubmit" class="admin-form">
          <div class="form-group">
            <label>Tiêu đề:</label>
            <input v-model="form.title" required>
          </div>
          <div class="form-group">
            <label>Đường dẫn (URL):</label>
            <input v-model="form.url" required>
          </div>
          <div class="form-group">
            <label>Thứ tự hiển thị:</label>
            <input type="number" v-model="form.positionOrder">
          </div>
          <div class="form-group checkbox-group">
            <input type="checkbox" v-model="form.active" id="m-active">
            <label for="m-active">Kích hoạt hiển thị</label>
          </div>
          <div class="modal-footer">
            <button type="button" @click="showModal = false" class="btn-cancel">Đóng</button>
            <button type="submit" class="btn-save">Lưu lại</button>
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
  name: 'MenuConfig',
  components: { DataTable },
  data() {
    return {
      menus: [],
      loading: false,
      keyword: '',
      pageSize: 10,
      currentPage: 1,
      showModal: false,
      isEditing: false,
      headers: [
        { text: 'Thứ tự', value: 'positionOrder', sortable: true, width: '100px' },
        { text: 'Tiêu đề', value: 'title', sortable: true },
        { text: 'Đường dẫn (URL)', value: 'url', sortable: true },
        { text: 'Trạng thái', value: 'active', sortable: true, width: '120px' }
      ],
      form: { id: null, title: '', url: '', positionOrder: 0, active: true }
    }
  },
  computed: {
    filteredMenus() {
      if (!this.keyword) return this.menus
      const k = this.keyword.toLowerCase()
      return this.menus.filter(m => 
        (m.title && m.title.toLowerCase().includes(k)) ||
        (m.url && m.url.toLowerCase().includes(k))
      )
    },
    displayMenus() {
      const start = (this.currentPage - 1) * this.pageSize
      const end = start + this.pageSize
      return this.filteredMenus.slice(start, end)
    }
  },
  mounted() {
    this.fetchMenus()
  },
  methods: {
    async fetchMenus() {
      this.loading = true
      const response = await AdminService.getMenus()
      this.menus = response.data
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
          await AdminService.updateMenu(this.form.id, this.form)
          toastSuccess('Cập nhật menu thành công')
        } else {
          await AdminService.createMenu(this.form)
          toastSuccess('Thêm menu thành công')
        }
        this.showModal = false
        this.fetchMenus()
      } catch (error) {
        toastError('Lỗi khi lưu dữ liệu')
      }
    },
    async deleteMenu(item) {
      const result = await alertConfirm('Xóa menu', `Bạn có chắc chắn muốn xóa menu "${item.title}"?`)
      if (result.isConfirmed) {
        try {
          await AdminService.deleteMenu(item.id)
          toastSuccess('Đã xóa menu')
          this.fetchMenus()
        } catch (error) {
          toastError('Lỗi khi xóa menu')
        }
      }
    },
    resetForm() {
      this.form = { id: null, title: '', url: '', positionOrder: 0, active: true }
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
.modal-card { background: white; width: 450px; border-radius: 8px; }
.admin-form { padding: 1.5rem; }
.form-group { margin-bottom: 1rem; }
.form-group label { display: block; margin-bottom: 0.5rem; font-weight: bold; }
.form-group input { width: 100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 4px; }
.checkbox-group { display: flex; align-items: center; gap: 10px; }
.checkbox-group input { width: auto; }
.modal-footer { display: flex; justify-content: flex-end; gap: 10px; margin-top: 1.5rem; }
.btn-save { background: #27ae60; color: white; border: none; padding: 0.75rem 2rem; border-radius: 4px; cursor: pointer; }
.btn-cancel { background: #95a5a6; color: white; border: none; padding: 0.75rem 1.5rem; border-radius: 4px; cursor: pointer; }
</style>

