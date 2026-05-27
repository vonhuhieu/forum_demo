package com.forum.controller;

import com.forum.dto.LabelDTO;
import com.forum.dto.ResponseDTO;
import com.forum.service.LabelService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/labels")
@RequiredArgsConstructor
public class LabelController {

    private final LabelService labelService;

    @GetMapping
    public ResponseEntity<ResponseDTO<List<LabelDTO>>> getAllLabels() {
        return ResponseEntity.ok(labelService.getAllLabels());
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPER_ADMIN')")
    public ResponseEntity<ResponseDTO<LabelDTO>> createLabel(@RequestBody LabelDTO dto) {
        return ResponseEntity.ok(labelService.createLabel(dto));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPER_ADMIN')")
    public ResponseEntity<ResponseDTO<LabelDTO>> updateLabel(@PathVariable Long id, @RequestBody LabelDTO dto) {
        return ResponseEntity.ok(labelService.updateLabel(id, dto));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPER_ADMIN')")
    public ResponseEntity<ResponseDTO<Void>> deleteLabel(@PathVariable Long id) {
        return ResponseEntity.ok(labelService.deleteLabel(id));
    }
}
