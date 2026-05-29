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
    private String creatorAvatar;
    private String creatorUsername;
    private String creatorDisplayName;
    private Long firstMessageId;

    @JsonProperty("isRead")
    private boolean isRead;

    @JsonProperty("isReaction")
    private boolean isReaction;
    private Long notificationId;
    private String reactionIcon;
    private String reactionName;
    private String reactionColor;

    @JsonProperty("isReply")
    private boolean isReply;
    private String lastMessageSenderUsername;
    private String lastMessageSenderDisplayName;
    private String lastMessageSenderAvatar;
    private Long lastMessageId;
}
