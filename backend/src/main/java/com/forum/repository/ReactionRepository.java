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

    @Query("SELECT r.reactionIcon, COUNT(r) FROM Reaction r WHERE r.thread.id = :threadId GROUP BY r.reactionIcon")
    List<Object[]> aggregateByThreadId(@Param("threadId") Long threadId);

    @Query("SELECT r.reactionIcon, COUNT(r) FROM Reaction r WHERE r.post.id = :postId GROUP BY r.reactionIcon")
    List<Object[]> aggregateByPostId(@Param("postId") Long postId);
}
