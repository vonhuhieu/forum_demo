import api from '@/shared/services/api.service'
import { ButtonView } from 'ckeditor5'

// Custom Upload Adapter cho hình ảnh (khi paste ảnh hoặc dùng nút imageUpload)
class MyUploadAdapter {
  constructor(loader) {
    this.loader = loader
  }

  upload() {
    return this.loader.file.then(file => new Promise((resolve, reject) => {
      const formData = new FormData()
      formData.append('file', file)
      
      api.post('/upload', formData, {
        headers: { 'Content-Type': 'multipart/form-data' }
      })
      .then(res => {
        resolve({ default: res.data.url })
      })
      .catch(err => {
        reject(err)
      })
    }))
  }

  abort() {}
}

export function MyCustomUploadAdapterPlugin(editor) {
  editor.plugins.get('FileRepository').createUploadAdapter = (loader) => {
    return new MyUploadAdapter(loader)
  }
}

// Plugin Tải Tệp Đa Năng
export function CustomUploadPlugin(editor) {
  editor.ui.componentFactory.add('customUpload', locale => {
    const view = new ButtonView(locale);

    // Icon hình ghim kẹp giấy (paperclip)
    const uploadIcon = '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M16.5 6v11.5c0 2.21-1.79 4-4 4s-4-1.79-4-4V5a2.5 2.5 0 0 1 5 0v10.5c0 .55-.45 1-1 1s-1-.45-1-1V6H10v9.5a2.5 2.5 0 0 0 5 0V5c0-1.38-1.12-2.5-2.5-2.5S10 3.62 10 5v12.5a4 4 0 0 0 8 0V6h-1.5z"/></svg>';

    view.set({
      label: 'Tải lên tệp đính kèm (Video, Ảnh, Tài liệu)',
      icon: uploadIcon,
      tooltip: true
    });

    view.on('execute', () => {
      const input = document.createElement('input');
      input.type = 'file';
      input.multiple = true;
      input.accept = 'video/*,image/*,.pdf,.doc,.docx,.xls,.xlsx';

      input.onchange = async (e) => {
        const files = Array.from(e.target.files);
        if (files.length === 0) return;

        const formData = new FormData();
        files.forEach(file => formData.append('files', file));
        
        try {
          const res = await api.post('/upload/multiple', formData, {
            headers: { 'Content-Type': 'multipart/form-data' }
          });
          
          const validResults = res.data || [];
          
          if (validResults.length > 0) {
            editor.model.change(writer => {
              // Lấy vị trí trỏ chuột hiện tại để chèn
              let insertPosition = editor.model.document.selection.getFirstPosition();

              validResults.forEach(result => {
                let elementToInsert;
                const fileType = result.type || '';
                const fileUrl = result.url;
                const fileName = result.name;

                if (fileType.startsWith('image/')) {
                  elementToInsert = writer.createElement('imageBlock', { src: fileUrl });
                } else if (fileType.startsWith('video/')) {
                  elementToInsert = writer.createElement('media', { url: fileUrl });
                } else {
                  elementToInsert = writer.createElement('paragraph');
                  const linkedText = writer.createText(`📎 ${fileName}`, { linkHref: fileUrl });
                  writer.insert(linkedText, elementToInsert, 'end');
                }

                // Chèn phần tử vào vị trí hiện tại
                writer.insert(elementToInsert, insertPosition);
                
                // Cập nhật vị trí chèn cho phần tử tiếp theo (ngay sau phần tử vừa chèn)
                insertPosition = writer.createPositionAfter(elementToInsert);
              });
              
              // Đặt lại con trỏ chuột xuống cuối để người dùng tiếp tục gõ
              writer.setSelection(insertPosition);
            });
          }
        } catch (err) {
          console.error('Error uploading multiple files:', err);
          alert('Không thể tải lên tệp đính kèm. Vui lòng thử lại sau.');
        }
      };

      input.click();
    });

    return view;
  });
}
