<template>
  <div v-if="show" class="modal-overlay" :class="overlayClass" @click.self="handleOverlayClick">
    <div class="modal-card" :class="cardClass" :style="cardStyle">
      <div class="card-header" v-if="$slots.header || title">
        <slot name="header">{{ title }}</slot>
        <button v-if="showCloseButton" @click="close" class="close-btn">&times;</button>
      </div>
      
      <slot></slot>
      
      <div class="modal-footer" v-if="$slots.footer">
        <slot name="footer"></slot>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'BaseModal',
  props: {
    show: {
      type: Boolean,
      default: false
    },
    title: {
      type: String,
      default: ''
    },
    cardClass: {
      type: [String, Object, Array],
      default: ''
    },
    overlayClass: {
      type: [String, Object, Array],
      default: ''
    },
    cardStyle: {
      type: [String, Object, Array],
      default: ''
    },
    closeOnOverlay: {
      type: Boolean,
      default: false
    },
    showCloseButton: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    close() {
      this.$emit('update:show', false)
      this.$emit('close')
    },
    handleOverlayClick() {
      if (this.closeOnOverlay) {
        this.close()
      }
    }
  }
}
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0,0,0,0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-card {
  background: white;
  width: 500px;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 5px 25px rgba(0,0,0,0.2);
  display: flex;
  flex-direction: column;
  max-height: 90vh;
}

.card-header {
  background: #1a507a;
  color: white;
  padding: 1rem;
  font-weight: bold;
  text-align: center;
  position: relative;
}

.close-btn {
  position: absolute;
  right: 15px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  color: white;
  font-size: 1.5rem;
  cursor: pointer;
  line-height: 1;
}
.close-btn:hover {
  color: #ddd;
}

/* 
  Lưu ý: Các style dưới đây thường được định nghĩa bên trong Component cha 
  (như CategoryConfig.vue) nếu chúng ta truyền nguyên khối <form> vào thẻ <slot>. 
  Tuy nhiên, nếu dùng <slot name="footer"> thì style modal-footer ở đây sẽ được áp dụng.
*/
.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 1rem 1.5rem;
  border-top: 1px solid #eee;
  background: #fff;
}
</style>
