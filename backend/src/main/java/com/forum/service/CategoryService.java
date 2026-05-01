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
        return ResponseDTO.success(categoryMapper.toDTOList(categoryRepository.findAllByOrderByPositionOrderAsc()));
    }

    public ResponseDTO<List<CategoryDTO>> getTopLevelCategories() {
        // This is a simplified version, you might want to filter in the repository
        List<Category> all = categoryRepository.findAllByOrderByPositionOrderAsc();
        List<Category> topLevel = all.stream()
                .filter(c -> c.getParentCategory() == null)
                .collect(java.util.stream.Collectors.toList());
        return ResponseDTO.success(categoryMapper.toDTOList(topLevel));
    }

    public ResponseDTO<CategoryDTO> getCategoryById(Long id) {
        return categoryRepository.findById(id)
                .map(category -> ResponseDTO.success(categoryMapper.toDTO(category)))
                .orElseThrow(() -> new RuntimeException("Category not found"));
    }

    public ResponseDTO<CategoryDTO> createCategory(CategoryDTO categoryDTO) {
        com.forum.entity.Category category = categoryMapper.toEntity(categoryDTO);
        if (categoryDTO.getCategoryGroupId() != null) {
            com.forum.entity.CategoryGroup group = new com.forum.entity.CategoryGroup();
            group.setId(categoryDTO.getCategoryGroupId());
            category.setCategoryGroup(group);
        }
        if (categoryDTO.getParentCategoryId() != null) {
            com.forum.entity.Category parent = new com.forum.entity.Category();
            parent.setId(categoryDTO.getParentCategoryId());
            category.setParentCategory(parent);
        }
        return ResponseDTO.success(categoryMapper.toDTO(categoryRepository.save(category)));
    }

    public ResponseDTO<CategoryDTO> updateCategory(Long id, CategoryDTO categoryDTO) {
        return categoryRepository.findById(id).map(category -> {
            category.setName(categoryDTO.getName());
            category.setDescription(categoryDTO.getDescription());
            category.setPositionOrder(categoryDTO.getPositionOrder());
            category.setActive(categoryDTO.isActive());
            
            if (categoryDTO.getCategoryGroupId() != null) {
                com.forum.entity.CategoryGroup group = new com.forum.entity.CategoryGroup();
                group.setId(categoryDTO.getCategoryGroupId());
                category.setCategoryGroup(group);
            } else {
                category.setCategoryGroup(null);
            }
            
            if (categoryDTO.getParentCategoryId() != null) {
                com.forum.entity.Category parent = new com.forum.entity.Category();
                parent.setId(categoryDTO.getParentCategoryId());
                category.setParentCategory(parent);
            } else {
                category.setParentCategory(null);
            }
            
            return ResponseDTO.success(categoryMapper.toDTO(categoryRepository.save(category)));
        }).orElseThrow(() -> new RuntimeException("Category not found"));
    }

    public ResponseDTO<Void> deleteCategory(Long id) {
        categoryRepository.deleteById(id);
        return ResponseDTO.success(null);
    }
}
