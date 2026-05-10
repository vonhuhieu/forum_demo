import { Client } from '@stomp/stompjs'
import SockJS from 'sockjs-client'

class WebSocketService {
  constructor() {
    this.client = null
    this.connected = false
    this.subscribers = new Map() // topic -> Array of callback functions
    this.username = null
  }

  connect(username) {
    if (this.connected && this.username === username) return
    
    this.disconnect()
    this.username = username

    // Initialize STOMP client using SockJS fallback mechanism
    const socket = new SockJS('http://localhost:8080/ws')
    this.client = new Client({
      webSocketFactory: () => socket,
      reconnectDelay: 5000,
      heartbeatIncoming: 4000,
      heartbeatOutgoing: 4000
    })

    this.client.onConnect = (frame) => {
      this.connected = true
      console.log('WebSocket Connected Successfully: ' + frame)
      
      // Subscribe to existing queued subscriptions
      this.subscribers.forEach((callbacks, topic) => {
        this._subscribeToClient(topic)
      })
    }

    this.client.onStompError = (frame) => {
      console.error('Broker error: ' + frame.headers['message'])
      console.error('Details: ' + frame.body)
    }

    this.client.onWebSocketClose = () => {
       this.connected = false
    }

    this.client.activate()
  }

  _subscribeToClient(topic) {
    if (!this.client || !this.connected) return
    
    this.client.subscribe(topic, (message) => {
      if (message.body) {
        const payload = JSON.parse(message.body)
        const callbacks = this.subscribers.get(topic) || []
        callbacks.forEach(cb => cb(payload))
      }
    })
  }

  subscribe(topic, callback) {
    if (!this.subscribers.has(topic)) {
      this.subscribers.set(topic, [])
    }
    
    this.subscribers.get(topic).push(callback)
    
    // If already connected, push active subscription instantly to backend
    if (this.connected) {
      this._subscribeToClient(topic)
    }
  }

  // Specifically shorthand for general notifications
  subscribeToNotifications(userId, callback) {
    const topic = `/topic/notifications/${userId}`
    this.subscribe(topic, callback)
  }

  disconnect() {
    if (this.client) {
      this.client.deactivate()
      this.client = null
    }
    this.connected = false
    this.subscribers.clear()
    this.username = null
  }
}

const instance = new WebSocketService()
export default instance
