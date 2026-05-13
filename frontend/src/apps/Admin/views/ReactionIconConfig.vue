<template>
  <div class="page-content">
    <DataTable
      title="Quản lý Cảm xúc (Reaction Icons)"
      placeholder="Tìm kiếm tooltip..."
      addButtonLabel="Thêm cảm xúc mới"
      :headers="headers"
      :items="displayIcons"
      :totalItems="filteredIcons.length"
      v-model:pageSize="pageSize"
      v-model:currentPage="currentPage"
      :loading="loading"
      @search="handleSearch"
      @add="openAddModal"
      @edit="openEditModal"
      @delete="deleteIcon"
      @sort="handleSort"
    >
      <!-- Slot cho cột icon -->
      <template #item-icon="{ item }">
        <div class="icon-display-cell">
          <ReactionIcon :code="item.icon" :color="item.color" size="30px" />
          <code>{{ item.icon }}</code>
        </div>
      </template>

      <!-- Slot cho cột tooltip -->
      <template #item-tooltip="{ item }">
        <span class="text-bold">{{ item.tooltip }}</span>
      </template>

      <!-- Slot cho cột màu sắc -->
      <template #item-color="{ item }">
        <div class="color-preview-cell">
          <span class="color-dot" :style="{ backgroundColor: item.color }"></span>
          <span :style="{ color: item.color, fontWeight: 'bold' }">{{ item.color }}</span>
        </div>
      </template>

      <!-- Slot cho cột xem trước -->
      <template #item-preview="{ item }">
        <div class="reaction-btn-preview">
          <ReactionIcon :code="item.icon" :color="item.color" size="20px" />
          <span :style="{ color: item.color, fontWeight: 'bold', fontSize: '14px' }">{{ item.tooltip }}</span>
        </div>
      </template>
    </DataTable>

    <!-- Modal Thêm/Sửa Reaction -->
    <BaseModal 
      v-model:show="showModal" 
      :title="isEdit ? 'SỬA CẢM XÚC' : 'THÊM CẢM XÚC MỚI'"
    >
      <div class="admin-form" v-click-outside="closeDropdown">
        <!-- Custom Dropdown Select for Icons -->
        <div class="form-group">
          <label>Chọn Icon Cảm xúc</label>
          <div class="custom-select-container">
            <div class="custom-select-trigger" @click.stop="showDropdown = !showDropdown">
              <div v-if="formData.icon" class="selected-item-display">
                <ReactionIcon :code="formData.icon" :color="formData.color" size="26px" />
                <span class="select-trigger-text">{{ getIconLabel(formData.icon) }} (<code>{{ formData.icon }}</code>)</span>
              </div>
              <span v-else class="placeholder">-- Click để chọn một Icon --</span>
              <span class="select-arrow" :class="{ open: showDropdown }">▼</span>
            </div>
            
            <div v-if="showDropdown" class="custom-options-list">
              <div 
                v-for="opt in availableIcons" 
                :key="opt.code" 
                class="custom-option-item"
                :class="{ selected: formData.icon === opt.code }"
                @click="selectIcon(opt.code)"
              >
                <img :src="getReactionUrl(opt.code)" class="option-item-img" />
                <span class="option-item-text">{{ opt.label }} (<code>{{ opt.code }}</code>)</span>
              </div>
            </div>
          </div>
        </div>

        <div class="form-group">
          <label>Chữ hiển thị (Tooltip)</label>
          <input type="text" class="form-control" v-model="formData.tooltip" placeholder="VD: Thích, Yêu thích, Haha..." />
        </div>

        <div class="form-row">
          <div class="form-group flex-1">
            <label>Màu chữ khi Active (HEX)</label>
            <div class="color-picker-wrapper">
              <input type="color" v-model="formData.color" class="color-input" />
              <input type="text" class="form-control" v-model="formData.color" placeholder="#000000" />
            </div>
          </div>
          <div class="form-group flex-1">
            <label>Thứ tự sắp xếp (Nhỏ hiển thị trước)</label>
            <input type="number" class="form-control" v-model.number="formData.orderIndex" placeholder="0" />
          </div>
        </div>

        <div class="preview-section mb-3" v-if="formData.icon">
          <label>Xem trước trạng thái hoạt động:</label>
          <div class="preview-box-active">
            <div class="simulated-btn">
              <ReactionIcon :code="formData.icon" :color="formData.color" size="24px" />
              <span :style="{ color: formData.color || '#65676B' }" class="simulated-text">{{ formData.tooltip || 'Tooltip' }}</span>
            </div>
          </div>
        </div>

        <div class="modal-footer">
          <button class="btn-cancel" @click="showModal = false">Hủy</button>
          <button class="btn-save" @click="saveIcon" :disabled="saving">
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
import ReactionIcon from '@/shared/components/ReactionIcon.vue'
import api from '@/shared/services/api.service'
import { alertConfirm, toastSuccess, toastError } from '@/shared/utils/swal'

export default {
  name: 'ReactionIconConfig',
  components: {
    DataTable,
    BaseModal,
    ReactionIcon
  },
  directives: {
    // Chỉ thị tự đóng dropdown khi click ra ngoài
    'click-outside': {
      beforeMount(el, binding) {
        el.clickOutsideEvent = function(event) {
          if (!(el === event.target || el.contains(event.target))) {
            binding.value(event)
          }
        }
        document.body.addEventListener('click', el.clickOutsideEvent)
      },
      unmounted(el) {
        document.body.removeEventListener('click', el.clickOutsideEvent)
      }
    }
  },
  data() {
    return {
      iconsList: [],
      loading: false,
      keyword: '',
      pageSize: 10,
      currentPage: 1,
      sortField: '',
      sortOrder: 'asc',
      headers: [
        { text: 'Mã Code Icon', value: 'icon', width: '20%', sortable: true },
        { text: 'Tooltip', value: 'tooltip', width: '20%', sortable: true },
        { text: 'Màu chữ active', value: 'color', width: '20%', sortable: true },
        { text: 'Thứ tự', value: 'orderIndex', width: '15%', sortable: true },
        { text: 'Xem trước Button', value: 'preview', width: '25%', sortable: false }
      ],
      showModal: false,
      isEdit: false,
      saving: false,
      showDropdown: false,
      formData: {
        id: null,
        icon: '',
        tooltip: '',
        color: '#1877f2',
        orderIndex: 0
      },
      availableIcons: [
        { code: 'like', label: 'Like (Thích)' },
        { code: 'love', label: 'Love (Yêu thương)' },
        { code: 'haha', label: 'Haha (Cười lớn)' },
        { code: 'wow', label: 'Wow (Ngạc nhiên)' },
        { code: 'sad', label: 'Sad (Buồn bã)' },
        { code: 'angry', label: 'Angry (Phẫn nộ)' }
      ]
    }
  },
  computed: {
    filteredIcons() {
      let result = this.iconsList
      
      if (this.keyword) {
        const k = this.keyword.trim().toLowerCase()
        result = result.filter(i => 
          (i.tooltip && i.tooltip.toLowerCase().includes(k)) ||
          (i.icon && i.icon.toLowerCase().includes(k))
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
    displayIcons() {
      const start = (this.currentPage - 1) * this.pageSize
      const end = start + this.pageSize
      return this.filteredIcons.slice(start, end)
    }
  },
  created() {
    this.fetchIcons()
  },
  methods: {
    getReactionUrl(code) {
      if (!code) return ''
      try {
        return require(`@/assets/reactions/${code}.svg`)
      } catch (e) {
        return ''
      }
    },
    getIconLabel(code) {
      const opt = this.availableIcons.find(i => i.code === code)
      return opt ? opt.label : code
    },
    selectIcon(code) {
      this.formData.icon = code
      this.showDropdown = false
      // Tự điền màu sắc và tooltip cơ bản khi chọn mới để hỗ trợ UX
      if (!this.isEdit) {
        if (code === 'like') { this.formData.color = '#1877f2'; this.formData.tooltip = 'Thích'; }
        else if (code === 'love') { this.formData.color = '#f33e58'; this.formData.tooltip = 'Yêu thương'; }
        else if (code === 'haha') { this.formData.color = '#f7b125'; this.formData.tooltip = 'Haha'; }
        else if (code === 'wow') { this.formData.color = '#f7b125'; this.formData.tooltip = 'Wow'; }
        else if (code === 'sad') { this.formData.color = '#f7b125'; this.formData.tooltip = 'Buồn'; }
        else if (code === 'angry') { this.formData.color = '#e94335'; this.formData.tooltip = 'Phẫn nộ'; }
      }
    },
    closeDropdown() {
      this.showDropdown = false
    },
    async fetchIcons() {
      this.loading = true
      try {
        const response = await api.get('/reaction-icons')
        this.iconsList = response.data
      } catch (error) {
        console.error('Lỗi khi tải danh sách cảm xúc:', error)
        toastError('Không thể tải danh sách reaction')
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
      this.formData = { id: null, icon: '', tooltip: '', color: '#1877f2', orderIndex: this.iconsList.length }
      this.showDropdown = false
      this.showModal = true
    },
    openEditModal(icon) {
      this.isEdit = true
      this.formData = { ...icon }
      this.showDropdown = false
      this.showModal = true
    },
    async saveIcon() {
      if (!this.formData.icon || !this.formData.tooltip || !this.formData.color) {
        toastError('Vui lòng điền đầy đủ thông tin và chọn Icon')
        return
      }
      this.saving = true
      try {
        if (this.isEdit) {
          await api.put(`/reaction-icons/${this.formData.id}`, this.formData)
          toastSuccess('Cập nhật reaction thành công')
        } else {
          await api.post('/reaction-icons', this.formData)
          toastSuccess('Thêm reaction mới thành công')
        }
        this.showModal = false
        this.fetchIcons()
      } catch (error) {
        console.error('Lỗi khi lưu reaction:', error)
        toastError('Lỗi khi lưu reaction icon')
      } finally {
        this.saving = false
      }
    },
    async deleteIcon(icon) {
      const result = await alertConfirm('Xóa cảm xúc', `Bạn có muốn xóa cảm xúc "${icon.tooltip}"?`)
      if (result.isConfirmed) {
        try {
          await api.delete(`/reaction-icons/${icon.id}`)
          toastSuccess('Đã xóa thành công')
          this.fetchIcons()
        } catch (error) {
          console.error('Lỗi khi xóa reaction:', error)
          toastError('Không thể xóa reaction')
        }
      }
    }
  }
}
</script>

<style scoped>
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
  margin-bottom: 1.25rem;
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

/* Custom visual select dropdown styling */
.custom-select-container {
  position: relative;
  width: 100%;
  user-select: none;
}

.custom-select-trigger {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 15px;
  border: 1px solid #ccc;
  border-radius: 6px;
  background-color: #fff;
  cursor: pointer;
  min-height: 45px;
  transition: border-color 0.2s;
}

.custom-select-trigger:hover {
  border-color: #888;
}

.selected-item-display {
  display: flex;
  align-items: center;
  gap: 12px;
}

.select-trigger-img {
  width: 26px;
  height: 26px;
  object-fit: contain;
}

.select-arrow {
  font-size: 0.75rem;
  color: #888;
  transition: transform 0.2s;
}

.select-arrow.open {
  transform: rotate(180deg);
}

.placeholder {
  color: #888;
  font-style: italic;
}

.custom-options-list {
  position: absolute;
  top: calc(100% + 5px);
  left: 0;
  right: 0;
  background: white;
  border: 1px solid #ddd;
  border-radius: 6px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.1);
  z-index: 999;
  max-height: 250px;
  overflow-y: auto;
}

.custom-option-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 15px;
  cursor: pointer;
  transition: background 0.15s;
}

.custom-option-item:hover {
  background: #f5f7fa;
}

.custom-option-item.selected {
  background: #e8f4ff;
  font-weight: bold;
}

.option-item-img {
  width: 30px;
  height: 30px;
  object-fit: contain;
  transition: transform 0.2s;
}

.custom-option-item:hover .option-item-img {
  transform: scale(1.2);
}

.option-item-text {
  color: #333;
}

/* End Dropdown Styling */

.color-picker-wrapper {
  display: flex;
  gap: 10px;
  align-items: center;
}

.color-input {
  width: 45px;
  height: 45px;
  padding: 0;
  border: 1px solid #ddd;
  border-radius: 4px;
  cursor: pointer;
}

.icon-display-cell {
  display: flex;
  align-items: center;
  gap: 10px;
}

.table-icon {
  width: 30px;
  height: 30px;
  object-fit: contain;
}

.color-preview-cell {
  display: flex;
  align-items: center;
  gap: 8px;
}

.color-dot {
  width: 14px;
  height: 14px;
  border-radius: 50%;
  border: 1px solid #ddd;
  display: inline-block;
}

.reaction-btn-preview {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 4px 8px;
  border: 1px solid #eee;
  border-radius: 20px;
  width: fit-content;
  background: #f8f9fa;
}

.preview-mini-icon {
  width: 20px;
  height: 20px;
}

.preview-section {
  padding: 1.25rem;
  background: #f8f9fa;
  border-radius: 6px;
  border: 1px dashed #ccc;
  margin-top: 1rem;
}

.preview-box-active {
  display: flex;
  justify-content: center;
  padding: 15px;
}

.simulated-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  background: #fff;
  border: 1px solid #ddd;
  border-radius: 20px;
  box-shadow: 0 2px 5px rgba(0,0,0,0.05);
}

.simulated-icon {
  width: 24px;
  height: 24px;
}

.simulated-text {
  font-weight: bold;
  font-size: 15px;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding-top: 1.25rem;
  border-top: 1px solid #eee;
  margin-top: 1rem;
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

code {
  background: #f1f1f1;
  padding: 2px 6px;
  border-radius: 3px;
  color: #e83e8c;
  font-size: 0.9em;
}
</style>
