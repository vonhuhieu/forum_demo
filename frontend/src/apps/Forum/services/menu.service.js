import api from '@/shared/services/api.service'

class MenuService {
  getAll() {
    return api.get('/menus')
  }
}

export default new MenuService()
