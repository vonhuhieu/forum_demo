<template>
  <div 
    class="svg-icon-wrapper" 
    :style="{ width: size, height: size }"
  >
    <!-- LIKE -->
    <svg v-if="code === 'like'" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 36 36" width="100%" height="100%">
      <circle cx="18" cy="18" r="18" :fill="fillColor"/>
      <path d="M11.5 26V17C11.5 16.17 12.17 15.5 13 15.5H15.5V26.5H13C12.17 26.5 11.5 25.83 11.5 26Z" fill="#ffffff"/>
      <path d="M17.5 26.5H23C23.83 26.5 24.5 25.83 24.5 25C24.5 24.17 23.83 23.5 23 23.5H25C25.83 23.5 26.5 22.83 26.5 22C26.5 21.17 25.83 20.5 25 20.5H25.5C26.33 20.5 27 19.83 27 19C27 18.17 26.33 17.5 25.5 17.5H21.5C21.5 17.5 22.5 15.5 22.5 13.5C22.5 11.5 21.5 9.5 20.5 9.5C19.5 9.5 19 10.5 19 11.5L17.5 15.5V26.5Z" fill="#ffffff"/>
    </svg>

    <!-- LOVE -->
    <svg v-else-if="code === 'love'" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 36 36" width="100%" height="100%">
      <circle cx="18" cy="18" r="18" :fill="fillColor"/>
      <path d="M18 28.5C18 28.5 8.5 22.5 8.5 15C8.5 11.13 11.63 8 15.5 8C17.46 8 19 9.5 19 9.5C19 9.5 20.54 8 22.5 8C26.37 8 29.5 11.13 29.5 15C29.5 22.5 18 28.5 18 28.5Z" fill="#ffffff"/>
    </svg>

    <!-- HAHA -->
    <svg v-else-if="code === 'haha'" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 36 36" width="100%" height="100%">
      <circle cx="18" cy="18" r="18" :fill="fillColor"/>
      <path d="M10.5 15L13.5 13.5L16.5 15" stroke="#333" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
      <path d="M19.5 15L22.5 13.5L25.5 15" stroke="#333" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
      <path d="M10.5 21C10.5 21 13 28 18 28C23 28 25.5 21 25.5 21H10.5Z" fill="#ffffff"/>
    </svg>

    <!-- WOW -->
    <svg v-else-if="code === 'wow'" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 36 36" width="100%" height="100%">
      <circle cx="18" cy="18" r="18" :fill="fillColor"/>
      <circle cx="12.5" cy="14.5" r="3.5" fill="#ffffff"/>
      <circle cx="12.5" cy="14.5" r="1.5" fill="#333333"/>
      <circle cx="23.5" cy="14.5" r="3.5" fill="#ffffff"/>
      <circle cx="23.5" cy="14.5" r="1.5" fill="#333333"/>
      <ellipse cx="18" cy="24" rx="4" ry="5" fill="#333333"/>
    </svg>

    <!-- SAD -->
    <svg v-else-if="code === 'sad'" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 36 36" width="100%" height="100%">
      <circle cx="18" cy="18" r="18" :fill="fillColor"/>
      <circle cx="12.5" cy="15" r="2" fill="#333333"/>
      <circle cx="23.5" cy="15" r="2" fill="#333333"/>
      <path d="M13.5 25C13.5 25 15.5 21.5 18 21.5C20.5 21.5 22.5 25 22.5 25" stroke="#333333" stroke-width="2" stroke-linecap="round" fill="none"/>
      <path d="M22 18.5C22 18.5 24 23 24.5 24.5C25 26 23.5 27.5 22 27.5C20.5 27.5 19.5 26 19.5 24.5C19.5 23 22 18.5 22 18.5Z" fill="#1877f2"/>
    </svg>

    <!-- ANGRY -->
    <svg v-else-if="code === 'angry'" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 36 36" width="100%" height="100%">
      <circle cx="18" cy="18" r="18" :fill="fillColor"/>
      <path d="M9 15L14 17" stroke="#333333" stroke-width="2.5" stroke-linecap="round"/>
      <path d="M27 15L22 17" stroke="#333333" stroke-width="2.5" stroke-linecap="round"/>
      <circle cx="12" cy="18.5" r="2" fill="#333333"/>
      <circle cx="24" cy="18.5" r="2" fill="#333333"/>
      <path d="M13.5 26C13.5 26 15.5 23 18 23C20.5 23 22.5 26 22.5 26" stroke="#333333" stroke-width="2.5" stroke-linecap="round" fill="none"/>
    </svg>
    
    <!-- FALLBACK IF CODE NOT MATCHED -->
    <svg v-else xmlns="http://www.w3.org/2000/svg" viewBox="0 0 36 36" width="100%" height="100%">
      <circle cx="18" cy="18" r="18" :fill="fillColor"/>
    </svg>
  </div>
</template>

<script>
export default {
  name: 'ReactionIcon',
  props: {
    code: {
      default: ''
    },
    color: {
      default: '#ccd0d5'
    },
    size: {
      default: '24px'
    },
    grayscale: {
      default: false
    }
  },
  computed: {
    fillColor() {
      if (this.grayscale) {
        return '#ccd0d5' // standard gray accent for unselected items
      }
      return this.color || '#ccd0d5'
    }
  }
}
</script>

<style scoped>
.svg-icon-wrapper {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}
.svg-icon-wrapper svg {
  display: block;
}
</style>
