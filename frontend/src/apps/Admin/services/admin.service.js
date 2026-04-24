import api from '@/shared/services/api.service'

class AdminService {
  // Categories
  getCategories() {
    return api.get('/categories')
  }
  createCategory(data) {
    return api.post('/categories', data)
  }
  updateCategory(id, data) {
    return api.put(`/categories/${id}`, data)
  }
  deleteCategory(id) {
    return api.delete(`/categories/${id}`)
  }

  // Menus
  getMenus() {
    return api.get('/menus')
  }
  createMenu(data) {
    return api.post('/menus', data)
  }
  updateMenu(id, data) {
    return api.put(`/menus/${id}`, data)
  }
  deleteMenu(id) {
    return api.delete(`/menus/${id}`)
  }
}

export default new AdminService()
