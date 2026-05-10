package com.forum.service;

import com.forum.entity.User;
import com.forum.repository.UserRepository;
import com.forum.security.JwtUtils;
import com.forum.utils.Constants;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.Random;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.SimpleMailMessage;

@Service
public class AuthService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtils jwtUtils;

    private static final String[] AVATAR_COLORS = {
            "#f44336", "#e91e63", "#9c27b0", "#673ab7", "#3f51b5",
            "#2196f3", "#03a9f4", "#00bcd4", "#009688", "#4caf50",
            "#8bc34a", "#cddc39", "#ffc107", "#ff9800", "#ff5722",
            "#795548", "#607d8b"
    };

    public Map<String, Object> authenticateUser(String username, String password) {
        Optional<User> userOpt = userRepository.findByUsername(username)
                .filter(user -> passwordEncoder.matches(password, user.getPassword()));

        if (userOpt.isPresent()) {
            User user = userOpt.get();
            
            // Generate avatar for existing users if missing
            if (user.getAvatar() == null) {
                user.setAvatar(getRandomColor());
                userRepository.save(user);
            }

            String token = jwtUtils.generateJwtToken(username);
            return Map.of(
                    "id", user.getId(),
                    "token", token,
                    "username", username,
                    "roles", user.getRoles(),
                    "avatar", user.getAvatar()
            );
        }
        return null;
    }

    private String getRandomColor() {
        int index = (int) (Math.random() * AVATAR_COLORS.length);
        return AVATAR_COLORS[index];
    }

    public void registerUser(String username, String password, String email) {
        if (userRepository.findByUsername(username).isPresent()) {
            throw new IllegalArgumentException("Tên đăng nhập đã tồn tại");
        }
        if (userRepository.findFirstByEmail(email).isPresent()) {
            throw new IllegalArgumentException("Email đã được sử dụng");
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(passwordEncoder.encode(password));
        user.setEmail(email);
        user.setRoles(Set.of(Constants.ROLE_USER));
        user.setAvatar(getRandomColor());
        userRepository.save(user);
    }

    @Autowired(required = false)
    private JavaMailSender mailSender;

    public void generatePasswordResetCode(String email) {
        Optional<User> userOpt = userRepository.findFirstByEmail(email);
        if (userOpt.isEmpty()) {
            throw new IllegalArgumentException("Email không tồn tại trong hệ thống");
        }

        User user = userOpt.get();
        String code = String.format("%06d", new Random().nextInt(999999));
        user.setResetCode(code);
        user.setResetCodeExpiry(java.time.LocalDateTime.now().plusMinutes(15));
        userRepository.save(user);

        System.out.println("Mã reset mật khẩu cho email " + email + " là: " + code);

        if (mailSender != null) {
            try {
                SimpleMailMessage message = new SimpleMailMessage();
                message.setTo(email);
                message.setSubject("Mã xác nhận lấy lại mật khẩu - Diễn đàn");
                message.setText("Mã xác nhận của bạn là: " + code + "\nMã này sẽ hết hạn sau 15 phút.");
                mailSender.send(message);
            } catch (Exception e) {
                System.out.println("Lỗi gửi email: " + e.getMessage());
                // Khong throw exception de van log code ra console cho muc dich test
            }
        }
    }

    public void resetPasswordWithCode(String email, String code, String newPassword) {
        Optional<User> userOpt = userRepository.findFirstByEmail(email);
        if (userOpt.isEmpty()) {
            throw new IllegalArgumentException("Email không tồn tại trong hệ thống");
        }

        User user = userOpt.get();
        if (user.getResetCode() == null || !user.getResetCode().equals(code)) {
            throw new IllegalArgumentException("Mã xác nhận không chính xác");
        }

        if (user.getResetCodeExpiry() == null || user.getResetCodeExpiry().isBefore(java.time.LocalDateTime.now())) {
            throw new IllegalArgumentException("Mã xác nhận đã hết hạn");
        }

        user.setPassword(passwordEncoder.encode(newPassword));
        user.setResetCode(null);
        user.setResetCodeExpiry(null);
        userRepository.save(user);
    }
}
