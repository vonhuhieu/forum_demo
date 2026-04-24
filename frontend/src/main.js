import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './router'

// Import Quill trực tiếp từ package 'quill'
import Quill from 'quill'
import { QuillEditor } from '@vueup/vue-quill'
import '@vueup/vue-quill/dist/vue-quill.snow.css'

// Import BlotFormatter & QuillBetterTable
import BlotFormatter from 'quill-blot-formatter'
import QuillBetterTable from 'quill-better-table'
import 'quill-better-table/dist/quill-better-table.css'

// Đảm bảo Quill có sẵn trên window
window.Quill = Quill

console.log('Quill Constructor:', Quill);
if (typeof Quill.import !== 'function') {
  console.error('CRITICAL: Quill.import is not a function. Check Quill version and import method.');
}

// Đăng ký các module mở rộng
if (typeof Quill.register === 'function') {
  // 1. BlotFormatter
  const actualBlotFormatter = BlotFormatter.default || BlotFormatter
  if (actualBlotFormatter) {
    try {
      Quill.register('modules/blotFormatter', actualBlotFormatter)
      console.log('Registered BlotFormatter');
    } catch (e) {
      console.error('Failed to register BlotFormatter:', e)
    }
  }

  // 1.5 Quill Better Table
  const actualQuillBetterTable = QuillBetterTable.default || QuillBetterTable;
  if (actualQuillBetterTable) {
    try {
      Quill.register('modules/better-table', actualQuillBetterTable, true)
      console.log('Registered QuillBetterTable');
    } catch (e) {
      console.error('Failed to register QuillBetterTable:', e)
    }
  }

  // 2. Cấu hình Font Size (Style Attributor)
  try {
    const FontSize = Quill.import('attributors/style/size')
    if (FontSize) {
      FontSize.whitelist = ['12px', '14px', '16px', '18px', '20px', '24px', '32px', '48px']
      Quill.register(FontSize, true)
      console.log('Registered FontSize attributor');
    }
  } catch (e) {
    console.error('Error importing/registering FontSize:', e)
  }

  // 3. Cấu hình Font Family (Style Attributor)
  try {
    const Font = Quill.import('attributors/style/font')
    if (Font) {
      Font.whitelist = ['roboto', 'arial', 'times-new-roman', 'georgia', 'courier-new', 'verdana']
      Quill.register(Font, true)
      console.log('Registered Font attributor');
    }
  } catch (e) {
    console.error('Error importing/registering Font:', e)
  }
}

const app = createApp(App)
app.use(router)
app.component('QuillEditor', QuillEditor)
app.mount('#app')
