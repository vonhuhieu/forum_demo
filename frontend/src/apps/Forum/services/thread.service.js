import api from '@/shared/services/api.service'

class ThreadService {
  getAll(params) {
    return api.get('/threads', { params })
  }
  getById(id) {
    return api.get(`/threads/${id}`)
  }
  create(payload) {
    return api.post('/threads', payload)
  }
  delete(id) {
    return api.delete(`/threads/${id}`)
  }
  pin(id) {
    return api.patch(`/threads/${id}/pin`)
  }
}

export default new ThreadService()
