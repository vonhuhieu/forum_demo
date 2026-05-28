import api from '@/shared/services/api.service'

class UploadService {
  upload(formData, config) {
    return api.post('/upload', formData, config)
  }

  uploadMultiple(formData, config) {
    return api.post('/upload/multiple', formData, config)
  }
}

export default new UploadService()
