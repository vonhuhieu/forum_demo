import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './router'
import { Quill, QuillEditor } from '@vueup/vue-quill'
import '@vueup/vue-quill/dist/vue-quill.snow.css';
import BlotFormatter from 'quill-blot-formatter';

// Đăng ký module định dạng ảnh/video
Quill.register('modules/blotFormatter', BlotFormatter);

// Cấu hình font size
const FontSize = Quill.import('attributors/style/size');
FontSize.whitelist = ['12px', '14px', '16px', '18px', '20px', '24px', '32px', '48px'];
Quill.register(FontSize, true);

const app = createApp(App)
app.use(router)
app.component('QuillEditor', QuillEditor)
app.mount('#app')
