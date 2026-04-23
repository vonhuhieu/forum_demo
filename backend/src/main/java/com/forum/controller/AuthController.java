package com.forum.controller;

import com.forum.entity.User;
import com.forum.repository.UserRepository;
import com.forum.security.JwtUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtils jwtUtils;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> loginRequest) {
        // ... giữ nguyên code login cũ ...
        String username = loginRequest.get("username");
        String password = loginRequest.get("password");

        return userRepository.findByUsername(username)
                .filter(user -> passwordEncoder.matches(password, user.getPassword()))
                .map(user -> {
                    String token = jwtUtils.generateJwtToken(username);
                    return ResponseEntity.ok(Map.of(
                            "token", token,
                            "username", username,
                            "roles", user.getRoles()
                    ));
                })
                .orElse(ResponseEntity.status(401).body(Map.of("message", "Sai tài khoản hoặc mật khẩu")));
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody Map<String, String> registerRequest) {
        String username = registerRequest.get("username");
        String password = registerRequest.get("password");

        if (userRepository.findByUsername(username).isPresent()) {
            return ResponseEntity.badRequest().body(Map.of("message", "Tên đăng nhập đã tồn tại"));
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(passwordEncoder.encode(password));
        user.setRoles(java.util.Set.of("ROLE_USER"));
        userRepository.save(user);

        return ResponseEntity.ok(Map.of("message", "Đăng ký thành công"));
    }
}
