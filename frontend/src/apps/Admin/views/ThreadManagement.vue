<template>
  <div class="page-content">
    <DataTable
      title="Quản lý bài viết diễn đàn"
      placeholder="Tìm kiếm tiêu đề, tác giả, chuyên mục..."
      addButtonLabel="Đăng bài mới"
      :headers="headers"
      :items="displayThreads"
      :totalItems="filteredThreads.length"
      v-model:pageSize="pageSize"
      v-model:currentPage="currentPage"
      :loading="loading"
      @search="handleSearch"
      @add="$router.push('/admin/threads/create')"
      @edit="editThread"
      @delete="deleteThread"
      @view="viewThread"
    >
      <template #extra-filters>
        <div class="filter-item-mini">
          <select v-model="filter.categoryId" @change="fetchThreads" class="mini-select">
            <option value="">Tất cả chuyên mục</option>
            <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
          </select>
        </div>
      </template>

      <template #item-title="{ item }">
        <span v-if="item.pinned" class="badge-pinned" style="margin-right: 5px;">GHIM</span>
        <strong>{{ item.title }}</strong>
      </template>

      <template #item-author="{ item }">
        {{ item.author ? item.author.username : 'Ẩn danh' }}
      </template>

      <template #item-category="{ item }">
        <span class="category-tag">{{ item.category ? item.category.name : 'N/A' }}</span>
      </template>

      <template #item-createdAt="{ item }">
        {{ formatDate(item.createdAt) }}
      </template>
    </DataTable>
  </div>
</template>

<script>
import api from '@/shared/services/api.service'
import AdminService from '@/apps/Admin/services/admin.service'
import DataTable from '@/shared/components/DataTable.vue'
import { alertConfirm, toastSuccess, toastError } from '@/shared/utils/swal'

export default {
  name: 'ThreadManagement',
  components: { DataTable },
  data() {
    return {
      threads: [],
      categories: [],
      loading: false,
      filter: { categoryId: '', keyword: '' },
      pageSize: 10,
      currentPage: 1,
      headers: [
        { text: 'Tiêu đề', value: 'title', sortable: true, width: '40%' },
        { text: 'Tác giả', value: 'author.username', sortable: true, width: '15%' },
        { text: 'Chuyên mục', value: 'category.name', sortable: true, width: '15%' },
        { text: 'Ngày đăng', value: 'createdAt', sortable: true, width: '150px' },
        { text: 'Lượt xem', value: 'viewCount', sortable: true, width: '80px' }
      ]
    }
  },
  computed: {
    filteredThreads() {
      let result = this.threads
      
      if (this.filter.keyword) {
        const k = this.filter.keyword.toLowerCase()
        result = result.filter(t => 
          (t.title && t.title.toLowerCase().includes(k)) ||
          (t.author && t.author.username && t.author.username.toLowerCase().includes(k)) ||
          (t.category && t.category.name && t.category.name.toLowerCase().includes(k))
        )
      }
      
      return result
    },
    displayThreads() {
      const start = (this.currentPage - 1) * this.pageSize
      const end = start + this.pageSize
      return this.filteredThreads.slice(start, end)
    }
  },
  mounted() {
    this.fetchCategories()
    this.fetchThreads()
  },
  methods: {
    async fetchCategories() {
      const response = await AdminService.getCategories()
      this.categories = response.data
    },
    async fetchThreads() {
      this.loading = true
      const params = {}
      if (this.filter.categoryId) params.categoryId = this.filter.categoryId
      const response = await api.get('/threads', { params })
      this.threads = response.data
      this.loading = false
      this.currentPage = 1 // Reset to first page on fetch
    },
    handleSearch(keyword) {
      this.filter.keyword = keyword
      this.currentPage = 1
    },
    editThread(item) {
      this.$router.push(`/admin/threads/edit/${item.id}`)
    },
    viewThread(item) {
      this.$router.push(`/admin/threads/view/${item.id}`)
    },
    async deleteThread(item) {
      const result = await alertConfirm('Xóa bài viết', `Bạn có chắc chắn muốn xóa bài viết "${item.title}"?`)
      if (result.isConfirmed) {
        try {
          await api.delete(`/threads/${item.id}`)
          toastSuccess('Đã xóa bài viết')
          this.fetchThreads()
        } catch (error) {
          toastError('Lỗi khi xóa bài viết')
        }
      }
    },
    formatDate(dateStr) {
      return new Date(dateStr).toLocaleString('vi-VN')
    }
  }
}
</script>

<style scoped>
.filter-item-mini {
  display: flex;
  align-items: center;
}

.mini-select {
  padding: 0.6rem;
  border: 1px solid var(--border);
  border-radius: 4px;
  background: white;
  outline: none;
  min-width: 200px;
}

.badge-pinned {
  background: #fff3cd;
  color: #856404;
  font-size: 0.7rem;
  padding: 2px 6px;
  border-radius: 3px;
  border: 1px solid #ffeeba;
}

.category-tag {
  background: #e8f4fd;
  color: #007bff;
  padding: 2px 8px;
  border-radius: 4px;
  font-size: 0.8rem;
}
.filter-item-mini {
  display: flex;
  align-items: center;
  gap: 10px;
}

.mini-select {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  background-color: white;
  color: #333;
  font-size: 14px;
  min-width: 200px;
  outline: none;
  cursor: pointer;
}

.mini-select:focus {
  border-color: var(--primary);
}
</style>

