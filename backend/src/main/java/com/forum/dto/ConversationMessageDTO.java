package com.forum.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ConversationMessageDTO {
    private Long id;
    private String content;
    private UserDTO sender;
    private LocalDateTime createdAt;
}
