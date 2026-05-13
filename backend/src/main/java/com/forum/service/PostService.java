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
    private final ReactionService reactionService;

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

        PostDTO resultDto = postMapper.toDTO(saved);
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
