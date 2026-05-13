<template>
  <div class="custom-editor-wrapper" :style="{ '--editor-min-height': minHeight }">
    <ckeditor 
      :editor="editor" 
      :model-value="modelValue" 
      @update:model-value="$emit('update:modelValue', $event)"
      :config="editorConfig"
      :disabled="disabled"
      @ready="onEditorReady"
    ></ckeditor>

    <!-- Reusable Emoji & Sticker Picker -->
    <EmojiPicker
      :visible="showEmojiPicker"
      :target-element="emojiPickerTarget"
      @close="showEmojiPicker = false"
      @select="handleEmojiSelect"
    />
  </div>
</template>

<script>
import { Ckeditor } from '@ckeditor/ckeditor5-vue'
import translations from 'ckeditor5/translations/vi.js'
import {
  ClassicEditor,
  Plugin,
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
  ImageInsert,
  ImageResize,
  ImageStyle,
  ImageToolbar,
  ImageCaption,
  ImageTextAlternative,
  Table,
  MediaEmbed,
  BlockQuote,
  FileRepository,
  TableToolbar,
  TableColumnResize,
  Undo,
  TextTransformation
} from 'ckeditor5'
import 'ckeditor5/ckeditor5.css'
import { MyCustomUploadAdapterPlugin, CustomUploadPlugin, TabIndentPlugin, ClearPastedImageWidthPlugin, EmojiPickerPlugin } from '@/shared/utils/ckeditorPlugins'
import EmojiPicker from '@/shared/components/EmojiPicker.vue'
 
class QuoteSourcePlugin extends Plugin {
  static get requires() {
    return [BlockQuote];
  }
  init() {
    const editor = this.editor;
    editor.model.schema.extend('blockQuote', { allowAttributes: 'data-source' });
    editor.conversion.attributeToAttribute({ model: 'data-source', view: 'data-source' });
  }
}

export default {
  name: 'CustomEditor',
  components: {
    ckeditor: Ckeditor,
    EmojiPicker
  },
  props: {
    modelValue: {
      type: String,
      default: ''
    },
    disabled: {
      type: Boolean,
      default: false
    },
    minHeight: {
      type: String,
      default: '400px'
    }
  },
  emits: ['update:modelValue', 'ready', 'image-uploaded'],
  data() {
    return {
      editorInstance: null,
      showEmojiPicker: false,
      emojiPickerTarget: null,
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
          styles: [
            'alignLeft',
            'alignCenter',
            'alignRight'
          ],
          toolbar: [
            'imageStyle:alignLeft',
            'imageStyle:alignCenter',
            'imageStyle:alignRight',
            '|',
            'toggleImageCaption',
            'imageTextAlternative',
            '|',
            'resizeImage'
          ]
        },
        plugins: [
          Essentials, Paragraph, Heading, Bold, Italic, Underline, Strikethrough,
          Font, Alignment, Link, List, Indent, IndentBlock, Image, ImageUpload, ImageInsert, ImageResize, ImageStyle, ImageToolbar, ImageCaption, ImageTextAlternative, Table,
          MediaEmbed, BlockQuote, FileRepository, TableToolbar, TableColumnResize, Undo, TextTransformation,
          MyCustomUploadAdapterPlugin, CustomUploadPlugin, TabIndentPlugin, ClearPastedImageWidthPlugin, EmojiPickerPlugin, QuoteSourcePlugin
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
            'link', 'insertImage', 'customUpload', 'emojiPicker', 'insertTable', 'mediaEmbed', 'blockQuote',
            '|',
            'undo', 'redo'
          ]
        },
        typing: {
          transformations: {
            include: [ 'symbols', 'mathematical', 'typography', 'quotes' ],
            extra: [
              { from: ':)', to: '😊' },
              { from: ';)', to: '😉' },
              { from: ':D', to: '😀' },
              { from: ':(', to: '☹️' },
              { from: '<3', to: '❤️' },
              { from: ':*', to: '😘' }
            ]
          }
        },
        table: {
          contentToolbar: [
            'tableColumn', 'tableRow', 'mergeTableCells'
          ]
        },
        link: {
          decorators: {
            openInNewTab: {
              mode: 'automatic',
              callback: url => !url.startsWith('#'),
              attributes: {
                target: '_blank',
                rel: 'noopener noreferrer'
              }
            },
            downloadable: {
              mode: 'automatic',
              callback: url => url.match(/\.(pdf|docx|xls|xlsx|doc|txt|zip|rar)$/i),
              attributes: {
                download: 'file'
              }
            }
          }
        },
        language: 'vi',
        translations: [
          translations,
          {
            language: 'vi',
            dictionary: {
              'Insert image': 'Chèn ảnh'
            }
          }
        ]
      }
    }
  },
  methods: {
    onEditorReady(editor) {
      this.editorInstance = editor;
      
      editor.on('imageUploaded', (evt, data) => {
        this.$emit('image-uploaded', data);
      });

      // Lắng nghe sự kiện click nút Picker từ Plugin
      editor.on('openEmojiPicker', (evt, data) => {
        this.emojiPickerTarget = data.domTarget;
        this.showEmojiPicker = !this.showEmojiPicker;
      });

      this.$emit('ready', editor);
    },
    handleEmojiSelect(item) {
      if (!this.editorInstance) return;

      this.editorInstance.model.change(writer => {
        const selection = this.editorInstance.model.document.selection;
        let insertPosition = selection.getFirstPosition();

        if (item.type === 'unicode') {
          // Chèn chữ thuần (emoji text)
          writer.insertText(item.value, selection.getAttributes(), insertPosition);
        } else if (item.type === 'image') {
          // Chèn Inline Image cho stickers
          const imageElement = writer.createElement('imageInline', { 
            src: item.value, 
            alt: item.name,
            resizedWidth: '24px' // Kích thước cố định nhỏ gọn cho sticker trong dòng văn bản
          });
          writer.insert(imageElement, insertPosition);
        }
      });

      // Focus trả lại editor để gõ tiếp
      this.editorInstance.editing.view.focus();
    },
    insertImages(urls, type = 'full') {
      if (!this.editorInstance) return;
      
      this.editorInstance.model.change(writer => {
        const selection = this.editorInstance.model.document.selection;
        let insertPosition = selection.getFirstPosition();

        if (type === 'thumbnail') {
          const paragraph = writer.createElement('paragraph');
          writer.setAttribute('alignment', 'center', paragraph);
          writer.insert(paragraph, insertPosition);
          
          let currentPos = writer.createPositionAt(paragraph, 0);

          urls.forEach((url, index) => {
            const imageElement = writer.createElement('imageInline', { src: url, resizedWidth: '200px' });
            writer.insert(imageElement, currentPos);
            currentPos = writer.createPositionAfter(imageElement);
            
            if (index < urls.length - 1) {
              const space = writer.createText(' ');
              writer.insert(space, currentPos);
              currentPos = writer.createPositionAfter(space);
            }
          });

          const spacer = writer.createElement('paragraph');
          writer.insert(spacer, writer.createPositionAfter(paragraph));
          insertPosition = writer.createPositionAt(spacer, 0);
        } else {
          urls.forEach((url, index) => {
            const attributes = { src: url };
            const imageElement = writer.createElement('imageBlock', attributes);
            writer.insert(imageElement, insertPosition);
            
            insertPosition = writer.createPositionAfter(imageElement);

            if (index === urls.length - 1) {
              const spacer = writer.createElement('paragraph');
              writer.insert(spacer, insertPosition);
              insertPosition = writer.createPositionAt(spacer, 0);
            }
          });
        }
        
        writer.setSelection(insertPosition);
      });
    }
  }
}
</script>

<style scoped>
.custom-editor-wrapper {
  background: white;
  min-height: var(--editor-min-height, 400px);
}

:deep(.ck-editor__editable) {
  min-height: var(--editor-min-height, 400px);
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

/* Image alignment styles */
:deep(.ck-content .image-style-align-center) {
  margin-left: auto !important;
  margin-right: auto !important;
  display: block !important;
  text-align: center !important;
}

:deep(.ck-content .image-style-align-left) {
  float: left !important;
  margin-right: 1.5em !important;
}

:deep(.ck-content .image-style-align-right) {
  float: right !important;
  margin-left: 1.5em !important;
}

/* Image inline spacing for thumbnails and emojis */
:deep(.ck-content .image-inline) {
  margin: 0 2px !important;
  display: inline-block !important;
  vertical-align: middle;
}

:deep(.ck-content .image-inline img) {
  max-width: 100%;
  height: auto;
  object-fit: contain;
}

/* Ensure inserted stickers don't blow up but preserve their intrinsic aspect ratio */
:deep(.ck-content .image-inline[src*="twemoji"]),
:deep(.ck-content img[src*="twemoji"]) {
   max-width: 24px !important;
   width: 24px !important;
   height: 24px !important;
   display: inline-block !important;
}

</style>
