import Swal from 'sweetalert2'

const Toast = Swal.mixin({
  toast: true,
  position: 'top-end',
  showConfirmButton: false,
  timer: 3000,
  timerProgressBar: true,
  didOpen: (toast) => {
    toast.addEventListener('mouseenter', Swal.stopTimer)
    toast.addEventListener('mouseleave', Swal.resumeTimer)
  }
})

export const alertSuccess = (message) => {
  return Swal.fire({
    icon: 'success',
    title: 'Thành công',
    text: message,
    confirmButtonColor: '#27ae60'
  })
}

export const alertError = (message) => {
  return Swal.fire({
    icon: 'error',
    title: 'Lỗi',
    text: message,
    confirmButtonColor: '#e74c3c'
  })
}

export const alertConfirm = (title, text) => {
  return Swal.fire({
    title: title,
    text: text,
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#27ae60',
    cancelButtonColor: '#95a5a6',
    confirmButtonText: 'Đồng ý',
    cancelButtonText: 'Hủy bỏ'
  })
}

export const toastSuccess = (message) => {
  Toast.fire({
    icon: 'success',
    title: message
  })
}

export const toastError = (message) => {
  Toast.fire({
    icon: 'error',
    title: message
  })
}

export default {
  alertSuccess,
  alertError,
  alertConfirm,
  toastSuccess,
  toastError
}
