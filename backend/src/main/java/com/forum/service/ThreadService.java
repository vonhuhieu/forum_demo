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

    public ResponseDTO<List<ThreadDTO>> getLatestThreads() {
        return ResponseDTO.success(threadMapper.toDTOList(threadRepository.findTop10ByOrderByCreatedAtDesc()));
    }

    public ResponseDTO<ThreadDTO> getThreadById(Long id) {
        return threadRepository.findById(id).map(thread -> {
            thread.setViewCount(thread.getViewCount() + 1);
            return ResponseDTO.success(threadMapper.toDTO(threadRepository.save(thread)));
        }).orElseThrow(() -> new RuntimeException("Thread not found"));
    }

    public ResponseDTO<ThreadDTO> createThread(ThreadDTO threadDTO) {
        Thread thread = threadMapper.toEntity(threadDTO);
        
        // Lấy username từ SecurityContext
        String username = (String) org.springframework.security.core.context.SecurityContextHolder.getContext()
                .getAuthentication().getPrincipal();
        
        userRepository.findByUsername(username).ifPresent(thread::setAuthor);
        
        if (thread.getPoll() != null) {
            thread.getPoll().setThread(thread);
            if (thread.getPoll().getOptions() != null) {
                thread.getPoll().getOptions().forEach(opt -> opt.setPoll(thread.getPoll()));
            }
        }
        
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

            // Xử lý cập nhật Poll
            if (threadDTO.getPoll() != null) {
                com.forum.entity.Poll existingPoll = thread.getPoll();
                if (existingPoll == null) {
                    com.forum.entity.Poll newPoll = threadMapper.toEntity(threadDTO).getPoll();
                    newPoll.setThread(thread);
                    if (newPoll.getOptions() != null) {
                        newPoll.getOptions().forEach(opt -> opt.setPoll(newPoll));
                    }
                    thread.setPoll(newPoll);
                } else {
                    existingPoll.setQuestion(threadDTO.getPoll().getQuestion());
                    existingPoll.setMaxChoices(threadDTO.getPoll().getMaxChoices());
                    existingPoll.setAllowChangeVote(threadDTO.getPoll().isAllowChangeVote());
                    existingPoll.setPublicVoting(threadDTO.getPoll().isPublicVoting());
                    existingPoll.setShowResultWithoutVote(threadDTO.getPoll().isShowResultWithoutVote());
                    existingPoll.setClosedAt(threadDTO.getPoll().getClosedAt());

                    // Cập nhật Options
                    if (threadDTO.getPoll().getOptions() != null) {
                        java.util.List<Long> dtoOptionIds = threadDTO.getPoll().getOptions().stream()
                                .filter(o -> o.getId() != null)
                                .map(com.forum.dto.PollOptionDTO::getId)
                                .collect(java.util.stream.Collectors.toList());

                        // Xóa các option không còn tồn tại trong request mới (và có ID)
                        existingPoll.getOptions().removeIf(opt -> opt.getId() != null && !dtoOptionIds.contains(opt.getId()));

                        // Thêm mới hoặc cập nhật option
                        for (com.forum.dto.PollOptionDTO optDto : threadDTO.getPoll().getOptions()) {
                            if (optDto.getId() != null) {
                                existingPoll.getOptions().stream()
                                        .filter(o -> o.getId().equals(optDto.getId()))
                                        .findFirst()
                                        .ifPresent(o -> o.setOptionText(optDto.getOptionText()));
                            } else {
                                com.forum.entity.PollOption newOpt = new com.forum.entity.PollOption();
                                newOpt.setOptionText(optDto.getOptionText());
                                newOpt.setPoll(existingPoll);
                                existingPoll.getOptions().add(newOpt);
                            }
                        }
                    }
                }
            }

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
