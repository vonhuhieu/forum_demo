package com.forum.config;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class DataBackfillRunner implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(DataBackfillRunner.class);
    private final JdbcTemplate jdbcTemplate;

    @Override
    public void run(String... args) {
        try {
            log.info("Đang khởi chạy tiến trình bù dữ liệu cho cột last_post_at...");
            
            // 1. Đồng bộ giá trị mặc định cho các bài viết cũ chưa có giá trị
            String updateFromCreatedAt = "UPDATE threads SET last_post_at = created_at WHERE last_post_at IS NULL";
            int rowsInit = jdbcTemplate.update(updateFromCreatedAt);
            
            // 2. Cập nhật lại theo thời gian của bình luận/phản hồi mới nhất (nếu có)
            String updateFromPosts = "UPDATE threads t " +
                    "JOIN (SELECT thread_id, MAX(created_at) as max_date FROM posts GROUP BY thread_id) p " +
                    "ON t.id = p.thread_id " +
                    "SET t.last_post_at = p.max_date " +
                    "WHERE p.max_date > t.last_post_at";
            int rowsRefined = jdbcTemplate.update(updateFromPosts);
            
            log.info("Hoàn tất bù dữ liệu. Khởi tạo {} dòng và cập nhật refine {} dòng.", rowsInit, rowsRefined);
        } catch (Exception e) {
            log.warn("Không thể thực hiện bù dữ liệu (có thể cột chưa sẵn sàng): {}", e.getMessage());
        }
    }
}
