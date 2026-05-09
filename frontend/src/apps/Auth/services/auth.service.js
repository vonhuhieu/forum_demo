import api from '@/shared/services/api.service'

class AuthService {
  login(credentials) {
    return api.post('/auth/login', credentials)
  }
  register(userData) {
    return api.post('/auth/register', userData)
  }
  forgotPassword(email) {
    return api.post('/auth/forgot-password', { email })
  }
  resetPassword(payload) {
    return api.post('/auth/reset-password', payload)
  }
}

export default new AuthService()
