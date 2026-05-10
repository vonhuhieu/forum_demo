package com.forum.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class PostDTO {
    private Long id;
    private String content;
    private UserDTO author;
    private Long threadId; // for mapping
    private LocalDateTime createdAt;
    private String attachedImages;
}
