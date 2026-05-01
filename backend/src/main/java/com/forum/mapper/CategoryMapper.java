package com.forum.mapper;

import com.forum.dto.CategoryDTO;
import com.forum.entity.Category;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper(componentModel = "spring")
public interface CategoryMapper {
    CategoryMapper INSTANCE = Mappers.getMapper(CategoryMapper.class);

    @org.mapstruct.Mapping(target = "categoryGroupId", source = "categoryGroup.id")
    @org.mapstruct.Mapping(target = "parentCategoryId", source = "parentCategory.id")
    @org.mapstruct.Mapping(target = "threadCount", expression = "java(calculateThreadCount(category))")
    @org.mapstruct.Mapping(target = "postCount", expression = "java(calculatePostCount(category))")
    CategoryDTO toDTO(Category category);
    
    Category toEntity(CategoryDTO categoryDTO);
    
    List<CategoryDTO> toDTOList(List<Category> categories);

    default Long calculateThreadCount(Category category) {
        if (category.getThreads() == null) return 0L;
        return (long) category.getThreads().size();
    }

    default Long calculatePostCount(Category category) {
        if (category.getThreads() == null) return 0L;
        return category.getThreads().stream()
                .mapToLong(t -> t.getReplyCount() + 1)
                .sum();
    }
}
