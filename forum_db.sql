-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: May 13, 2026 at 11:37 PM
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
  `type` enum('NEW_COMMENT','QUOTE','MENTION') DEFAULT NULL,
  `actor_id` bigint DEFAULT NULL,
  `post_id` bigint DEFAULT NULL,
  `recipient_id` bigint NOT NULL,
  `thread_id` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `content`, `created_at`, `is_read`, `type`, `actor_id`, `post_id`, `recipient_id`, `thread_id`) VALUES
(28, NULL, '2026-05-13 15:53:44.052628', b'0', 'NEW_COMMENT', 38, 142, 37, 189);

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

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`id`, `attached_images`, `content`, `created_at`, `updated_at`, `author_id`, `thread_id`) VALUES
(142, '[]', '<p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">tao thấy né nhất là mấy con mê phim hàn quốc ra, đm tính cách thì hãm lol mơ mộng như phim, chuyện tình muốn lúc nào cũng đẹp như tranh hở tý là xúc động là khóc, là giận dỗi đime sợ hãi</span></p>', '2026-05-13 15:53:44.051118', '2026-05-13 15:53:44.051118', 38, 189);

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
  `user_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `reactions`
--

INSERT INTO `reactions` (`id`, `created_at`, `updated_at`, `post_id`, `reaction_icon_id`, `thread_id`, `user_id`) VALUES
(6, '2026-05-13 17:45:20.576609', '2026-05-13 17:45:20.576609', NULL, 2, 189, 1);

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

--
-- Dumping data for table `threads`
--

INSERT INTO `threads` (`id`, `active`, `content`, `created_at`, `pinned`, `reply_count`, `title`, `view_count`, `author_id`, `category_id`, `label_id`, `attached_images`, `last_post_at`) VALUES
(189, b'1', '<p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Ờ địt mẹ từ từ bố mày update dần dần.</span><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Cái tao share cho chúng mày là exp đúc kết về kinh nghiệm chăn và thực chiến gái trên mạng lẫn thực tế. Chỉ là những kinh nghiệm để chúng mày đỡ mắc những lỗi ngu sơ đẳng, chứ đéo có bí kíp kịch bản cặc gì đâu nhé, vì mỗi thằng mỗi hoàn cảnh khác nhau</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Vào việc:</span><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">1. Xác định luôn: Tỉ lệ thành công luôn chỉ ở tầm ~5% là ổn. Kể cả mày có mọi thứ trời ban, thì cũng chỉ có tỉ lệ cỡ 10%, chứ đéo bao giờ có chuyện gạ con nào là được con đấy, phần lớn thành bại là do gái nó có nứng với mày hay ko? Mà cái này thì chính bản thân đứa con gái nó cũng đéo biết được lúc nào nó nứng lên đâu tao nói thật. Cho nên: TUYỆT ĐỐI KO CỐ ĐẤM ĂN XÔI: Đi vài 3 nước thấy đéo trôi là bỏ luôn kiếm con khác, vì lợi thế của mày là có thể tiếp cận vô hạn số gái, tức DỄ TIẾP CẬN, còn nhược điểm của thời đại bây giờ là DỄ TUỘT -&gt; Như vậy việc của chúng mày là phải ĐÂM NHIỀU LÊN, chỗ nào trôi thì mới đâm vào tiếp chứ đéo phải lock mục tiêu rồi cố đâm bằng được.</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">2. Được hay ko thì phát đầu quyết định hết. Bắt đầu nói chuyện thì 5-10 câu đầu tiên quyết định thắng thua, nghĩ cho kĩ rồi hãy nói. Gặp trực tiếp thì ấn tượng trong 1 phút đầu tiên sẽ là 80% định kiến của gái về mày, đéo bao giờ thay đổi được, cho nên làm gì thì làm luôn buổi đầu, đừng bao giờ tư duy theo kiểu \"từ từ\", phông bạt bao nhiêu tất tay con mẹ mày hết đi.</span><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Buổi hẹn đầu tiên thì cứ sang xịn nhất có thể, có lần sau thì có tất mẹ rồi cần lồn gì nữa.</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">3. Luôn tìm múi mít: Độ tuổi 16-21 luôn thèm địt thèm yêu. Đừng bao giờ có suy nghĩ tìm mấy con \"trưởng thành\" hay mẹ đơn thân với suy nghĩ \"hàng ế sẽ giảm giá\".</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">4. Mấy con kín đáo, ra dáng ngoan hiền, nói chuyện nhã nhặn lịch sự, sở thích lành mạnh như thích mèo, truyện tranh, nhạc nhẽo phim ảnh vớ vẩn,... giờ giấc chuẩn chỉ, không dính líu vào bất cứ thói xấu dễ thấy nào, không bao giờ thả thính vớ vẩn, và đặc biệt nhất là hay cười -&gt; Đích xác là những con thèm địt nhất, thơm tho nhất, đáng theo đuổi nhất. Đâm mấy con này vừa dễ thành công vừa mang lại cho chúng mày sướng khoái</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Ngược lại mấy con có biểu hiện như sau tránh cho xa:</span><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">- Hay chán, hay \"tâm trạng\" thất thường, hay tỏ ra dark deep, đặc biệt là hay thả thính bâng qơ</span><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">- Không có thú vui, sở thích nào rõ rệt. Nói nôm na là đéo \"nghiện\" cái gì hết. Tin tao đi con người phải \"nghiện\" thì mới chơi được, đéo biết nghiện thì cũng tức là sẵn sàng buông bỏ buông thả, lúc êm đẹp đéo sao, hơi sóng gió tí nó bỏ mày ngay.</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">5. Mình chăn nó, nó cũng đang chăn mình. Chúng mày đéo bao giờ được quên đàn bà nó cũng đang nhìn chúng mày và đánh giá y hệt những gì chúng mày đang làm với nó. Chỉ cần luôn nhớ như vậy, đừng bao giờ ảo tưởng chỉ có mình là kẻ đi săn, tự chúng mày sẽ ngộ ra rất nhiều thứ nhỏ nhặt lợi hại. Tóm lại \"luôn nghĩ 2 chiều, đừng chỉ nhìn ở góc của mình\"</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Ờ rồi thằng nào có exp gì thì anh em trao đổi học hỏi lẫn nhau đi.</span></p>', '2026-05-13 15:50:02.699925', b'0', 1, 'Trao đổi kinh nghiệm về gái', 23, 37, 10, 6, '[]', '2026-05-13 15:53:44.051118');

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
  `display_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `password`, `username`, `avatar`, `email`, `reset_code`, `reset_code_expiry`, `display_name`) VALUES
(1, '$2a$10$9ijOKopSb6/uK3Z.ZGsrcuNOf4F16p8FDO0llFVLobiCOn5q9I2o.', 'admin', '#3f51b5', NULL, NULL, NULL, NULL),
(2, '$2a$10$jAk/ZlViZS5D3VYASEplYurbzK0lLmhwKe66h/wzwtYPz3hsFs8Ty', 'user01', '#ff9800', NULL, NULL, NULL, NULL),
(3, '$2a$10$i52hSXKbS4RqeYimw7xAHu4YXFtxLAg5zGKkPHC37PVeG.EtWpZk2', 'tester', NULL, NULL, NULL, NULL, NULL),
(4, '$2a$10$vZ8cyER2eHAdBzyqf/w5uuxMoWLz7tfqq4pPoztnsjb7hZjRuPWfC', 'user02', NULL, NULL, NULL, NULL, NULL),
(5, '$2a$10$PWHubAcanB47WaEkH0PnZuPBlj4SJxcuKs0/LvXlI1W9mEDsEsS5a', 'user03', '#ff5722', NULL, NULL, NULL, NULL),
(6, '$2a$10$e4R42eA1hMYXYFf.mWNf4OitBIC3lhG6gucoNAplHb6JHJvb3L48u', 'user04', '#03a9f4', 'vonhuhieu2003@gmail.com', NULL, NULL, NULL),
(7, '$2a$10$XO3NuxFEJ/YVB7tsWTPcyeEAlp4aktEXqfUaXf9vq9zoukLF1pWEK', 'Pro Trader ❤️', '#795548', 'ProTrader@gmail.com', NULL, NULL, NULL),
(8, '$2a$10$5B9MOACgtBo9V6veWd8UiugDi9cQb6hslty9Z81Y8LBVwhKMegGmS', 'Fast159', '#e91e63', 'Fast159@gmail.com', NULL, NULL, NULL),
(9, '$2a$10$nId8mosJxLhj7r3Sr7LSbeQgC3q.v7boo7JliQsnr6I0xaS0TpkMy', 'Wun', '#e91e63', 'Wun@gmail.com', NULL, NULL, NULL),
(10, '$2a$10$lBfypm18sqFhUFLa1OoM4OjdL0rHkfwDhpG79BfCUgoIXYmxL4yYO', 'archi', '#3f51b5', 'archi@gmail.com', NULL, NULL, NULL),
(11, '$2a$10$/FwHbZ1r3VifLosbJ8DOuOJ36LOkWTL8S69we1a4CG0fwPNN94wkq', 'Polimen', '#009688', 'Polimen@gmail.com', NULL, NULL, NULL),
(12, '$2a$10$MDZFGN5vgixFWGhmossdougu.EbZMJS06ID/sLFi5dJFyDW5EPT4q', 'Tun2k', '#03a9f4', 'Tun2k@gmail.com', NULL, NULL, NULL),
(13, '$2a$10$RWIw.qotsRWxqlLAxgLPB.OOgIsZ9hBQsnlEdZQoF9Az4QPInQjvW', 'Sharingan Vạn Hoa Đồng', '#ffc107', 'test@gmail.com', NULL, NULL, NULL),
(14, '$2a$10$il6sgCWMEnCFFbYbtzgpD.ExWsxsaFdjAXlePRNyYOZKdF7/jrtuy', 'binzuto', '#8bc34a', 'binzuto@gmail.com', NULL, NULL, NULL),
(15, '$2a$10$TWRa36ioAfMQkR2wafV1U.hvuTcgsRxUih8HotZbgO9W03GUtYENa', 'ducpm9', '#2196f3', 'ducpm9@gmail.com', NULL, NULL, NULL),
(16, '$2a$10$rvV73hLsN98ZZvL9CM9rBuFPOWOhTyg0LCnSh0aGhfKVLoxtQDnQy', 'banhkeoth', '#673ab7', 'banhkeoth@gmail.com', NULL, NULL, NULL),
(17, '$2a$10$U7RXDfzyCocZGpG8yZBwwOtqrfQ8GpXfodvLdZz0weieOHmQW/hgW', 'laokhonglo', '#4caf50', 'laokhonglo@gmail.com', NULL, NULL, NULL),
(18, '$2a$10$wOk/dsG58NG/SVNCZlZx5eLOvB.ud283HGYGQKuP4llDFgvb4Fbf6', 'klu123', '#4caf50', 'klu123@gmail.com', NULL, NULL, NULL),
(19, '$2a$10$6x4r/6kUQeunvrje3kygS.aQvchHMbz9hskXkwLuWm91AHaB01scC', 'tnhuw', '#00bcd4', 'tnhuw@gmail.com', NULL, NULL, NULL),
(20, '$2a$10$4Tu2ZQD8pLaTr2Pb2GJWIeSNJmU63S.2vCZhQ/sOjtzpd5MDmPjxS', 'hettienchoigai', '#f44336', 'hettienchoigai@gmail.com', NULL, NULL, NULL),
(21, '$2a$10$ZftL7Gcl48hboKC.cE6Am.l.nBm1azVs.9E4Z56Qw1dP6IFLulBxq', 'Henry888888', 'hsl(311, 70%, 45%)', 'Henry888888@gmail.com', NULL, NULL, NULL),
(22, '$2a$10$HIJPFmaTnPTIRVz4akfUUOgNUpChME4ndmxEtbeoOriKVKUW5gyYa', 'ThichDamLon', 'hsl(48, 70%, 45%)', 'ThichDamLon@gmail.com', NULL, NULL, 'Thích Dâm Lồn'),
(23, '$2a$10$nVvti/12tyRvGbhrAoYaPOLcmsmAQJ15YXMrXBXXxF31tbhkJBUYa', 'Tuanh020393', 'hsl(200, 70%, 45%)', 'Tuanh020393@gmail.com', NULL, NULL, 'Tuanh020393'),
(24, '$2a$10$O5kH/e91wJeuN9Dsp9a6x.JoxlpiR3m8DC4Q35F3L5p1UEeFwBZ.S', 'ditieubao88', 'hsl(319, 70%, 45%)', 'ditieubao88@gmail.com', NULL, NULL, 'ditieubao88'),
(25, '$2a$10$4b7nUIlmGxPcao1NNo53XO35Jvpwa6ec3aYQizRucToBLxMnjmlnu', 'Elian', 'hsl(226, 70%, 45%)', 'Elian@gmail.com', NULL, NULL, 'Elian'),
(26, '$2a$10$3FU08KvYJg9FD.ORJ7xQJ.dqJ2GrRSRJ4EKno8q4LL13yFe.PnkQu', 'spy_cnn', 'hsl(179, 70%, 45%)', 'spy_cnn@gmail.com', NULL, NULL, 'spy_cnn'),
(27, '$2a$10$d20GvSVkE62vxhX/9HjxAOMywe0MKWk/kmmBm9Ora8Q8.H3r8ZMyK', 'Vklaeoi', 'hsl(247, 70%, 45%)', 'Vklaeoi@gmail.com', NULL, NULL, 'Vklaeoi'),
(28, '$2a$10$3mbQjMu5ZeUfnrWokyXgkOS.ePvu7R2f9Dzzw1sdkaveZB0kokEEW', 'Dskinder18', 'hsl(184, 70%, 45%)', 'Dskinder18@gmail.com', NULL, NULL, 'Dskinder18'),
(29, '$2a$10$E74.hGwd6bHj/P9K/fBh6ut2oLhGCwPbib7gc.9ym5y.ytUKNQxRe', 'Tanker69', 'hsl(280, 70%, 45%)', 'Tanker69@gmail.com', NULL, NULL, 'Tanker69'),
(30, '$2a$10$i3M/XadwHhb9NduLdP9N2.VQNiiztwKcSc203o4vIMPbkdWlbFDG.', 'ksonnn', 'hsl(156, 70%, 45%)', 'ksonnn@gmail.com', NULL, NULL, 'ksonnn'),
(31, '$2a$10$0Troodt97ElI1GWe/D0DBuWgsU7ARyD8gbla0tGFlFq1HqWgHFcaS', 'Vinhsinh12', 'hsl(129, 70%, 45%)', 'Vinhsinh12@gmail.com', NULL, NULL, 'Vinhsinh12'),
(32, '$2a$10$Mi79uXqPivU.fN0Z7obaXOZpM5lLOQZpiixWG3BWNv.mTeo6V1eqW', 'garung193', 'hsl(165, 70%, 45%)', 'garung193@gmail.com', NULL, NULL, 'garung193'),
(33, '$2a$10$PY9tRPzS.pAysOu8zdNR3OJEf2FzzyqqQJl9PihczaNu9rSdswURy', 'thanchien', 'hsl(63, 70%, 45%)', 'thanchien@gmail.com', NULL, NULL, 'thanchien'),
(34, '$2a$10$9hSMHhp01hvd6GL.WXCgyOYAlZq8Z2jctA7dmYLZuJ/LpTdAgfh9i', 'haimyxam', 'hsl(284, 70%, 45%)', 'haimyxam@gmail.com', NULL, NULL, 'haimyxam'),
(35, '$2a$10$6QvA9qHcJdBhqhsVypuZIugtK2Af/j6RD82.H0c1tc12vL0VJNP2q', 'Android17', 'hsl(225, 70%, 45%)', 'Android17@gmail.com', NULL, NULL, 'Android17'),
(36, '$2a$10$d0ibjCGyIliI6vQ95dlEdOdL23wf6Zxo2taBR94ofvNxdVuNFPjtu', 'Voldermort', 'hsl(33, 70%, 45%)', 'Voldermort@gmail.com', NULL, NULL, 'Voldermort'),
(37, '$2a$10$oz7oXRIkXj.YmbCXpeuv4eLryo6yrvcnKaVvocgQfmjRcwN6tCEb6', 'hongtran', 'hsl(99, 70%, 45%)', 'hongtran@gmail.com', NULL, NULL, 'Hồng Trần'),
(38, '$2a$10$FcySdHCTPCvbbcqdb8.gluz0BjYXaYNO23DmObisuPvW/qFaA4DTe', 'slowguy', 'hsl(182, 70%, 45%)', 'slowguy@gmail.com', NULL, NULL, 'slowguy'),
(39, '$2a$10$Rv5GQaBR7T9Fd5yXJVxg/ePrx1BNq4dPnxYTCzgYUWpIiluEV4BzS', 'Deadpoo', 'hsl(39, 70%, 45%)', 'Deadpoo@gmail.com', NULL, NULL, 'Deadpoo');

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
(3, 'ROLE_USER'),
(4, 'ROLE_USER'),
(5, 'ROLE_USER'),
(6, 'ROLE_USER'),
(7, 'ROLE_USER'),
(8, 'ROLE_USER'),
(9, 'ROLE_USER'),
(10, 'ROLE_USER'),
(11, 'ROLE_USER'),
(12, 'ROLE_USER'),
(13, 'ROLE_USER'),
(14, 'ROLE_USER'),
(15, 'ROLE_USER'),
(16, 'ROLE_USER'),
(17, 'ROLE_USER'),
(18, 'ROLE_USER'),
(19, 'ROLE_USER'),
(20, 'ROLE_USER'),
(21, 'ROLE_USER'),
(22, 'ROLE_USER'),
(23, 'ROLE_USER'),
(24, 'ROLE_USER'),
(25, 'ROLE_USER'),
(26, 'ROLE_USER'),
(27, 'ROLE_USER'),
(28, 'ROLE_USER'),
(29, 'ROLE_USER'),
(30, 'ROLE_USER'),
(31, 'ROLE_USER'),
(32, 'ROLE_USER'),
(33, 'ROLE_USER'),
(34, 'ROLE_USER'),
(35, 'ROLE_USER'),
(36, 'ROLE_USER'),
(37, 'ROLE_USER'),
(38, 'ROLE_USER'),
(39, 'ROLE_USER');

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
  ADD KEY `FKny4eo4f76xn6u916yyy223q2b` (`thread_id`);

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
  ADD KEY `FKh8b4h9wybhu8tc5w11e8t3krc` (`post_id`),
  ADD KEY `FKp9d3mnkttyrrly1e9hwcthyxe` (`reaction_icon_id`),
  ADD KEY `FK4udx0pcqyqe9787n6lg8qhwwn` (`thread_id`);

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
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

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
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=143;

--
-- AUTO_INCREMENT for table `reactions`
--
ALTER TABLE `reactions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `reaction_icons`
--
ALTER TABLE `reaction_icons`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `threads`
--
ALTER TABLE `threads`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=193;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

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
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `FK4sd9fik0uthbk6d9rsxco4uja` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `FK599539lym3mnkbqks0u806eac` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
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
-- Constraints for table `user_roles`
--
ALTER TABLE `user_roles`
  ADD CONSTRAINT `FKhfh9dx7w3ubf1co1vdev94g3f` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;