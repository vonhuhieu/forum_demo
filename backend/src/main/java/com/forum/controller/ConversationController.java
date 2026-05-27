package com.forum.controller;

import com.forum.dto.ConversationCreateDTO;
import com.forum.dto.ConversationDTO;
import com.forum.dto.ResponseDTO;
import com.forum.service.ConversationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/conversations")
@RequiredArgsConstructor
public class ConversationController {

    private final ConversationService conversationService;

    @PostMapping
    public ResponseEntity<ResponseDTO<ConversationDTO>> createConversation(@RequestBody ConversationCreateDTO createDTO) {
        try {
            return ResponseEntity.ok(conversationService.createConversation(createDTO));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(ResponseDTO.fail(null));
        }
    }

    @GetMapping
    public ResponseEntity<ResponseDTO<List<ConversationDTO>>> getMyConversations() {
        return ResponseEntity.ok(conversationService.getMyConversations());
    }

    @GetMapping("/unread-count")
    public ResponseEntity<ResponseDTO<Long>> getMyUnreadCount() {
        return ResponseEntity.ok(conversationService.getMyUnreadCount());
    }

    @PutMapping("/read-all")
    public ResponseEntity<ResponseDTO<Void>> readAll() {
        return ResponseEntity.ok(conversationService.readAll());
    }
}
