import api from '@/shared/services/api.service'

class PostService {
  getByThreadId(threadId, page = 0, size = 10) {
    return api.get(`/posts/thread/${threadId}`, { params: { page, size } })
  }

  getPageNumber(postId, size = 10) {
    return api.get(`/posts/${postId}/page-number`, { params: { size } })
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
