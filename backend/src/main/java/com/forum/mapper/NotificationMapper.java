package com.forum.mapper;

import com.forum.dto.NotificationDTO;
import com.forum.entity.Notification;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(componentModel = "spring")
public interface NotificationMapper {

    @Mapping(source = "actor.id", target = "actorId")
    @Mapping(source = "actor.username", target = "actorUsername")
    @Mapping(source = "actor.displayName", target = "actorDisplayName")
    @Mapping(source = "actor.avatar", target = "actorAvatar")
    @Mapping(source = "thread.id", target = "threadId")
    @Mapping(source = "thread.title", target = "threadTitle")
    @Mapping(source = "thread.label.name", target = "threadLabelName")
    @Mapping(source = "thread.label.colorCode", target = "threadLabelColor")
    @Mapping(source = "post.id", target = "postId")
    NotificationDTO toDTO(Notification notification);

    List<NotificationDTO> toDTOList(List<Notification> notifications);
}
