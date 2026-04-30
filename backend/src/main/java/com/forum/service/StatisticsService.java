package com.forum.service;

import com.forum.dto.StatisticsDTO;
import com.forum.entity.User;
import com.forum.repository.CategoryRepository;
import com.forum.repository.ThreadRepository;
import com.forum.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class StatisticsService {

    private final CategoryRepository categoryRepository;
    private final ThreadRepository threadRepository;
    private final UserRepository userRepository;

    public StatisticsDTO getStatistics() {
        long totalCategories = categoryRepository.count();
        long totalThreads = threadRepository.count();
        Long totalReplies = threadRepository.countReplies();
        if (totalReplies == null) {
            totalReplies = 0L;
        }
        
        long totalPosts = totalThreads + totalReplies;
        long totalMembers = userRepository.count();
        
        String latestMember = userRepository.findFirstByOrderByIdDesc()
                .map(User::getUsername)
                .orElse("Chưa có");

        return StatisticsDTO.builder()
                .totalCategories(totalCategories)
                .totalThreads(totalThreads)
                .totalPosts(totalPosts)
                .totalMembers(totalMembers)
                .latestMember(latestMember)
                .build();
    }
}
