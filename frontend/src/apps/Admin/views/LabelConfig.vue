<template>
  <div class="label-config">
    <div class="header-actions">
      <h2>Quản lý Nhãn (Label)</h2>
      <button class="btn btn-primary" @click="openAddModal">Thêm Nhãn</button>
    </div>

    <div class="card sub-manager-card">
      <DataTable
        :headers="headers"
        :items="labels"
        :loading="loading"
      >
        <!-- Slot cho cột tên nhãn (hiển thị kèm màu) -->
        <template #item-name="{ item }">
          <span class="label-badge" :style="{ backgroundColor: item.colorCode }">{{ item.name }}</span>
        </template>
        
        <!-- Slot cho cột mã màu -->
        <template #item-colorCode="{ item }">
          <code>{{ item.colorCode }}</code>
        </template>
        
        <!-- Slot cho cột hành động -->
        <template #item-actions="{ item }">
          <div class="action-buttons">
            <button class="btn btn-sm btn-outline-primary" @click="openEditModal(item)">Sửa</button>
            <button class="btn btn-sm btn-outline-danger" @click="confirmDelete(item)">Xoá</button>
          </div>
        </template>
      </DataTable>
    </div>

    <!-- Modal Thêm/Sửa Nhãn -->
    <BaseModal 
      :show="showModal" 
      :title="isEdit ? 'Sửa Nhãn' : 'Thêm Nhãn mới'"
      @close="closeModal"
    >
      <div class="form-group">
        <label>Tên Nhãn</label>
        <input type="text" class="form-control" v-model="formData.name" placeholder="VD: Kiến thức, Thảo luận..." />
      </div>
      <div class="form-group">
        <label>Màu Sắc (HEX)</label>
        <div class="color-picker-wrapper">
          <input type="color" v-model="formData.colorCode" class="color-input" />
          <input type="text" class="form-control" v-model="formData.colorCode" placeholder="#000000" />
        </div>
      </div>
      <template #footer>
        <button class="btn btn-secondary" @click="closeModal">Hủy</button>
        <button class="btn btn-primary" @click="saveLabel" :disabled="saving">
          {{ saving ? 'Đang lưu...' : 'Lưu' }}
        </button>
      </template>
    </BaseModal>
  </div>
</template>

<script>
import DataTable from '@/shared/components/DataTable.vue'
import BaseModal from '@/shared/components/BaseModal.vue'
import api from '@/shared/services/api.service'

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
      headers: [
        { text: 'STT', value: 'index', width: '5%' },
        { text: 'Tên Nhãn', value: 'name', width: '40%' },
        { text: 'Mã Màu', value: 'colorCode', width: '30%' },
        { text: 'Hành động', value: 'actions', sortable: false, width: '25%' }
      ],
      showModal: false,
      isEdit: false,
      saving: false,
      formData: {
        id: null,
        name: '',
        colorCode: '#3498db'
      }
    }
  },
  created() {
    this.fetchLabels()
  },
  methods: {
    async fetchLabels() {
      this.loading = true
      try {
        const response = await api.get('/labels')
        // Đánh số thứ tự
        this.labels = response.data.map((item, index) => ({
          ...item,
          index: index + 1
        }))
      } catch (error) {
        console.error('Lỗi khi tải danh sách nhãn:', error)
        alert('Không thể tải danh sách nhãn')
      } finally {
        this.loading = false
      }
    },
    openAddModal() {
      this.isEdit = false
      this.formData = { id: null, name: '', colorCode: '#3498db' }
      this.showModal = true
    },
    openEditModal(label) {
      this.isEdit = true
      this.formData = { ...label }
      this.showModal = true
    },
    closeModal() {
      this.showModal = false
    },
    async saveLabel() {
      if (!this.formData.name || !this.formData.colorCode) {
        alert('Vui lòng điền đủ thông tin')
        return
      }
      this.saving = true
      try {
        if (this.isEdit) {
          await api.put(`/labels/${this.formData.id}`, this.formData)
        } else {
          await api.post('/labels', this.formData)
        }
        this.closeModal()
        this.fetchLabels()
      } catch (error) {
        console.error('Lỗi khi lưu nhãn:', error)
        alert('Lỗi khi lưu nhãn')
      } finally {
        this.saving = false
      }
    },
    async confirmDelete(label) {
      if (confirm(`Bạn có chắc muốn xoá nhãn "${label.name}" không?`)) {
        try {
          await api.delete(`/labels/${label.id}`)
          this.fetchLabels()
        } catch (error) {
          console.error('Lỗi khi xoá nhãn:', error)
          alert('Lỗi khi xoá nhãn')
        }
      }
    }
  }
}
</script>

<style scoped>
.label-config {
  padding: 1rem;
}

.header-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
}

.header-actions h2 {
  font-size: 1.5rem;
  font-weight: 600;
  color: #333;
}

.sub-manager-card {
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
  padding: 1rem;
}

.form-group {
  margin-bottom: 1rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
  color: #555;
}

.form-control {
  width: 100%;
  padding: 0.5rem 0.75rem;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: 1rem;
}

.color-picker-wrapper {
  display: flex;
  gap: 10px;
  align-items: center;
}

.color-input {
  width: 40px;
  height: 40px;
  padding: 0;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.label-badge {
  display: inline-block;
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
  color: #fff;
  font-size: 0.85rem;
  font-weight: 600;
}

.action-buttons {
  display: flex;
  gap: 0.5rem;
}

.btn {
  padding: 0.5rem 1rem;
  border-radius: 4px;
  font-weight: 500;
  cursor: pointer;
  border: 1px solid transparent;
}

.btn-primary {
  background-color: #3498db;
  color: #fff;
}

.btn-primary:hover {
  background-color: #2980b9;
}

.btn-secondary {
  background-color: #e0e0e0;
  color: #333;
}

.btn-outline-primary {
  color: #3498db;
  border-color: #3498db;
  background: transparent;
}

.btn-outline-danger {
  color: #e74c3c;
  border-color: #e74c3c;
  background: transparent;
}

.btn-sm {
  padding: 0.25rem 0.5rem;
  font-size: 0.875rem;
}
</style>
