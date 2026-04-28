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

    public Map<String, Object> authenticateUser(String username, String password) {
        Optional<User> userOpt = userRepository.findByUsername(username)
                .filter(user -> passwordEncoder.matches(password, user.getPassword()));

        if (userOpt.isPresent()) {
            User user = userOpt.get();
            String token = jwtUtils.generateJwtToken(username);
            return Map.of(
                    "token", token,
                    "username", username,
                    "roles", user.getRoles()
            );
        }
        return null;
    }

    public boolean registerUser(String username, String password) {
        if (userRepository.findByUsername(username).isPresent()) {
            return false;
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(passwordEncoder.encode(password));
        user.setRoles(Set.of(Constants.ROLE_USER));
        userRepository.save(user);

        return true;
    }
}
