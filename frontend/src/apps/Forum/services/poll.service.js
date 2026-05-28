import api from '@/shared/services/api.service'

class PollService {
  vote(pollId, optionIds) {
    return api.post(`/polls/${pollId}/vote`, { optionIds })
  }

  getVotes(pollId, params) {
    return api.get(`/polls/${pollId}/votes`, { params })
  }
}

export default new PollService()
