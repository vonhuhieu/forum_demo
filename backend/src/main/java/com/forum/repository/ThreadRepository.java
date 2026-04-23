package com.forum.repository;

import com.forum.entity.Thread;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ThreadRepository extends JpaRepository<Thread, Long> {
    List<Thread> findAllByCategoryIdOrderByPinnedDescCreatedAtDesc(Long categoryId);
    List<Thread> findAllByOrderByCreatedAtDesc();
}
