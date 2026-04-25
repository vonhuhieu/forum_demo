package com.forum.service;

import com.forum.dto.ResponseDTO;
import com.forum.dto.ThreadDTO;
import com.forum.entity.Thread;
import com.forum.mapper.ThreadMapper;
import com.forum.repository.ThreadRepository;
import com.forum.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class ThreadService {

    private final ThreadRepository threadRepository;
    private final UserRepository userRepository;
    private final ThreadMapper threadMapper;

    public ResponseDTO<List<ThreadDTO>> getAllThreads(Long categoryId) {
        List<Thread> threads;
        if (categoryId != null) {
            threads = threadRepository.findAllByCategoryIdOrderByPinnedDescCreatedAtDesc(categoryId);
        } else {
            threads = threadRepository.findAllByOrderByCreatedAtDesc();
        }
        return ResponseDTO.success(threadMapper.toDTOList(threads));
    }

    public ResponseDTO<ThreadDTO> getThreadById(Long id) {
        return threadRepository.findById(id).map(thread -> {
            thread.setViewCount(thread.getViewCount() + 1);
            return ResponseDTO.success(threadMapper.toDTO(threadRepository.save(thread)));
        }).orElseThrow(() -> new RuntimeException("Thread not found"));
    }

    public ResponseDTO<ThreadDTO> createThread(ThreadDTO threadDTO) {
        Thread thread = threadMapper.toEntity(threadDTO);
        // Tạm thời gán author là admin (ID: 1)
        userRepository.findById(1L).ifPresent(thread::setAuthor);
        Thread saved = threadRepository.save(thread);
        return ResponseDTO.success(threadMapper.toDTO(saved));
    }

    public ResponseDTO<ThreadDTO> updateThread(Long id, ThreadDTO threadDTO) {
        return threadRepository.findById(id).map(thread -> {
            thread.setTitle(threadDTO.getTitle());
            thread.setContent(threadDTO.getContent());
            if (threadDTO.getCategory() != null) {
                com.forum.entity.Category category = new com.forum.entity.Category();
                category.setId(threadDTO.getCategory().getId());
                thread.setCategory(category);
            }
            thread.setPinned(threadDTO.isPinned());
            return ResponseDTO.success(threadMapper.toDTO(threadRepository.save(thread)));
        }).orElseThrow(() -> new RuntimeException("Thread not found"));
    }

    public ResponseDTO<Void> deleteThread(Long id) {
        threadRepository.deleteById(id);
        return ResponseDTO.success(null);
    }

    public ResponseDTO<ThreadDTO> togglePin(Long id) {
        return threadRepository.findById(id).map(thread -> {
            thread.setPinned(!thread.isPinned());
            return ResponseDTO.success(threadMapper.toDTO(threadRepository.save(thread)));
        }).orElseThrow(() -> new RuntimeException("Thread not found"));
    }
}
