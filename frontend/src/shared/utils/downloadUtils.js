/**
 * Mở URL trong tab mới bằng cách tạo và click thẻ <a>.
 * Đáng tin cậy hơn window.open() vì không bị popup blocker chặn
 * khi được gọi trong user gesture context.
 * @param {string} url
 */
function openInNewTab(url) {
  const link = document.createElement('a');
  link.href = url;
  link.target = '_blank';
  link.rel = 'noopener noreferrer';
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
}

/**
 * Kiểm tra URL có phải Cloudinary image/upload không (PDF bị upload nhầm resource_type=image).
 * Các URL dạng này bị Cloudinary chặn cross-origin fetch với 401.
 */
function isCloudinaryImageUrl(url) {
  return url.includes('res.cloudinary.com') && url.includes('/image/upload/');
}

/**
 * Chuyển URL Cloudinary image/upload thành URL có fl_attachment flag.
 * Cloudinary sẽ trả Content-Disposition: attachment → browser tự download.
 */
function getCloudinaryAttachmentUrl(url, filename) {
  const safeFilename = filename.replace(/[^\w\-_.()[\]]/g, '_');
  return url.replace('/image/upload/', `/image/upload/fl_attachment:${safeFilename}/`);
}

/**
 * Tải xuống file từ URL.
 *
 * Chiến lược:
 * 1. Nếu là Cloudinary image/upload URL (PDF cũ bị lưu sai resource_type):
 *    - Bỏ qua fetch (sẽ thất bại 401 do CORS)
 *    - Dùng fl_attachment transformation → Content-Disposition: attachment
 *    - Phải xử lý TRƯỚC mọi async operation để giữ user gesture context
 * 2. Còn lại (Cloudinary raw/upload cho .doc/.xlsx, URL thông thường):
 *    - fetch() → Blob → createObjectURL → anchor click (download đúng tên file)
 *    - Fallback: mở URL trực tiếp nếu fetch thất bại
 *
 * @param {string} url - URL của file cần tải xuống
 * @param {string} filename - Tên file đầy đủ (kể cả đuôi mở rộng)
 */
export async function downloadFileAsBlob(url, filename) {
  // ── CASE 1: Cloudinary image/upload URL ─────────────────────────────────────
  // fetch() cross-origin vào image/upload trả 401 do CORS policy của Cloudinary.
  // Giải pháp: dùng fl_attachment transformation để server trả Content-Disposition: attachment.
  // PHẢI gọi openInNewTab() NGAY TẠI ĐÂY (đồng bộ, trong user gesture context)
  // để tránh bị popup blocker chặn sau khi async operation vỡ gesture chain.
  if (isCloudinaryImageUrl(url)) {
    const attachmentUrl = getCloudinaryAttachmentUrl(url, filename);
    openInNewTab(attachmentUrl);
    return;
  }

  // ── CASE 2: Các URL khác (raw/upload, URL thông thường) ─────────────────────
  try {
    let response = await fetch(url);
    
    // Fallback thông minh: Nếu URL tài liệu đính kèm (raw/upload) bị lỗi 404 (do phiên bản code cũ lưu public_id không đuôi)
    // thì ta tự động bóc đuôi mở rộng ra để thử tải lại.
    if (!response.ok && response.status === 404 && url.includes('res.cloudinary.com') && url.includes('/raw/upload/')) {
      const lastDotIndex = url.lastIndexOf('.');
      if (lastDotIndex > url.lastIndexOf('/')) {
        const strippedUrl = url.substring(0, lastDotIndex);
        console.warn(`[Download Fallback] Phát hiện 404 trên URL raw. Thử tải lại không có extension: ${strippedUrl}`);
        const retryResponse = await fetch(strippedUrl);
        if (retryResponse.ok) {
          response = retryResponse;
        }
      }
    }

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    
    const blob = await response.blob();
    const objectUrl = URL.createObjectURL(blob);

    const anchor = document.createElement('a');
    anchor.href = objectUrl;
    anchor.download = filename; // Tên file khi lưu xuống
    document.body.appendChild(anchor);
    anchor.click();
    document.body.removeChild(anchor);

    // Giải phóng object URL sau khi click để tránh rò rỉ bộ nhớ
    setTimeout(() => URL.revokeObjectURL(objectUrl), 5000);
  } catch (err) {
    console.error('Lỗi khi tải xuống file:', err);
    // Fallback: mở URL trực tiếp (cross-origin, không có download attr)
    openInNewTab(url);
  }
}

/**
 * Kiểm tra xem URL có phải là link tài liệu đính kèm không (chứa 📎 prefix trong text).
 * Tách tên file từ link text dạng "📎 ten-file.ext".
 * @param {HTMLElement} linkEl - Phần tử <a>
 * @returns {string|null} Tên file hoặc null nếu không phải link tài liệu
 */
export function extractAttachmentFilename(linkEl) {
  if (!linkEl || linkEl.tagName !== 'A') return null;
  const text = (linkEl.textContent || '').trim();
  // Link tài liệu đính kèm có dạng "📎 ten-file.ext"
  if (text.startsWith('📎')) {
    return text.replace(/^📎\s*/, '').trim();
  }
  return null;
}
