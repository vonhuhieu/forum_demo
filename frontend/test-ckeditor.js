const ckeditor = require('ckeditor5');
console.log(Object.keys(ckeditor).filter(k => ['Font', 'FontFamily', 'FontSize', 'Alignment', 'Underline', 'Strikethrough', 'IndentBlock', 'Undo', 'FileRepository'].includes(k)));
