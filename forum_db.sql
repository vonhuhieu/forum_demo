-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 06, 2026 at 08:12 AM
-- Server version: 8.4.3
-- PHP Version: 8.3.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET SESSION sql_require_primary_key = 0;
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
  `position_order` int DEFAULT NULL,
  `category_group_id` bigint DEFAULT NULL,
  `parent_id` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `active`, `description`, `name`, `position_order`, `category_group_id`, `parent_id`) VALUES
(4, b'1', '', 'Chuyện trò linh tinh', 1, 1, NULL),
(5, b'1', '', 'Lô đẹp hôm nay, Tip kèo Bong bánh', 2, 1, NULL),
(6, b'1', '', 'Chợ cóc', 1, 2, NULL),
(7, b'1', '', 'Bóc phốt nhà cái', 3, 1, NULL),
(8, b'1', '', 'Bác sĩ mạng', 4, 1, NULL),
(9, b'1', '', 'Lều báo Người Tối Cổ', 5, 1, NULL),
(10, b'1', '', 'Tư vấn tình cảm', 6, 1, NULL),
(11, b'1', '', 'Trẻ trâu bàn chuyện vĩ mô', 7, 1, NULL),
(12, b'1', '', 'Trại sáng tác', 8, 1, NULL),
(13, b'1', '', 'Check Var - Cháu là con nhà ai?', 9, 1, NULL),
(14, b'1', '', 'Ăn chơi miền nam', 10, 1, NULL),
(15, b'1', '', 'Ăn chơi miền bắc', 11, 1, NULL),
(16, b'1', '', 'Ăn chơi miền trung', 12, 1, NULL),
(17, b'1', '', 'Quán con sò say', 13, 1, NULL),
(18, b'1', '', 'Huyền học - 神秘', 14, 1, NULL),
(19, b'1', '', 'Ăn chơi hưởng thụ', 1, 1, 17),
(20, b'1', '', 'Loa phường', 1, 3, NULL),
(21, b'1', '', 'VIP (Pro Max)', 2, 3, NULL),
(22, b'1', '', 'MMO - Làm giàu không khó', 2, 2, NULL),
(23, b'1', '', 'Đầu tư Tiền ảo - Chứng khoán', 3, 2, NULL),
(24, b'1', '', 'Đầu trộm, đuôi cướp', 4, 2, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `category_groups`
--

CREATE TABLE `category_groups` (
  `id` bigint NOT NULL,
  `active` bit(1) NOT NULL,
  `name` varchar(255) NOT NULL,
  `position_order` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `category_groups`
--

INSERT INTO `category_groups` (`id`, `active`, `name`, `position_order`) VALUES
(1, b'1', 'XAM Entertainment', 1),
(2, b'1', 'XAM e-commerce', 2),
(3, b'1', 'Thông cáo', 3);

-- --------------------------------------------------------

--
-- Table structure for table `conversations`
--

CREATE TABLE `conversations` (
  `id` bigint NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `creator_id` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `conversations`
--

INSERT INTO `conversations` (`id`, `created_at`, `title`, `updated_at`, `creator_id`) VALUES
(3, '2026-05-27 23:23:28.020756', 'Hội thoại kiểm thử 2026-05-27T23:23:27.980Z', '2026-05-27 23:23:28.020756', NULL),
(4, '2026-05-27 23:24:26.480470', 'test hpopok ỵpaok', '2026-05-27 23:24:26.480470', NULL),
(5, '2026-05-27 23:27:13.023671', 'Hội thoại kiểm thử 2026-05-27T23:27:12.981Z', '2026-05-27 23:27:13.023671', NULL),
(6, '2026-05-27 23:30:03.679710', 'test hội thoại số 1', '2026-05-27 23:30:03.679710', NULL),
(7, '2026-05-27 23:33:58.009877', 'Hội thoại kiểm thử 2026-05-27T23:33:58.002Z', '2026-05-27 23:33:58.009877', NULL),
(8, '2026-05-28 12:14:29.360501', 'Test chức năng đối thoại', '2026-05-28 12:14:29.360501', NULL),
(9, '2026-05-28 12:15:54.456816', 'test đối thoại 1', '2026-05-28 12:15:54.456816', NULL),
(10, '2026-05-28 12:26:11.591652', 'test đối thoại 1', '2026-05-28 12:26:11.591652', NULL),
(11, '2026-05-28 12:33:06.573022', 'test 2', '2026-05-28 12:33:06.573022', NULL),
(12, '2026-05-28 16:25:47.462971', 'test user03 gửi user01', '2026-05-28 16:25:47.462971', NULL),
(13, '2026-05-28 16:42:07.989783', 'test', '2026-05-28 16:42:07.989783', NULL),
(14, '2026-05-28 16:46:08.781484', 'test', '2026-05-28 16:46:08.781484', NULL),
(15, '2026-05-28 16:48:57.014551', 'test lại', '2026-05-28 17:02:11.072414', NULL),
(16, '2026-05-28 17:10:38.012306', 'Xin chào', '2026-05-28 17:10:38.012306', NULL),
(17, '2026-05-28 18:11:38.121695', 'Gin chào Vy nhé', '2026-05-28 18:11:38.121695', NULL),
(18, '2026-05-28 18:16:33.770131', 'Hỏi thăm thường ngày', '2026-05-28 18:16:33.770131', NULL),
(19, '2026-05-28 18:33:31.833681', 'Hôm nay mẹ thế nào', '2026-05-28 18:33:31.833681', NULL),
(20, '2026-05-28 18:35:27.009285', 'Hôm nay của Vy thế nào', '2026-05-28 18:35:27.009285', NULL),
(21, '2026-05-28 18:38:35.114381', 'sdsd', '2026-05-28 18:38:35.114381', NULL),
(22, '2026-05-28 18:39:33.467461', 'shdjkahda', '2026-05-28 18:39:33.467461', NULL),
(23, '2026-05-28 18:41:29.897500', 'dsa', '2026-05-28 18:41:29.897500', NULL),
(24, '2026-05-28 18:42:03.310339', 'dsada', '2026-05-28 18:42:03.310339', NULL),
(25, '2026-05-28 18:42:23.522594', 'dá', '2026-05-28 18:42:23.522594', NULL),
(26, '2026-05-28 18:44:15.667061', 'dsa', '2026-05-28 18:44:15.667061', NULL),
(27, '2026-05-28 18:46:48.093391', 'dsa', '2026-05-28 18:46:48.093391', NULL),
(28, '2026-05-28 18:47:03.754955', 'dsad', '2026-05-28 18:47:03.754955', NULL),
(29, '2026-05-28 18:48:46.079345', 'sad', '2026-05-28 18:48:46.079345', NULL),
(30, '2026-05-28 18:54:06.394452', 'dsad', '2026-05-28 18:54:06.394452', NULL),
(31, '2026-05-28 18:55:14.718151', 'test', '2026-05-28 18:55:14.718151', NULL),
(32, '2026-05-28 19:01:41.732434', 'test 2', '2026-05-28 19:01:41.732434', NULL),
(33, '2026-05-28 19:02:33.764510', 'test 3', '2026-05-28 19:02:33.764510', NULL),
(34, '2026-05-28 19:03:19.443316', 'dsad', '2026-05-28 19:03:19.443316', NULL),
(35, '2026-05-28 19:03:40.757167', 'sda', '2026-05-28 19:03:40.757167', NULL),
(36, '2026-05-28 19:04:41.546025', 'đá', '2026-05-28 19:04:41.546025', NULL),
(37, '2026-05-28 19:06:55.043797', 'sdasdsadsad', '2026-05-28 19:06:55.043797', NULL),
(38, '2026-05-28 19:09:46.863252', 'test lại', '2026-05-28 19:09:46.863252', NULL),
(39, '2026-05-28 19:10:12.606567', 'test lkaij lần 2', '2026-05-28 19:10:12.606567', NULL),
(40, '2026-05-28 19:10:54.913640', 'đasa', '2026-05-28 19:10:54.913640', NULL),
(41, '2026-05-28 19:11:07.099974', 'đá', '2026-05-28 19:11:07.099974', NULL),
(42, '2026-05-28 23:26:27.226899', 'Hỏi về việc tách component trong VueJS', '2026-05-28 23:26:27.226899', NULL),
(43, '2026-06-01 03:02:03.779162', 'Test chức năng hội thoại lần I', '2026-06-01 03:02:03.824668', 96),
(44, '2026-06-01 03:03:18.413093', 'Test chức năng hội thoại lần I', '2026-06-01 03:03:18.430279', 96),
(45, '2026-06-01 03:11:37.174431', 'test chức năng đối thoại lần I', '2026-06-01 03:11:37.258537', 96),
(46, '2026-06-01 03:14:32.208395', 'Review cách tổ chức source VueJS', '2026-06-01 03:20:14.483019', 96);

-- --------------------------------------------------------

--
-- Table structure for table `conversation_messages`
--

CREATE TABLE `conversation_messages` (
  `id` bigint NOT NULL,
  `content` text NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `conversation_id` bigint NOT NULL,
  `sender_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `conversation_messages`
--

INSERT INTO `conversation_messages` (`id`, `content`, `created_at`, `conversation_id`, `sender_id`) VALUES
(44, '<p>test chức năng đối thoại lần I</p>', '2026-06-01 03:02:03.797812', 43, 96),
(45, '<h2 style=\"margin-left:0px;\">Test chức năng hội thoại lần I</h2>', '2026-06-01 03:03:18.425692', 44, 96),
(46, '<p>test chức năng đối thoại lần I</p>', '2026-06-01 03:11:37.233356', 45, 96),
(47, '<p>Mình đang refactor project VueJS nhưng càng tách component càng thấy rối. Muốn xin ý kiến mọi người về cách organize source code. Project mình hiện tại khoảng 40 component.</p>', '2026-06-01 03:14:32.215408', 46, 96),
(48, '<p>40 component thì chưa nhiều lắm đâu 😄</p>', '2026-06-01 03:14:58.255568', 46, 97),
(49, '<p>Nhưng mình thấy import rất mệt.</p>', '2026-06-01 03:15:11.509848', 46, 96),
(50, '<p>Bạn đang organize theo kiểu nào?</p>', '2026-06-01 03:16:05.770415', 46, 97),
(51, '<p>Theo pages với components thôi.</p>', '2026-06-01 03:16:27.834097', 46, 96),
(52, '<p>Có tách feature module chưa?</p>', '2026-06-01 03:17:14.220680', 46, 97),
(53, '<p>Chưa.</p>', '2026-06-01 03:17:20.115906', 46, 96),
(54, '<p>Nên thử đó.</p>', '2026-06-01 03:17:27.447115', 46, 97),
(55, '<p>Mình hơi sợ structure phức tạp quá.</p>', '2026-06-01 03:17:33.115936', 46, 96),
(56, '<blockquote><p><strong>user01 đã viết:</strong></p><p>Mình hơi sợ structure phức tạp quá.</p></blockquote><p>Lúc đầu ai cũng vậy 😄</p>', '2026-06-01 03:17:46.631363', 46, 97),
(57, '<p><span style=\"color:#2577b1;\"><strong>@user02</strong></span> Haha.</p>', '2026-06-01 03:18:45.872706', 46, 96),
(58, '<blockquote><p><strong>user02 đã viết:</strong></p><p>Lúc đầu ai cũng vậy 😄</p></blockquote><p>Nhưng project lớn dần sẽ thấy lợi.</p>', '2026-06-01 03:20:14.478509', 46, 97);

-- --------------------------------------------------------

--
-- Table structure for table `conversation_participants`
--

CREATE TABLE `conversation_participants` (
  `id` bigint NOT NULL,
  `is_read` bit(1) DEFAULT NULL,
  `conversation_id` bigint NOT NULL,
  `user_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `conversation_participants`
--

INSERT INTO `conversation_participants` (`id`, `is_read`, `conversation_id`, `user_id`) VALUES
(85, b'1', 43, 96),
(86, b'1', 43, 97),
(87, b'1', 44, 96),
(88, b'1', 44, 97),
(89, b'1', 45, 96),
(90, b'1', 45, 97),
(91, b'1', 46, 96),
(92, b'1', 46, 97);

-- --------------------------------------------------------

--
-- Table structure for table `labels`
--

CREATE TABLE `labels` (
  `id` bigint NOT NULL,
  `color_code` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `text_color` varchar(255) NOT NULL,
  `border_color` varchar(255) DEFAULT NULL,
  `admin_only` bit(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `labels`
--

INSERT INTO `labels` (`id`, `color_code`, `name`, `text_color`, `border_color`, `admin_only`) VALUES
(3, '#ffff91', 'Thời sự', '#000', '#e6e687', b'0'),
(6, '#7cc3e0', 'Kiến thức', '#fff', '#53b0d6', b'0'),
(7, '#008000', 'Có video', '#fff', '#004d00', b'0'),
(8, '#4169e1', 'Có ảnh', '#fff', '#214cce', b'0'),
(9, '#ffff91', 'Video + ảnh', '#000', '#e6e687', b'0');

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
(1, b'1', 1, 'Trang nhất', '/trang-chu'),
(2, b'1', 2, 'Lều báo', '/leu-bao'),
(3, b'1', 3, 'Quán con sò say', '/quan-con-so-say'),
(4, b'1', 4, 'Checkerviet', '/checkerviet'),
(5, b'1', 5, 'Có gì mới', '/co-gi-moi'),
(6, b'1', 6, 'Thành viên', '/thanh-vien');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` bigint NOT NULL,
  `content` text,
  `created_at` datetime(6) DEFAULT NULL,
  `is_read` bit(1) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `actor_id` bigint DEFAULT NULL,
  `post_id` bigint DEFAULT NULL,
  `recipient_id` bigint NOT NULL,
  `thread_id` bigint DEFAULT NULL,
  `reaction_icon` varchar(255) DEFAULT NULL,
  `reaction_name` varchar(255) DEFAULT NULL,
  `reaction_color` varchar(255) DEFAULT NULL,
  `conversation_id` bigint DEFAULT NULL,
  `conversation_message_id` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `polls`
--

CREATE TABLE `polls` (
  `id` bigint NOT NULL,
  `allow_change_vote` bit(1) NOT NULL,
  `closed_at` datetime(6) DEFAULT NULL,
  `max_choices` int NOT NULL,
  `public_voting` bit(1) NOT NULL,
  `question` varchar(255) NOT NULL,
  `show_result_without_vote` bit(1) NOT NULL,
  `thread_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `poll_options`
--

CREATE TABLE `poll_options` (
  `id` bigint NOT NULL,
  `option_text` varchar(255) NOT NULL,
  `vote_count` int NOT NULL,
  `poll_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `poll_votes`
--

CREATE TABLE `poll_votes` (
  `id` bigint NOT NULL,
  `option_id` bigint NOT NULL,
  `poll_id` bigint NOT NULL,
  `user_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `id` bigint NOT NULL,
  `attached_images` text,
  `content` text NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `author_id` bigint DEFAULT NULL,
  `thread_id` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reactions`
--

CREATE TABLE `reactions` (
  `id` bigint NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `post_id` bigint DEFAULT NULL,
  `reaction_icon_id` bigint NOT NULL,
  `thread_id` bigint DEFAULT NULL,
  `user_id` bigint NOT NULL,
  `conversation_message_id` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `reactions`
--

INSERT INTO `reactions` (`id`, `created_at`, `updated_at`, `post_id`, `reaction_icon_id`, `thread_id`, `user_id`, `conversation_message_id`) VALUES
(37, '2026-06-01 03:14:42.233359', '2026-06-01 03:14:42.233359', NULL, 2, NULL, 97, 47),
(38, '2026-06-01 03:17:00.319925', '2026-06-01 03:17:00.319925', NULL, 1, NULL, 96, 50),
(40, '2026-06-01 06:43:13.598539', '2026-06-01 06:43:13.598539', NULL, 1, NULL, 97, 57);

-- --------------------------------------------------------

--
-- Table structure for table `reaction_icons`
--

CREATE TABLE `reaction_icons` (
  `id` bigint NOT NULL,
  `color` varchar(255) NOT NULL,
  `icon` varchar(255) NOT NULL,
  `order_index` int NOT NULL,
  `tooltip` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `reaction_icons`
--

INSERT INTO `reaction_icons` (`id`, `color`, `icon`, `order_index`, `tooltip`) VALUES
(1, '#2577b1', 'like', 1, 'Like'),
(2, '#E81C27', 'love', 2, 'Ngon'),
(3, '#FDCA47', 'haha', 3, 'Haha'),
(4, '#FDCA47', 'wow', 4, 'Ảo vãi loz'),
(5, '#FDCA47', 'sad', 5, 'Buồn'),
(6, '#FF4D4D', 'angry', 5, 'Địt mẹ mày');

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
  `category_id` bigint DEFAULT NULL,
  `label_id` bigint DEFAULT NULL,
  `attached_images` text,
  `last_post_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `thread_subscriptions`
--

CREATE TABLE `thread_subscriptions` (
  `id` bigint NOT NULL,
  `is_following` bit(1) NOT NULL,
  `thread_id` bigint NOT NULL,
  `user_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint NOT NULL,
  `password` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `reset_code` varchar(255) DEFAULT NULL,
  `reset_code_expiry` datetime(6) DEFAULT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `password`, `username`, `avatar`, `email`, `reset_code`, `reset_code_expiry`, `display_name`, `created_at`) VALUES
(1, '$2a$10$9ijOKopSb6/uK3Z.ZGsrcuNOf4F16p8FDO0llFVLobiCOn5q9I2o.', 'admin', '#3f51b5', NULL, NULL, NULL, NULL, '2025-08-29 12:00:00.000000'),
(65, '$2a$10$pEHY0q6kk0w1.2VFEI4s3u34Y5rXNdmukyrTnBXv0bZuz.jabwna6', 'superadmin', 'hsl(18, 70%, 45%)', NULL, NULL, NULL, NULL, '2026-05-27 14:31:01.860628'),
(96, '$2a$10$/SzErD.ONP/lSHoDhxfXCOxsS/qk95Rdu6UhURJjEdb3ei2533dq6', 'user01', 'hsl(104, 70%, 45%)', NULL, NULL, NULL, NULL, '2026-06-01 03:00:21.137354'),
(97, '$2a$10$lp.kf15UfDuDNUciQqWzxOgWHTCjH6boeuk.u.Glp1a.gRAXmFNYG', 'user02', 'hsl(224, 70%, 45%)', NULL, NULL, NULL, NULL, '2026-06-01 03:00:30.336900');

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
(65, 'ROLE_SUPER_ADMIN'),
(96, 'ROLE_USER'),
(97, 'ROLE_USER');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKd4n83qf1yheqnwarwl6iq7gsf` (`category_group_id`),
  ADD KEY `FKsaok720gsu4u2wrgbk10b5n8d` (`parent_id`);

--
-- Indexes for table `category_groups`
--
ALTER TABLE `category_groups`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `conversations`
--
ALTER TABLE `conversations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK537ttdl13uqjd45m9850v038i` (`creator_id`);

--
-- Indexes for table `conversation_messages`
--
ALTER TABLE `conversation_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKcr8qqgnqnaqq2hw3gr4wtfe2a` (`conversation_id`),
  ADD KEY `FK57egbymdh9yllolr5i6hdwiwq` (`sender_id`);

--
-- Indexes for table `conversation_participants`
--
ALTER TABLE `conversation_participants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK84npv3fo2vwl7ut63im0p417q` (`conversation_id`),
  ADD KEY `FKjukjgq6uinvvk4307y8u9lixu` (`user_id`);

--
-- Indexes for table `labels`
--
ALTER TABLE `labels`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UK_otpirygk7h1hmo02w999f7kmp` (`name`);

--
-- Indexes for table `menus`
--
ALTER TABLE `menus`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK4sd9fik0uthbk6d9rsxco4uja` (`actor_id`),
  ADD KEY `FK599539lym3mnkbqks0u806eac` (`post_id`),
  ADD KEY `FKqqnsjxlwleyjbxlmm213jaj3f` (`recipient_id`),
  ADD KEY `FKny4eo4f76xn6u916yyy223q2b` (`thread_id`),
  ADD KEY `FKgvf1ydtdpj3mv66w9o9uf0rmd` (`conversation_id`),
  ADD KEY `FKl50ermcl00s5lxyy7k2c8s2ab` (`conversation_message_id`);

--
-- Indexes for table `polls`
--
ALTER TABLE `polls`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UK_hbas9rixkt3ncklvjr1glw7d0` (`thread_id`);

--
-- Indexes for table `poll_options`
--
ALTER TABLE `poll_options`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK1baxdjoxricfu0grc0j6821f7` (`poll_id`);

--
-- Indexes for table `poll_votes`
--
ALTER TABLE `poll_votes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UKby74t3g6apehqx430lhk1wu06` (`poll_id`,`user_id`,`option_id`),
  ADD KEY `FK974fgfa4183h12b8vns9226qs` (`option_id`),
  ADD KEY `FK3q0e7cabgif9f1t7voom07bg5` (`user_id`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK6xvn0811tkyo3nfjk2xvqx6ns` (`author_id`),
  ADD KEY `FK2h178flnfq5ha27wy8of7p6xs` (`thread_id`);

--
-- Indexes for table `reactions`
--
ALTER TABLE `reactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_user_thread_reaction` (`user_id`,`thread_id`),
  ADD UNIQUE KEY `uq_user_post_reaction` (`user_id`,`post_id`),
  ADD UNIQUE KEY `uq_user_message_reaction` (`user_id`,`conversation_message_id`),
  ADD KEY `FKh8b4h9wybhu8tc5w11e8t3krc` (`post_id`),
  ADD KEY `FKp9d3mnkttyrrly1e9hwcthyxe` (`reaction_icon_id`),
  ADD KEY `FK4udx0pcqyqe9787n6lg8qhwwn` (`thread_id`),
  ADD KEY `FK5r3gua5lg2y4roccbye9vxjux` (`conversation_message_id`);

--
-- Indexes for table `reaction_icons`
--
ALTER TABLE `reaction_icons`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `threads`
--
ALTER TABLE `threads`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK7n8uiua8ljj5dwubk7wxlm9d0` (`author_id`),
  ADD KEY `FKnxv40ka4vbktf3ab4pl4m9lvx` (`category_id`),
  ADD KEY `FKijm3d2bl51uo6ap2dr696fdul` (`label_id`);

--
-- Indexes for table `thread_subscriptions`
--
ALTER TABLE `thread_subscriptions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UK6lf429wbhgcjs6vaswuhig7m2` (`thread_id`,`user_id`),
  ADD KEY `FKm86an08p03ogwypwpghn7uedy` (`user_id`);

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
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `category_groups`
--
ALTER TABLE `category_groups`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `conversations`
--
ALTER TABLE `conversations`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `conversation_messages`
--
ALTER TABLE `conversation_messages`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT for table `conversation_participants`
--
ALTER TABLE `conversation_participants`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=93;

--
-- AUTO_INCREMENT for table `labels`
--
ALTER TABLE `labels`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `menus`
--
ALTER TABLE `menus`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=106;

--
-- AUTO_INCREMENT for table `polls`
--
ALTER TABLE `polls`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `poll_options`
--
ALTER TABLE `poll_options`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `poll_votes`
--
ALTER TABLE `poll_votes`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=201;

--
-- AUTO_INCREMENT for table `reactions`
--
ALTER TABLE `reactions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `reaction_icons`
--
ALTER TABLE `reaction_icons`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `threads`
--
ALTER TABLE `threads`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=221;

--
-- AUTO_INCREMENT for table `thread_subscriptions`
--
ALTER TABLE `thread_subscriptions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=98;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `FKd4n83qf1yheqnwarwl6iq7gsf` FOREIGN KEY (`category_group_id`) REFERENCES `category_groups` (`id`),
  ADD CONSTRAINT `FKsaok720gsu4u2wrgbk10b5n8d` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`);

--
-- Constraints for table `conversations`
--
ALTER TABLE `conversations`
  ADD CONSTRAINT `FK537ttdl13uqjd45m9850v038i` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `conversation_messages`
--
ALTER TABLE `conversation_messages`
  ADD CONSTRAINT `FK57egbymdh9yllolr5i6hdwiwq` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `FKcr8qqgnqnaqq2hw3gr4wtfe2a` FOREIGN KEY (`conversation_id`) REFERENCES `conversations` (`id`);

--
-- Constraints for table `conversation_participants`
--
ALTER TABLE `conversation_participants`
  ADD CONSTRAINT `FK84npv3fo2vwl7ut63im0p417q` FOREIGN KEY (`conversation_id`) REFERENCES `conversations` (`id`),
  ADD CONSTRAINT `FKjukjgq6uinvvk4307y8u9lixu` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `FK4sd9fik0uthbk6d9rsxco4uja` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `FK599539lym3mnkbqks0u806eac` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
  ADD CONSTRAINT `FKgvf1ydtdpj3mv66w9o9uf0rmd` FOREIGN KEY (`conversation_id`) REFERENCES `conversations` (`id`),
  ADD CONSTRAINT `FKl50ermcl00s5lxyy7k2c8s2ab` FOREIGN KEY (`conversation_message_id`) REFERENCES `conversation_messages` (`id`),
  ADD CONSTRAINT `FKny4eo4f76xn6u916yyy223q2b` FOREIGN KEY (`thread_id`) REFERENCES `threads` (`id`),
  ADD CONSTRAINT `FKqqnsjxlwleyjbxlmm213jaj3f` FOREIGN KEY (`recipient_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `polls`
--
ALTER TABLE `polls`
  ADD CONSTRAINT `FKpngf046l3iabdtrxr6lqw5sj` FOREIGN KEY (`thread_id`) REFERENCES `threads` (`id`);

--
-- Constraints for table `poll_options`
--
ALTER TABLE `poll_options`
  ADD CONSTRAINT `FK1baxdjoxricfu0grc0j6821f7` FOREIGN KEY (`poll_id`) REFERENCES `polls` (`id`);

--
-- Constraints for table `poll_votes`
--
ALTER TABLE `poll_votes`
  ADD CONSTRAINT `FK3q0e7cabgif9f1t7voom07bg5` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `FK974fgfa4183h12b8vns9226qs` FOREIGN KEY (`option_id`) REFERENCES `poll_options` (`id`),
  ADD CONSTRAINT `FKmaogo469u92y072mev488em6p` FOREIGN KEY (`poll_id`) REFERENCES `polls` (`id`);

--
-- Constraints for table `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `FK2h178flnfq5ha27wy8of7p6xs` FOREIGN KEY (`thread_id`) REFERENCES `threads` (`id`),
  ADD CONSTRAINT `FK6xvn0811tkyo3nfjk2xvqx6ns` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `reactions`
--
ALTER TABLE `reactions`
  ADD CONSTRAINT `FK4udx0pcqyqe9787n6lg8qhwwn` FOREIGN KEY (`thread_id`) REFERENCES `threads` (`id`),
  ADD CONSTRAINT `FK5r3gua5lg2y4roccbye9vxjux` FOREIGN KEY (`conversation_message_id`) REFERENCES `conversation_messages` (`id`),
  ADD CONSTRAINT `FKh8b4h9wybhu8tc5w11e8t3krc` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
  ADD CONSTRAINT `FKp9d3mnkttyrrly1e9hwcthyxe` FOREIGN KEY (`reaction_icon_id`) REFERENCES `reaction_icons` (`id`),
  ADD CONSTRAINT `FKqmewaibcp5bxtlqxc2cawhuln` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `threads`
--
ALTER TABLE `threads`
  ADD CONSTRAINT `FK7n8uiua8ljj5dwubk7wxlm9d0` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `FKijm3d2bl51uo6ap2dr696fdul` FOREIGN KEY (`label_id`) REFERENCES `labels` (`id`),
  ADD CONSTRAINT `FKnxv40ka4vbktf3ab4pl4m9lvx` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);

--
-- Constraints for table `thread_subscriptions`
--
ALTER TABLE `thread_subscriptions`
  ADD CONSTRAINT `FKm86an08p03ogwypwpghn7uedy` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `FKotxm1mv6djj99sssd61hd5er8` FOREIGN KEY (`thread_id`) REFERENCES `threads` (`id`);

--
-- Constraints for table `user_roles`
--
ALTER TABLE `user_roles`
  ADD CONSTRAINT `FKhfh9dx7w3ubf1co1vdev94g3f` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
