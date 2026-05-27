package com.forum.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.filter.CorsFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private JwtAuthenticationFilter jwtAuthenticationFilter;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/auth/**").permitAll()
                .requestMatchers(org.springframework.http.HttpMethod.GET, "/api/menus", "/api/menus/**").permitAll() 
                .requestMatchers(org.springframework.http.HttpMethod.GET, "/api/statistics", "/api/statistics/**").permitAll() // Cho phép công khai xem thống kê diễn đàn
                .requestMatchers("/uploads/**").permitAll()
                .requestMatchers("/ws/**").permitAll()
                // Cấu hình GET công khai
                .requestMatchers(org.springframework.http.HttpMethod.GET, "/api/categories", "/api/categories/**").permitAll()
                .requestMatchers(org.springframework.http.HttpMethod.GET, "/api/category-groups", "/api/category-groups/**").permitAll()
                .requestMatchers(org.springframework.http.HttpMethod.GET, "/api/threads", "/api/threads/**").permitAll()
                .requestMatchers(org.springframework.http.HttpMethod.GET, "/api/polls", "/api/polls/**").permitAll()
                .requestMatchers(org.springframework.http.HttpMethod.GET, "/api/labels", "/api/labels/**").permitAll()
                .requestMatchers(org.springframework.http.HttpMethod.GET, "/api/posts", "/api/posts/**").permitAll()
                .requestMatchers(org.springframework.http.HttpMethod.GET, "/api/reaction-icons", "/api/reaction-icons/**").permitAll()
                .requestMatchers(org.springframework.http.HttpMethod.GET, "/api/reactions", "/api/reactions/**").permitAll()
                // Cấu hình bảo vệ cho tác vụ ADMIN / SUPER_ADMIN
                .requestMatchers("/api/menus/**").hasAnyRole("ADMIN", "SUPER_ADMIN")
                .requestMatchers("/api/categories/**").hasAnyRole("ADMIN", "SUPER_ADMIN")
                .requestMatchers("/api/category-groups/**").hasAnyRole("ADMIN", "SUPER_ADMIN")
                .requestMatchers("/api/labels/**").hasAnyRole("ADMIN", "SUPER_ADMIN")
                .requestMatchers("/api/reaction-icons/**").hasAnyRole("ADMIN", "SUPER_ADMIN")
                .requestMatchers("/api/users/admin/**").hasAnyRole("ADMIN", "SUPER_ADMIN")
                // Còn lại yêu cầu đăng nhập và thuộc các nhóm quyền chính thức
                .anyRequest().hasAnyRole("USER", "ADMIN", "SUPER_ADMIN")
            )
            .addFilterBefore(jwtAuthenticationFilter, org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter.class);
        return http.build();
    }

    @Bean
    public CorsFilter corsFilter() {
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowCredentials(true);
        config.addAllowedOrigin("http://localhost:5173");
        config.addAllowedHeader("*");
        config.addAllowedMethod("*");
        source.registerCorsConfiguration("/**", config);
        return new CorsFilter(source);
    }
}
