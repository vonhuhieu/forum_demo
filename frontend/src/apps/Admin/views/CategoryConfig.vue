<template>
  <div class="page-content">
    <DataTable
      :title="pageTitle"
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
      @sort="handleSort"
    >
      <template #extra-filters>
        <div class="filter-group-wrapper">
          <label>Nhóm:</label>
          <select v-model="filterGroupId" class="form-select-sm" :disabled="isFixedGroup">
            <option :value="null">-- Tất cả nhóm --</option>
            <option v-for="g in categoryGroups" :key="g.id" :value="g.id">{{ g.name }}</option>
          </select>
        </div>
      </template>

      <template #extra-actions="{ item }">
        <button class="action-btn sub-cat-btn" @click="openSubModal(item)" title="Quản lý chuyên mục con">📁</button>
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

    <!-- Modal Form Chuyên mục chính -->
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
          <div class="form-group">
            <label>Nhóm chuyên mục:</label>
            <select v-model="form.categoryGroupId" class="form-select" :disabled="isFixedGroup">
              <option :value="null">-- Không chọn --</option>
              <option v-for="g in categoryGroups" :key="g.id" :value="g.id">{{ g.name }}</option>
            </select>
          </div>
          <div class="modal-footer">
            <button type="button" @click="showModal = false" class="btn-cancel">Đóng</button>
            <button type="submit" class="btn-save">{{ isEditing ? 'Cập nhật' : 'Lưu lại' }}</button>
          </div>
        </form>
      </div>
    </div>

    <!-- Modal Quản lý Chuyên mục con (Sub-categories) -->
    <div v-if="showSubModal" class="modal-overlay">
      <div class="modal-card sub-manager-card">
        <div class="card-header">
          QUẢN LÝ CHUYÊN MỤC CON: {{ selectedParentCategory?.name }}
        </div>
        
        <div class="sub-manager-content">
          <DataTable
            placeholder="Tìm kiếm chuyên mục con..."
            addButtonLabel="Thêm chuyên mục con"
            :headers="subHeaders"
            :items="displaySubCategories"
            :totalItems="filteredSubCategories.length"
            v-model:pageSize="subPageSize"
            v-model:currentPage="subCurrentPage"
            :loading="loading"
            @search="handleSubSearch"
            @add="openAddSubCategory"
            @edit="openEditSubCategory"
            @delete="deleteSubCategory"
            @sort="handleSubSort"
            :showSTT="true"
          >
            <template #item-name="{ item }">
              <strong>{{ item.name }}</strong>
            </template>
            <template #item-active="{ item }">
              <span :class="['badge', item.active ? 'badge-success' : 'badge-danger']">
                {{ item.active ? 'Bật' : 'Tắt' }}
              </span>
            </template>
          </DataTable>
        </div>

        <div class="modal-footer">
          <button type="button" @click="showSubModal = false" class="btn-cancel">Đóng</button>
        </div>
      </div>
    </div>

    <!-- Modal Form Chuyên mục con (CRUD Sub-cat) -->
    <div v-if="showSubFormModal" class="modal-overlay sub-form-overlay">
      <div class="modal-card sub-form-card">
        <div class="card-header">{{ isEditingSub ? 'SỬA CHUYÊN MỤC CON' : 'THÊM CHUYÊN MỤC CON' }}</div>
        <form @submit.prevent="handleSubSubmit" class="admin-form">
          <div class="form-group">
            <label>Tên chuyên mục:</label>
            <input v-model="subForm.name" required>
          </div>
          <div class="form-group">
            <label>Mô tả:</label>
            <textarea v-model="subForm.description" rows="2"></textarea>
          </div>
          <div class="form-group">
            <label>Thứ tự:</label>
            <input type="number" v-model="subForm.positionOrder">
          </div>
          <div class="form-group checkbox-group">
            <input type="checkbox" v-model="subForm.active" id="sub-active">
            <label for="sub-active">Kích hoạt</label>
          </div>
          <div class="modal-footer">
            <button type="button" @click="showSubFormModal = false" class="btn-cancel">Hủy</button>
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
  name: 'CategoryConfig',
  components: { DataTable },
  data() {
    return {
      categories: [],
      loading: false,
      keyword: '',
      pageSize: 10,
      currentPage: 1,
      
      // Main Category Modal
      showModal: false,
      isEditing: false,
      headers: [
        { text: 'Tên chuyên mục', value: 'name', sortable: true },
        { text: 'Mô tả', value: 'description', sortable: true },
        { text: 'Thứ tự', value: 'positionOrder', sortable: true, width: '100px' },
        { text: 'Trạng thái', value: 'active', sortable: true, width: '120px' }
      ],
      form: { id: null, name: '', description: '', positionOrder: 0, active: true, categoryGroupId: null, parentCategoryId: null },
      categoryGroups: [],
      sortField: 'positionOrder',
      sortOrder: 'asc',

      // Filter
      filterGroupId: null,
      isFixedGroup: false,

      // Sub-category Modal
      showSubModal: false,
      selectedParentCategory: null,
      subKeyword: '',
      subPageSize: 10,
      subCurrentPage: 1,
      subSortField: 'positionOrder',
      subSortOrder: 'asc',
      subHeaders: [
        { text: 'Tên chuyên mục con', value: 'name', sortable: true },
        { text: 'Mô tả', value: 'description', sortable: true },
        { text: 'Thứ tự', value: 'positionOrder', sortable: true, width: '100px' },
        { text: 'Trạng thái', value: 'active', sortable: true, width: '120px' }
      ],

      // Sub-category Form
      showSubFormModal: false,
      isEditingSub: false,
      subForm: { id: null, name: '', description: '', positionOrder: 0, active: true, categoryGroupId: null, parentCategoryId: null }
    }
  },
  computed: {
    pageTitle() {
      if (this.isFixedGroup && this.selectedGroupName) {
        return `Quản lý Chuyên mục thuộc Nhóm: ${this.selectedGroupName}`
      }
      return 'Quản lý Chuyên mục'
    },
    selectedGroupName() {
      const g = this.categoryGroups.find(group => group.id === this.filterGroupId)
      return g ? g.name : ''
    },
    filteredCategories() {
      let result = this.categories
      
      // Group Filter
      if (this.filterGroupId) {
        result = result.filter(c => c.categoryGroupId === this.filterGroupId)
      }

      // Show only top level in main table if we have a parent/child structure
      // Actually, usually we show all or just top-level. 
      // User wants another icon for sub-categories, implying main table shows parent categories.
      result = result.filter(c => !c.parentCategoryId)

      if (this.keyword) {
        const k = this.keyword.trim().toLowerCase()
        result = result.filter(c => 
          (c.name && c.name.toLowerCase().includes(k)) ||
          (c.description && c.description.toLowerCase().includes(k))
        )
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
    displayCategories() {
      const start = (this.currentPage - 1) * this.pageSize
      const end = start + this.pageSize
      return this.filteredCategories.slice(start, end)
    },

    // Sub-categories Logic
    filteredSubCategories() {
      if (!this.selectedParentCategory) return []
      let result = this.categories.filter(c => c.parentCategoryId === this.selectedParentCategory.id)
      
      if (this.subKeyword) {
        const k = this.subKeyword.trim().toLowerCase()
        result = result.filter(c => 
          (c.name && c.name.toLowerCase().includes(k)) ||
          (c.description && c.description.toLowerCase().includes(k))
        )
      }
      if (this.subSortField) {
        result = [...result].sort((a, b) => {
          let valA = a[this.subSortField]
          let valB = b[this.subSortField]
          if (typeof valA === 'string') valA = valA.toLowerCase()
          if (typeof valB === 'string') valB = valB.toLowerCase()
          if (valA < valB) return this.subSortOrder === 'asc' ? -1 : 1
          if (valA > valB) return this.subSortOrder === 'asc' ? 1 : -1
          return 0
        })
      }
      return result
    },
    displaySubCategories() {
      const start = (this.subCurrentPage - 1) * this.subPageSize
      const end = start + this.subPageSize
      return this.filteredSubCategories.slice(start, end)
    }
  },
  watch: {
    selectedGroupName: {
      immediate: true,
      handler(newVal) {
        if (newVal) this.updateBreadcrumb()
      }
    },
    '$route.params.groupId': {
      immediate: true,
      handler() {
        this.updateFilterFromRoute()
      }
    },
    '$route.query.groupId': {
      immediate: true,
      handler() {
        this.updateFilterFromRoute()
      }
    }
  },
  mounted() {
    this.fetchCategories()
  },
  methods: {
    updateFilterFromRoute() {
      const gId = this.$route.params.groupId || this.$route.query.groupId
      if (gId) {
        this.filterGroupId = parseInt(gId)
        this.isFixedGroup = true
      } else {
        this.filterGroupId = null
        this.isFixedGroup = false
      }
      this.updateBreadcrumb()
    },
    async fetchCategories() {
      this.loading = true
      try {
        const response = await AdminService.getCategories()
        this.categories = response.data
        
        // Fetch Groups and Top-level for dropdowns
        const groupRes = await AdminService.getCategoryGroups()
        this.categoryGroups = groupRes.data
        
        this.updateBreadcrumb()
      } catch (error) {
        console.error('Lỗi khi tải dữ liệu:', error)
      } finally {
        this.loading = false
      }
    },
    updateBreadcrumb() {
      if (this.$route.name === 'AdminCategoryGroupDetail' && this.selectedGroupName) {
        this.$route.meta.breadcrumbTitle = `Chuyên mục thuộc Nhóm: ${this.selectedGroupName}`
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
    
    // Main CRUD
    openAddModal() {
      this.resetForm()
      if (this.filterGroupId) {
        this.form.categoryGroupId = this.filterGroupId
      }
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
      const result = await alertConfirm('Xóa chuyên mục', `Bạn có chắc chắn muốn xóa chuyên mục "${item.name}" và tất cả dữ liệu bên trong?`)
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
      this.form = { id: null, name: '', description: '', positionOrder: 0, active: true, categoryGroupId: null, parentCategoryId: null }
      this.isEditing = false
    },

    // Sub-category Actions
    openSubModal(category) {
      this.selectedParentCategory = category
      this.subKeyword = ''
      this.subCurrentPage = 1
      this.showSubModal = true
    },
    handleSubSearch(k) {
      this.subKeyword = k
      this.subCurrentPage = 1
    },
    handleSubSort({ field, order }) {
      this.subSortField = field
      this.subSortOrder = order
    },
    openAddSubCategory() {
      this.subForm = { 
        id: null, name: '', description: '', positionOrder: 0, active: true, 
        categoryGroupId: this.selectedParentCategory.categoryGroupId, 
        parentCategoryId: this.selectedParentCategory.id 
      }
      this.isEditingSub = false
      this.showSubFormModal = true
    },
    openEditSubCategory(item) {
      this.subForm = { ...item }
      this.isEditingSub = true
      this.showSubFormModal = true
    },
    async handleSubSubmit() {
      try {
        if (this.isEditingSub) {
          await AdminService.updateCategory(this.subForm.id, this.subForm)
          toastSuccess('Cập nhật chuyên mục con thành công')
        } else {
          await AdminService.createCategory(this.subForm)
          toastSuccess('Thêm chuyên mục con thành công')
        }
        this.showSubFormModal = false
        this.fetchCategories() // Refresh all to update sub-list
      } catch (error) {
        toastError('Lỗi khi lưu chuyên mục con')
      }
    },
    async deleteSubCategory(item) {
      const result = await alertConfirm('Xóa chuyên mục con', `Xóa chuyên mục con "${item.name}"?`)
      if (result.isConfirmed) {
        try {
          await AdminService.deleteCategory(item.id)
          toastSuccess('Đã xóa chuyên mục con')
          this.fetchCategories()
        } catch (error) {
          toastError('Lỗi khi xóa chuyên mục con')
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
.sub-form-overlay { z-index: 1001; background: rgba(0,0,0,0.3); }

.modal-card { background: white; width: 500px; border-radius: 8px; overflow: hidden; box-shadow: 0 5px 25px rgba(0,0,0,0.2); }
.sub-manager-card { width: 1000px; max-width: 95vw; max-height: 90vh; }
.sub-form-card { width: 450px; }

.card-header { background: #1a507a; color: white; padding: 1rem; font-weight: bold; text-align: center; }
.admin-form { padding: 1.5rem; }
.form-group { margin-bottom: 1rem; }
.form-group label { display: block; margin-bottom: 0.5rem; font-weight: bold; }
.form-group input, .form-group textarea, .form-select { width: 100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 4px; background: white; }
.checkbox-group { display: flex; align-items: center; gap: 10px; }
.checkbox-group input { width: auto; }

.modal-footer { display: flex; justify-content: flex-end; gap: 10px; padding: 1rem 1.5rem; border-top: 1px solid #eee; }
.btn-save { background: #27ae60; color: white; border: none; padding: 0.75rem 2rem; border-radius: 4px; cursor: pointer; font-weight: bold; }
.btn-cancel { background: #95a5a6; color: white; border: none; padding: 0.75rem 1.5rem; border-radius: 4px; cursor: pointer; }

.filter-group-wrapper { display: flex; align-items: center; gap: 8px; background: #f0f4f8; padding: 4px 12px; border-radius: 4px; border: 1px solid #d1d9e6; }
.filter-group-wrapper label { font-weight: bold; margin-bottom: 0; color: #1a507a; }
.form-select-sm { padding: 4px 8px; border-radius: 4px; border: 1px solid #ddd; }

.sub-manager-content { padding: 0 1.5rem; overflow-y: auto; max-height: 60vh; }
.sub-cat-btn:hover { color: #f39c12; }
</style>
