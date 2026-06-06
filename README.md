---
title: Forum Demo Backend Deploy
emoji: 💬
colorFrom: blue
colorTo: indigo
sdk: docker
pinned: false
app_port: 7860
---

# Forum Backend (Spring Boot)

Backend API cho dự án Forum được xây dựng bằng **Spring Boot** + **MySQL**.

## Công nghệ sử dụng

- Java 17 + Spring Boot 3
- Spring Security + JWT
- MySQL Database
- WebSocket (STOMP)
- Maven

## Biến môi trường cần thiết

| Biến | Mô tả |
|------|-------|
| `SPRING_DATASOURCE_URL` | JDBC URL kết nối MySQL |
| `SPRING_DATASOURCE_USERNAME` | Username database |
| `SPRING_DATASOURCE_PASSWORD` | Password database |
| `JWT_SECRET` | Secret key cho JWT |
| `ALLOWED_ORIGINS` | URL frontend được phép CORS |
