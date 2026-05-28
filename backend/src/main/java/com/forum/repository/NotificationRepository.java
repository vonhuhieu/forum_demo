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
    
    @org.springframework.data.jpa.repository.Modifying
    @org.springframework.data.jpa.repository.Query("DELETE FROM Notification n WHERE n.thread.id = :threadId")
    void deleteByThreadId(@org.springframework.data.repository.query.Param("threadId") Long threadId);
}
