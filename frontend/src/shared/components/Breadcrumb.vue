<template>
  <nav class="breadcrumb" aria-label="breadcrumb">
    <ol>
      <!-- Trang chủ luôn ở đầu -->
      <li class="breadcrumb-item">
        <router-link to="/">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon-home"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>
        </router-link>
      </li>

      <!-- Danh sách các item truyền vào -->
      <li 
        v-for="(item, index) in items" 
        :key="index" 
        class="breadcrumb-item"
        :class="{ active: index === items.length - 1 }"
      >
        <span class="separator">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"></polyline></svg>
        </span>
        <template v-if="item.to && index !== items.length - 1">
          <router-link :to="item.to">{{ item.title }}</router-link>
        </template>
        <template v-else>
          <span>{{ item.title }}</span>
        </template>
      </li>
    </ol>
  </nav>
</template>

<script>
export default {
  name: 'Breadcrumb',
  props: {
    items: {
      type: Array,
      default: () => [],
      // Cấu trúc mong đợi: [{ title: '...', to: '...' }]
    }
  }
}
</script>

<style scoped>
.breadcrumb {
  margin-bottom: 1rem;
  padding: 0.75rem 1rem;
  background-color: #f8f9fa;
  border-radius: 4px;
}

.breadcrumb ol {
  list-style: none;
  margin: 0;
  padding: 0;
  display: flex;
  flex-wrap: wrap;
  align-items: center;
}

.breadcrumb-item {
  display: flex;
  align-items: center;
  font-size: 0.9rem;
}

.breadcrumb-item a {
  color: #1a507a;
  text-decoration: none;
  transition: color 0.2s ease;
  display: flex;
  align-items: center;
}

.breadcrumb-item a:hover {
  color: #d13838;
  text-decoration: underline;
}

.icon-home {
  margin-bottom: 2px;
}

.separator {
  margin: 0 0.5rem;
  color: #6c757d;
  display: flex;
  align-items: center;
}

.breadcrumb-item.active {
  color: #6c757d;
  font-weight: 500;
}
</style>
