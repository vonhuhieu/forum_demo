<template>
  <Teleport to="body">
    <div
      ref="popover"
      v-show="visible"
      class="emoji-picker-popover"
      :style="popoverStyle"
      @mousedown.stop
    >
      <div ref="pickerContainer" class="mart-wrapper"></div>
    </div>
  </Teleport>
</template>

<script>
import { Picker } from 'emoji-mart'
import data from '@emoji-mart/data'

export default {
  name: 'EmojiPicker',
  props: {
    visible: { default: false },
    targetElement: { default: null }
  },
  data() {
    return {
      popoverStyle: {
        position: 'fixed',
        top: '-9999px',
        left: '-9999px'
      },
      pickerInstance: null
    }
  },
  watch: {
    visible(val) {
      if (val) {
        // Khởi tạo trước, rồi sau một tick mới tính vị trí (đảm bảo DOM đã render)
        this.initPicker();
        this.$nextTick(() => {
          this.updatePosition();
        });
        document.addEventListener('mousedown', this.handleClickOutside);
      } else {
        document.removeEventListener('mousedown', this.handleClickOutside);
      }
    }
  },
  mounted() {
    if (this.visible) {
      this.initPicker();
      this.$nextTick(() => this.updatePosition());
    }
  },
  beforeUnmount() {
    document.removeEventListener('mousedown', this.handleClickOutside);
  },
  methods: {
    initPicker() {
      if (this.pickerInstance) return;
      // Retry nếu ref chưa sẵn sàng (do Teleport render async)
      const tryInit = () => {
        if (this.$refs.pickerContainer) {
          this.pickerInstance = new Picker({
            parent: this.$refs.pickerContainer,
            data: data,
            set: 'native',
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
        } else {
          this.$nextTick(tryInit);
        }
      };
      tryInit();
    },
    updatePosition() {
      // getBoundingClientRect() trả về tọa độ viewport (phù hợp với position: fixed)
      let top, left;

      if (this.targetElement) {
        const rect = this.targetElement.getBoundingClientRect();
        // Nếu rect hợp lệ (element thực sự đang hiển thị)
        if (rect.width > 0 || rect.height > 0 || rect.top !== 0 || rect.left !== 0) {
          top = rect.bottom + 5;
          left = rect.left;
        } else {
          // Fallback: hiển thị ở vị trí giữa màn hình nếu không lấy được vị trí button
          top = 120;
          left = Math.max(5, window.innerWidth / 2 - 176);
        }
      } else {
        top = 120;
        left = Math.max(5, window.innerWidth / 2 - 176);
      }

      // Tránh bị tràn ra khỏi màn hình bên phải
      const pickerWidth = 352;
      if (left + pickerWidth > window.innerWidth) {
        left = window.innerWidth - pickerWidth - 10;
      }
      // Tránh bị tràn ra phía dưới màn hình
      const pickerHeight = 450;
      if (top + pickerHeight > window.innerHeight) {
        top = Math.max(5, (this.targetElement ? this.targetElement.getBoundingClientRect().top : top) - pickerHeight - 5);
      }

      this.popoverStyle = {
        position: 'fixed',
        top: `${Math.max(5, top)}px`,
        left: `${Math.max(5, left)}px`,
        zIndex: 99999
      };
    },
    handleClickOutside(e) {
      // Nếu người dùng nhấn vào chính nút toggle → bỏ qua (tránh race condition đóng/mở liên tục)
      if (this.targetElement && this.targetElement.contains(e.target)) {
        return;
      }
      // Đóng nếu click ra ngoài picker
      if (this.$refs.popover && !this.$refs.popover.contains(e.target)) {
        this.$emit('close');
      }
    }
  }
}
</script>

<style>
/* Không dùng scoped để đảm bảo CSS áp dụng đúng cho element teleported vào body */
.emoji-picker-popover {
  z-index: 99999 !important;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.18);
  border-radius: 8px;
  overflow: hidden;
  animation: emojiSlideFadeIn 0.15s ease-out;
}

@keyframes emojiSlideFadeIn {
  from { opacity: 0; transform: translateY(-6px); }
  to   { opacity: 1; transform: translateY(0); }
}

.emoji-picker-popover .mart-wrapper {
  display: flex;
  --font-family: 'Segoe UI', Roboto, Arial, sans-serif;
  --shadow: none;
  --border-radius: 8px;
}

.emoji-picker-popover em-emoji-picker {
  max-width: 100vw;
}
</style>
