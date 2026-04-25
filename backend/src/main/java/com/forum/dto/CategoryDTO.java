package com.forum.dto;

import lombok.Data;

@Data
public class CategoryDTO {
    private Long id;
    private String name;
    private String description;
    private Integer positionOrder;
    private boolean active;
}
