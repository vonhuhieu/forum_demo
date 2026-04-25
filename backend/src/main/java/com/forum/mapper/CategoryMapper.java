package com.forum.mapper;

import com.forum.dto.CategoryDTO;
import com.forum.entity.Category;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper(componentModel = "spring")
public interface CategoryMapper {
    CategoryMapper INSTANCE = Mappers.getMapper(CategoryMapper.class);

    CategoryDTO toDTO(Category category);
    
    Category toEntity(CategoryDTO categoryDTO);
    
    List<CategoryDTO> toDTOList(List<Category> categories);
}
