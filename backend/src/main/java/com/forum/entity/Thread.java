package com.forum.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "threads")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Thread {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String content;

    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category;

    @ManyToOne
    @JoinColumn(name = "label_id")
    private Label label;

    @ManyToOne
    @JoinColumn(name = "author_id")
    private User author;

    @CreationTimestamp
    private LocalDateTime createdAt;

    private LocalDateTime lastPostAt;

    private int viewCount = 0;
    private int replyCount = 0;

    @PrePersist
    protected void onCreate() {
        if (this.lastPostAt == null) {
            this.lastPostAt = LocalDateTime.now();
        }
    }

    private boolean pinned = false;
    private boolean active = true;

    @OneToOne(mappedBy = "thread", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Poll poll;

    @Column(columnDefinition = "TEXT")
    private String attachedImages; // JSON string of images

    @OneToMany(mappedBy = "thread", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Post> posts;
}
