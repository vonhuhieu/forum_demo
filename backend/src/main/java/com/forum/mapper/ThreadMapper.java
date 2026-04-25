package com.forum.mapper;

import com.forum.dto.ThreadDTO;
import com.forum.entity.Thread;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ThreadMapper {
    ThreadMapper INSTANCE = Mappers.getMapper(ThreadMapper.class);

    ThreadDTO toDTO(Thread thread);
    
    Thread toEntity(ThreadDTO threadDTO);
    
    List<ThreadDTO> toDTOList(List<Thread> threads);
}
