package com.forum.controller;

import com.forum.dto.ReactionIconDTO;
import com.forum.dto.ResponseDTO;
import com.forum.service.ReactionIconService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reaction-icons")
@RequiredArgsConstructor
public class ReactionIconController {

    private final ReactionIconService reactionIconService;

    @GetMapping
    public ResponseEntity<ResponseDTO<List<ReactionIconDTO>>> getAllIcons() {
        return ResponseEntity.ok(reactionIconService.getAllIcons());
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ResponseDTO<ReactionIconDTO>> createIcon(@RequestBody ReactionIconDTO dto) {
        return ResponseEntity.ok(reactionIconService.createIcon(dto));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ResponseDTO<ReactionIconDTO>> updateIcon(@PathVariable Long id, @RequestBody ReactionIconDTO dto) {
        return ResponseEntity.ok(reactionIconService.updateIcon(id, dto));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ResponseDTO<Void>> deleteIcon(@PathVariable Long id) {
        return ResponseEntity.ok(reactionIconService.deleteIcon(id));
    }
}
