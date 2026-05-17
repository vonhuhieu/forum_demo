package com.forum.service;

import com.forum.dto.PostDTO;
import com.forum.dto.ResponseDTO;
import com.forum.entity.Post;
import com.forum.entity.Thread;
import com.forum.entity.ThreadSubscription;
import com.forum.entity.User;
import com.forum.mapper.PostMapper;
import com.forum.repository.PostRepository;
import com.forum.repository.ThreadRepository;
import com.forum.repository.UserRepository;
import com.forum.repository.ThreadSubscriptionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
@Transactional
@RequiredArgsConstructor
public class PostService {

    private final PostRepository postRepository;
    private final ThreadRepository threadRepository;
    private final UserRepository userRepository;
    private final PostMapper postMapper;
    private final NotificationService notificationService;
    private final ReactionService reactionService;
    private final ThreadSubscriptionRepository threadSubscriptionRepository;

    public ResponseDTO<List<PostDTO>> getPostsByThread(Long threadId) {
        List<Post> posts = postRepository.findByThreadIdOrderByCreatedAtAsc(threadId);
        List<PostDTO> dtos = postMapper.toDTOList(posts);
        enrichPosts(dtos);
        return ResponseDTO.success(dtos);
    }

    private void enrichPosts(List<PostDTO> dtos) {
        if (dtos != null) {
            dtos.forEach(this::enrichPost);
        }
    }

    private void enrichPost(PostDTO dto) {
        if (dto == null || dto.getId() == null) return;
        dto.setReactionSummary(reactionService.getSummaryForPost(dto.getId()));
        dto.setCurrentUserReaction(reactionService.getCurrentUserReactionForPost(dto.getId()));
        dto.setRecentReactors(reactionService.getRecentReactorsForPost(dto.getId()));
    }

    public ResponseDTO<PostDTO> createPost(PostDTO postDTO) {
        if (postDTO.getThreadId() == null) {
            throw new RuntimeException("Thread ID cannot be null");
        }

        Thread thread = threadRepository.findById(postDTO.getThreadId())
                .orElseThrow(() -> new RuntimeException("Thread not found"));

        Post post = postMapper.toEntity(postDTO);
        post.setThread(thread);

        // Get username from SecurityContext
        String username = (String) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        userRepository.findByUsername(username).ifPresent(post::setAuthor);

        Post saved = postRepository.save(post);

        // Update thread statistics
        thread.setReplyCount(thread.getReplyCount() + 1);
        thread.setLastPostAt(saved.getCreatedAt());
        Thread updatedThread = threadRepository.save(thread);

        // Auto-subscribe the commenting user if not the thread owner
        boolean autoFollowed = false;
        try {
            User actor = post.getAuthor();
            if (actor != null && updatedThread.getAuthor() != null && !updatedThread.getAuthor().getId().equals(actor.getId())) {
                Optional<ThreadSubscription> subOpt = threadSubscriptionRepository.findByThreadIdAndUserId(updatedThread.getId(), actor.getId());
                if (subOpt.isEmpty()) {
                    ThreadSubscription sub = new ThreadSubscription();
                    sub.setThread(updatedThread);
                    sub.setUser(actor);
                    sub.setFollowing(true);
                    threadSubscriptionRepository.save(sub);
                    autoFollowed = true;
                } else if (!subOpt.get().isFollowing()) {
                    ThreadSubscription sub = subOpt.get();
                    sub.setFollowing(true);
                    threadSubscriptionRepository.save(sub);
                    autoFollowed = true;
                }
            }
        } catch (Exception e) {
            // ignore
        }

        // Gửi thông báo
        try {
            User actor = post.getAuthor();
            String content = post.getContent();
            
            // 1. Detect tagged users
            Set<Long> mentionedUserIds = notificationService.getMentionedUserIds(actor, content);
            Set<Long> notifiedUserIds = new HashSet<>(mentionedUserIds);
            
            // Send MENTION notifications to all tagged users
            for (Long recipientId : mentionedUserIds) {
                userRepository.findById(recipientId).ifPresent(recipient -> {
                    notificationService.sendMentionNotification(actor, recipient, updatedThread, saved);
                });
            }

            // Pattern to detect quotes with data-source
            Pattern pattern = Pattern.compile("data-source=\"([^\"]+)\"");
            Matcher matcher = pattern.matcher(content != null ? content : "");
            Set<String> quotedIds = new HashSet<>();
            while (matcher.find()) {
                quotedIds.add(matcher.group(1));
            }

            for (String sourceId : quotedIds) {
                if ("main_thread_entry".equals(sourceId)) {
                    // Quoting the thread itself
                    User threadAuthor = updatedThread.getAuthor();
                    if (threadAuthor != null && actor != null && !threadAuthor.getId().equals(actor.getId())) {
                        // Suppress quote notification if the threadAuthor is already mentioned
                        if (!notifiedUserIds.contains(threadAuthor.getId())) {
                            notificationService.sendQuoteNotification(actor, threadAuthor, updatedThread, saved);
                            notifiedUserIds.add(threadAuthor.getId());
                        }
                    }
                } else {
                    // Quoting a specific post
                    try {
                        Long postId = Long.parseLong(sourceId);
                        postRepository.findById(postId).ifPresent(quotedPost -> {
                            User quotedAuthor = quotedPost.getAuthor();
                            if (quotedAuthor != null && actor != null && !quotedAuthor.getId().equals(actor.getId())) {
                                // Suppress quote notification if the quotedAuthor is already mentioned
                                if (!notifiedUserIds.contains(quotedAuthor.getId())) {
                                    notificationService.sendQuoteNotification(actor, quotedAuthor, updatedThread, saved);
                                    notifiedUserIds.add(quotedAuthor.getId());
                                }
                            }
                        });
                    } catch (NumberFormatException e) {
                        // ignore invalid IDs
                    }
                }
            }

            // Notify all thread followers who have NOT been notified yet via MENTION or QUOTE
            Set<Long> followers = new HashSet<>();
            
            // Explicit followers
            List<ThreadSubscription> subs = threadSubscriptionRepository.findByThreadIdAndIsFollowingTrue(updatedThread.getId());
            for (ThreadSubscription sub : subs) {
                if (sub.getUser() != null) {
                    followers.add(sub.getUser().getId());
                }
            }

            // Implicit thread owner follow
            User threadOwner = updatedThread.getAuthor();
            if (threadOwner != null) {
                Optional<ThreadSubscription> ownerSubOpt = threadSubscriptionRepository.findByThreadIdAndUserId(updatedThread.getId(), threadOwner.getId());
                if (ownerSubOpt.isEmpty() || ownerSubOpt.get().isFollowing()) {
                    followers.add(threadOwner.getId());
                }
            }

            for (Long followerId : followers) {
                if (actor != null && followerId.equals(actor.getId())) {
                    continue;
                }
                if (notifiedUserIds.contains(followerId)) {
                    continue;
                }
                userRepository.findById(followerId).ifPresent(follower -> {
                    notificationService.sendNewCommentNotification(actor, updatedThread, saved, follower);
                });
            }
        } catch (Exception e) {
            // log error or ignore
        }

        PostDTO resultDto = postMapper.toDTO(saved);
        if (autoFollowed) {
            resultDto.setAutoFollowed(true);
        }
        enrichPost(resultDto);
        return ResponseDTO.success(resultDto);
    }

    public ResponseDTO<PostDTO> updatePost(Long id, PostDTO postDTO) {
        Post post = postRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Post not found"));

        // Lấy username từ SecurityContext để kiểm tra quyền sở hữu
        String currentUsername = (String) org.springframework.security.core.context.SecurityContextHolder.getContext()
                .getAuthentication().getPrincipal();
        
        if (post.getAuthor() == null || !post.getAuthor().getUsername().equals(currentUsername)) {
            throw new RuntimeException("You are not authorized to edit this post");
        }

        post.setContent(postDTO.getContent());
        post.setAttachedImages(postDTO.getAttachedImages());

        Post saved = postRepository.save(post);
        PostDTO resultDto = postMapper.toDTO(saved);
        enrichPost(resultDto);
        return ResponseDTO.success(resultDto);
    }
}
