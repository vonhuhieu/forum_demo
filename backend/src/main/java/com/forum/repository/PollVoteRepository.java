package com.forum.repository;

import com.forum.entity.PollVote;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface PollVoteRepository extends JpaRepository<PollVote, Long> {
    List<PollVote> findByPollIdAndUserId(Long pollId, Long userId);
    boolean existsByPollIdAndOptionIdAndUserId(Long pollId, Long optionId, Long userId);
    int countByOptionId(Long optionId);
}
