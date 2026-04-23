<script setup>
import { ref } from 'vue'
import axios from 'axios'
import { useRouter } from 'vue-router'

const router = useRouter()
const username = ref('')
const password = ref('')
const error = ref('')

const handleLogin = async () => {
  try {
    const response = await axios.post('http://localhost:8080/api/auth/login', {
      username: username.value,
      password: password.value
    })
    
    localStorage.setItem('token', response.data.token)
    localStorage.setItem('user', JSON.stringify(response.data))
    
    // Kiểm tra quyền để chuyển hướng
    const roles = response.data.roles || []
    if (roles.includes('ROLE_ADMIN')) {
      router.push('/admin/menu')
    } else {
      router.push('/')
    }
  } catch (err) {
    error.value = 'Tài khoản hoặc mật khẩu không chính xác'
  }
}
</script>

<template>
  <div class="login-page">
    <div class="card login-card">
      <div class="card-header">ĐĂNG NHẬP HỆ THỐNG</div>
      <form @submit.prevent="handleLogin" class="login-form">
        <div class="form-group">
          <label>Tên đăng nhập</label>
          <input v-model="username" required>
        </div>
        <div class="form-group">
          <label>Mật khẩu</label>
          <input type="password" v-model="password" required>
        </div>
        <div v-if="error" class="error-msg">{{ error }}</div>
        <button type="submit" class="btn-login">VÀO HỆ THỐNG</button>
        <div style="margin-top: 1rem; text-align: center;">
            <router-link to="/">Quay lại trang chủ</router-link>
        </div>
      </form>
    </div>
  </div>
</template>

<style scoped>
.login-page {
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #004a7c;
}
.login-card { width: 400px; }
.login-form { padding: 2rem; }
.form-group { margin-bottom: 1.5rem; }
.form-group label { display: block; margin-bottom: 0.5rem; font-weight: bold; color: #1a507a; }
.form-group input { width: 100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 4px; }
.btn-login { width: 100%; background: #1a507a; color: white; border: none; padding: 1rem; border-radius: 4px; font-weight: bold; cursor: pointer; }
.error-msg { color: #e74c3c; margin-bottom: 1rem; text-align: center; font-size: 0.9rem; }
</style>
