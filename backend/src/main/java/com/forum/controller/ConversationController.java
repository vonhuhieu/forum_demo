package com.forum.controller;

import com.forum.dto.ConversationCreateDTO;
import com.forum.dto.ConversationDTO;
import com.forum.dto.ConversationDetailDTO;
import com.forum.dto.ConversationMessageDTO;
import com.forum.dto.ResponseDTO;
import com.forum.service.ConversationService;
import java.util.Map;
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
            return ResponseEntity.badRequest().body(ResponseDTO.fail(null, e.getMessage()));
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

    @GetMapping("/{id}")
    public ResponseEntity<ResponseDTO<ConversationDetailDTO>> getConversationDetail(@PathVariable Long id) {
        try {
            return ResponseEntity.ok(conversationService.getConversationDetail(id));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(ResponseDTO.fail(null, e.getMessage()));
        }
    }

    @PostMapping("/{id}/messages")
    public ResponseEntity<ResponseDTO<ConversationMessageDTO>> addMessage(@PathVariable Long id, @RequestBody Map<String, String> payload) {
        try {
            String content = payload.get("content");
            if (content == null || content.trim().isEmpty()) {
                throw new IllegalArgumentException("Nội dung tin nhắn không được để trống");
            }
            return ResponseEntity.ok(conversationService.addMessage(id, content));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(ResponseDTO.fail(null, e.getMessage()));
        }
    }
}
