package com.forum.repository;

import com.forum.entity.Thread;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ThreadRepository extends JpaRepository<Thread, Long> {
    @Query("SELECT SUM(t.replyCount) FROM Thread t")
    Long countReplies();

    @org.springframework.data.jpa.repository.Modifying
    @Query("UPDATE Thread t SET t.label = null WHERE t.label.id = :labelId")
    void removeLabelFromThreads(@org.springframework.data.repository.query.Param("labelId") Long labelId);

    List<Thread> findAllByCategoryIdOrderByPinnedDescLastPostAtDesc(Long categoryId);
    List<Thread> findAllByOrderByLastPostAtDesc();
    List<Thread> findTop10ByOrderByLastPostAtDesc();
    java.util.Optional<Thread> findFirstByCategoryIdOrderByLastPostAtDesc(Long categoryId);
}
