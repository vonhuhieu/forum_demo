package com.forum.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ThreadDTO {
    private Long id;
    private String title;
    private String content;
    private CategoryDTO category;
    private UserDTO author;
    private LocalDateTime createdAt;
    private int viewCount;
    private int replyCount;
    private boolean pinned;
    private boolean active;
}
