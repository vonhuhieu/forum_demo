<template>
  <BaseModal 
    :show="show" 
    @update:show="$emit('update:show', $event)" 
    :title="title" 
    :cardClass="cardClass"
    :overlayClass="overlayClass"
    :cardStyle="cardStyle"
    :closeOnOverlay="closeOnOverlay"
    :showCloseButton="showCloseButton"
  >
    <div class="table-modal-content">
      <DataTable
        :placeholder="placeholder"
        :headers="headers"
        :items="items"
        :totalItems="totalItems"
        :pageSize="pageSize"
        @update:pageSize="$emit('update:pageSize', $event)"
        :currentPage="currentPage"
        @update:currentPage="$emit('update:currentPage', $event)"
        :loading="loading"
        :addButtonLabel="addButtonLabel"
        :showAddButton="showAddButton"
        :showSTT="showSTT"
        :showAction="showAction"
        :showPagination="showPagination"
        @search="$emit('search', $event)"
        @sort="$emit('sort', $event)"
        @add="$emit('add')"
        @edit="$emit('edit', $event)"
        @delete="$emit('delete', $event)"
        @view="$emit('view', $event)"
      >
        <!-- Chuyển tiếp (Forward) toàn bộ slots xuống cho DataTable -->
        <template v-for="(_, slotName) in $slots" v-slot:[slotName]="slotProps">
          <slot :name="slotName" v-bind="slotProps || {}"></slot>
        </template>
      </DataTable>
    </div>

    <template #footer v-if="showFooter">
      <slot name="modal-footer">
        <button type="button" @click="$emit('update:show', false)" class="btn-cancel">Đóng</button>
      </slot>
    </template>
  </BaseModal>
</template>

<script>
import BaseModal from './BaseModal.vue'
import DataTable from './DataTable.vue'

export default {
  name: 'TableModal',
  components: { BaseModal, DataTable },
  props: {
    // BaseModal Props
    show: { type: Boolean, default: false },
    title: { type: String, default: '' },
    cardClass: { type: [String, Object, Array], default: 'table-modal-card' },
    overlayClass: { type: [String, Object, Array], default: '' },
    cardStyle: { type: [String, Object, Array], default: '' },
    closeOnOverlay: { type: Boolean, default: false },
    showCloseButton: { type: Boolean, default: false },
    showFooter: { type: Boolean, default: true },

    // DataTable Props
    headers: { type: Array, required: true },
    items: { type: Array, default: () => [] },
    totalItems: { type: Number, default: 0 },
    pageSize: { type: Number, default: 10 },
    currentPage: { type: Number, default: 1 },
    loading: { type: Boolean, default: false },
    placeholder: { type: String, default: 'Nhập từ khóa tìm kiếm...' },
    addButtonLabel: { type: String, default: 'Thêm mới' },
    showAddButton: { type: Boolean, default: true },
    showSTT: { type: Boolean, default: true },
    showAction: { type: Boolean, default: true },
    showPagination: { type: Boolean, default: true }
  }
}
</script>

<style scoped>
:deep(.table-modal-card) {
  width: 1000px;
  max-width: 95vw;
  max-height: 90vh;
}

.table-modal-content {
  padding: 0 1.5rem;
  overflow-y: auto;
  flex: 1; /* Để table có thể co giãn nếu cần */
}

/* Các filter slots đôi khi cần canh lề, nhưng DataTable đã quản lý .filter-left */

.btn-cancel {
  background: #95a5a6;
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 4px;
  cursor: pointer;
  font-weight: bold;
}

.btn-cancel:hover {
  background: #7f8c8d;
}
</style>
