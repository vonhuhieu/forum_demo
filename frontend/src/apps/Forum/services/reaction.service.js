import api from '@/shared/services/api.service'

class ReactionService {
  getIcons() {
    return api.get('/reaction-icons')
  }

  addReaction(type, targetId, iconId) {
    const endpoint = type === 'thread'
      ? `/reactions/threads/${targetId}`
      : `/reactions/posts/${targetId}`
    return api.post(`${endpoint}?iconId=${iconId}`)
  }

  removeReaction(type, targetId) {
    const endpoint = type === 'thread'
      ? `/reactions/threads/${targetId}`
      : `/reactions/posts/${targetId}`
    return api.delete(endpoint)
  }

  getParticipants(type, targetId, params) {
    // type must be 'threads' or 'posts'
    return api.get(`/reactions/${type}/${targetId}/participants`, { params })
  }
}

export default new ReactionService()
