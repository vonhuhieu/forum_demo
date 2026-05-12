package com.forum.service;

import com.forum.dto.PostDTO;
import com.forum.dto.ResponseDTO;
import com.forum.entity.Post;
import com.forum.entity.Thread;
import com.forum.entity.User;
import com.forum.mapper.PostMapper;
import com.forum.repository.PostRepository;
import com.forum.repository.ThreadRepository;
import com.forum.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class PostService {

    private final PostRepository postRepository;
    private final ThreadRepository threadRepository;
    private final UserRepository userRepository;
    private final PostMapper postMapper;
    private final NotificationService notificationService;

    public ResponseDTO<List<PostDTO>> getPostsByThread(Long threadId) {
        List<Post> posts = postRepository.findByThreadIdOrderByCreatedAtAsc(threadId);
        return ResponseDTO.success(postMapper.toDTOList(posts));
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

        // Gửi thông báo tới chủ bài viết realtime + lưu DB
        try {
            User authorEntity = post.getAuthor(); // Lấy User object đã resolve ở trên
            notificationService.sendNewCommentNotification(authorEntity, updatedThread, saved);
        } catch (Exception e) {
            // Don't block transaction if notification push errors out
        }

        return ResponseDTO.success(postMapper.toDTO(saved));
    }
}
