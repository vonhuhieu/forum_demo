<template>
  <div v-if="hasReactions" class="reactions-summary-pill">
    <div class="stacked-icons-container">
      <ReactionIcon 
        v-for="(item, idx) in topReactionIcons" 
        :key="item.reactionIcon.id" 
        :code="item.reactionIcon.icon"
        :color="item.reactionIcon.color"
        class="stacked-summary-icon"
        :style="{ zIndex: 10 - idx }"
        :title="item.reactionIcon.tooltip"
        size="16px"
      />
    </div>
    
    <div class="reactors-text-display">
      <template v-if="processedReactors.length > 0">
        <template v-for="(reactor, idx) in processedReactors" :key="reactor.id">
          <span class="reactor-name" :class="{ 'is-me': reactor.isMe }">{{ reactor.displayName }}</span>
          
          <template v-if="idx < processedReactors.length - 1">
            <template v-if="totalCount > 3">, </template>
            <template v-else>
              <template v-if="idx === processedReactors.length - 2"> và </template>
              <template v-else>, </template>
            </template>
          </template>
        </template>

        <template v-if="totalCount > 3">
          và <span class="other-reactors-count">{{ totalCount - 3 }} người khác</span>
        </template>
      </template>
      <template v-else>
        <span class="reactor-count-only">{{ totalCount }}</span>
      </template>
    </div>
  </div>
</template>

<script>
import ReactionIcon from './ReactionIcon.vue'

export default {
  name: 'ReactionSummary',
  components: {
    ReactionIcon
  },
  props: {
    summary: {
      type: Array,
      required: true,
      default: () => []
    },
    recentReactors: {
      type: Array,
      default: () => []
    }
  },
  computed: {
    hasReactions() {
      return this.summary && this.summary.length > 0 && this.totalCount > 0
    },
    totalCount() {
      if (!this.summary) return 0
      return this.summary.reduce((acc, curr) => acc + curr.count, 0)
    },
    topReactionIcons() {
      if (!this.summary) return []
      
      return [...this.summary]
        .sort((a, b) => {
          // 1. Ưu tiên số lượt thả nhiều nhất
          if (b.count !== a.count) {
            return b.count - a.count
          }
          
          // 2. Nếu bằng nhau, ưu tiên icon có thời gian tương tác mới nhất
          const timeA = a.latestInteractionTime ? new Date(a.latestInteractionTime).getTime() : 0
          const timeB = b.latestInteractionTime ? new Date(b.latestInteractionTime).getTime() : 0
          return timeB - timeA
        })
        .slice(0, 3)
    },
    currentUser() {
      const userStr = localStorage.getItem('user')
      if (!userStr) return null
      try {
        return JSON.parse(userStr)
      } catch (e) {
        return null
      }
    },
    processedReactors() {
      if (!this.recentReactors) return []
      
      const currentUserId = this.currentUser ? this.currentUser.id : null
      const mapped = this.recentReactors.map(user => {
        const isMe = currentUserId && String(user.id) === String(currentUserId)
        return {
          id: user.id,
          displayName: isMe ? 'Bạn' : (user.displayName || user.username),
          isMe
        }
      })

      // Đưa "Bạn" lên đầu danh sách nếu có để hợp logic tiếng Việt
      const meIndex = mapped.findIndex(r => r.isMe)
      if (meIndex > -1) {
        const [me] = mapped.splice(meIndex, 1)
        mapped.unshift(me)
      }

      return mapped.slice(0, 3)
    }
  }
}
</script>

<style scoped>
.reactions-summary-pill {
  display: inline-flex;
  align-items: center;
  background: #f8f9fa;
  border: 1px solid #e4e6eb;
  border-radius: 18px;
  padding: 4px 12px;
  gap: 8px;
  cursor: default;
  transition: all 0.2s ease;
}

.reactions-summary-pill:hover {
  background: #f0f2f5;
  border-color: #d8dadf;
}

.stacked-icons-container {
  display: flex;
  align-items: center;
}

.stacked-summary-icon {
  border-radius: 50%;
  border: 1.5px solid #f8f9fa;
  background: white;
  box-sizing: content-box;
  transition: border-color 0.2s ease;
}

.reactions-summary-pill:hover .stacked-summary-icon {
  border-color: #f0f2f5;
}

.stacked-summary-icon:not(:first-child) {
  margin-left: -6px;
}

.reactors-text-display {
  font-size: 13px;
  color: #65676B;
  font-weight: 400;
  line-height: 1.4;
  user-select: none;
}

.reactor-name {
  font-weight: 600;
  color: #1877f2;
  cursor: pointer;
}

.reactor-name:hover {
  text-decoration: underline;
}

.reactor-name.is-me {
  color: #1877f2;
}

.other-reactors-count {
  font-weight: 600;
  color: #1877f2;
  cursor: pointer;
}

.other-reactors-count:hover {
  text-decoration: underline;
}

.reactor-count-only {
  font-weight: 600;
  color: #65676b;
}
</style>
