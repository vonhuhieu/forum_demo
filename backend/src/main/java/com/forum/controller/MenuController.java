package com.forum.controller;

import com.forum.entity.Menu;
import com.forum.repository.MenuRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/menus")
@CrossOrigin(origins = "*") // Tạm thời cho phép tất cả các nguồn để test
public class MenuController {

    @Autowired
    private MenuRepository menuRepository;

    @GetMapping
    public List<Menu> getAllMenus() {
        return menuRepository.findAllByOrderByPositionOrderAsc();
    }

    @PostMapping
    public Menu createMenu(@RequestBody Menu menu) {
        return menuRepository.save(menu);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Menu> updateMenu(@PathVariable Long id, @RequestBody Menu menuDetails) {
        return menuRepository.findById(id).map(menu -> {
            menu.setTitle(menuDetails.getTitle());
            menu.setUrl(menuDetails.getUrl());
            menu.setPositionOrder(menuDetails.getPositionOrder());
            menu.setActive(menuDetails.isActive());
            return ResponseEntity.ok(menuRepository.save(menu));
        }).orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteMenu(@PathVariable Long id) {
        return menuRepository.findById(id).map(menu -> {
            menuRepository.delete(menu);
            return ResponseEntity.ok().<Void>build();
        }).orElse(ResponseEntity.notFound().build());
    }
}
