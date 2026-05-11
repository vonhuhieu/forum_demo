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
}
