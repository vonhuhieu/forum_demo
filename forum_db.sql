-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Apr 23, 2026 at 11:43 PM
-- Server version: 8.4.3
-- PHP Version: 8.3.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `forum_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` bigint NOT NULL,
  `active` bit(1) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `position_order` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `active`, `description`, `name`, `position_order`) VALUES
(1, b'1', 'Đây là chuyên mục về bóng đá', 'Bóng đá', 1);

-- --------------------------------------------------------

--
-- Table structure for table `menus`
--

CREATE TABLE `menus` (
  `id` bigint NOT NULL,
  `active` bit(1) NOT NULL,
  `position_order` int DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `menus`
--

INSERT INTO `menus` (`id`, `active`, `position_order`, `title`, `url`) VALUES
(1, b'1', 1, 'Trang nhất', '/trang-chu');

-- --------------------------------------------------------

--
-- Table structure for table `threads`
--

CREATE TABLE `threads` (
  `id` bigint NOT NULL,
  `active` bit(1) NOT NULL,
  `content` text,
  `created_at` datetime(6) DEFAULT NULL,
  `pinned` bit(1) NOT NULL,
  `reply_count` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `view_count` int NOT NULL,
  `author_id` bigint DEFAULT NULL,
  `category_id` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `threads`
--

INSERT INTO `threads` (`id`, `active`, `content`, `created_at`, `pinned`, `reply_count`, `title`, `view_count`, `author_id`, `category_id`) VALUES
(1, b'1', 'Fabregas lọt top 5 ứng viên thay Rosenior ở Chelsea', '2026-04-23 16:10:27.927318', b'0', 0, 'Fabregas lọt top 5 ứng viên thay Rosenior ở Chelsea', 1, 1, 1),
(2, b'1', '<h3><strong>Sau vòng 32 La Liga: Ngả mũ trước Hansi Flick</strong></h3><p><em>Thứ năm, 23/04/2026 22:36</em></p><p><a href=\"http://www.bongdaso66.net/Sau-v%c3%b2ng-32-La-Liga-Ng%e1%ba%a3-m%c5%a9-tr%c6%b0%e1%bb%9bc-Hansi-Flick-_Art_281781.aspx#comments\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(101, 33, 80);\"><strong><em>Phản hồi, bình luận về bài viết: 0</em></strong></a></p><p>Đánh giá&nbsp;<img src=\"http://www.bongdaso66.net/img/stars-0-0.gif\"></p><p><a href=\"http://www.facebook.com/sharer.php?u=http://bongdaso66.net/art_281781.aspx\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(101, 33, 80);\"><img src=\"http://www.bongdaso66.net/img/facebook.png\" alt=\"Facebook\"></a>&nbsp;<a href=\"http://twitter.com/home?status=http://bongdaso66.net/art_281781.aspx\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(101, 33, 80);\"><img src=\"http://www.bongdaso66.net/img/twitter.png\" alt=\"Twitter\"></a>&nbsp;<a href=\"https://plus.google.com/share?url=http://bongdaso66.net/art_281781.aspx\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(101, 33, 80);\"><img src=\"http://www.bongdaso66.net/img/gplus.png\" alt=\"Google\"></a>&nbsp;<a href=\"http://www.tumblr.com/share?v=3&amp;u=bongdaso66.net/art_281781.aspx\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(101, 33, 80);\"><img src=\"http://www.bongdaso66.net/img/tumblr.png\" alt=\"Myspace\"></a></p><h5><strong>HLV Hansi Flick đã góp phần giúp Barcelona lập thành tích sân nhà có 1 không 2 tại 5 giải VĐQG hàng đầu châu Âu mùa 2025-26, đồng thời tạo nên kì tích trong lịch sử đội bóng xứ Catalan sau chiến thắng nhọc nhằn trước Celta Vigo.</strong></h5><p class=\"ql-align-center\"><em><img src=\"https://media.gettyimages.com/id/2272621752/photo/barcelona-spain-lamine-yamal-of-fc-barcelona-leaves-the-pitch-injured-during-the-laliga-ea.jpg?s=612x612&amp;w=0&amp;k=20&amp;c=d2_lWaPsPbchcl-IPYCdiHNHZmiI9EGvbvROe3GwSaA=\"></em></p><p class=\"ql-align-right\"><br></p>', '2026-04-23 23:07:08.661598', b'1', 0, 'tewsst', 1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint NOT NULL,
  `password` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `password`, `username`) VALUES
(1, '$2a$10$9ijOKopSb6/uK3Z.ZGsrcuNOf4F16p8FDO0llFVLobiCOn5q9I2o.', 'admin'),
(2, '$2a$10$jAk/ZlViZS5D3VYASEplYurbzK0lLmhwKe66h/wzwtYPz3hsFs8Ty', 'user01'),
(3, '$2a$10$i52hSXKbS4RqeYimw7xAHu4YXFtxLAg5zGKkPHC37PVeG.EtWpZk2', 'tester');

-- --------------------------------------------------------

--
-- Table structure for table `user_roles`
--

CREATE TABLE `user_roles` (
  `user_id` bigint NOT NULL,
  `role` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `user_roles`
--

INSERT INTO `user_roles` (`user_id`, `role`) VALUES
(1, 'ROLE_ADMIN'),
(2, 'ROLE_USER'),
(3, 'ROLE_USER');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `menus`
--
ALTER TABLE `menus`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `threads`
--
ALTER TABLE `threads`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK7n8uiua8ljj5dwubk7wxlm9d0` (`author_id`),
  ADD KEY `FKnxv40ka4vbktf3ab4pl4m9lvx` (`category_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UK_r43af9ap4edm43mmtq01oddj6` (`username`);

--
-- Indexes for table `user_roles`
--
ALTER TABLE `user_roles`
  ADD KEY `FKhfh9dx7w3ubf1co1vdev94g3f` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `menus`
--
ALTER TABLE `menus`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `threads`
--
ALTER TABLE `threads`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `threads`
--
ALTER TABLE `threads`
  ADD CONSTRAINT `FK7n8uiua8ljj5dwubk7wxlm9d0` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `FKnxv40ka4vbktf3ab4pl4m9lvx` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);

--
-- Constraints for table `user_roles`
--
ALTER TABLE `user_roles`
  ADD CONSTRAINT `FKhfh9dx7w3ubf1co1vdev94g3f` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
