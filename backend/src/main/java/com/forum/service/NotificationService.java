package com.forum.service;

import com.forum.dto.NotificationDTO;
import com.forum.dto.ResponseDTO;
import com.forum.entity.Notification;
import com.forum.entity.NotificationType;
import com.forum.entity.Post;
import com.forum.entity.ReactionIcon;
import com.forum.entity.Thread;
import com.forum.entity.User;
import com.forum.mapper.NotificationMapper;
import com.forum.repository.NotificationRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.scheduling.annotation.Async;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class NotificationService {

    private final NotificationRepository notificationRepository;
    private final NotificationMapper notificationMapper;
    private final SimpMessagingTemplate messagingTemplate;

    /**
     * Logic to generate notification record and fire realtime message to targeted user socket.
     */
    @Async
    @Transactional
    public void sendNewCommentNotification(User actor, Thread thread, Post post) {
        User recipient = thread.getAuthor();
        
        // Don't notify user about their own actions
        if (recipient == null || actor == null || recipient.getId().equals(actor.getId())) {
            return;
        }

        Notification notif = new Notification();
        notif.setRecipient(recipient);
        notif.setActor(actor);
        notif.setType(NotificationType.NEW_COMMENT);
        notif.setThread(thread);
        notif.setPost(post);
        notif.setRead(false);

        Notification saved = notificationRepository.save(notif);
        NotificationDTO dto = notificationMapper.toDTO(saved);

        pushNotification(recipient.getId(), dto);
    }

    @Async
    @Transactional
    public void sendQuoteNotification(User actor, User recipient, Thread thread, Post post) {
        // Don't notify user about their own actions
        if (recipient == null || actor == null || recipient.getId().equals(actor.getId())) {
            return;
        }

        Notification notif = new Notification();
        notif.setRecipient(recipient);
        notif.setActor(actor);
        notif.setType(NotificationType.QUOTE);
        notif.setThread(thread);
        notif.setPost(post);
        notif.setRead(false);

        Notification saved = notificationRepository.save(notif);
        NotificationDTO dto = notificationMapper.toDTO(saved);

        pushNotification(recipient.getId(), dto);
    }

    @Async
    @Transactional
    public void sendReactionNotification(User actor, User recipient, Thread thread, Post post, ReactionIcon icon) {
        // Don't notify user about their own actions
        if (recipient == null || actor == null || recipient.getId().equals(actor.getId())) {
            return;
        }

        Notification notif = new Notification();
        notif.setRecipient(recipient);
        notif.setActor(actor);
        notif.setType(NotificationType.REACTION);
        notif.setThread(thread);
        notif.setPost(post);
        notif.setReactionIcon(icon.getIcon());
        notif.setReactionName(icon.getTooltip());
        notif.setReactionColor(icon.getColor());
        notif.setRead(false);

        Notification saved = notificationRepository.save(notif);
        NotificationDTO dto = notificationMapper.toDTO(saved);

        pushNotification(recipient.getId(), dto);
    }

    private void pushNotification(Long userId, NotificationDTO dto) {
        try {
            String dest = "/topic/notifications/" + userId;
            messagingTemplate.convertAndSend(dest, dto);
            log.info("Successfully pushed realtime notification to topic: {}", dest);
        } catch (Exception e) {
            log.warn("Failed to push realtime websocket message, but record persists in DB: {}", e.getMessage());
        }
    }

    public ResponseDTO<List<NotificationDTO>> getMyNotifications() {
        String username = (String) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        List<Notification> list = notificationRepository.findByRecipientUsernameOrderByCreatedAtDesc(username);
        return ResponseDTO.success(notificationMapper.toDTOList(list));
    }

    public ResponseDTO<Long> getMyUnreadCount() {
        String username = (String) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        long count = notificationRepository.countByRecipientUsernameAndIsReadFalse(username);
        return ResponseDTO.success(count);
    }

    public ResponseDTO<Void> markAsRead(Long id) {
        notificationRepository.findById(id).ifPresent(notif -> {
            notif.setRead(true);
            notificationRepository.save(notif);
        });
        return ResponseDTO.success(null);
    }

    public ResponseDTO<Void> markAllAsRead() {
        String username = (String) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        List<Notification> unreads = notificationRepository.findByRecipientUsernameOrderByCreatedAtDesc(username);
        unreads.stream().filter(n -> !n.isRead()).forEach(n -> {
            n.setRead(true);
            notificationRepository.save(n);
        });
        return ResponseDTO.success(null);
    }
}
