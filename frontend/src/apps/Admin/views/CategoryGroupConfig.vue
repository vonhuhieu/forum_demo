<template>
  <div class="page-content">
    <DataTable
      title="Quản lý Nhóm & Chuyên mục"
      placeholder="Tìm kiếm tên nhóm..."
      addButtonLabel="Thêm nhóm mới"
      :headers="headers"
      :items="displayGroups"
      :totalItems="filteredGroups.length"
      v-model:pageSize="pageSize"
      v-model:currentPage="currentPage"
      :loading="loading"
      @search="handleSearch"
      @add="openAddModal"
      @edit="openEditModal"
      @delete="deleteGroup"
      @view="openEditModal"
      @sort="handleSort"
    >
      <template #extra-actions="{ item }">
        <button class="action-btn cat-btn" @click="openCategoryModal(item)" title="Quản lý chuyên mục">📁</button>
      </template>

      <template #item-name="{ item }">
        <strong>{{ item.name }}</strong>
      </template>

      <template #item-active="{ item }">
        <span :class="['badge', item.active ? 'badge-success' : 'badge-danger']">
          {{ item.active ? 'Hoạt động' : 'Tắt' }}
        </span>
      </template>
    </DataTable>

    <!-- Modal Form Nhóm -->
    <div v-if="showModal" class="modal-overlay">
      <div class="modal-card">
        <div class="card-header">{{ isEditing ? 'CẬP NHẬT NHÓM' : 'THÊM NHÓM MỚI' }}</div>
        <form @submit.prevent="handleSubmit" class="admin-form">
          <div class="form-group">
            <label>Tên nhóm:</label>
            <input v-model="form.name" required>
          </div>
          <div class="form-group">
            <label>Thứ tự hiển thị:</label>
            <input type="number" v-model="form.positionOrder">
          </div>
          <div class="form-group checkbox-group">
            <input type="checkbox" v-model="form.active" id="g-active">
            <label for="g-active">Kích hoạt</label>
          </div>
          <div class="modal-footer">
            <button type="button" @click="showModal = false" class="btn-cancel">Đóng</button>
            <button type="submit" class="btn-save">{{ isEditing ? 'Cập nhật' : 'Lưu lại' }}</button>
          </div>
        </form>
      </div>
    </div>

    <!-- Modal Quản lý Chuyên mục con -->
    <div v-if="showCategoryModal" class="modal-overlay">
      <div class="modal-card category-modal">
        <div class="card-header">
          CHUYÊN MỤC THUỘC NHÓM: {{ selectedGroup?.name }}
        </div>
        
        <div class="category-manager-content">
          <div class="category-toolbar">
            <button class="btn-add-sub" @click="openAddCategory">+ Thêm chuyên mục</button>
          </div>

          <table class="sub-table">
            <thead>
              <tr>
                <th>Tên chuyên mục</th>
                <th>Thứ tự</th>
                <th>Trạng thái</th>
                <th width="120">Thao tác</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="cat in selectedGroup?.categories" :key="cat.id">
                <td>{{ cat.name }}</td>
                <td>{{ cat.positionOrder }}</td>
                <td>
                  <span :class="['badge', cat.active ? 'badge-success' : 'badge-danger']">
                    {{ cat.active ? 'Bật' : 'Tắt' }}
                  </span>
                </td>
                <td class="actions">
                  <button class="btn-icon-edit" @click="openEditCategory(cat)">✏️</button>
                  <button class="btn-icon-delete" @click="deleteCategory(cat)">🗑️</button>
                </td>
              </tr>
              <tr v-if="!selectedGroup?.categories || selectedGroup.categories.length === 0">
                <td colspan="4" class="text-center">Chưa có chuyên mục nào</td>
              </tr>
            </tbody>
          </table>
        </div>

        <div class="modal-footer">
          <button type="button" @click="showCategoryModal = false" class="btn-cancel">Đóng</button>
        </div>
      </div>
    </div>

    <!-- Modal Form Chuyên mục -->
    <div v-if="showCatFormModal" class="modal-overlay sub-modal">
      <div class="modal-card sub-card">
        <div class="card-header">{{ isEditingCat ? 'SỬA CHUYÊN MỤC' : 'THÊM CHUYÊN MỤC' }}</div>
        <form @submit.prevent="handleCatSubmit" class="admin-form">
          <div class="form-group">
            <label>Tên chuyên mục:</label>
            <input v-model="catForm.name" required>
          </div>
          <div class="form-group">
            <label>Mô tả:</label>
            <textarea v-model="catForm.description" rows="2"></textarea>
          </div>
          <div class="form-group">
            <label>Thứ tự:</label>
            <input type="number" v-model="catForm.positionOrder">
          </div>
          <div class="form-group">
            <label>Chuyên mục cha (nếu có):</label>
            <select v-model="catForm.parentCategoryId" class="form-select">
              <option :value="null">-- Cấp cao nhất --</option>
              <option v-for="c in selectedGroup?.categories" :key="c.id" :value="c.id" v-show="c.id !== catForm.id">
                {{ c.name }}
              </option>
            </select>
          </div>
          <div class="form-group checkbox-group">
            <input type="checkbox" v-model="catForm.active" id="c-active">
            <label for="c-active">Kích hoạt</label>
          </div>
          <div class="modal-footer">
            <button type="button" @click="showCatFormModal = false" class="btn-cancel">Hủy</button>
            <button type="submit" class="btn-save">Lưu</button>
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
  name: 'CategoryGroupConfig',
  components: { DataTable },
  data() {
    return {
      groups: [],
      loading: false,
      keyword: '',
      pageSize: 10,
      currentPage: 1,
      
      // Group Modal
      showModal: false,
      isEditing: false,
      headers: [
        { text: 'Tên nhóm', value: 'name', sortable: true },
        { text: 'Thứ tự', value: 'positionOrder', sortable: true, width: '100px' },
        { text: 'Trạng thái', value: 'active', sortable: true, width: '120px' }
      ],
      form: { id: null, name: '', positionOrder: 0, active: true },
      
      // Category Modal
      showCategoryModal: false,
      selectedGroup: null,
      showCatFormModal: false,
      isEditingCat: false,
      catForm: { id: null, name: '', description: '', positionOrder: 0, active: true, categoryGroupId: null, parentCategoryId: null },
      
      sortField: 'positionOrder',
      sortOrder: 'asc'
    }
  },
  computed: {
    filteredGroups() {
      let result = this.groups
      if (this.keyword) {
        const k = this.keyword.toLowerCase()
        result = result.filter(g => g.name && g.name.toLowerCase().includes(k))
      }
      if (this.sortField) {
        result = [...result].sort((a, b) => {
          let valA = a[this.sortField]
          let valB = b[this.sortField]
          if (typeof valA === 'string') valA = valA.toLowerCase()
          if (typeof valB === 'string') valB = valB.toLowerCase()
          if (valA < valB) return this.sortOrder === 'asc' ? -1 : 1
          if (valA > valB) return this.sortOrder === 'asc' ? 1 : -1
          return 0
        })
      }
      return result
    },
    displayGroups() {
      const start = (this.currentPage - 1) * this.pageSize
      const end = start + this.pageSize
      return this.filteredGroups.slice(start, end)
    }
  },
  mounted() {
    this.fetchGroups()
  },
  methods: {
    async fetchGroups() {
      this.loading = true
      try {
        const response = await AdminService.getCategoryGroups()
        this.groups = response.data
        // Update selected group if category modal is open
        if (this.showCategoryModal && this.selectedGroup) {
          this.selectedGroup = this.groups.find(g => g.id === this.selectedGroup.id)
        }
      } catch (error) {
        console.error('Lỗi khi tải nhóm chuyên mục:', error)
      } finally {
        this.loading = false
      }
    },
    handleSearch(k) {
      this.keyword = k
      this.currentPage = 1
    },
    handleSort({ field, order }) {
      this.sortField = field
      this.sortOrder = order
    },
    
    // Group Actions
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
          await AdminService.updateCategoryGroup(this.form.id, this.form)
          toastSuccess('Cập nhật nhóm thành công')
        } else {
          await AdminService.createCategoryGroup(this.form)
          toastSuccess('Thêm nhóm thành công')
        }
        this.showModal = false
        this.fetchGroups()
      } catch (error) {
        toastError('Lỗi khi lưu dữ liệu')
      }
    },
    async deleteGroup(item) {
      const result = await alertConfirm('Xóa nhóm', `Bạn có chắc chắn muốn xóa nhóm "${item.name}"?`)
      if (result.isConfirmed) {
        try {
          await AdminService.deleteCategoryGroup(item.id)
          toastSuccess('Đã xóa nhóm')
          this.fetchGroups()
        } catch (error) {
          toastError('Lỗi khi xóa nhóm')
        }
      }
    },
    resetForm() {
      this.form = { id: null, name: '', positionOrder: 0, active: true }
      this.isEditing = false
    },

    // Category Management
    openCategoryModal(group) {
      this.selectedGroup = group
      this.showCategoryModal = true
    },
    openAddCategory() {
      this.catForm = { 
        id: null, name: '', description: '', positionOrder: 0, 
        active: true, categoryGroupId: this.selectedGroup.id, parentCategoryId: null 
      }
      this.isEditingCat = false
      this.showCatFormModal = true
    },
    openEditCategory(cat) {
      this.catForm = { ...cat, categoryGroupId: this.selectedGroup.id }
      this.isEditingCat = true
      this.showCatFormModal = true
    },
    async handleCatSubmit() {
      try {
        if (this.isEditingCat) {
          await AdminService.updateCategory(this.catForm.id, this.catForm)
          toastSuccess('Cập nhật chuyên mục thành công')
        } else {
          await AdminService.createCategory(this.catForm)
          toastSuccess('Thêm chuyên mục thành công')
        }
        this.showCatFormModal = false
        this.fetchGroups()
      } catch (e) {
        toastError('Lỗi khi lưu chuyên mục')
      }
    },
    async deleteCategory(cat) {
      const result = await alertConfirm('Xóa chuyên mục', `Xóa chuyên mục "${cat.name}" sẽ xóa tất cả bài viết bên trong. Bạn có chắc chắn?`)
      if (result.isConfirmed) {
        try {
          await AdminService.deleteCategory(cat.id)
          toastSuccess('Đã xóa chuyên mục')
          this.fetchGroups()
        } catch (e) {
          toastError('Lỗi khi xóa chuyên mục')
        }
      }
    }
  }
}
</script>

<style scoped>
.badge { padding: 4px 8px; border-radius: 12px; font-size: 0.75rem; font-weight: bold; }
.badge-success { background: #d4edda; color: #155724; }
.badge-danger { background: #f8d7da; color: #721c24; }

.modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); display: flex; align-items: center; justify-content: center; z-index: 1000; }
.sub-modal { z-index: 1001; background: rgba(0,0,0,0.3); }

.modal-card { background: white; width: 450px; border-radius: 8px; overflow: hidden; box-shadow: 0 5px 25px rgba(0,0,0,0.2); }
.category-modal { width: 800px; max-width: 95vw; }
.sub-card { width: 400px; }

.card-header { background: #1a507a; color: white; padding: 1rem; font-weight: bold; text-align: center; }
.admin-form { padding: 1.5rem; }
.form-group { margin-bottom: 1rem; }
.form-group label { display: block; margin-bottom: 0.5rem; font-weight: bold; }
.form-group input, .form-group textarea, .form-select { width: 100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 4px; }
.checkbox-group { display: flex; align-items: center; gap: 10px; }
.checkbox-group input { width: auto; }

.modal-footer { display: flex; justify-content: flex-end; gap: 10px; padding: 1rem 1.5rem; border-top: 1px solid #eee; }
.btn-save { background: #27ae60; color: white; border: none; padding: 0.75rem 2rem; border-radius: 4px; cursor: pointer; font-weight: bold; }
.btn-cancel { background: #95a5a6; color: white; border: none; padding: 0.75rem 1.5rem; border-radius: 4px; cursor: pointer; }

/* Category Manager Styles */
.category-manager-content { padding: 1.5rem; }
.category-toolbar { margin-bottom: 1rem; display: flex; justify-content: flex-end; }
.btn-add-sub { background: #3498db; color: white; border: none; padding: 8px 15px; border-radius: 4px; cursor: pointer; font-weight: bold; }

.sub-table { width: 100%; border-collapse: collapse; }
.sub-table th { background: #f8f9fa; text-align: left; padding: 10px; border-bottom: 2px solid #dee2e6; }
.sub-table td { padding: 10px; border-bottom: 1px solid #eee; }
.text-center { text-align: center; }

.actions { display: flex; gap: 10px; }
.btn-icon-edit, .btn-icon-delete { background: none; border: none; cursor: pointer; font-size: 1.1rem; padding: 4px; border-radius: 4px; transition: background 0.2s; }
.btn-icon-edit:hover { background: #e3f2fd; }
.btn-icon-delete:hover { background: #ffebee; }

.cat-btn:hover { color: #f39c12; }
</style>
