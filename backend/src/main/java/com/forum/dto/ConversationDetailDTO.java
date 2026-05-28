package com.forum.dto;

import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class ConversationDetailDTO {
    private Long id;
    private String title;
    private UserDTO creator;
    private List<UserDTO> participants;
    private List<ConversationMessageDTO> messages;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    private int participantCount;
    private int replyCount;
    private LocalDateTime lastReplyAt;
    private UserDTO lastReplyAuthor;
}
