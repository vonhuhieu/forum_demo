/**
 * Định dạng ngày tháng theo yêu cầu:
 * - Nếu trong tuần hiện tại: "Thứ [Thứ] lúc [Giờ:Phút]"
 * - Nếu trước đó: "dd/mm/yyyy"
 */
export const formatForumDate = (dateStr) => {
  if (!dateStr) return '';
  const date = new Date(dateStr);
  const now = new Date();
  
  // Bản sao để so sánh ngày
  const dDate = new Date(date.getFullYear(), date.getMonth(), date.getDate());
  const dNow = new Date(now.getFullYear(), now.getMonth(), now.getDate());
  
  const diffMs = now.getTime() - date.getTime();
  const diffSec = Math.floor(diffMs / 1000);
  const diffMin = Math.floor(diffSec / 60);

  if (diffSec < 60) return 'Vài giây trước';
  if (diffMin < 60) return `${diffMin} phút trước`;

  const diffTime = dNow.getTime() - dDate.getTime();
  const diffDays = Math.round(diffTime / (1000 * 60 * 60 * 24));

  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');
  const timeStr = `lúc ${hours}:${minutes}`;

  if (diffDays === 0) {
    return `Hôm nay ${timeStr}`;
  } else if (diffDays === 1) {
    return `Hôm qua ${timeStr}`;
  } else if (diffDays > 1 && diffDays < 7) {
    const days = ['Chủ nhật', 'Thứ hai', 'Thứ ba', 'Thứ tư', 'Thứ năm', 'Thứ sáu', 'Thứ bảy'];
    return `${days[date.getDay()]} ${timeStr}`;
  } else {
    const d = String(date.getDate()).padStart(2, '0');
    const m = String(date.getMonth() + 1).padStart(2, '0');
    const y = date.getFullYear();
    return `${d}/${m}/${y}`;
  }
};
