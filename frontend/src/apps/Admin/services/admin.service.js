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

  // Category Groups
  getCategoryGroups() {
    return api.get('/category-groups')
  }
  createCategoryGroup(data) {
    return api.post('/category-groups', data)
  }
  updateCategoryGroup(id, data) {
    return api.put(`/category-groups/${id}`, data)
  }
  deleteCategoryGroup(id) {
    return api.delete(`/category-groups/${id}`)
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
