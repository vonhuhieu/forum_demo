<template>
  <div v-show="visible" class="emoji-picker-popover" :style="popoverStyle" @mousedown.stop>
    <div ref="pickerContainer" class="mart-wrapper"></div>
  </div>
</template>

<script>
import { Picker } from 'emoji-mart'
import data from '@emoji-mart/data'

export default {
  name: 'EmojiPicker',
  props: {
    visible: { type: Boolean, default: false },
    targetElement: { type: Object, default: null }
  },
  data() {
    return {
      popoverStyle: { top: '0px', left: '0px' },
      pickerInstance: null
    }
  },
  watch: {
    visible(val) {
      if (val) {
        this.$nextTick(() => {
          this.updatePosition();
          this.initPicker();
        });
        document.addEventListener('mousedown', this.handleClickOutside);
      } else {
        document.removeEventListener('mousedown', this.handleClickOutside);
      }
    }
  },
  mounted() {
    // Khởi tạo Picker ngay để tránh render delay khi nhấn nút lần đầu
    if (this.visible) this.initPicker();
  },
  beforeUnmount() {
    document.removeEventListener('mousedown', this.handleClickOutside);
  },
  methods: {
    initPicker() {
      if (!this.pickerInstance && this.$refs.pickerContainer) {
        this.pickerInstance = new Picker({
          parent: this.$refs.pickerContainer,
          data: data,
          set: 'native', // Dùng Native để đảm bảo 100% hiển thị, không phụ thuộc tải Sprite từ CDN bị chặn
          locale: 'vi',
          theme: 'light',
          onEmojiSelect: (emoji) => {
            this.$emit('select', {
               type: 'unicode',
               value: emoji.native,
               name: emoji.id
            });
            this.$emit('close');
          }
        });
      }
    },
    updatePosition() {
      if (!this.targetElement) return;
      const rect = this.targetElement.getBoundingClientRect();
      
      const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
      const scrollLeft = window.pageXOffset || document.documentElement.scrollLeft;

      let top = rect.bottom + scrollTop + 5;
      let left = rect.left + scrollLeft;

      const pickerWidth = 352;
      if (left + pickerWidth > window.innerWidth) {
        left = window.innerWidth - pickerWidth - 20;
      }

      this.popoverStyle = {
        top: `${top}px`,
        left: `${Math.max(10, left)}px`
      };
    },
    handleClickOutside(e) {
      // QUAN TRỌNG: Nếu người dùng nhấn vào đúng cái nút toggle, không can thiệp để tránh bị đóng xong lại mở (Race condition)
      if (this.targetElement && this.targetElement.contains(e.target)) {
        return;
      }

      // Nếu nhấn ra ngoài picker container và không phải cái nút bấm kích hoạt
      if (this.$el && !this.$el.contains(e.target)) {
        this.$emit('close');
      }
    }
  }
}
</script>

<style scoped>
.emoji-picker-popover {
  position: absolute;
  z-index: 99999; /* Cao nhất để không bị che mất */
  box-shadow: 0 8px 30px rgba(0,0,0,0.15);
  border-radius: 8px;
  overflow: hidden;
  animation: slideFadeIn 0.15s ease-out;
}

@keyframes slideFadeIn {
  from { opacity: 0; transform: translateY(-5px); }
  to { opacity: 1; transform: translateY(0); }
}

/* Ghi đè biến CSS của emoji-mart để tích hợp mượt hơn vào giao diện web */
.mart-wrapper {
  display: flex;
  --font-family: 'Segoe UI', Roboto, Arial, sans-serif;
  --shadow: none; /* Đã dùng box shadow ngoài */
  --border-radius: 8px;
}

/* Điều chỉnh chiều rộng mặc định để tương thích màn hình nhỏ */
:deep(em-emoji-picker) {
  max-width: 100vw;
}
</style>
