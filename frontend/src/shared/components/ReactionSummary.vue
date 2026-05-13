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
    <span class="total-reactions-count">{{ totalCount }}</span>
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
      // Sort by count desc to show the most popular ones first, then take top 3
      return [...this.summary]
        .sort((a, b) => b.count - a.count)
        .slice(0, 3)
    }
  }
}
</script>

<style scoped>
.reactions-summary-pill {
  display: flex;
  align-items: center;
  background: white;
  border: 1px solid #e4e6eb;
  border-radius: 15px;
  padding: 3px 8px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.05);
  gap: 5px;
  cursor: default;
  width: fit-content;
}

.stacked-icons-container {
  display: flex;
  align-items: center;
}

.stacked-summary-icon {
  border-radius: 50%;
  border: 1.5px solid white;
  background: white;
}

/* Overlay effect: negative margin for each next icon */
.stacked-summary-icon:not(:first-child) {
  margin-left: -5px;
}

.total-reactions-count {
  font-size: 12px;
  color: #65676B;
  font-weight: 500;
  line-height: 1;
}
</style>
