package com.forum.service;

import com.forum.dto.CategoryDTO;
import com.forum.dto.ResponseDTO;
import com.forum.entity.Category;
import com.forum.mapper.CategoryMapper;
import com.forum.repository.CategoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class CategoryService {

    private final CategoryRepository categoryRepository;
    private final CategoryMapper categoryMapper;

    public ResponseDTO<List<CategoryDTO>> getAllCategories() {
        return ResponseDTO.success(categoryMapper.toDTOList(categoryRepository.findAll()));
    }

    public ResponseDTO<CategoryDTO> getCategoryById(Long id) {
        return categoryRepository.findById(id)
                .map(category -> ResponseDTO.success(categoryMapper.toDTO(category)))
                .orElseThrow(() -> new RuntimeException("Category not found"));
    }

    public ResponseDTO<CategoryDTO> createCategory(CategoryDTO categoryDTO) {
        Category category = categoryMapper.toEntity(categoryDTO);
        return ResponseDTO.success(categoryMapper.toDTO(categoryRepository.save(category)));
    }

    public ResponseDTO<CategoryDTO> updateCategory(Long id, CategoryDTO categoryDTO) {
        return categoryRepository.findById(id).map(category -> {
            category.setName(categoryDTO.getName());
            category.setDescription(categoryDTO.getDescription());
            category.setPositionOrder(categoryDTO.getPositionOrder());
            category.setActive(categoryDTO.isActive());
            return ResponseDTO.success(categoryMapper.toDTO(categoryRepository.save(category)));
        }).orElseThrow(() -> new RuntimeException("Category not found"));
    }

    public ResponseDTO<Void> deleteCategory(Long id) {
        categoryRepository.deleteById(id);
        return ResponseDTO.success(null);
    }
}
