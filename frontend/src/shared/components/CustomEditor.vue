<template>
  <div class="custom-editor-wrapper">
    <ckeditor 
      :editor="editor" 
      :model-value="modelValue" 
      @update:model-value="$emit('update:modelValue', $event)"
      :config="editorConfig"
      :disabled="disabled"
    ></ckeditor>
  </div>
</template>

<script>
import { Ckeditor } from '@ckeditor/ckeditor5-vue'
import {
  ClassicEditor,
  Essentials,
  Paragraph,
  Heading,
  Bold,
  Italic,
  Underline,
  Strikethrough,
  Font,
  Alignment,
  Link,
  List,
  Indent,
  IndentBlock,
  Image,
  ImageUpload,
  ImageResize,
  Table,
  MediaEmbed,
  BlockQuote,
  FileRepository,
  TableToolbar,
  TableColumnResize,
  Undo
} from 'ckeditor5'
import 'ckeditor5/ckeditor5.css'
import { MyCustomUploadAdapterPlugin, CustomUploadPlugin } from '@/shared/utils/ckeditorPlugins'

export default {
  name: 'CustomEditor',
  components: {
    ckeditor: Ckeditor
  },
  props: {
    modelValue: {
      type: String,
      default: ''
    },
    disabled: {
      type: Boolean,
      default: false
    }
  },
  emits: ['update:modelValue'],
  data() {
    return {
      editor: ClassicEditor,
      editorConfig: {
        licenseKey: 'GPL',
        mediaEmbed: {
          extraProviders: [
            {
              name: 'uploaded-video',
              url: /^.*\.(mp4|webm|ogg|avi|mov)(\?.*)?$/,
              html: match => {
                let url = match[0];
                const uploadsIndex = url.indexOf('/uploads/');
                if (uploadsIndex !== -1) {
                  url = url.substring(uploadsIndex);
                }
                return `<div data-cke-ignore-events="true" style="width: 100%;"><video controls data-cke-ignore-events="true" style="width: 100%; max-height: 500px; object-fit: contain; background: #000;" src="${url}"></video></div>`;
              }
            }
          ]
        },
        fontSize: {
          options: [
            9, 10, 11, 12, 13, 'default', 15, 16, 18, 20, 22, 24, 28, 32, 36
          ]
        },
        image: {
          resizeOptions: [
            { name: 'resizeImage:original', value: null, label: 'Original' },
            { name: 'resizeImage:50', value: '50', label: '50%' },
            { name: 'resizeImage:75', value: '75', label: '75%' }
          ],
          toolbar: [
            'imageStyle:inline',
            'imageStyle:block',
            'imageStyle:side',
            '|',
            'toggleImageCaption',
            'imageTextAlternative',
            '|',
            'resizeImage'
          ]
        },
        plugins: [
          Essentials, Paragraph, Heading, Bold, Italic, Underline, Strikethrough,
          Font, Alignment, Link, List, Indent, IndentBlock, Image, ImageUpload, ImageResize, Table,
          MediaEmbed, BlockQuote, FileRepository, TableToolbar, TableColumnResize, Undo,
          MyCustomUploadAdapterPlugin, CustomUploadPlugin
        ],
        toolbar: {
          items: [
            'heading',
            '|',
            'bold', 'italic', 'underline', 'strikethrough',
            '|',
            'fontSize', 'fontFamily', 'fontColor', 'fontBackgroundColor',
            '|',
            'alignment',
            '|',
            'bulletedList', 'numberedList',
            '|',
            'outdent', 'indent',
            '|',
            'link', 'imageUpload', 'customUpload', 'insertTable', 'mediaEmbed', 'blockQuote',
            '|',
            'undo', 'redo'
          ]
        },
        table: {
          contentToolbar: [
            'tableColumn', 'tableRow', 'mergeTableCells'
          ]
        },
        language: 'vi'
      }
    }
  }
}
</script>

<style scoped>
.custom-editor-wrapper {
  background: white;
  min-height: 400px;
}

:deep(.ck-editor__editable) {
  min-height: 400px;
  font-size: 16px;
  line-height: 1.6;
}

:deep(.ck-content table) {
  width: 100%;
  border-collapse: collapse;
}

/* Ghi đè các lớp bảo vệ của CKEditor để cho phép click vào video trong lúc soạn thảo */
:deep(.ck-editor__editable .ck-widget[data-widget="media"]) {
  pointer-events: auto !important;
}
:deep(.ck-editor__editable .ck-media__wrapper) {
  pointer-events: auto !important;
}
:deep(.ck-editor__editable .ck-media__wrapper::after) {
  display: none !important;
  pointer-events: none !important;
}
:deep(.ck-editor__editable .ck-media__wrapper video),
:deep(.ck-editor__editable .ck-media__wrapper iframe) {
  pointer-events: auto !important;
  z-index: 1000 !important;
}

:deep(.ck-content td), :deep(.ck-content th) {
  border: 1px solid #bfbfbf;
  padding: 0.4em;
}
</style>
