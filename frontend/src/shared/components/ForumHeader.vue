<template>
  <header>
    <div class="header-top">
      <div class="container">
        <div class="logo" style="cursor: pointer;" @click="$router.push({ name: 'Home' })">HTXSL</div>
      </div>
    </div>
    <div class="header-nav">
      <div class="container nav-container">
        <nav class="nav-links">
          <router-link
            v-for="menu in menus"
            :key="menu.id"
            :to="menu.url"
            active-class="active"
          >
            {{ menu.title }}
          </router-link>
        </nav>
        <div class="nav-right">
          <div class="nav-group-user" :class="{ 'active': showUserDropdown }" v-if="isLoggedIn" ref="userContainer" @click="toggleUserDropdown" style="cursor: pointer;">
            <div class="user-info-header">
              <span class="user-avatar-small" :style="{ backgroundColor: currentUser.avatar || '#fff', color: currentUser.avatar ? '#fff' : '#1a507a' }">
                {{ (currentUser.displayName || currentUser.username).charAt(0).toUpperCase() }}
              </span>
              <span class="user-greeting">Chào, {{ currentUser.displayName || currentUser.username }}</span>
              
              <!-- User Dropdown Menu -->
              <div class="user-dropdown" v-show="showUserDropdown">
                <button @click.stop="handleLogout" class="user-dropdown-item">Thoát</button>
              </div>
            </div>
          </div>
          <template v-else>
            <router-link :to="{ name: 'Login' }" class="nav-group-user">Đăng nhập</router-link>
            <router-link :to="{ name: 'Register' }" class="nav-group-user">Đăng ký</router-link>
          </template>

          <!-- Mailbox Container -->
          <div class="mailbox-container" :class="{ 'active': showMailDropdown }" ref="mailContainer" v-if="isLoggedIn">
             <button class="btn-icon-mail" :class="{ 'shake-animation': isMailShaking }" @click.stop="toggleMailDropdown" aria-label="Inbox">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                  <polyline points="22,6 12,13 2,6"></polyline>
                </svg>
                <span class="notif-badge" :class="{ 'pulse-animation': isMailShaking }" v-if="unreadMailCount > 0">{{ unreadMailCount > 99 ? '99+' : unreadMailCount }}</span>
             </button>

             <!-- Mailbox Dropdown -->
             <div class="mail-dropdown" v-show="showMailDropdown">
                <div class="notif-header">
                   <span class="notif-title">Hộp thư</span>
                </div>
                
                <div class="notif-list" v-if="conversations.length > 0">
                   <div 
                     v-for="convo in conversations" 
                     :key="convo.id" 
                     class="notif-item" 
                     :class="{ 'unread': !convo.isRead }"
                     @click="goToConversation(convo)"
                   >
                     <div class="notif-avatar-wrapper">
                        <div class="notif-avatar" :style="{ backgroundColor: convo.creatorAvatar || '#3498db' }">
                           {{ (convo.creatorDisplayName || convo.creatorUsername || 'C').charAt(0).toUpperCase() }}
                        </div>
                     </div>
                      <div class="notif-body">
                         <div class="notif-text">
                            <template v-if="convo.isReaction">
                               <strong>{{ convo.creatorDisplayName || convo.creatorUsername }}</strong> đã tương tác 
                               <img :src="getReactionIconUrl(convo.reactionIcon)" class="notif-reaction-icon" :title="convo.reactionName" />
                               <strong :style="{ color: convo.reactionColor || '#2c3e50' }">{{ convo.reactionName }}</strong>
                               với trả lời của bạn trong hội thoại 
                               <span class="convo-title-link" style="display: inline;">{{ convo.title }}</span>
                            </template>
                            <template v-else-if="currentUser && convo.creatorUsername === currentUser.username">
                               Bạn đã mở cuộc hội thoại 
                               <span class="convo-title-link" style="display: inline;">{{ convo.title }}</span>
                               với {{ getRecipients(convo) }}
                            </template>
                            <template v-else>
                               {{ convo.creatorDisplayName || convo.creatorUsername }} đã bắt đầu cuộc hội thoại 
                               <span class="convo-title-link" style="display: inline;">{{ convo.title }}</span>
                               với bạn
                            </template>
                         </div>
                         <!-- Line 3: Dynamic Time -->
                         <div class="notif-time">{{ formatTime(convo.updatedAt || convo.createdAt) }}</div>
                      </div>
                     <div class="notif-status-dot" v-if="!convo.isRead"></div>
                   </div>
                </div>
                
                <div class="notif-empty" v-else>
                   Không có cuộc hội thoại nào mới.
                </div>
                
                <div class="notif-footer">
                   <a href="#" @click.prevent>Xem tất cả</a>
                   <span style="color: #ccc;">·</span>
                   <a href="#" @click.prevent="goToAddConvo">Bắt đầu đối thoại mới</a>
                </div>
             </div>
          </div>

          <!-- Notification Bell Container -->
          <div class="notification-bell-container" :class="{ 'active': showNotifDropdown }" ref="notifContainer" v-if="isLoggedIn">
             <button class="btn-icon-bell" :class="{ 'shake-animation': isShaking }" @click.stop="toggleNotifDropdown" aria-label="Notifications">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                  <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                </svg>
                <span class="notif-badge" :class="{ 'pulse-animation': isShaking }" v-if="unreadCount > 0">{{ unreadCount > 99 ? '99+' : unreadCount }}</span>
             </button>

             <!-- Notification Dropdown -->
             <div class="notif-dropdown" v-show="showNotifDropdown">
                <div class="notif-header">
                   <span class="notif-title">Thông báo</span>
                   <button class="btn-read-all" v-if="unreadCount > 0" @click.stop="markAllRead">Đánh dấu đã đọc</button>
                </div>
                
                <div class="notif-list" v-if="notifications.length > 0">
                   <div 
                     v-for="notif in notifications" 
                     :key="notif.id" 
                     class="notif-item" 
                     :class="{ 'unread': !notif.isRead }"
                     @click="handleNotifClick(notif)"
                   >
                     <div class="notif-avatar-wrapper">
                        <div class="notif-avatar" :style="{ backgroundColor: notif.actorAvatar || '#3498db' }">
                           {{ (notif.actorDisplayName || notif.actorUsername || '?').charAt(0).toUpperCase() }}
                        </div>
                     </div>
                     <div class="notif-body">
                        <div class="notif-text">
                           <strong>{{ notif.actorDisplayName || notif.actorUsername }}</strong>
                           <template v-if="notif.type === 'REACTION'">
                              đã tương tác <img :src="getReactionIconUrl(notif.reactionIcon)" class="notif-reaction-icon" :title="notif.reactionName" /> 
                              <strong :style="{ color: notif.reactionColor || '#2c3e50' }">{{ notif.reactionName }}</strong>
                              với bài viết của bạn trong chủ đề
                           </template>
                           <template v-else-if="notif.type === 'QUOTE'">
                              đã trích bài viết của bạn trong chủ đề
                           </template>
                           <template v-else-if="notif.type === 'MENTION'">
                              đã tag bạn trong chủ đề
                           </template>
                           <template v-else>
                              đã trả lời vào chủ đề
                           </template>
                           <span class="notif-link-block" @click.stop="handleNotifClick(notif)">
                              <span v-if="notif.threadLabelName" class="notif-label-tag" :style="{ backgroundColor: notif.type === 'MENTION' ? '#2577b1' : (notif.threadLabelColor || '#95a5a6'), color: notif.type === 'MENTION' ? '#fff' : (notif.threadLabelTextColor || '#fff'), borderColor: notif.type === 'MENTION' ? 'transparent' : (notif.threadLabelBorderColor || 'transparent') }">{{ notif.threadLabelName }}</span>
                              <span class="highlight-thread">{{ notif.threadTitle }}</span>
                           </span>.
                           <span v-if="notif.type !== 'QUOTE' && notif.type !== 'REACTION' && notif.type !== 'MENTION'" class="notif-extra">Có thể có bài viết thêm trong chủ đề</span>
                        </div>
                        <div class="notif-time">{{ formatTime(notif.createdAt) }}</div>
                     </div>
                     <div class="notif-status-dot" v-if="!notif.isRead"></div>
                   </div>
                </div>
                
                <div class="notif-empty" v-else>
                   Không có thông báo nào.
                </div>
                
                <div class="notif-footer">
                    <a href="#" @click.prevent>Xem tất cả</a>
                    <button class="btn-mark-all-read" @click.stop="markAllRead">Đánh dấu đã xem</button>
                 </div>
             </div>
          </div>

          <div class="btn-search">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
            <span>Tìm kiếm</span>
          </div>
        </div>
      </div>
    </div>
  </header>
</template>

<script>
import webSocketService from '@/shared/services/websocket.service'
import conversationService from '@/apps/Forum/services/conversation.service'
import menuService from '@/apps/Forum/services/menu.service'
import notificationService from '@/apps/Forum/services/notification.service'
import { formatForumDate } from '@/shared/utils/date'
import { alertSuccess } from '@/shared/utils/swal'

export default {
  name: 'ForumHeader',
  data() {
    return {
      menus: [],
      isLoggedIn: false,
      currentUser: null,
      showNotifDropdown: false,
      showUserDropdown: false,
      showMailDropdown: false,
      notifications: [],
      unreadCount: 0,
      isShaking: false,
      conversations: [],
      unreadMailCount: 0,
      isMailShaking: false
    }
  },
  async mounted() {
    this.checkAuth()
    
    if (this.isLoggedIn && this.currentUser) {
      this.fetchNotifSummary()
      this.fetchMailSummary()
      this.setupSocket()
    }
    
    document.addEventListener('click', this.handleClickOutside)

    try {
      const response = await menuService.getAll()
      this.menus = response.data
    } catch (error) {
      console.error('Lỗi khi tải menu:', error)
      this.menus = [
        { id: 1, title: 'Trang nhất', url: '/' }
      ]
    }
  },
  beforeUnmount() {
    document.removeEventListener('click', this.handleClickOutside)
    if (this.notifUnsubscribe) {
      this.notifUnsubscribe()
    }
    if (this.convoUnsubscribe) {
      this.convoUnsubscribe()
    }
  },
  methods: {
    checkAuth() {
      const user = localStorage.getItem('user')
      if (user) {
        this.isLoggedIn = true
        this.currentUser = JSON.parse(user)
      }
    },
    handleLogout() {
      webSocketService.disconnect()
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      this.isLoggedIn = false
      this.currentUser = null
      this.$emit('logout')
      if (this.$route.meta.requiresAuth) {
        this.$router.push({ name: 'Home' })
      } else {
        window.location.reload() // Reload to update UI across components
      }
    },
    
    // --- Notification System Logic ---
    
    setupSocket() {
      if (!this.currentUser || !this.currentUser.id) return
      
      // Connect (using username for tracking connection identifier internally in service)
      webSocketService.connect(this.currentUser.username)
      
      // Clean up existing subscription if present
      if (this.notifUnsubscribe) {
        this.notifUnsubscribe()
      }
      if (this.convoUnsubscribe) {
        this.convoUnsubscribe()
      }

      // Register callback for live push notifications - USING NUMERICAL USER ID FOR TOPIC
      this.notifUnsubscribe = webSocketService.subscribeToNotifications(this.currentUser.id, (newNotif) => {
        // Add to top of list
        this.notifications.unshift(newNotif)
        this.unreadCount++
        
        // Hiệu ứng âm thanh và rung chuông
        this.playNotifSound()
        this.triggerShake()
      })

      // Register callback for live conversations - USING NUMERICAL USER ID FOR TOPIC
      this.convoUnsubscribe = webSocketService.subscribe(`/topic/conversations/${this.currentUser.id}`, (newConvo) => {
        // Add to top of list and avoid duplicates for same convo
        if (newConvo.isReaction) {
          this.conversations.unshift(newConvo)
        } else {
          this.conversations = this.conversations.filter(c => c.id !== newConvo.id || c.isReaction)
          this.conversations.unshift(newConvo)
        }
        
        // If not read (for recipient), trigger visual/audio notifications
        if (!newConvo.isRead) {
          this.unreadMailCount++
          this.playNotifSound()
          this.triggerMailShake()
        }
      })
    },
    
    playNotifSound() {
      // Bell sound URL (Mixkit generic notification)
      const audio = new Audio('https://assets.mixkit.co/active_storage/sfx/2550/2550-preview.mp3');
      audio.volume = 0.5;
      audio.play().catch(e => {
        // Many browsers block autoplay without interaction
        console.log('Autoplay sound blocked or audio error:', e);
      });
    },
    
    triggerShake() {
       this.isShaking = false;
       this.$nextTick(() => {
         this.isShaking = true;
         setTimeout(() => {
            this.isShaking = false;
         }, 3000);
       });
    },
    
    async fetchNotifSummary() {
      try {
        const [listRes, countRes] = await Promise.all([
          notificationService.getAll(),
          notificationService.getUnreadCount()
        ])
        this.notifications = listRes.data
        this.unreadCount = countRes.data
      } catch (error) {
        console.error('Lỗi khi tải thông báo:', error)
      }
    },
    
    toggleNotifDropdown() {
      this.showNotifDropdown = !this.showNotifDropdown
      this.showUserDropdown = false
      this.showMailDropdown = false
    },
    toggleUserDropdown() {
      this.showUserDropdown = !this.showUserDropdown
      this.showNotifDropdown = false
      this.showMailDropdown = false
    },
    toggleMailDropdown() {
      this.showMailDropdown = !this.showMailDropdown
      this.showNotifDropdown = false
      this.showUserDropdown = false
    },
    triggerMailShake() {
       this.isMailShaking = false;
       this.$nextTick(() => {
         this.isMailShaking = true;
         setTimeout(() => {
            this.isMailShaking = false;
         }, 3000);
       });
    },
    async fetchMailSummary() {
      try {
        const [listRes, countRes] = await Promise.all([
          conversationService.getAll(),
          conversationService.getUnreadCount()
        ])
        this.conversations = listRes.data || []
        this.unreadMailCount = countRes.data || 0
      } catch (error) {
        console.error('Lỗi khi tải hộp thư:', error)
      }
    },
    goToAddConvo() {
      this.showMailDropdown = false
      this.$router.push({ name: 'AddConversation' })
    },
    async goToConversation(convo) {
      this.showMailDropdown = false
      
      if (!convo.isRead) {
        convo.isRead = true
        this.unreadMailCount = Math.max(0, this.unreadMailCount - 1)
        try {
          if (convo.isReaction) {
            await notificationService.markAsRead(convo.notificationId)
          } else {
            await conversationService.markAsRead(convo.id)
          }
        } catch (e) {
          console.error('Lỗi khi đánh dấu đã đọc:', e)
        }
      }

      // Dispatch global custom event for ConversationDetail to react if we are already on this conversation detail page
      window.dispatchEvent(new CustomEvent('conversation-clicked', {
        detail: {
          conversationId: convo.id,
          messageId: convo.firstMessageId
        }
      }))

      const query = convo.firstMessageId ? { messageId: convo.firstMessageId } : {}
      this.$router.push({ 
        name: 'ConversationDetail', 
        params: { id: convo.id },
        query
      })
    },
    getRecipients(convo) {
      if (!convo || !convo.participants) return ''
      const myName = this.currentUser ? (this.currentUser.displayName || this.currentUser.username) : ''
      const myUsername = this.currentUser ? this.currentUser.username : ''
      const filtered = convo.participants.filter(p => p !== myName && p !== myUsername)
      return filtered.join(', ')
    },
    
    handleClickOutside(e) {
      const container = this.$refs.notifContainer
      if (container && !container.contains(e.target)) {
        this.showNotifDropdown = false
      }
      const userContainer = this.$refs.userContainer
      if (userContainer && !userContainer.contains(e.target)) {
        this.showUserDropdown = false
      }
      const mailContainer = this.$refs.mailContainer
      if (mailContainer && !mailContainer.contains(e.target)) {
        this.showMailDropdown = false
      }
    },
    
    getReactionIconUrl(code) {
      if (!code) return ''
      try {
        return require(`@/assets/reactions/${code}.svg`)
      } catch (e) {
        return ''
      }
    },
    formatTime(dateStr) {
      return formatForumDate(dateStr)
    },
    
    async markAllRead() {
      try {
        await notificationService.markAllRead()
        this.unreadCount = 0
        this.notifications.forEach(n => n.isRead = true)
      } catch (e) {
        console.error(e)
      }
    },
    
    async handleNotifClick(notif) {
      this.showNotifDropdown = false
      
      // 1. Mark this specific notification as read instantly locally
      if (!notif.isRead) {
        notif.isRead = true
        this.unreadCount = Math.max(0, this.unreadCount - 1)
        
        // Fire off the API async background (no wait)
        try {
          notificationService.markAsRead(notif.id)
        } catch (e) {
          console.error(e)
        }
      }
      
      // 2. Dispatch global custom event for ThreadDetail to react (e.g. if we are already on this thread)
      window.dispatchEvent(new CustomEvent('notification-clicked', {
        detail: {
          threadId: notif.threadId,
          postId: notif.postId
        }
      }))

      // 3. Route logic: navigate to exact post
      const routeTarget = {
         name: 'ThreadDetail',
         params: { id: notif.threadId }
      }
      
      if (notif.postId) {
         routeTarget.query = { postId: notif.postId }
      } else {
         // Default to main post for thread-level actions (like reactions to thread)
         routeTarget.query = { postId: 'main_thread_entry' }
      }
      
      this.$router.push(routeTarget)
    }
  }
}
</script>

<style scoped>
.notification-bell-container {
  position: relative;
}

.btn-icon-bell, .btn-icon-mail {
  background: transparent;
  border: none;
  color: #fff;
  cursor: pointer;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  outline: none;
  height: 100%;
  width: 100%;
}

.btn-icon-bell:hover, .btn-icon-mail:hover {
  background: transparent;
}

/* Bell Shake Animation */
.shake-animation {
  animation: bell-shake 3s cubic-bezier(.36,.07,.19,.97) both;
  transform-origin: center top;
}

@keyframes bell-shake {
  0% { transform: rotate(0); }
  10% { transform: rotate(15deg); }
  20% { transform: rotate(-15deg); }
  30% { transform: rotate(12deg); }
  40% { transform: rotate(-12deg); }
  50% { transform: rotate(8deg); }
  60% { transform: rotate(-8deg); }
  70% { transform: rotate(4deg); }
  80% { transform: rotate(-4deg); }
  90% { transform: rotate(2deg); }
  100% { transform: rotate(0); }
}

.notif-badge {
  position: absolute;
  top: -2px;
  right: -2px;
  background-color: #e74c3c;
  color: white;
  font-size: 10px;
  font-weight: bold;
  min-width: 16px;
  height: 16px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 4px;
  border: 2px solid #1a507a;
  z-index: 2;
}

.pulse-animation {
  animation: badge-pulse 1s infinite;
}

@keyframes badge-pulse {
  0% { transform: scale(1); box-shadow: 0 0 0 0 rgba(231, 76, 60, 0.7); }
  70% { transform: scale(1.1); box-shadow: 0 0 0 10px rgba(231, 76, 60, 0); }
  100% { transform: scale(1); box-shadow: 0 0 0 0 rgba(231, 76, 60, 0); }
}

/* Dropdown Shell */
.notif-dropdown, .mail-dropdown {
  position: absolute;
  top: 50px;
  right: -100px;
  width: 360px;
  background: #fff;
  border-radius: 4px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.15);
  z-index: 1000;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

/* Standard Arrow pointer at top */
.notif-dropdown::before, .mail-dropdown::before {
  content: '';
  position: absolute;
  top: -6px;
  right: 112px;
  border-left: 6px solid transparent;
  border-right: 6px solid transparent;
  border-bottom: 6px solid #f8f9fa;
}

.notif-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 15px;
  background: #f8f9fa;
  border-bottom: 1px solid #eee;
}

.notif-title {
  color: #2c3e50;
  font-weight: bold;
  font-size: 0.95rem;
}

.btn-read-all {
  background: none;
  border: none;
  color: #3498db;
  font-size: 0.8rem;
  cursor: pointer;
  padding: 0;
}

.btn-read-all:hover {
  text-decoration: underline;
}

.notif-list {
  max-height: 400px;
  overflow-y: auto;
}

.notif-item {
  display: flex;
  gap: 12px;
  padding: 12px 15px;
  border-bottom: 1px solid #f0f0f0;
  cursor: pointer;
  transition: background 0.15s;
  position: relative;
}

.notif-item:hover {
  background: #f5f8fa;
}

.notif-item.unread {
  background: #f0f7fb;
}

.notif-avatar-wrapper {
  flex-shrink: 0;
}

.notif-avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-weight: bold;
  font-size: 0.9rem;
}

.notif-body {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4px;
  font-size: 0.88rem;
  color: #555;
  line-height: 1.4;
}

.notif-text strong {
  color: #2c3e50;
}

.highlight-thread {
  color: #2577b1;
  font-weight: 500;
  cursor: pointer;
}

.highlight-thread:hover {
  text-decoration: underline;
}

.notif-link-block {
  display: inline;
  cursor: pointer;
}

.notif-link-block:hover .highlight-thread {
  text-decoration: underline !important;
}

.notif-label-tag {
  display: inline-block;
  padding: 1px 6px;
  font-size: 0.75rem;
  border-radius: 3px;
  color: #fff;
  margin: 0 4px;
  vertical-align: middle;
  line-height: 1.4;
  border: 1px solid transparent;
}

.notif-reaction-icon {
  width: 16px;
  height: 16px;
  vertical-align: middle;
  margin: 0 2px;
}

.notif-extra {
  display: block;
  font-size: 0.8rem;
  color: #888;
  margin-top: 2px;
}

.notif-time {
  font-size: 0.75rem;
  color: #888;
}

.notif-status-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #3498db;
  position: absolute;
  right: 15px;
  top: calc(50% - 4px);
}

.notif-empty {
  padding: 30px;
  text-align: center;
  color: #7f8c8d;
  font-size: 0.9rem;
}

.notif-footer {
  padding: 10px 15px;
  background: #f8f9fa;
  border-top: 1px solid #eee;
  display: flex;
  justify-content: flex-start;
  gap: 15px;
  align-items: center;
  font-size: 0.85rem;
}

.notif-footer a {
  color: #3498db;
  text-decoration: none;
  font-weight: 500;
}

.notif-footer a:hover {
  text-decoration: underline;
}

.btn-mark-all-read {
  background: none;
  border: none;
  color: #3498db;
  font-size: 0.85rem;
  font-weight: 500;
  cursor: pointer;
  padding: 0;
  font-family: inherit;
  outline: none;
}

.btn-mark-all-read:hover {
  text-decoration: underline;
}
.user-info-header {
  display: flex;
  align-items: center;
  gap: 8px;
  position: relative;
  height: 100%;
}

.user-dropdown {
  position: absolute;
  top: 50px;
  right: 0;
  width: 150px;
  background: #fff;
  border-radius: 4px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.15);
  z-index: 1000;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  padding: 5px 0;
}

.user-dropdown::before {
  content: '';
  position: absolute;
  top: -6px;
  right: 15px;
  border-left: 6px solid transparent;
  border-right: 6px solid transparent;
  border-bottom: 6px solid #fff;
}

.user-dropdown-item {
  background: none;
  border: none;
  color: #2c3e50;
  padding: 10px 15px;
  text-align: left;
  width: 100%;
  cursor: pointer;
  font-size: 0.90rem;
  transition: background 0.15s, color 0.15s;
  font-family: inherit;
}

.user-dropdown-item:hover {
  background: #f5f8fa;
  color: #e74c3c;
}

.user-avatar-small {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.75rem;
  font-weight: bold;
}

.user-greeting {
  color: white;
  font-size: 0.9rem;
}

.convo-title-link {
  display: block;
  color: #2577b1;
  font-weight: 500;
  cursor: pointer;
  font-size: 0.95rem;
  line-height: 1.3;
}

.convo-title-link:hover {
  text-decoration: underline;
}

.convo-participants {
  display: block;
  font-size: 0.85rem;
  color: #666;
  margin-top: 2px;
}
</style>
