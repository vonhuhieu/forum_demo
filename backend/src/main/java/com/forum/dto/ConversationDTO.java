package com.forum.dto;

import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class ConversationDTO {
    private Long id;
    private String title;
    private List<String> participants;
    private LocalDateTime updatedAt;
    private boolean isRead;
}
