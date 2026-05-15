package com.forum.service;

import com.forum.dto.ResponseDTO;
import com.forum.dto.ThreadDTO;
import com.forum.entity.Thread;
import com.forum.mapper.ThreadMapper;
import com.forum.repository.NotificationRepository;
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
    private final com.forum.repository.PollVoteRepository pollVoteRepository;
    private final com.forum.repository.PostRepository postRepository;
    private final NotificationRepository notificationRepository;
    private final ReactionService reactionService;

    public ResponseDTO<List<ThreadDTO>> getAllThreads(Long categoryId, Integer limit) {
        List<Thread> threads;
        if (categoryId != null) {
            if (limit != null && limit == 1) {
                // Dành cho các ô tóm tắt "Bài viết cuối", lấy tuyệt đối 1 bài mới phản hồi nhất bỏ qua Ghim
                threads = threadRepository.findFirstByCategoryIdOrderByLastPostAtDesc(categoryId)
                        .map(java.util.Collections::singletonList)
                        .orElse(java.util.Collections.emptyList());
            } else {
                threads = threadRepository.findAllByCategoryIdOrderByPinnedDescLastPostAtDesc(categoryId);
            }
        } else {
            threads = threadRepository.findAllByOrderByLastPostAtDesc();
        }
        List<ThreadDTO> dtos = threadMapper.toDTOList(threads);
        enrichThreads(dtos);
        return ResponseDTO.success(dtos);
    }

    public ResponseDTO<List<ThreadDTO>> getLatestThreads() {
        List<ThreadDTO> dtos = threadMapper.toDTOList(threadRepository.findTop10ByOrderByLastPostAtDesc());
        enrichThreads(dtos);
        return ResponseDTO.success(dtos);
    }

    public ResponseDTO<ThreadDTO> getThreadById(Long id) {
        return threadRepository.findById(id).map(thread -> {
            thread.setViewCount(thread.getViewCount() + 1);
            ThreadDTO dto = threadMapper.toDTO(threadRepository.save(thread));
            enrichThread(dto);
            return ResponseDTO.success(dto);
        }).orElseThrow(() -> new RuntimeException("Thread not found"));
    }

    private void enrichThreads(List<ThreadDTO> dtos) {
        if (dtos != null) {
            for (ThreadDTO dto : dtos) {
                enrichThread(dto);
            }
        }
    }

    private void enrichThread(ThreadDTO dto) {
        if (dto == null || dto.getId() == null) return;
        
        postRepository.findFirstByThreadIdOrderByCreatedAtDesc(dto.getId()).ifPresent(post -> {
            dto.setLastPostId(post.getId());
            dto.setLastPostAt(post.getCreatedAt());
            
            if (post.getAuthor() != null) {
                com.forum.dto.UserDTO userDTO = new com.forum.dto.UserDTO();
                userDTO.setId(post.getAuthor().getId());
                userDTO.setUsername(post.getAuthor().getUsername());
                userDTO.setDisplayName(post.getAuthor().getDisplayName());
                userDTO.setEmail(post.getAuthor().getEmail());
                userDTO.setAvatar(post.getAuthor().getAvatar());
                dto.setLastPostAuthor(userDTO);
            }
        });

        // Enrich reactions
        dto.setReactionSummary(reactionService.getSummaryForThread(dto.getId()));
        dto.setCurrentUserReaction(reactionService.getCurrentUserReactionForThread(dto.getId()));
        dto.setRecentReactors(reactionService.getRecentReactorsForThread(dto.getId()));
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
        
        if (threadDTO.getLabel() != null) {
            com.forum.entity.Label label = new com.forum.entity.Label();
            label.setId(threadDTO.getLabel().getId());
            thread.setLabel(label);
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
            
            if (threadDTO.getLabel() != null && threadDTO.getLabel().getId() != null) {
                com.forum.entity.Label label = new com.forum.entity.Label();
                label.setId(threadDTO.getLabel().getId());
                thread.setLabel(label);
            } else {
                thread.setLabel(null);
            }
            
            
            thread.setPinned(threadDTO.isPinned());
            thread.setAttachedImages(threadDTO.getAttachedImages());

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
                        existingPoll.getOptions().removeIf(opt -> {
                            if (opt.getId() != null && !dtoOptionIds.contains(opt.getId())) {
                                pollVoteRepository.deleteByOptionId(opt.getId());
                                return true;
                            }
                            return false;
                        });

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
        threadRepository.findById(id).ifPresent(thread -> {
            // 1. Delete notifications related to this thread and its posts
            notificationRepository.deleteByThreadId(id);
            
            // 2. Handle poll votes if exists
            if (thread.getPoll() != null) {
                pollVoteRepository.deleteByPollId(thread.getPoll().getId());
            }
            
            // 3. Delete all reactions for the thread and its posts
            reactionService.deleteAllReactionsForThread(id);
            
            // 4. Delete posts manually to be safe before thread
            postRepository.deleteByThreadId(id);
            
            // 5. Clear the collections in the managed entity to avoid Hibernate sync issues
            if (thread.getPosts() != null) {
                thread.getPosts().clear();
            }
            
            // 6. Finally delete the thread
            threadRepository.delete(thread);
        });
        return ResponseDTO.success(null);
    }

    public ResponseDTO<ThreadDTO> togglePin(Long id) {
        return threadRepository.findById(id).map(thread -> {
            thread.setPinned(!thread.isPinned());
            return ResponseDTO.success(threadMapper.toDTO(threadRepository.save(thread)));
        }).orElseThrow(() -> new RuntimeException("Thread not found"));
    }
}
