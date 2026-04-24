<template>
  <div class="admin-layout">
    <!-- Sidebar -->
    <aside class="admin-sidebar">
      <div class="sidebar-brand">
        <div class="brand-icon">HTX</div>
        <span>QUẢN TRỊ HỆ THỐNG</span>
      </div>
      
      <nav class="sidebar-nav">
        <div class="nav-group">
          <div class="nav-label">HỆ THỐNG</div>
          <router-link to="/admin/menu" class="nav-item">
            <span class="icon">☰</span> Cấu hình Menu
          </router-link>
        </div>
        
        <div class="nav-group">
          <div class="nav-label">NỘI DUNG</div>
          <router-link to="/admin/category" class="nav-item">
            <span class="icon">📁</span> Quản lý Chuyên mục
          </router-link>
          <router-link to="/admin/threads" class="nav-item">
            <span class="icon">📝</span> Quản lý Bài viết
          </router-link>
        </div>

        <div class="nav-group">
          <div class="nav-label">NGƯỜI DÙNG</div>
          <router-link to="#" class="nav-item">
            <span class="icon">👥</span> Thành viên
          </router-link>
        </div>
      </nav>

      <div class="sidebar-footer">
        <button @click="handleLogout" class="btn-logout">Đăng xuất</button>
      </div>
    </aside>

    <!-- Main Content -->
    <div class="admin-main">
      <header class="admin-header">
        <div class="breadcrumb">
          <router-link to="/">Trang chủ</router-link> / 
          <span>{{ $route.name }}</span>
        </div>
        <div class="user-info">
          <span>Chào, Admin</span>
        </div>
      </header>

      <div class="admin-content-wrapper">
        <router-view />
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'AdminLayout',
  methods: {
    handleLogout() {
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      this.$router.push('/login')
    }
  }
}
</script>

<style scoped>
.admin-layout { display: flex; height: 100vh; background-color: #f4f7f6; font-family: 'Roboto', sans-serif; }
.admin-sidebar { width: 260px; background-color: #1a507a; color: white; display: flex; flex-direction: column; }
.sidebar-brand { padding: 1.5rem; display: flex; align-items: center; gap: 10px; font-weight: bold; font-size: 1.1rem; background-color: rgba(0,0,0,0.1); }
.brand-icon { background: #ffd700; color: #1a507a; width: 35px; height: 35px; display: flex; align-items: center; justify-content: center; border-radius: 4px; }
.sidebar-nav { flex: 1; padding: 1rem 0; }
.nav-group { margin-bottom: 1.5rem; }
.nav-label { padding: 0 1.5rem; font-size: 0.75rem; font-weight: bold; color: rgba(255,255,255,0.5); margin-bottom: 0.5rem; text-transform: uppercase; }
.nav-item { display: flex; align-items: center; padding: 0.75rem 1.5rem; color: rgba(255,255,255,0.8); text-decoration: none; transition: all 0.3s; gap: 10px; }
.nav-item:hover, .nav-item.router-link-active { background-color: rgba(255,255,255,0.1); color: #ffd700; border-left: 4px solid #ffd700; }
.sidebar-footer { padding: 1rem; border-top: 1px solid rgba(255,255,255,0.1); }
.btn-logout { width: 100%; padding: 0.75rem; background: rgba(231, 76, 60, 0.2); color: #ff7675; border: 1px solid #ff7675; border-radius: 4px; cursor: pointer; }
.admin-main { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
.admin-header { height: 60px; background: white; display: flex; align-items: center; justify-content: space-between; padding: 0 2rem; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
.admin-content-wrapper { flex: 1; padding: 2rem; overflow-y: auto; }
</style>
