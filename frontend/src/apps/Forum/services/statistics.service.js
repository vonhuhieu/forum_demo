import api from '@/shared/services/api.service'

class StatisticsService {
  get() {
    return api.get('/statistics')
  }
}

export default new StatisticsService()
