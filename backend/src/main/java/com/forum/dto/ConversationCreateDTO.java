package com.forum.dto;

import lombok.Data;

@Data
public class ConversationCreateDTO {
    private String recipientDisplayName;
    private String title;
    private String content;
}
