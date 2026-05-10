package com.forum.controller;

import com.forum.dto.PostDTO;
import com.forum.dto.ResponseDTO;
import com.forum.service.PostService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/posts")
@RequiredArgsConstructor
public class PostController {

    private final PostService postService;

    @GetMapping("/thread/{threadId}")
    public ResponseEntity<ResponseDTO<List<PostDTO>>> getPostsByThread(@PathVariable Long threadId) {
        return ResponseEntity.ok(postService.getPostsByThread(threadId));
    }

    @PostMapping
    public ResponseEntity<ResponseDTO<PostDTO>> createPost(@RequestBody PostDTO postDTO) {
        try {
            return ResponseEntity.ok(postService.createPost(postDTO));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }
}
