package com.forum.dto;

import com.forum.entity.NotificationType;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class NotificationDTO {
    private Long id;
    private String type; // Maps NotificationType string
    
    private Long actorId;
    private String actorUsername;
    private String actorAvatar;
    
    private Long threadId;
    private String threadTitle;
    
    private Long postId; // Optional for direct jumping
    
    private String content;
    private boolean isRead;
    private LocalDateTime createdAt;
}
