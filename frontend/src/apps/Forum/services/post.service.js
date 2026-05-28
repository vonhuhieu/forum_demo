import api from '@/shared/services/api.service'

class PostService {
  getByThreadId(threadId) {
    return api.get(`/posts/thread/${threadId}`)
  }

  create(payload) {
    return api.post('/posts', payload)
  }

  update(id, payload) {
    return api.put(`/posts/${id}`, payload)
  }

  delete(id) {
    return api.delete(`/posts/${id}`)
  }
}

export default new PostService()
