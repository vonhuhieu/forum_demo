package com.forum.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(
    name = "reactions",
    uniqueConstraints = {
        @UniqueConstraint(name = "uq_user_thread_reaction", columnNames = {"user_id", "thread_id"}),
        @UniqueConstraint(name = "uq_user_post_reaction", columnNames = {"user_id", "post_id"})
    }
)
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Reaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(optional = false)
    @JoinColumn(name = "reaction_icon_id", nullable = false)
    private ReactionIcon reactionIcon;

    @ManyToOne
    @JoinColumn(name = "thread_id")
    private Thread thread; // Nullable, only filled if reacting to main thread post

    @ManyToOne
    @JoinColumn(name = "post_id")
    private Post post; // Nullable, only filled if reacting to reply post

    @CreationTimestamp
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;
}
