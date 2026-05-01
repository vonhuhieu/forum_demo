<template>
  <header class="admin-header">
    <div class="header-left">
      <div class="logo" @click="$router.push({ name: 'Home' })">HTXSL</div>
    </div>
    <div class="header-right">
      <div class="user-info">
        <span class="user-avatar">A</span>
        <span class="user-name">Chào, Admin</span>
      </div>
    </div>
  </header>
</template>

<script>
export default {
  name: 'AdminHeader'
}
</script>

<style scoped>
.admin-header {
  height: 60px;
  background-color: #1a507a;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 1.5rem;
  color: white;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.logo {
  font-size: 1.5rem;
  font-weight: 700;
  letter-spacing: 1px;
  cursor: pointer;
  color: white;
}

.header-right {
  display: flex;
  align-items: center;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 10px;
}

.user-avatar {
  width: 32px;
  height: 32px;
  background: white;
  color: #1a507a;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.8rem;
  font-weight: bold;
}

.user-name {
  font-size: 0.9rem;
  color: white;
  font-weight: 500;
}
</style>
