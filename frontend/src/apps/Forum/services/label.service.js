import api from '@/shared/services/api.service'

class LabelService {
  getAll() {
    return api.get('/labels')
  }
}

export default new LabelService()
