<script setup>
import { ref } from 'vue'
import axios from 'axios'
import { useRouter } from 'vue-router'

const router = useRouter()
const username = ref('')
const password = ref('')
const confirmPassword = ref('')
const error = ref('')
const success = ref('')

const handleRegister = async () => {
  if (password.value !== confirmPassword.value) {
    error.value = 'Mật khẩu xác nhận không khớp'
    return
  }

  try {
    await axios.post('http://localhost:8080/api/auth/register', {
      username: username.value,
      password: password.value
    })
    success.value = 'Đăng ký thành công! Đang chuyển hướng đến trang đăng nhập...'
    setTimeout(() => {
      router.push('/login')
    }, 2000)
  } catch (err) {
    error.value = err.response?.data?.message || 'Đã có lỗi xảy ra'
  }
}
</script>

<template>
  <div class="login-page">
    <div class="card login-card">
      <div class="card-header">ĐĂNG KÝ THÀNH VIÊN</div>
      <form @submit.prevent="handleRegister" class="login-form">
        <div class="form-group">
          <label>Tên đăng nhập</label>
          <input v-model="username" required>
        </div>
        <div class="form-group">
          <label>Mật khẩu</label>
          <input type="password" v-model="password" required>
        </div>
        <div class="form-group">
          <label>Xác nhận mật khẩu</label>
          <input type="password" v-model="confirmPassword" required>
        </div>
        <div v-if="error" class="error-msg">{{ error }}</div>
        <div v-if="success" class="success-msg">{{ success }}</div>
        <button type="submit" class="btn-login">ĐĂNG KÝ NGAY</button>
        <div style="margin-top: 1rem; text-align: center;">
            Đã có tài khoản? <router-link to="/login">Đăng nhập</router-link>
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
.success-msg { color: #27ae60; margin-bottom: 1rem; text-align: center; font-size: 0.9rem; }
</style>
