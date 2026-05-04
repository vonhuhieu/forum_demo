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

    public boolean registerUser(String username, String password, String email) {
        if (userRepository.findByUsername(username).isPresent()) {
            return false;
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(passwordEncoder.encode(password));
        user.setEmail(email);
        user.setRoles(Set.of(Constants.ROLE_USER));
        user.setAvatar(getRandomColor());
        userRepository.save(user);

        return true;
    }
}
