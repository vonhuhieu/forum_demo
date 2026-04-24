import api from '@/shared/services/api.service'

class AuthService {
  login(credentials) {
    return api.post('/auth/login', credentials)
  }
  register(userData) {
    return api.post('/auth/register', userData)
  }
}

export default new AuthService()
