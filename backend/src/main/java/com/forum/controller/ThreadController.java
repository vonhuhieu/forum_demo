package com.forum.controller;

import com.forum.dto.ResponseDTO;
import com.forum.dto.ThreadDTO;
import com.forum.service.ThreadService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/threads")
@RequiredArgsConstructor
public class ThreadController {

    private final ThreadService threadService;

    @GetMapping
    public ResponseEntity<ResponseDTO<List<ThreadDTO>>> getAllThreads(@RequestParam(required = false) Long categoryId) {
        return ResponseEntity.ok(threadService.getAllThreads(categoryId));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ResponseDTO<ThreadDTO>> getThreadById(@PathVariable Long id) {
        try {
            return ResponseEntity.ok(threadService.getThreadById(id));
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @PostMapping
    public ResponseEntity<ResponseDTO<ThreadDTO>> createThread(@RequestBody ThreadDTO threadDTO) {
        return ResponseEntity.ok(threadService.createThread(threadDTO));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ResponseDTO<ThreadDTO>> updateThread(@PathVariable Long id, @RequestBody ThreadDTO threadDTO) {
        try {
            return ResponseEntity.ok(threadService.updateThread(id, threadDTO));
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ResponseDTO<Void>> deleteThread(@PathVariable Long id) {
        try {
            return ResponseEntity.ok(threadService.deleteThread(id));
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @PatchMapping("/{id}/pin")
    public ResponseEntity<ResponseDTO<ThreadDTO>> togglePin(@PathVariable Long id) {
        try {
            return ResponseEntity.ok(threadService.togglePin(id));
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
}
