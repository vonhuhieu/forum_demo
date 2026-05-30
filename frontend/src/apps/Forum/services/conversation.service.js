import api from '@/shared/services/api.service'

class ConversationService {
  getAll() {
    return api.get('/conversations')
  }

  getUnreadCount() {
    return api.get('/conversations/unread-count')
  }

  markAsRead(id) {
    return api.put(`/conversations/${id}/read`)
  }

  getById(id) {
    return api.get(`/conversations/${id}`)
  }

  create(payload) {
    return api.post('/conversations', payload)
  }

  addMessage(id, payload) {
    return api.post(`/conversations/${id}/messages`, payload)
  }

  markAllAsRead() {
    return api.put('/conversations/read-all')
  }
}

export default new ConversationService()
