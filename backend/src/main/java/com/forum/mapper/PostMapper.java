package com.forum.mapper;

import com.forum.dto.PostDTO;
import com.forum.entity.Post;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper(componentModel = "spring")
public interface PostMapper {
    PostMapper INSTANCE = Mappers.getMapper(PostMapper.class);

    @Mapping(target = "threadId", source = "thread.id")
    PostDTO toDTO(Post post);

    @Mapping(target = "thread.id", source = "threadId")
    Post toEntity(PostDTO postDTO);

    List<PostDTO> toDTOList(List<Post> posts);
}
