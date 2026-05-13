package com.forum.controller;

import com.forum.dto.ResponseDTO;
import com.forum.service.ReactionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/reactions")
@RequiredArgsConstructor
public class ReactionController {

    private final ReactionService reactionService;

    @PostMapping("/threads/{id}")
    public ResponseEntity<ResponseDTO<Void>> reactToThread(@PathVariable Long id, @RequestParam Long iconId) {
        reactionService.reactToThread(id, iconId);
        return ResponseEntity.ok(ResponseDTO.success(null));
    }

    @DeleteMapping("/threads/{id}")
    public ResponseEntity<ResponseDTO<Void>> removeReactionFromThread(@PathVariable Long id) {
        reactionService.removeReactionFromThread(id);
        return ResponseEntity.ok(ResponseDTO.success(null));
    }

    @PostMapping("/posts/{id}")
    public ResponseEntity<ResponseDTO<Void>> reactToPost(@PathVariable Long id, @RequestParam Long iconId) {
        reactionService.reactToPost(id, iconId);
        return ResponseEntity.ok(ResponseDTO.success(null));
    }

    @DeleteMapping("/posts/{id}")
    public ResponseEntity<ResponseDTO<Void>> removeReactionFromPost(@PathVariable Long id) {
        reactionService.removeReactionFromPost(id);
        return ResponseEntity.ok(ResponseDTO.success(null));
    }
}
