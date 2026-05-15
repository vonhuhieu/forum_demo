package com.forum.repository;

import com.forum.entity.Reaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ReactionRepository extends JpaRepository<Reaction, Long> {

    Optional<Reaction> findByUserIdAndThreadId(Long userId, Long threadId);

    Optional<Reaction> findByUserIdAndPostId(Long userId, Long postId);

    void deleteByUserIdAndThreadId(Long userId, Long threadId);

    void deleteByUserIdAndPostId(Long userId, Long postId);

    @Query("SELECT r.reactionIcon, COUNT(r), MAX(r.updatedAt) FROM Reaction r WHERE r.thread.id = :threadId GROUP BY r.reactionIcon")
    List<Object[]> aggregateByThreadId(@Param("threadId") Long threadId);

    @Query("SELECT r.reactionIcon, COUNT(r), MAX(r.updatedAt) FROM Reaction r WHERE r.post.id = :postId GROUP BY r.reactionIcon")
    List<Object[]> aggregateByPostId(@Param("postId") Long postId);

    List<Reaction> findTop3ByThreadIdOrderByUpdatedAtDesc(Long threadId);

    List<Reaction> findTop3ByPostIdOrderByUpdatedAtDesc(Long postId);

    @org.springframework.data.jpa.repository.Modifying
    @Query("DELETE FROM Reaction r WHERE r.thread.id = :threadId OR r.post.id IN (SELECT p.id FROM Post p WHERE p.thread.id = :threadId)")
    void deleteByThreadIdOrPostThreadId(@Param("threadId") Long threadId);

    org.springframework.data.domain.Page<Reaction> findByThreadId(Long threadId, org.springframework.data.domain.Pageable pageable);

    org.springframework.data.domain.Page<Reaction> findByThreadIdAndReactionIconId(Long threadId, Long iconId, org.springframework.data.domain.Pageable pageable);

    org.springframework.data.domain.Page<Reaction> findByPostId(Long postId, org.springframework.data.domain.Pageable pageable);

    org.springframework.data.domain.Page<Reaction> findByPostIdAndReactionIconId(Long postId, Long iconId, org.springframework.data.domain.Pageable pageable);
}
