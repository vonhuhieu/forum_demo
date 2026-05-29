package com.forum.config;

import org.springframework.boot.CommandLineRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Component
public class DatabaseSchemaPatcher implements CommandLineRunner {

    private final JdbcTemplate jdbcTemplate;

    public DatabaseSchemaPatcher(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public void run(String... args) {
        try {
            jdbcTemplate.execute("ALTER TABLE notifications MODIFY COLUMN type VARCHAR(50)");
            System.out.println(">>> Database schema patched: notifications.type modified to VARCHAR(50) successfully.");
        } catch (Exception e) {
            System.err.println(">>> Failed to patch database schema: " + e.getMessage());
        }
    }
}
