<template>
  <div class="d-flex justify-content-between align-items-center mt-3 pagination-v">
    <div class="pagination-info">
      <span v-if="totalItems > 0">
        Hiển thị từ <strong>{{ startItem }}</strong> đến <strong>{{ endItem }}</strong> của <strong>{{ totalItems }}</strong> mục
      </span>
      <span v-else>Đang hiển thị 0 kết quả</span>
    </div>

    <div class="d-flex align-items-center gap-3">
      <div class="d-flex align-items-center gap-2">
        <span class="text-muted">Số hàng:</span>
        <select :value="pageSize" @change="$emit('update:pageSize', Number($event.target.value))" class="form-select-sm">
          <option v-for="size in [10, 20, 50, 100]" :key="size" :value="size">{{ size }}</option>
        </select>
      </div>

      <div class="page-buttons d-flex align-items-center gap-1">
        <button :disabled="currentPage === 1" @click="$emit('update:currentPage', 1)" class="page-btn" title="Trang đầu">
          «
        </button>
        <button :disabled="currentPage === 1" @click="$emit('update:currentPage', currentPage - 1)" class="page-btn" title="Trang trước">
          ‹
        </button>
        
        <template v-for="page in visiblePages" :key="page">
          <button 
            v-if="page !== '...'" 
            :class="['page-btn', { active: page === currentPage }]"
            @click="$emit('update:currentPage', page)"
          >
            {{ page }}
          </button>
          <span v-else class="page-dots">...</span>
        </template>

        <button :disabled="currentPage === totalPages" @click="$emit('update:currentPage', currentPage + 1)" class="page-btn" title="Trang sau">
          ›
        </button>
        <button :disabled="currentPage === totalPages" @click="$emit('update:currentPage', totalPages)" class="page-btn" title="Trang cuối">
          »
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Pagination',
  props: {
    totalItems: { type: Number, default: 0 },
    pageSize: { type: Number, default: 20 },
    currentPage: { type: Number, default: 1 }
  },
  computed: {
    totalPages() {
      return Math.ceil(this.totalItems / this.pageSize) || 1
    },
    startItem() {
      if (this.totalItems === 0) return 0
      return (this.currentPage - 1) * this.pageSize + 1
    },
    endItem() {
      return Math.min(this.currentPage * this.pageSize, this.totalItems)
    },
    visiblePages() {
      const total = this.totalPages
      const current = this.currentPage
      const pages = []

      if (total <= 7) {
        for (let i = 1; i <= total; i++) pages.push(i)
      } else {
        pages.push(1)
        if (current > 4) pages.push('...')
        
        const start = Math.max(2, current - 2)
        const end = Math.min(total - 1, current + 2)
        
        for (let i = start; i <= end; i++) {
          pages.push(i)
        }
        
        if (current < total - 3) pages.push('...')
        pages.push(total)
      }
      return pages
    }
  }
}
</script>

<style scoped>
.pagination-v {
    font-size: 0.9rem;
    color: #555;
}

.form-select-sm {
    padding: 2px 5px;
    border: 1px solid #ccc;
    border-radius: 4px;
    outline: none;
}

.page-buttons {
    display: flex;
}

.page-btn {
    min-width: 32px;
    height: 32px;
    padding: 0 5px;
    border: 1px solid #ddd;
    background: white;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s;
    border-radius: 4px;
}

.page-btn:hover:not(:disabled) {
    background-color: #f5f5f5;
    border-color: var(--primary);
    color: var(--primary);
}

.page-btn.active {
    background-color: var(--primary);
    color: white;
    border-color: var(--primary);
}

.page-btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}

.page-dots {
    padding: 0 5px;
}

.gap-3 { gap: 1rem; }
.gap-2 { gap: 0.5rem; }
.gap-1 { gap: 0.25rem; }

.d-flex { display: flex; }
.justify-content-between { justify-content: space-between; }
.align-items-center { align-items: center; }
</style>
