package com.forum.repository;

import com.forum.entity.Notification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {
    List<Notification> findByRecipientUsernameOrderByCreatedAtDesc(String username);
    long countByRecipientUsernameAndIsReadFalse(String username);

    long countByRecipientUsernameAndTypeNotAndIsReadFalse(String username, com.forum.entity.NotificationType type);

    long countByRecipientUsernameAndTypeAndIsReadFalse(String username, com.forum.entity.NotificationType type);

    java.util.List<Notification> findByRecipientUsernameAndTypeOrderByCreatedAtDesc(String username, com.forum.entity.NotificationType type);

    java.util.List<Notification> findByRecipientUsernameAndTypeInOrderByCreatedAtDesc(String username, java.util.List<com.forum.entity.NotificationType> types);

    long countByRecipientUsernameAndTypeInAndIsReadFalse(String username, java.util.List<com.forum.entity.NotificationType> types);

    long countByRecipientUsernameAndTypeNotInAndIsReadFalse(String username, java.util.List<com.forum.entity.NotificationType> types);

    @org.springframework.data.jpa.repository.Modifying
    @org.springframework.data.jpa.repository.Query("UPDATE Notification n SET n.isRead = true WHERE n.recipient.username = :username AND n.conversation.id = :conversationId AND n.isRead = false")
    void markConversationNotificationsAsRead(@org.springframework.data.repository.query.Param("username") String username, @org.springframework.data.repository.query.Param("conversationId") Long conversationId);
    
    @org.springframework.data.jpa.repository.Modifying
    @org.springframework.data.jpa.repository.Query("DELETE FROM Notification n WHERE n.thread.id = :threadId")
    void deleteByThreadId(@org.springframework.data.repository.query.Param("threadId") Long threadId);
}
