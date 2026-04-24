<template>
  <div class="admin-create-thread">
    <div class="card">
      <div class="card-header">TẠO BÀI VIẾT MỚI (QUẢN TRỊ)</div>
      <div class="admin-form" style="padding: 2rem;">
        <div class="form-group">
          <label>Tiêu đề bài viết:</label>
          <input v-model="form.title" class="admin-input-large" placeholder="Nhập tiêu đề..." required>
        </div>

        <div class="form-row" style="display: flex; gap: 2rem; margin-bottom: 1.5rem;">
          <div class="form-group" style="flex: 1;">
            <label>Chuyên mục:</label>
            <select v-model="form.categoryId" class="admin-input" required>
              <option value="">-- Chọn chuyên mục --</option>
              <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
            </select>
          </div>
          <div class="form-group" style="padding-top: 2rem;">
            <label style="display: flex; align-items: center; gap: 10px; cursor: pointer;">
              <input type="checkbox" v-model="form.pinned"> Ghim bài viết lên đầu
            </label>
          </div>
        </div>

        <div class="form-group">
          <label>Nội dung bài viết:</label>
          <div class="editor-wrapper">
            <QuillEditor
              ref="quillRef"
              v-model:content="form.content"
              contentType="html"
              theme="snow"
              :modules="customModules"
              :toolbar="{ container: toolbarOptions, handlers: customHandlers }"
              @ready="onEditorReady"
              :options="editorOptions"
              placeholder="Nhập nội dung bài viết..."
              style="height: 500px;"
            />
          </div>
        </div>

        <div class="form-actions" style="margin-top: 2rem; display: flex; gap: 1rem; justify-content: flex-end;">
          <button @click="$router.push('/admin/threads')" class="btn-cancel">Hủy bỏ</button>
          <button @click="handlePost" class="btn-save">Đăng bài ngay</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { QuillEditor } from '@vueup/vue-quill'
import '@vueup/vue-quill/dist/vue-quill.snow.css'
import api from '@/shared/services/api.service'
import AdminService from '@/apps/Admin/services/admin.service'
import QuillBetterTable from 'quill-better-table'
import BlotFormatter from 'quill-blot-formatter'

const QuillBetterTableOriginal = QuillBetterTable.default || QuillBetterTable
class SafeQuillBetterTable extends QuillBetterTableOriginal {
  constructor(quill, options) {
    if (quill && quill.keyboard && quill.keyboard.bindings) {
      if (!('Backspace' in quill.keyboard.bindings)) {
        Object.defineProperty(quill.keyboard.bindings, 'Backspace', {
          get: function() { return this[8] || [] },
          set: function(val) { this[8] = val }
        })
      }
    }
    super(quill, options)
  }
}
SafeQuillBetterTable.keyboardBindings = QuillBetterTableOriginal.keyboardBindings

const BlotFormatterModule = BlotFormatter.default || BlotFormatter

const toolbarOptions = [
  ['bold', 'italic', 'underline', 'strike'],
  ['blockquote', 'code-block'],
  [{ 'header': 1 }, { 'header': 2 }],
  [{ 'list': 'ordered' }, { 'list': 'bullet' }],
  [{ 'indent': '-1' }, { 'indent': '+1' }],
  [{ 'font': ['roboto', 'arial', 'times-new-roman', 'georgia', 'courier-new', 'verdana'] }],
  [{ 'size': ['12px', '14px', '16px', '18px', '20px', '24px', '32px', '48px'] }],
  [{ 'color': [] }, { 'background': [] }],
  [{ 'align': [] }],
  ['link', 'image', 'video', 'table'],
  ['attachment'],
  ['clean']
]

const customModules = [
  { name: 'blotFormatter', module: BlotFormatterModule, options: {} },
  {
    name: 'better-table',
    module: SafeQuillBetterTable,
    options: {
      operationMenu: {
        items: { unmergeCells: { text: 'Bỏ gộp ô' } },
        color: { colors: ['green', 'red', 'yellow', 'blue', 'white', '#000', '#f3f4f6'] }
      }
    }
  }
]

const editorOptions = {
  bounds: 'body',
  modules: {
    table: false,
    keyboard: { bindings: SafeQuillBetterTable.keyboardBindings }
  }
}

export default {
  name: 'AdminCreateThread',
  components: { QuillEditor },
  data() {
    return {
      categories: [],
      form: { title: '', content: '', categoryId: '', pinned: false },
      toolbarOptions,
      customModules,
      editorOptions,
      customHandlers: {
        image: () => this.selectFile('image/*'),
        video: () => this.selectFile('video/*'),
        attachment: () => this.selectFile('*'),
        table: function() {
          const q = this.quill
          const tableMod = q.getModule('better-table')
          if (tableMod) {
            const rowsStr = prompt('Nhập số dòng (mặc định 3):', '3')
            if (rowsStr === null) return
            const colsStr = prompt('Nhập số cột (mặc định 3):', '3')
            if (colsStr === null) return
            const rows = parseInt(rowsStr, 10)
            const cols = parseInt(colsStr, 10)
            if (!isNaN(rows) && !isNaN(cols) && rows > 0 && cols > 0) {
              q.focus()
              tableMod.insertTable(rows, cols)
            } else {
              alert('Số dòng và số cột phải là số hợp lệ lớn hơn 0.')
            }
          } else {
            alert('Module bảng chưa được tải!')
          }
        },
        link: function(value) {
          const q = this.quill
          const range = q.getSelection()
          if (value) {
            const href = prompt('Nhập địa chỉ liên kết (URL):', 'https://')
            if (href && href !== 'https://') {
              q.focus()
              if (range && range.length > 0) {
                q.formatText(range.index, range.length, 'link', href)
              } else {
                const index = range ? range.index : q.getLength()
                q.insertText(index, href, 'link', href)
                q.setSelection(index + href.length)
              }
            }
          } else {
            q.format('link', false)
          }
        }
      }
    }
  },
  mounted() {
    this.fetchCategories()
    setTimeout(this.addTooltips, 500)
  },
  methods: {
    async fetchCategories() {
      const response = await AdminService.getCategories()
      this.categories = response.data
    },
    async handlePost() {
      if (!this.form.title || !this.form.content || !this.form.categoryId) {
        alert('Vui lòng điền đầy đủ thông tin')
        return
      }
      try {
        await api.post('/threads', {
          title: this.form.title,
          content: this.form.content,
          category: { id: this.form.categoryId },
          pinned: this.form.pinned
        })
        this.$router.push('/admin/threads')
      } catch (error) {
        alert('Lỗi khi đăng bài')
      }
    },
    selectFile(accept) {
      const input = document.createElement('input')
      input.setAttribute('type', 'file')
      input.setAttribute('accept', accept)
      input.click()
      input.onchange = async () => {
        const file = input.files[0]
        if (!file) return
        const formData = new FormData()
        formData.append('file', file)
        try {
          const res = await api.post('/upload', formData, {
            headers: { 'Content-Type': 'multipart/form-data' }
          })
          const url = res.data.url
          const quill = this.$refs.quillRef.getQuill()
          const range = quill.getSelection(true)
          if (file.type.startsWith('image/')) {
            quill.insertEmbed(range.index, 'image', url)
          } else if (file.type.startsWith('video/')) {
            quill.insertEmbed(range.index, 'video', url)
          } else {
            quill.insertText(range.index, `📎 ${file.name} `, { 'link': url, 'bold': true, 'color': '#2980b9' })
          }
          quill.setSelection(range.index + 1)
        } catch (error) {
          alert('Lỗi khi tải file lên')
        }
      }
    },
    onEditorReady(quill) {
      const tableBtn = document.querySelector('.ql-table')
      if (tableBtn && tableBtn.innerHTML.trim() === '') {
        tableBtn.innerHTML = '<svg viewBox="0 0 18 18"><rect class="ql-stroke" height="12" width="14" x="2" y="3"/><line class="ql-stroke" x1="2" x2="16" y1="9" y2="9"/><line class="ql-stroke" x1="8" x2="8" y1="3" y2="15"/></svg>'
      }
      const tooltip = quill.theme.tooltip
      if (!tooltip) return
      const getLinkBlotAtCursor = (range) => {
        if (!range) return null
        let [leaf] = quill.getLeaf(range.index)
        if (leaf && leaf.parent && leaf.parent.statics.blotName === 'link') return leaf.parent
        if (range.index > 0) {
          let [leafBefore] = quill.getLeaf(range.index - 1)
          if (leafBefore && leafBefore.parent && leafBefore.parent.statics.blotName === 'link') return leafBefore.parent
        }
        return null
      }
      const originalSave = tooltip.save
      tooltip.save = function() {
        const value = this.textbox.value
        const range = this.quill.getSelection(true)
        if (value && this.root.getAttribute('data-mode') === 'link') {
          const linkBlot = getLinkBlotAtCursor(range)
          if (linkBlot) {
            const text = linkBlot.domNode.innerText
            const oldHref = linkBlot.formats().link
            if (text && oldHref && text.trim() === oldHref.trim()) {
              const linkIndex = this.quill.getIndex(linkBlot)
              const linkLength = linkBlot.length()
              this.quill.deleteText(linkIndex, linkLength)
              this.quill.insertText(linkIndex, value, 'link', value)
              this.hide()
              return
            }
          }
        }
        originalSave.call(this)
      }
      const removeBtn = tooltip.root.querySelector('a.ql-remove')
      if (removeBtn) {
        const newRemoveBtn = removeBtn.cloneNode(true)
        removeBtn.parentNode.replaceChild(newRemoveBtn, removeBtn)
        newRemoveBtn.addEventListener('click', function(e) {
          e.preventDefault()
          e.stopPropagation()
          let deleted = false
          if (tooltip.linkRange) {
            quill.deleteText(tooltip.linkRange.index, tooltip.linkRange.length)
            deleted = true
          } else {
            const range = quill.getSelection(true)
            const linkBlot = getLinkBlotAtCursor(range)
            if (linkBlot) {
              quill.deleteText(quill.getIndex(linkBlot), linkBlot.length())
              deleted = true
            }
          }
          if (!deleted) quill.format('link', false)
          tooltip.hide()
        })
      }
    },
    addTooltips() {
      const tooltips = {
        'ql-bold': 'In đậm', 'ql-italic': 'In nghiêng', 'ql-underline': 'Gạch chân', 'ql-strike': 'Gạch ngang',
        'ql-blockquote': 'Trích dẫn', 'ql-code-block': 'Chèn mã', 'ql-list[value="ordered"]': 'Số thứ tự',
        'ql-list[value="bullet"]': 'Dấu chấm', 'ql-indent[value="-1"]': 'Giảm thụt lề', 'ql-indent[value="+1"]': 'Tăng thụt lề',
        'ql-color': 'Màu chữ', 'ql-background': 'Màu nền', 'ql-align': 'Căn lề', 'ql-link': 'Liên kết',
        'ql-image': 'Ảnh', 'ql-video': 'Video', 'ql-table': 'Chèn bảng', 'ql-attachment': 'Đính kèm tệp tin', 'ql-clean': 'Xóa định dạng'
      }
      for (let key in tooltips) {
        document.querySelectorAll(`.admin-create-thread .${key}`).forEach(el => el.setAttribute('title', tooltips[key]))
      }
      const attachBtn = document.querySelector('.admin-create-thread .ql-attachment')
      if (attachBtn) {
        attachBtn.innerHTML = '<svg viewBox="0 0 24 24" style="width:18px;height:18px;"><path fill="currentColor" d="M16.5,6V17.5A4,4 0 0,1 12.5,21.5A4,4 0 0,1 8.5,17.5V5A2.5,2.5 0 0,1 11,2.5A2.5,2.5 0 0,1 13.5,5V15.5A1,1 0 0,1 12.5,16.5A1,1 0 0,1 11.5,15.5V6H10V15.5A2.5,2.5 0 0,0 12.5,18A2.5,2.5 0 0,0 15,15.5V5A4,4 0 0,0 11,1A4,4 0 0,0 7,5V17.5A5.5,5.5 0 0,0 12.5,23A5.5,5.5 0 0,0 18,17.5V6H16.5Z" /></svg>'
      }
    }
  }
}
</script>

<style scoped>
.admin-input-large { width: 100%; padding: 1rem; font-size: 1.2rem; border: 1px solid #ddd; border-radius: 4px; }
.admin-input { width: 100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 4px; }
.btn-save { background-color: #27ae60; color: white; border: none; padding: 12px 30px; border-radius: 4px; font-weight: bold; cursor: pointer; }
.btn-cancel { background-color: #95a5a6; color: white; border: none; padding: 12px 20px; border-radius: 4px; cursor: pointer; }
.form-group label { font-weight: bold; display: block; margin-bottom: 0.5rem; }
:deep(.ql-editor) { font-size: 16px; }
:deep(.ql-editor table) { border-collapse: collapse; width: 100%; }
:deep(.ql-editor td) { border: 1px solid #ccc; padding: 8px; }
</style>
