package com.forum.dto;

import com.forum.entity.NotificationType;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class NotificationDTO {
    private Long id;
    private String type; // Maps NotificationType string
    
    private Long actorId;
    private String actorUsername;
    private String actorDisplayName;
    private String actorAvatar;
    
    private Long threadId;
    private String threadTitle;
    private String threadLabelName;
    private String threadLabelColor;
    
    private Long postId; // Optional for direct jumping
    
    private String content;
    
    @JsonProperty("isRead")
    private boolean isRead;
    private LocalDateTime createdAt;
}
