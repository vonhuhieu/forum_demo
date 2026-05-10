package com.forum.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        // Clients subscribe to topics like /topic/all or individual /queue/notifications
        config.enableSimpleBroker("/topic", "/queue");
        // Prefix for app-destination mapping methods in controllers (not really needed for push only)
        config.setApplicationDestinationPrefixes("/app");
        // Individual user-specific queue destination prefix
        config.setUserDestinationPrefix("/user");
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // Register path /ws with cross origin allowance for dev server and fallback options
        registry.addEndpoint("/ws")
                .setAllowedOrigins("http://localhost:5173")
                .withSockJS();
        
        // Fallback non-SockJS direct endpoint just in case
        registry.addEndpoint("/ws")
                .setAllowedOrigins("http://localhost:5173");
    }
}
