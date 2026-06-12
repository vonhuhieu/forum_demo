package com.forum.repository;

import com.forum.entity.Post;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import java.util.List;

@Repository
public interface PostRepository extends JpaRepository<Post, Long> {
    List<Post> findByThreadIdOrderByCreatedAtAsc(Long threadId);
    Page<Post> findByThreadId(Long threadId, Pageable pageable);
    java.util.Optional<Post> findFirstByThreadIdOrderByCreatedAtDesc(Long threadId);
    
    @org.springframework.data.jpa.repository.Modifying
    @org.springframework.data.jpa.repository.Query("DELETE FROM Post p WHERE p.thread.id = :threadId")
    void deleteByThreadId(@org.springframework.data.repository.query.Param("threadId") Long threadId);

    @org.springframework.data.jpa.repository.Query(value = 
        "SELECT p.* FROM posts p " +
        "INNER JOIN (SELECT MAX(p2.id) AS max_id FROM posts p2 WHERE p2.thread_id IN :threadIds GROUP BY p2.thread_id) m " +
        "ON p.id = m.max_id", 
        nativeQuery = true)
    List<Post> findLatestPostsForThreadIds(@org.springframework.data.repository.query.Param("threadIds") List<Long> threadIds);
}
