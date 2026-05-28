<template>
  <div class="page-content">
    <DataTable
      title="Quản lý Nhãn (Label)"
      placeholder="Tìm kiếm tên nhãn..."
      addButtonLabel="Thêm nhãn mới"
      :headers="headers"
      :items="displayLabels"
      :totalItems="filteredLabels.length"
      v-model:pageSize="pageSize"
      v-model:currentPage="currentPage"
      :loading="loading"
      @search="handleSearch"
      @add="openAddModal"
      @edit="openEditModal"
      @delete="deleteLabel"
      @sort="handleSort"
    >
      <!-- Slot cho cột tên nhãn (hiển thị kèm màu) -->
      <template #item-name="{ item }">
        <span class="label-badge" :style="{ backgroundColor: item.colorCode, color: item.textColor, borderColor: item.borderColor || 'transparent' }">{{ item.name }}</span>
      </template>
      
      <!-- Slot cho cột mã màu -->
      <template #item-colorCode="{ item }">
        <div class="color-preview-cell">
          <span class="color-dot" :style="{ backgroundColor: item.colorCode }"></span>
          <code>{{ item.colorCode }}</code>
        </div>
      </template>

      <!-- Slot cho cột màu chữ -->
      <template #item-textColor="{ item }">
        <div class="color-preview-cell">
          <span class="color-dot" :style="{ backgroundColor: item.textColor }"></span>
          <code>{{ item.textColor }}</code>
        </div>
      </template>

      <!-- Slot cho cột màu viền -->
      <template #item-borderColor="{ item }">
        <div class="color-preview-cell">
          <span class="color-dot" :style="{ backgroundColor: item.borderColor || 'transparent' }"></span>
          <code>{{ item.borderColor || 'transparent' }}</code>
        </div>
      </template>

      <!-- Slot cho cột quyền -->
      <template #item-adminOnly="{ item }">
        <span :class="['badge', item.adminOnly ? 'badge-danger' : 'badge-success']">
          {{ item.adminOnly ? 'Admin' : 'Công khai' }}
        </span>
      </template>
    </DataTable>

    <!-- Modal Thêm/Sửa Nhãn -->
    <BaseModal 
      v-model:show="showModal" 
      :title="isEdit ? 'SỬA NHÃN' : 'THÊM NHÃN MỚI'"
    >
      <div class="admin-form">
        <div class="form-group">
          <label>Tên Nhãn</label>
          <input type="text" class="form-control" v-model="formData.name" placeholder="VD: Kiến thức, Thảo luận..." />
        </div>
        <div class="form-row">
          <div class="form-group flex-1">
            <label>Màu Nền (HEX)</label>
            <div class="color-picker-wrapper">
              <input type="color" v-model="formData.colorCode" class="color-input" />
              <input type="text" class="form-control" v-model="formData.colorCode" placeholder="#000000" />
            </div>
          </div>
          <div class="form-group flex-1">
            <label>Màu Chữ (HEX)</label>
            <div class="color-picker-wrapper">
              <input type="color" v-model="formData.textColor" class="color-input" />
              <input type="text" class="form-control" v-model="formData.textColor" placeholder="#FFFFFF" />
            </div>
          </div>
        </div>
        <div class="form-group">
          <label>Màu Viền (HEX)</label>
          <div class="color-picker-wrapper">
            <input type="color" v-model="formData.borderColor" class="color-input" />
            <div class="input-with-clear">
              <input type="text" class="form-control" v-model="formData.borderColor" placeholder="transparent" />
              <button class="btn-clear" @click="formData.borderColor = 'transparent'">Xóa viền</button>
            </div>
          </div>
        </div>

        <div class="form-group">
          <div class="checkbox-wrapper">
            <input type="checkbox" id="adminOnly" v-model="formData.adminOnly" />
            <label for="adminOnly">Chỉ dành cho Admin</label>
          </div>
          <small class="form-text text-muted">Nếu chọn, người dùng thông thường sẽ không thấy nhãn này khi đăng bài.</small>
        </div>
        
        <div class="preview-section mb-3">
          <label>Xem trước:</label>
          <div class="preview-box">
            <span class="label-badge" :style="{ backgroundColor: formData.colorCode, color: formData.textColor, borderColor: formData.borderColor || 'transparent' }">
              {{ formData.name || 'Tên nhãn' }}
            </span>
          </div>
        </div>

        <div class="modal-footer">
          <button class="btn-cancel" @click="showModal = false">Hủy</button>
          <button class="btn-save" @click="saveLabel" :disabled="saving">
            {{ saving ? 'Đang lưu...' : (isEdit ? 'Cập nhật' : 'Lưu lại') }}
          </button>
        </div>
      </div>
    </BaseModal>
  </div>
</template>

<script>
import DataTable from '@/shared/components/DataTable.vue'
import BaseModal from '@/shared/components/BaseModal.vue'
import AdminService from '@/apps/Admin/services/admin.service'
import { alertConfirm, toastSuccess, toastError } from '@/shared/utils/swal'

export default {
  name: 'LabelConfig',
  components: {
    DataTable,
    BaseModal
  },
  data() {
    return {
      labels: [],
      loading: false,
      keyword: '',
      pageSize: 10,
      currentPage: 1,
      sortField: '',
      sortOrder: 'asc',
      headers: [
        { text: 'Tên Nhãn', value: 'name', width: '25%', sortable: true },
        { text: 'Màu Nền', value: 'colorCode', width: '20%', sortable: true },
        { text: 'Màu Chữ', value: 'textColor', width: '15%', sortable: true },
        { text: 'Màu Viền', value: 'borderColor', width: '15%', sortable: true },
        { text: 'Quyền', value: 'adminOnly', width: '10%', sortable: true }
      ],
      showModal: false,
      isEdit: false,
      saving: false,
      formData: {
        id: null,
        name: '',
        colorCode: '#3498db',
        textColor: '#ffffff',
        borderColor: 'transparent',
        adminOnly: false
      }
    }
  },
  computed: {
    filteredLabels() {
      let result = this.labels
      
      if (this.keyword) {
        const k = this.keyword.trim().toLowerCase()
        result = result.filter(l => 
          (l.name && l.name.toLowerCase().includes(k)) ||
          (l.colorCode && l.colorCode.toLowerCase().includes(k)) ||
          (l.textColor && l.textColor.toLowerCase().includes(k)) ||
          (l.borderColor && l.borderColor.toLowerCase().includes(k))
        )
      }
      
      if (this.sortField) {
        result = [...result].sort((a, b) => {
          let valA = a[this.sortField] || ''
          let valB = b[this.sortField] || ''
          
          if (typeof valA === 'string') valA = valA.toLowerCase()
          if (typeof valB === 'string') valB = valB.toLowerCase()

          if (valA < valB) return this.sortOrder === 'asc' ? -1 : 1
          if (valA > valB) return this.sortOrder === 'asc' ? 1 : -1
          return 0
        })
      }
      
      return result
    },
    displayLabels() {
      const start = (this.currentPage - 1) * this.pageSize
      const end = start + this.pageSize
      return this.filteredLabels.slice(start, end)
    }
  },
  created() {
    this.fetchLabels()
  },
  methods: {
    async fetchLabels() {
      this.loading = true
      try {
        const response = await AdminService.getLabels()
        this.labels = response.data
      } catch (error) {
        console.error('Lỗi khi tải danh sách nhãn:', error)
        toastError('Không thể tải danh sách nhãn')
      } finally {
        this.loading = false
      }
    },
    handleSearch(keyword) {
      this.keyword = keyword
      this.currentPage = 1
    },
    handleSort({ field, order }) {
      this.sortField = field
      this.sortOrder = order
    },
    openAddModal() {
      this.isEdit = false
      this.formData = { id: null, name: '', colorCode: '#3498db', textColor: '#ffffff', borderColor: 'transparent', adminOnly: false }
      this.showModal = true
    },
    openEditModal(label) {
      this.isEdit = true
      this.formData = { 
        ...label,
        textColor: label.textColor || '#ffffff',
        borderColor: label.borderColor || 'transparent',
        adminOnly: !!label.adminOnly
      }
      this.showModal = true
    },
    async saveLabel() {
      if (!this.formData.name || !this.formData.colorCode || !this.formData.textColor) {
        toastError('Vui lòng điền đủ thông tin')
        return
      }
      this.saving = true
      try {
        if (this.isEdit) {
          await AdminService.updateLabel(this.formData.id, this.formData)
          toastSuccess('Cập nhật nhãn thành công')
        } else {
          await AdminService.createLabel(this.formData)
          toastSuccess('Thêm nhãn mới thành công')
        }
        this.showModal = false
        this.fetchLabels()
      } catch (error) {
        console.error('Lỗi khi lưu nhãn:', error)
        toastError('Lỗi khi lưu nhãn')
      } finally {
        this.saving = false
      }
    },
    async deleteLabel(label) {
      const result = await alertConfirm('Xóa nhãn', `Bạn có chắc chắn muốn xóa nhãn "${label.name}"?`)
      if (result.isConfirmed) {
        try {
          await AdminService.deleteLabel(label.id)
          toastSuccess('Đã xóa nhãn thành công')
          this.fetchLabels()
        } catch (error) {
          console.error('Lỗi khi xóa nhãn:', error)
          toastError('Lỗi khi xóa nhãn')
        }
      }
    }
  }
}
</script>

<style scoped>
.page-content {
  /* Common spacing */
}

.admin-form {
  padding: 1.5rem;
}

.form-row {
  display: flex;
  gap: 1.5rem;
}

.flex-1 {
  flex: 1;
}

.form-group {
  margin-bottom: 1rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: bold;
}

.form-control {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.color-picker-wrapper {
  display: flex;
  gap: 10px;
  align-items: center;
}

.input-with-clear {
  display: flex;
  gap: 5px;
  flex: 1;
}

.btn-clear {
  padding: 0.5rem;
  background: #eee;
  border: 1px solid #ddd;
  border-radius: 4px;
  cursor: pointer;
  white-space: nowrap;
}

.color-input {
  width: 40px;
  height: 40px;
  padding: 0;
  border: 1px solid #ddd;
  border-radius: 4px;
  cursor: pointer;
}

.color-preview-cell {
  display: flex;
  align-items: center;
  gap: 8px;
}

.color-dot {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  border: 1px solid #ddd;
  display: inline-block;
}

.label-badge {
  display: inline-block;
  padding: 0.25rem 0.6rem;
  border-radius: 4px;
  font-size: 0.85rem;
  font-weight: 600;
  border: 1px solid transparent;
}

.preview-section {
  padding: 1rem;
  background: #f8f9fa;
  border-radius: 4px;
  border: 1px solid #eee;
}

.preview-box {
  display: flex;
  justify-content: center;
  padding: 0.5rem;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding-top: 1rem;
  border-top: 1px solid #eee;
}

.btn-save {
  background: #27ae60;
  color: white;
  border: none;
  padding: 0.75rem 2rem;
  border-radius: 4px;
  cursor: pointer;
  font-weight: bold;
}

.btn-cancel {
  background: #95a5a6;
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 4px;
  cursor: pointer;
}

.checkbox-wrapper {
  display: flex;
  align-items: center;
  gap: 10px;
}

.checkbox-wrapper input[type="checkbox"] {
  width: 18px;
  height: 18px;
  cursor: pointer;
}

.checkbox-wrapper label {
  margin-bottom: 0 !important;
  cursor: pointer;
}

.text-muted {
  color: #6c757d;
  font-size: 0.8rem;
  display: block;
  margin-top: 4px;
}

.badge {
  padding: 4px 8px;
  border-radius: 12px;
  font-size: 0.75rem;
  font-weight: bold;
}
.badge-success { background: #d4edda; color: #155724; }
.badge-danger { background: #f8d7da; color: #721c24; }
</style>



