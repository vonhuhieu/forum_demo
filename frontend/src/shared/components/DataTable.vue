<template>
  <div class="data-table-container">
    <!-- Row 1: Title (Full Width) -->
    <div class="title-row mb-2">
      <h2 class="textHeader text-uppercase">{{ title }}</h2>
    </div>

    <!-- Row 2: Filter Section (Two blocks: Filters on Left, Buttons on Right) -->
    <div class="filter-row mb-3">
      <div class="filter-left">
        <!-- Main Search Input -->
        <div class="search-input-wrapper">
          <input 
            type="text" 
            class="search-input" 
            v-model="keyword" 
            :placeholder="placeholder"
            @keyup.enter="handleSearch"
          >
        </div>
        <!-- Extra Filters (e.g., Select category) -->
        <slot name="extra-filters"></slot>
      </div>
      
      <div class="filter-right">
        <button class="btn-primary-custom" @click="handleSearch">
          <span class="icon">🔍</span> Tìm kiếm
        </button>
        <slot name="divAction">
          <button v-if="showAddButton" class="btn-add-new" @click="$emit('add')">
            <span class="icon">+</span> {{ addButtonLabel }}
          </button>
        </slot>
      </div>
    </div>

    <!-- Table Section -->
    <div class="tablerounededCorner wrapper-scroll">
      <table class="customize-table table-striped">
        <thead>
          <tr>
            <th v-if="showSTT" width="60px" class="text-center">STT</th>
            <th 
              v-for="header in headers" 
              :key="header.value"
              :width="header.width"
              :style="{ width: header.width, minWidth: header.width }"
              class="text-center"
              @click="header.sortable !== false && handleSort(header.value)"
            >
              <div class="d-flex justify-content-center align-items-center header-cell-content">
                <span class="th-label">{{ header.text }}</span>
                <span v-if="header.sortable !== false" class="sort-icon">
                  <i v-if="sortField === header.value && sortOrder === 'asc'">▲</i>
                  <i v-else-if="sortField === header.value && sortOrder === 'desc'">▼</i>
                  <i v-else class="sort-placeholder">↕</i>
                </span>
              </div>
            </th>
            <th v-if="showAction" width="140px" class="text-center">Thao tác</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="loading">
            <td :colspan="totalColumns" class="table-empty-no-data">
              <div class="spinner">Đang tải dữ liệu...</div>
            </td>
          </tr>
          <template v-else-if="items && items.length > 0">
            <tr v-for="(item, index) in items" :key="item.id || index">
              <td v-if="showSTT" class="text-center">{{ (currentPage - 1) * pageSize + index + 1 }}</td>
              <td v-for="header in headers" :key="header.value" :class="getCellClass(header, item)" :style="header.style">
                <slot :name="`item-${header.value}`" :item="item">
                  <div class="cell-content">{{ getValue(item, header.value) }}</div>
                </slot>
              </td>
              <td v-if="showAction" class="text-center action-column">
                <div class="action-buttons-wrapper">
                  <button class="action-btn view-btn" @click="$emit('view', item)" title="Xem chi tiết">👁</button>
                  <button class="action-btn edit-btn" @click="$emit('edit', item)" title="Chỉnh sửa">✏️</button>
                  <button class="action-btn delete-btn" @click="$emit('delete', item)" title="Xóa">🗑</button>
                </div>
              </td>
            </tr>
          </template>
          <tr v-else>
            <td :colspan="totalColumns" class="table-empty-no-data">
              Không tìm thấy bản ghi nào.
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Pagination Section -->
    <div class="pagination-wrapper mt-4">
      <Pagination 
        v-if="showPagination && totalItems > 0"
        :totalItems="totalItems"
        v-model:pageSize="localPageSize"
        v-model:currentPage="localCurrentPage"
      />
    </div>
  </div>
</template>

<script>
import Pagination from './Pagination.vue'

export default {
  name: 'DataTable',
  components: { Pagination },
  props: {
    headers: { type: Array, required: true },
    items: { type: Array, default: () => [] },
    totalItems: { type: Number, default: 0 },
    pageSize: { type: Number, default: 10 },
    currentPage: { type: Number, default: 1 },
    loading: { type: Boolean, default: false },
    title: { type: String, default: '' },
    placeholder: { type: String, default: 'Nhập từ khóa tìm kiếm...' },
    addButtonLabel: { type: String, default: 'Thêm mới' },
    showAddButton: { type: Boolean, default: true },
    showSTT: { type: Boolean, default: true },
    showAction: { type: Boolean, default: true },
    showPagination: { type: Boolean, default: true }
  },
  data() {
    return {
      keyword: '',
      sortField: '',
      sortOrder: 'asc'
    }
  },
  computed: {
    totalColumns() {
      let count = this.headers.length
      if (this.showSTT) count++
      if (this.showAction) count++
      return count
    },
    localPageSize: {
      get() { return this.pageSize },
      set(val) { this.$emit('update:pageSize', val) }
    },
    localCurrentPage: {
      get() { return this.currentPage },
      set(val) { this.$emit('update:currentPage', val) }
    }
  },
  methods: {
    getValue(item, key) {
      if (!key) return ''
      return key.split('.').reduce((obj, k) => (obj ? obj[k] : ''), item)
    },
    handleSearch() {
      this.$emit('search', this.keyword)
    },
    handleSort(field) {
      if (this.sortField === field) {
        this.sortOrder = this.sortOrder === 'asc' ? 'desc' : 'asc'
      } else {
        this.sortField = field
        this.sortOrder = 'asc'
      }
      this.$emit('sort', { field: this.sortField, order: this.sortOrder })
    },
    getCellClass(header, item) {
      // 1. Ưu tiên class được định nghĩa cụ thể trong header
      if (header.cellClass) return header.cellClass

      const value = this.getValue(item, header.value)
      const text = (header.text || '').toLowerCase()

      // 2. Căn giữa cho số (Number)
      if (typeof value === 'number') return 'text-center'

      // 3. Căn giữa cho các trường ngày tháng (dựa trên tên cột hoặc giá trị)
      if (text.includes('ngày') || text.includes('thời gian')) return 'text-center'

      // 4. Căn giữa cho một số trường đặc thù khác
      if (text.includes('lượt') || text.includes('thứ tự') || text.includes('trạng thái')) return 'text-center'

      // 5. Mặc định là căn trái cho chuỗi (String)
      return 'text-left'
    }
  }
}
</script>

<style src="@/shared/assets/styles/table-light.css"></style>
<style scoped>
.data-table-container {
  padding: 1.5rem 0;
  width: 100%;
}

.title-row {
  width: 100%;
  text-align: left;
  margin-bottom: 1.5rem;
}

.filter-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 1rem;
  flex-wrap: wrap;
  margin-bottom: 2rem; /* Tăng khoảng cách với bảng */
}

.filter-left {
  display: flex;
  align-items: center;
  gap: 1rem;
  flex: 1;
}

.filter-right {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.search-input-wrapper {
  flex: 0 0 300px;
}

.search-input {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  outline: none;
}

.search-input:focus {
  border-color: var(--primary);
}

.btn-primary-custom {
  background-color: var(--primary);
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 4px;
  font-weight: 600;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 5px;
}

.btn-add-new {
  background-color: #27ae60;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 4px;
  font-weight: 700;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 5px;
}

.action-column {
  white-space: nowrap;
}

.action-buttons-wrapper {
  display: flex;
  justify-content: center;
  gap: 8px;
  width: 100%;
}

.action-btn {
  background: none;
  border: none;
  cursor: pointer;
  font-size: 1.2rem;
  padding: 2px;
  transition: transform 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
}

.action-btn:hover {
  transform: scale(1.2);
}

.cell-content {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: normal;
  word-break: break-word;
}

.pagination-wrapper {
  margin-top: 2.5rem;
}

@media (max-width: 768px) {
  .filter-row {
    flex-direction: column;
    align-items: flex-start;
  }
  .filter-left, .filter-right {
    width: 100%;
  }
  .search-input-wrapper {
    flex: 1;
  }
}
</style>
