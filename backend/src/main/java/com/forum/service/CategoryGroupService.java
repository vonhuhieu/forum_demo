package com.forum.service;

import com.forum.dto.CategoryGroupDTO;
import com.forum.dto.ResponseDTO;
import com.forum.entity.CategoryGroup;
import com.forum.mapper.CategoryGroupMapper;
import com.forum.repository.CategoryGroupRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class CategoryGroupService {

    private final CategoryGroupRepository categoryGroupRepository;
    private final CategoryGroupMapper categoryGroupMapper;

    public ResponseDTO<List<CategoryGroupDTO>> getAllGroups() {
        return ResponseDTO.success(categoryGroupMapper.toDTOList(categoryGroupRepository.findAllByOrderByPositionOrderAsc()));
    }

    public ResponseDTO<CategoryGroupDTO> getGroupById(Long id) {
        return categoryGroupRepository.findById(id)
                .map(group -> ResponseDTO.success(categoryGroupMapper.toDTO(group)))
                .orElseThrow(() -> new RuntimeException("Category Group not found"));
    }

    public ResponseDTO<CategoryGroupDTO> createGroup(CategoryGroupDTO groupDTO) {
        CategoryGroup group = categoryGroupMapper.toEntity(groupDTO);
        return ResponseDTO.success(categoryGroupMapper.toDTO(categoryGroupRepository.save(group)));
    }

    public ResponseDTO<CategoryGroupDTO> updateGroup(Long id, CategoryGroupDTO groupDTO) {
        return categoryGroupRepository.findById(id).map(group -> {
            group.setName(groupDTO.getName());
            group.setPositionOrder(groupDTO.getPositionOrder());
            group.setActive(groupDTO.isActive());
            return ResponseDTO.success(categoryGroupMapper.toDTO(categoryGroupRepository.save(group)));
        }).orElseThrow(() -> new RuntimeException("Category Group not found"));
    }

    public ResponseDTO<Void> deleteGroup(Long id) {
        categoryGroupRepository.deleteById(id);
        return ResponseDTO.success(null);
    }
}
