package com.forum.controller;

import com.forum.dto.ResponseDTO;
import com.forum.dto.UserDTO;
import com.forum.entity.User;
import com.forum.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.text.Normalizer;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserRepository userRepository;

    @GetMapping("/search")
    public ResponseEntity<ResponseDTO<Page<UserDTO>>> searchUsers(
            @RequestParam(required = false, defaultValue = "") String keyword,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        try {
            // Trim keyword as requested by the user
            String trimmedKeyword = keyword != null ? keyword.trim() : "";
            String cleanKeyword = removeDiacritics(trimmedKeyword);

            // Get current logged-in username to exclude from autocomplete
            String currentUsername = null;
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null && auth.getPrincipal() instanceof String) {
                currentUsername = (String) auth.getPrincipal();
            }

            List<User> allUsers = userRepository.findAll();
            List<UserDTO> matchedUsers = new ArrayList<>();

            for (User user : allUsers) {
                // Exclude current logged in user
                if (currentUsername != null && currentUsername.equalsIgnoreCase(user.getUsername())) {
                    continue;
                }

                String displayName = user.getDisplayName() != null ? user.getDisplayName() : "";
                String username = user.getUsername() != null ? user.getUsername() : "";

                String normDisplayName = removeDiacritics(displayName);
                String normUsername = removeDiacritics(username);

                if (cleanKeyword.isEmpty() || normDisplayName.contains(cleanKeyword) || normUsername.contains(cleanKeyword)) {
                    UserDTO dto = new UserDTO();
                    dto.setId(user.getId());
                    dto.setUsername(user.getUsername());
                    dto.setDisplayName(user.getDisplayName());
                    dto.setEmail(user.getEmail());
                    dto.setAvatar(user.getAvatar());
                    matchedUsers.add(dto);
                }
            }

            // Paginate in memory
            Pageable pageable = PageRequest.of(page, size);
            int start = Math.min((int) pageable.getOffset(), matchedUsers.size());
            int end = Math.min((start + pageable.getPageSize()), matchedUsers.size());
            List<UserDTO> paginatedList = matchedUsers.subList(start, end);
            Page<UserDTO> pageResult = new PageImpl<>(paginatedList, pageable, matchedUsers.size());

            return ResponseEntity.ok(ResponseDTO.success(pageResult));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ResponseDTO.fail(null));
        }
    }

    private static String removeDiacritics(String str) {
        if (str == null) {
            return "";
        }
        String nfdNormalizedString = Normalizer.normalize(str, Normalizer.Form.NFD);
        Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
        String result = pattern.matcher(nfdNormalizedString).replaceAll("");
        // Normalize specific Vietnamese letters like 'đ'
        result = result.replace('đ', 'd').replace('Đ', 'D');
        return result.toLowerCase();
    }
}
