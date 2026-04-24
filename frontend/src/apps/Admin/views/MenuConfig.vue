<template>
  <div class="page-content">
    <div class="card filter-card">
      <div class="filter-row">
        <div class="filter-item">
          <label>Tìm kiếm menu:</label>
          <input placeholder="Nhập tiêu đề menu...">
        </div>
        <div class="filter-actions">
          <button class="btn-search">Tìm kiếm</button>
          <button @click="openAddModal" class="btn-add">+ Thêm Menu</button>
        </div>
      </div>
    </div>

    <div class="card table-card">
      <div class="card-header">Danh sách Menu trên Header</div>
      <table class="data-table">
        <thead>
          <tr>
            <th>Thứ tự</th>
            <th>Tiêu đề</th>
            <th>Đường dẫn (URL)</th>
            <th>Trạng thái</th>
            <th class="text-center">Thao tác</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="menu in menus" :key="menu.id">
            <td>{{ menu.positionOrder }}</td>
            <td><strong>{{ menu.title }}</strong></td>
            <td><code>{{ menu.url }}</code></td>
            <td>
              <span :class="['badge', menu.active ? 'badge-success' : 'badge-danger']">
                {{ menu.active ? 'Bật' : 'Tắt' }}
              </span>
            </td>
            <td class="actions">
              <button @click="openEditModal(menu)" class="action-btn edit-btn">✎</button>
              <button @click="deleteMenu(menu.id)" class="action-btn delete-btn">🗑</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

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

export default {
  name: 'MenuConfig',
  data() {
    return {
      menus: [],
      loading: false,
      showModal: false,
      isEditing: false,
      form: { id: null, title: '', url: '', positionOrder: 0, active: true }
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
      if (this.isEditing) {
        await AdminService.updateMenu(this.form.id, this.form)
      } else {
        await AdminService.createMenu(this.form)
      }
      this.showModal = false
      this.fetchMenus()
    },
    async deleteMenu(id) {
      if (confirm('Xác nhận xóa menu này?')) {
        await AdminService.deleteMenu(id)
        this.fetchMenus()
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
.filter-card { padding: 1.5rem; margin-bottom: 1.5rem; }
.filter-row { display: flex; align-items: flex-end; gap: 2rem; }
.filter-item { flex: 1; }
.filter-item label { display: block; margin-bottom: 0.5rem; font-weight: bold; }
.filter-item input { width: 100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 4px; }
.btn-search { background: #34495e; color: white; border: none; padding: 0.75rem 1.5rem; border-radius: 4px; cursor: pointer; }
.btn-add { background: #27ae60; color: white; border: none; padding: 0.75rem 1.5rem; border-radius: 4px; cursor: pointer; font-weight: bold; }
.table-card { padding: 0; }
.data-table { width: 100%; border-collapse: collapse; }
.data-table th { background: #f8f9fa; padding: 1rem; text-align: left; border-bottom: 2px solid #eee; }
.data-table td { padding: 1rem; border-bottom: 1px solid #eee; }
.badge { padding: 4px 8px; border-radius: 12px; font-size: 0.75rem; font-weight: bold; }
.badge-success { background: #d4edda; color: #155724; }
.badge-danger { background: #f8d7da; color: #721c24; }
.actions { text-align: center; display: flex; justify-content: center; gap: 10px; }
.action-btn { width: 32px; height: 32px; border: none; border-radius: 4px; cursor: pointer; }
.edit-btn { background: #e3f2fd; color: #1976d2; }
.delete-btn { background: #ffebee; color: #c62828; }
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
