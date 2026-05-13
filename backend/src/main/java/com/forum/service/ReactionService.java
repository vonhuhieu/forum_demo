package com.forum.service;

import com.forum.dto.ReactionIconDTO;
import com.forum.dto.ReactionSummaryDTO;
import com.forum.entity.*;
import com.forum.entity.Thread;
import com.forum.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
@RequiredArgsConstructor
public class ReactionService {

    private final ReactionRepository reactionRepository;
    private final ReactionIconRepository reactionIconRepository;
    private final ThreadRepository threadRepository;
    private final PostRepository postRepository;
    private final UserRepository userRepository;
    private final ReactionIconService reactionIconService;

    private Optional<User> getCurrentUser() {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof String && !principal.equals("anonymousUser")) {
            return userRepository.findByUsername((String) principal);
        }
        return Optional.empty();
    }

    public void reactToThread(Long threadId, Long iconId) {
        User currentUser = getCurrentUser().orElseThrow(() -> new RuntimeException("Authentication required"));
        Thread thread = threadRepository.findById(threadId)
                .orElseThrow(() -> new RuntimeException("Thread not found"));
        ReactionIcon icon = reactionIconRepository.findById(iconId)
                .orElseThrow(() -> new RuntimeException("Reaction icon not found"));

        // Check and hide if author reacts to self
        if (thread.getAuthor() != null && thread.getAuthor().getId().equals(currentUser.getId())) {
            throw new RuntimeException("You cannot react to your own content");
        }

        // UPSERT logic: Check for existing reaction by this user on this thread
        Optional<Reaction> existing = reactionRepository.findByUserIdAndThreadId(currentUser.getId(), threadId);
        if (existing.isPresent()) {
            Reaction reaction = existing.get();
            reaction.setReactionIcon(icon);
            reactionRepository.save(reaction);
        } else {
            Reaction newReaction = new Reaction();
            newReaction.setUser(currentUser);
            newReaction.setThread(thread);
            newReaction.setReactionIcon(icon);
            reactionRepository.save(newReaction);
        }
    }

    public void reactToPost(Long postId, Long iconId) {
        User currentUser = getCurrentUser().orElseThrow(() -> new RuntimeException("Authentication required"));
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("Post not found"));
        ReactionIcon icon = reactionIconRepository.findById(iconId)
                .orElseThrow(() -> new RuntimeException("Reaction icon not found"));

        // Check and hide if author reacts to self
        if (post.getAuthor() != null && post.getAuthor().getId().equals(currentUser.getId())) {
            throw new RuntimeException("You cannot react to your own content");
        }

        // UPSERT logic: Check for existing reaction by this user on this post
        Optional<Reaction> existing = reactionRepository.findByUserIdAndPostId(currentUser.getId(), postId);
        if (existing.isPresent()) {
            Reaction reaction = existing.get();
            reaction.setReactionIcon(icon);
            reactionRepository.save(reaction);
        } else {
            Reaction newReaction = new Reaction();
            newReaction.setUser(currentUser);
            newReaction.setPost(post);
            newReaction.setReactionIcon(icon);
            reactionRepository.save(newReaction);
        }
    }

    public void removeReactionFromThread(Long threadId) {
        User currentUser = getCurrentUser().orElseThrow(() -> new RuntimeException("Authentication required"));
        reactionRepository.deleteByUserIdAndThreadId(currentUser.getId(), threadId);
    }

    public void removeReactionFromPost(Long postId) {
        User currentUser = getCurrentUser().orElseThrow(() -> new RuntimeException("Authentication required"));
        reactionRepository.deleteByUserIdAndPostId(currentUser.getId(), postId);
    }

    public List<ReactionSummaryDTO> getSummaryForThread(Long threadId) {
        List<Object[]> results = reactionRepository.aggregateByThreadId(threadId);
        return mapAggregateResults(results);
    }

    public List<ReactionSummaryDTO> getSummaryForPost(Long postId) {
        List<Object[]> results = reactionRepository.aggregateByPostId(postId);
        return mapAggregateResults(results);
    }

    public ReactionIconDTO getCurrentUserReactionForThread(Long threadId) {
        return getCurrentUser().flatMap(user -> 
            reactionRepository.findByUserIdAndThreadId(user.getId(), threadId)
                    .map(Reaction::getReactionIcon)
                    .map(reactionIconService::convertToDTO)
        ).orElse(null);
    }

    public ReactionIconDTO getCurrentUserReactionForPost(Long postId) {
        return getCurrentUser().flatMap(user -> 
            reactionRepository.findByUserIdAndPostId(user.getId(), postId)
                    .map(Reaction::getReactionIcon)
                    .map(reactionIconService::convertToDTO)
        ).orElse(null);
    }

    private List<ReactionSummaryDTO> mapAggregateResults(List<Object[]> results) {
        List<ReactionSummaryDTO> summaries = new ArrayList<>();
        if (results == null) return summaries;
        
        for (Object[] row : results) {
            if (row != null && row.length == 3) {
                ReactionIcon icon = (ReactionIcon) row[0];
                Long count = (Long) row[1];
                java.time.LocalDateTime latestTime = (java.time.LocalDateTime) row[2];
                summaries.add(new ReactionSummaryDTO(reactionIconService.convertToDTO(icon), count, latestTime));
            }
        }
        return summaries;
    }

    private com.forum.dto.UserDTO mapUserToDTO(User user) {
        if (user == null) return null;
        com.forum.dto.UserDTO dto = new com.forum.dto.UserDTO();
        dto.setId(user.getId());
        dto.setUsername(user.getUsername());
        dto.setDisplayName(user.getDisplayName());
        dto.setEmail(user.getEmail());
        dto.setAvatar(user.getAvatar());
        return dto;
    }

    public List<com.forum.dto.UserDTO> getRecentReactorsForThread(Long threadId) {
        List<Reaction> reactions = reactionRepository.findTop3ByThreadIdOrderByUpdatedAtDesc(threadId);
        return reactions.stream()
                .map(Reaction::getUser)
                .map(this::mapUserToDTO)
                .collect(java.util.stream.Collectors.toList());
    }

    public List<com.forum.dto.UserDTO> getRecentReactorsForPost(Long postId) {
        List<Reaction> reactions = reactionRepository.findTop3ByPostIdOrderByUpdatedAtDesc(postId);
        return reactions.stream()
                .map(Reaction::getUser)
                .map(this::mapUserToDTO)
                .collect(java.util.stream.Collectors.toList());
    }
}
