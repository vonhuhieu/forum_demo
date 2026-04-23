package com.forum.controller;

import com.forum.entity.Thread;
import com.forum.repository.ThreadRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/threads")
public class ThreadController {

    @Autowired
    private ThreadRepository threadRepository;

    @GetMapping
    public List<Thread> getAllThreads(@RequestParam(required = false) Long categoryId) {
        if (categoryId != null) {
            return threadRepository.findAllByCategoryIdOrderByPinnedDescCreatedAtDesc(categoryId);
        }
        return threadRepository.findAllByOrderByCreatedAtDesc();
    }

    @Autowired
    private com.forum.repository.UserRepository userRepository;

    @PostMapping
    public Thread createThread(@RequestBody Thread thread) {
        // Tạm thời gán author là admin (ID: 1)
        userRepository.findById(1L).ifPresent(thread::setAuthor);
        return threadRepository.save(thread);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteThread(@PathVariable Long id) {
        return threadRepository.findById(id).map(thread -> {
            threadRepository.delete(thread);
            return ResponseEntity.ok().<Void>build();
        }).orElse(ResponseEntity.notFound().build());
    }

    @PatchMapping("/{id}/pin")
    public ResponseEntity<Thread> togglePin(@PathVariable Long id) {
        return threadRepository.findById(id).map(thread -> {
            thread.setPinned(!thread.isPinned());
            return ResponseEntity.ok(threadRepository.save(thread));
        }).orElse(ResponseEntity.notFound().build());
    }
}
