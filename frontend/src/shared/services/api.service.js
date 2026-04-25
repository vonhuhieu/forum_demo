import axios from 'axios'

const api = axios.create({
  baseURL: 'http://localhost:8080/api'
})

// Interceptor đính kèm Token vào Header
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// Interceptor xử lý phản hồi
api.interceptors.response.use(
  (response) => {
    // Nếu phản hồi có cấu trúc { status, data } từ ResponseDTO của Backend
    if (response.data && Object.prototype.hasOwnProperty.call(response.data, 'status') && Object.prototype.hasOwnProperty.call(response.data, 'data')) {
      return { ...response, data: response.data.data }
    }
    return response
  },
  (error) => {
    if (error.response && error.response.status === 401) {
      localStorage.removeItem('token')
      window.location.href = '/login'
    }
    return Promise.reject(error)
  }
)

export default api
