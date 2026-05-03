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

  const diffTime = dNow.getTime() - dDate.getTime();
  const diffDays = Math.round(diffTime / (1000 * 60 * 60 * 24));

  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');
  const timeStr = `lúc ${hours}:${minutes}`;

  // Kiểm tra xem 2 ngày có cùng tuần không (Tuần bắt đầu từ Thứ Hai)
  const getMonday = (d) => {
    const result = new Date(d);
    const day = result.getDay() === 0 ? 7 : result.getDay();
    result.setDate(result.getDate() - day + 1);
    return result.getTime();
  };
  const isSameWeek = getMonday(dDate) === getMonday(dNow);

  // Hàm helper format chuẩn
  const formatFullDate = () => {
    const d = String(date.getDate()).padStart(2, '0');
    const m = String(date.getMonth() + 1).padStart(2, '0');
    const y = date.getFullYear();
    return `${d}/${m}/${y} ${timeStr}`;
  };

  const days = ['Chủ nhật', 'Thứ hai', 'Thứ ba', 'Thứ tư', 'Thứ năm', 'Thứ sáu', 'Thứ bảy'];

  // Xử lý ngày trong tương lai
  if (diffMs < 0) {
    if (diffDays === 0) {
      return `Hôm nay ${timeStr}`;
    } else if (diffDays === -1) {
      return `Ngày mai ${timeStr}`;
    } else if (isSameWeek) {
      return `${days[date.getDay()]} ${timeStr}`;
    } else {
      return formatFullDate();
    }
  }

  // Xử lý ngày trong quá khứ
  if (diffSec < 60) return 'Vài giây trước';
  if (diffMin < 60) return `${diffMin} phút trước`;

  if (diffDays === 0) {
    return `Hôm nay ${timeStr}`;
  } else if (diffDays === 1) {
    return `Hôm qua ${timeStr}`;
  } else if (isSameWeek) {
    return `${days[date.getDay()]} ${timeStr}`;
  } else {
    // Với quá khứ, ta có thể bỏ timeStr nếu muốn, nhưng để nhất quán thì tùy thuộc vào requirement cũ
    // Requirement cũ với quá khứ trả về d/m/y không kèm giờ. Mình giữ nguyên requirement cũ cho quá khứ.
    const d = String(date.getDate()).padStart(2, '0');
    const m = String(date.getMonth() + 1).padStart(2, '0');
    const y = date.getFullYear();
    return `${d}/${m}/${y}`;
  }
};
