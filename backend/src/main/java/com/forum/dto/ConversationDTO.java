package com.forum.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class ConversationDTO {
    private Long id;
    private String title;
    private List<String> participants;
    private LocalDateTime updatedAt;

    @JsonProperty("isRead")
    private boolean isRead;
}
