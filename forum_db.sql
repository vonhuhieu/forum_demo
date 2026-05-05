-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: May 05, 2026 at 04:59 AM
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
(24, b'1', '', 'Đầu trộm, đuôi cướp', 4, 2, NULL),
(25, b'1', '', 'test popup coi có hoạt động đúng chưa', 2, 1, 17);

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
  `border_color` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `labels`
--

INSERT INTO `labels` (`id`, `color_code`, `name`, `text_color`, `border_color`) VALUES
(3, '#ffff91', 'Thời sự', '#000', '#e6e687'),
(6, '#7cc3e0', 'Kiến thức', '#fff', '#53b0d6'),
(7, '#008000', 'Có video', '#fff', '#004d00'),
(8, '#4169e1', 'Có ảnh', '#fff', '#214cce'),
(9, '#ffff91', 'Video + ảnh', '#000', '#e6e687');

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

--
-- Dumping data for table `polls`
--

INSERT INTO `polls` (`id`, `allow_change_vote`, `closed_at`, `max_choices`, `public_voting`, `question`, `show_result_without_vote`, `thread_id`) VALUES
(5, b'0', '2026-05-04 09:23:03.820000', 1, b'1', 'Kiểu bơi này dễ nhất', b'1', 143);

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

--
-- Dumping data for table `poll_options`
--

INSERT INTO `poll_options` (`id`, `option_text`, `vote_count`, `poll_id`) VALUES
(14, 'Ếch', 0, 5),
(15, 'Sải', 0, 5),
(16, 'Bướm', 0, 5),
(17, 'Chó', 0, 5);

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
  `label_id` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `threads`
--

INSERT INTO `threads` (`id`, `active`, `content`, `created_at`, `pinned`, `reply_count`, `title`, `view_count`, `author_id`, `category_id`, `label_id`) VALUES
(122, b'0', '<p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">tao tổng hợp lại, thằng nào rp đc nhiều nội dung cp tao thưởng cạk</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">nhớ inbox, tag nhiều quá tao đéo đọc hết đc</span></p>', '2026-05-01 05:01:52.146879', b'0', 0, 'Thấy nội dung CP, inbox tao report nhận thưởng', 5, 1, 4, NULL),
(123, b'0', '<p>Tự do thoải mái, cố gắng đăng đúng box giúp tao khỏi phải move, lương chỉ có 6 triệu/1 tháng nên bọn mày thương tao</p><p>- Không Quảng cáo, lôi kéo mem<br>- Không được đăng CP<br>- Không được đăng BVS - SHIT hoặc những thứ tương tự<br>- PBVM không được đăng đi đăng lại 1 nội dung, hoặc quá cực đoan, dùng từ ngữ kích động như mấy thằng thần kinh<br>- Không Lợi dụng up bài trong chợ cóc quá nhiều cũng bị ban vì quá rác forum, đã cho lên top thì bọn mày nên trân trọng<br>- Không được share hàng có phí (vì hiện tại lừa đảo tại xamvn khá nhiều)</p>', '2026-05-01 07:43:22.122958', b'0', 0, 'Nội quy ngắn gọn của xamvn', 3, 1, 4, NULL),
(124, b'0', '<h4 style=\"margin-left:0px;\">Nhóm kín víp prồ, đỉnh của chóp <img class=\"image_resized\" style=\"aspect-ratio:64/64;height:auto;width:1.467em;\" src=\"https://cdn.jsdelivr.net/joypixels/assets/6.6/png/unicode/64/1f449.png\" alt=\"👉\" width=\"64\" height=\"64\"> <a target=\"_blank\" rel=\"noopener noreferrer\" href=\"https://t.me/xamvailon\">xamvn</a>​</h4><p><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Nhân dịp 30/4, tao miễn phí 200 slot tham gia nhóm, ai nhanh thì được </span><img style=\"height:auto;\" src=\"https://xamvn.cyou/styles/default/xenforo/smilies/nemgach/beauty.gif\" alt=\"{beauty}\" width=\"40\" height=\"40\"></p>', '2026-05-01 07:43:52.938801', b'0', 0, 'Xamvn mới tạo nhóm telegram kín, phí tham gia 500usdt/1 tháng', 0, 1, 4, NULL),
(125, b'0', '<p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Lập cái box </span><span style=\"color:rgb(44,130,201);\"><strong>chợ cóc</strong></span><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\"> đéo thèm đăng, cứ phải để tao cho cái nhãn lừa đảo với move vào box </span><span style=\"color:rgb(44,130,201);\"><strong>đầu trộm, đuôi cướp</strong></span><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\"> mới chịu!</span><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Tao đã thông báo rồi đó !</span></p>', '2026-05-01 07:44:11.136708', b'0', 0, 'Mấy tml đăng tin mua bán đéo đúng box tao cho cái nhãn \"Lừa đảo\" cho bớt khôn vặt!', 0, 1, 4, NULL),
(126, b'0', '<p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Chuyện là hôm nay được nghỉ lễ 30/4</span><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">4 ngày nên em vợ tao muốn lên thăm chị gái</span><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Sáng đi xe về mệt quá buổi trưa vợ chồng tao nằm trong phòng mà có mỗi 1 cái máy lạnh thế là con em vợ ra sofa nằm cho mát. Tao dậy thì thấy cảnh này. Tao phải làm gì để con thú trong tao không trỗi dậy đây mấy tml?</span><a target=\"_blank\" rel=\"noopener noreferrer\" href=\"https://xamvn.cyou/[url=https%3A//zpic.app/view/7Rc6R1lW][img]https%3A//zpi.cx/b/h6sK2Jluit.jpeg-webp[/img][/url]\">[url=https://zpic.app/view/7Rc6R1lW]</a></p>', '2026-05-01 07:44:34.942848', b'0', 0, 'Em vợ nghỉ lễ lên chơi', 0, 1, 4, NULL),
(127, b'0', '<p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Bày tui vs mn</span></p>', '2026-05-01 07:45:01.697675', b'0', 0, 'Cách tải video sex từ web viet69 sieudamtv QMH các bác nào biết ko', 0, 1, 4, NULL),
(128, b'0', '<p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Có ai giống t k, thích show cho ng khác coi t nắc con ny t nữa </span><img style=\"height:auto;\" src=\"https://xamvn.cyou/data/assets/smilies/24.gif\" alt=\"=))\" width=\"30\" height=\"18\"><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\"> mình dây đít bự mê vl</span></p>', '2026-05-01 07:46:28.308056', b'0', 0, 'Cuckold, show ny', 0, 1, 4, NULL),
(129, b'0', '<p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Tao làm mmo tháng đút túi 50 60m, mà tán gái khó quá muốn tìm 1 người bình thường ưu nhìn k quá xấu là đc, t nhắn tin trên app hẹn hò fb fail toàn tập luôn.</span><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Đa số k rep, có người rep 1,2 câu xong biến mất</span></p>', '2026-05-01 07:47:00.804142', b'0', 0, 'Xấu trai, có tiền mà giờ tán gái khó thật', 0, 1, 4, NULL),
(130, b'0', '<p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">lễ lộc ở nhà chán vãi đái nên tự nhiên có ý tưởng hay là lập 1 cái group telegram để ae vô đó chia sẻ ảnh chụp lén của chị họ em họ hay bạn bè cùng lớp chẳng hạn, thằng nào hứng thú thì ib tele @dukkannh nha, do mới lên ý tưởng th nên t kiếm đông đông r mới tạo nhóm nha ae, demo ae xem chị họ t trc:</span></p>', '2026-05-01 07:47:24.300262', b'0', 0, 't tính lập group chụp/quay lén họ hàng, bạn bè,..', 0, 1, 4, NULL),
(131, b'0', '<p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Hi anh em, đang loanh quanh trần cung, mình đi đạp mái chỉ thích được thổi kèn chứ k có nhu cầu đút vào lắm, xin anh em list hàng em nào chuyên bộ môn bú liếm để check phát, MB hệ giá rẻ càng tốt ạ</span></p>', '2026-05-01 07:48:14.033712', b'0', 0, 'Đang gần HQV , anh em cho xin hàng checkerviet nào chuyên dịch vụ thổi kèn với', 1, 1, 4, NULL),
(132, b'0', '<p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">qua con ny t đi họp lớp về say khướt lôi nó ra địt thì quần lót ướt nhẹp địt cứ có cảm giác nhóp nhép ướt sẵn hơi bọt trắng như vừa địt nhau xong t vừa ghen vừa nứng</span></p>', '2026-05-01 07:48:55.774477', b'0', 0, 'thằng nào địt ny khi mới đi tiệc về như t không', 5, 1, 4, NULL),
(133, b'1', '<p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Danh sách này tao nhặt nhạnh từ các bài viết trong xamvn này</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Bọn này có đặc điểm chung là nạp tiền vào thì dễ, hoặc khuyến mãi hay bào khuyến mãi rất bịp, nhưng chơi thắng nhiều muốn rút thì đéo cho, nhiều thằng còn bị khóa tài khoản vì \"gian lận\" hoặc \"vi phạm chính sách\" </span><img src=\"/uploads/6b283b92-76dc-4076-b0ab-75da97934766.gif\" alt=\":ROFLMAO:\" width=\"22\" height=\"22\"><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\"> , tao cũng đéo hiểu chơi cá độ thì làm sao mà gian lận đc nữa </span><img src=\"/uploads/84b124ea-99ce-486b-8915-a51789f2df59.gif\" alt=\":ROFLMAO:\" width=\"22\" height=\"22\"><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Các bài viết tố cáo bọn mày có thể xem thêm ở link này: </span><a target=\"_blank\" rel=\"noopener noreferrer\" href=\"https://xamvn.link/forums/26/\">https://xamvn.link/forums/26/</a><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Danh sách này tao sẽ update thường xuyên, nếu được </span><a target=\"_blank\" rel=\"noopener noreferrer\" href=\"https://xamvn.cyou/members/1/\">@ManhThuong</a><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\"> và </span><a target=\"_blank\" rel=\"noopener noreferrer\" href=\"https://xamvn.cyou/members/23959/\">@Ủn Hý</a><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\"> giúp tao edit bài, cùng nhau chung tay tiêu diệt bọn nhà cái</span><br><br><br><strong>(Ấn Ctrl+F gõ tên nhà check cho nhanh)</strong><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">- </span><strong>Sao789</strong><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\"> lừa đảo, không cho rút tiền, app chứa virus hack tài khoản ngân hàng</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">- </span><strong>QH88</strong><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\"> lừa đảo</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">- </span><strong>Fun88 </strong><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">lừa đảo</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">- </span><strong>Jun88 </strong><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">lừa đảo</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">- </span><strong>Bk8 </strong><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">lừa đảo</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">- </span><strong>SunWin </strong><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">lừa đảo</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">- </span><strong>188Bet </strong><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">lừa đảo</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">- </span><strong>Kubet </strong><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">(rất nhiều phốt)</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">- </span><strong>SM66 </strong><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">lừa đảo</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">- </span><strong>FB88 </strong><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">lừa đảo</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">- </span><strong>QH88 </strong><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">lừa đảo</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">- </span><strong>Miso88 </strong><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">lừa đảo</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">- </span><strong>Five88 </strong><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">lừa đảo</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">- </span><strong>Rw88 </strong><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">lừa đảo</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">- </span><strong>039vip </strong><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">lừa đảo</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">- </span><strong>Hk88 </strong><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">lừa đảo</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">- </span><strong>W88 </strong><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">lừa đảo</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">- </span><strong>5679 </strong><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">lừa đảo</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Bọn mày nhà cái lừa đảo hay app sập nào thì bốc phốt và bình luận vào đây</span></p>', '2026-05-01 08:32:09.856562', b'0', 0, 'Danh sách các nhà cái lừa đảo, bọn mày nên tránh xa kẻo hối hận', 2, 1, 5, NULL),
(134, b'1', '<p><span style=\"color:rgb(226,80,65);\"><strong>LINK ĐĂNG KÝ THAM GIA <img style=\"height:auto;\" src=\"https://cdn.jsdelivr.net/joypixels/assets/6.6/png/unicode/64/1f449.png\" alt=\"👉\" width=\"64\" height=\"64\"> </strong></span><a target=\"_blank\" rel=\"noopener noreferrer\" href=\"https://au88link.pro/w1\"><span style=\"color:rgb(44,130,201);font-size:22px;\"><strong>68GAME BÀI</strong></span></a><br><br><br>&nbsp;</p><h3 style=\"margin-left:0px;\">68GAMEBAI – Sân Chơi Đẳng Cấp Cho Tín Đồ Game Bài​</h3><p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Trong thời đại số hóa bùng nổ như hiện nay, việc lựa chọn một cổng game uy tín, đa dạng, dễ thao tác và hỗ trợ tốt là yếu tố then chốt quyết định trải nghiệm cá cược có thực sự thăng hoa hay không. Giữa hàng loạt cái tên chen chân trên thị trường, 68GAMEBAI nổi lên như một biểu tượng của sự đẳng cấp, an toàn và trọn vẹn – một sân chơi đúng nghĩa cho những tín đồ game bài đang khao khát vừa giải trí vừa tìm kiếm phần thưởng giá trị.</span><br><br>&nbsp;</p><h3 style=\"margin-left:0px;\">Cổng game top 1 thị trường – Nơi hội tụ đỉnh cao giải trí​</h3><p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Không phải ngẫu nhiên mà 68GAMEBAI được cộng đồng game thủ vinh danh là cổng game top 1 thị trường.Từ giao diện đến chất lượng vận hành, tất cả đều được chăm chút kỹ lưỡng với định hướng mang lại trải nghiệm “chạm là mê, chơi là cuốn”.</span><br><br><br><br>&nbsp;</p><ul><li data-list-item-id=\"e7be400736add338cbccfce13745237b2\">Giao diện của 68GAMEBAI sử dụng tông màu sang trọng, dễ nhìn, bố cục rõ ràng cùng các nút tính năng được sắp xếp khoa học, giúp thao tác nhanh chóng, thuận tiện trên mọi thiết bị.</li><li data-list-item-id=\"eb877067ff82228ef5665efcdfeeb07c3\">Cổng game cũng luôn đảm bảo tính ổn định trong mọi khung giờ, kể cả khi hàng chục nghìn tài khoản đăng nhập cùng lúc.<br>Tốc độ phản hồi nhanh, load game mượt mà và không bị lag giật là yếu tố giữ chân game thủ lâu dài.</li><li data-list-item-id=\"e7a1f463a3bd4ede531fb524317ee2ba2\">Nhờ công nghệ tối ưu server kết hợp với thuật toán bảo mật tiên tiến, 68GAMEBAI luôn là điểm đến đáng tin cậy để bạn vừa chơi game, vừa an tâm về dữ liệu cá nhân và tài sản cá cược.</li></ul><h3 style=\"margin-left:0px;\">Nạp rút nhanh – Không chờ đợi, không rườm rà​</h3><p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Một trong những yếu tố khiến 68GAMEBAI được đánh giá cao hơn hẳn các cổng game khác chính là hệ thống nạp rút siêu tốc. Người dùng có thể nạp tiền qua nhiều phương thức như chuyển khoản ngân hàng, ví điện tử phổ biến, mã thẻ hoặc QR code. Thao tác chỉ mất vài bước đơn giản, tiền sẽ cập bến tài khoản chỉ sau vài chục giây.</span><br><br>&nbsp;</p><p><img style=\"height:auto;\" src=\"https://xamvn.cyou/attachments/626392/\" alt=\"1771564072205.png\" width=\"800\" height=\"400\"></p><p><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">8GAMEBAI nạp rút nhanh</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Quan trọng hơn, khâu rút tiền tại 68GAMEBAI cực kỳ minh bạch và không có tình trạng làm khó, chờ đợi xét duyệt như nhiều nơi khác. Cổng game cam kết xử lý rút tiền chỉ trong 2 – 5 phút sau khi xác nhận lệnh, dù là giờ cao điểm hay khuya muộn. Chính điều này đã tạo nên sự uy tín bền vững cho thương hiệu 68GAMEBAI suốt thời gian qua.</span><br><br>&nbsp;</p><h3 style=\"margin-left:0px;\">Đa dạng trò chơi – Từ truyền thống đến thời thượng​</h3><p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Không chỉ đơn thuần là một cổng game giải trí, 68GAMEBAI mang đến một hệ sinh thái trò chơi phong phú, trải dài từ các tựa game bài kinh điển đến những trò chơi hiện đại mang đậm chất công nghệ. Đây không chỉ là nơi để bạn giải trí mà còn là thế giới cá cược đúng nghĩa dành cho mọi lứa tuổi, mọi sở thích. Tại 68GAMEBAI, kho trò chơi khổng lồ luôn được cập nhật liên tục để theo kịp xu hướng toàn cầu, giúp người dùng không bao giờ cảm thấy nhàm chán.</span><br><br>&nbsp;</p><p><img style=\"height:auto;\" src=\"https://xamvn.cyou/attachments/626389/\" alt=\"1771564072223.png\" width=\"800\" height=\"400\"></p><p><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Kho trò chơi đa dạng tại 68GAMEBAI</span><br><br>&nbsp;</p><h4 style=\"margin-left:0px;\">Game bài kinh điển​</h4><p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Những ai đam mê phong cách cổ điển có thể thỏa mãn cùng các game bài truyền thống như Tiến lên miền Nam, Phỏm, Liêng, Xì tố hay Sâm lốc. Giao diện sắc nét, âm thanh chân thực cùng hệ thống cược linh hoạt tạo nên cảm giác như đang ngồi trong một sòng bài đẳng cấp. Mỗi bàn chơi đều có nhiều mức đặt cược, phù hợp từ người mới đến cao thủ lâu năm.</span><br><br>&nbsp;</p><p><img style=\"height:auto;\" src=\"https://xamvn.cyou/attachments/626387/\" alt=\"1771564072237.png\" width=\"800\" height=\"400\"></p><p><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Game bài kinh điển đều có mặt tại 68GAMEBAI</span><br><br>&nbsp;</p><h4 style=\"margin-left:0px;\">Tài xỉu siêu hấp dẫn​</h4><p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Với những ai yêu thích sự nhanh gọn, Tài xỉu sẽ là lựa chọn hoàn hảo. Chỉ với vài giây, kết quả sẽ được công bố, mang đến trải nghiệm hồi hộp như đang ngồi cạnh dealer thực thụ. Tỷ lệ trả thưởng được thiết kế hấp dẫn, giúp người tham gia dễ dàng nhân đôi, nhân ba tài khoản chỉ trong chớp mắt.</span><br><br>&nbsp;</p><h4 style=\"margin-left:0px;\">Nổ hũ uy tín​</h4><p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Không thể không nhắc đến các dòng game giải trí có thưởng như nổ hũ uy tín – nơi mà cơ hội “nổ hũ đổi đời” luôn chờ đón. Những tựa game nổ hũ tại 68GAMEBAI không chỉ sở hữu chủ đề đa dạng như thần tài, Ai Cập, vũ trụ mà còn được thiết kế với hiệu ứng mãn nhãn, âm thanh sống động và cơ chế giải thưởng cực khủng, mang lại trải nghiệm quay hũ cực kỳ phấn khích.</span><br><br>&nbsp;</p><p><img style=\"height:auto;\" src=\"https://xamvn.cyou/attachments/626391/\" alt=\"1771564072254.png\" width=\"800\" height=\"400\"></p><p><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Nổ hũ trúng lớn tại 68GAMEBAI</span><br><br>&nbsp;</p><h4 style=\"margin-left:0px;\">Avitado – game máy bay thời thượng​</h4><p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Đặc biệt, Avitado – game máy bay hiện đại là điểm sáng công nghệ đáng tự hào tại cổng game này. Với cách chơi đơn giản nhưng không kém phần cuốn hút, người tham gia có thể điều khiển chiến đấu cơ để tiêu diệt mục tiêu, thu về phần thưởng dựa trên kỹ năng và chiến lược.</span><br><br>&nbsp;</p><h4 style=\"margin-left:0px;\">Xóc đĩa mini​</h4><p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Xóc đĩa mini – một trò chơi dân gian quen thuộc với cách chơi cực kỳ đơn giản – cũng đã được 68GAMEBAI nâng cấp với giao diện hiện đại, tốc độ xử lý nhanh và kết quả minh bạch. Chỉ cần vài thao tác chạm là bạn đã có thể biết ngay thắng thua, tạo nên nhịp chơi dồn dập nhưng vẫn đầy kịch tính.</span><br><br>&nbsp;</p><p><img style=\"height:auto;\" src=\"https://xamvn.cyou/attachments/626390/\" alt=\"1771564072270.png\" width=\"800\" height=\"400\"></p><p><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Xóc đĩa mở ra,trúng lớn vỡ oà</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Sự kết hợp hài hòa giữa game truyền thống và hiện đại đã giúp 68GAMEBAI chiếm trọn cảm tình của cộng đồng cá cược mọi độ tuổi, từ dân lâu năm đến tân thủ.</span><br><br>&nbsp;</p><h3 style=\"margin-left:0px;\">Cổng game có trách nhiệm – Chung tay vì cộng đồng​</h3><p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Giữa một thị trường cạnh tranh khốc liệt, 68GAMEBAI không chỉ chạy theo lợi nhuận mà còn tích cực thể hiện vai trò trách nhiệm với xã hội. Nhiều chương trình thiện nguyện đã được tổ chức thường xuyên như:</span><br><br><br><br>&nbsp;</p><p><img style=\"height:auto;\" src=\"https://xamvn.cyou/attachments/626388/\" alt=\"1771564072286.png\" width=\"800\" height=\"400\"></p><p><br>&nbsp;</p><ul><li data-list-item-id=\"ea8b425e3e36713d1f258b431a03f395e\">Ủng hộ quỹ học bổng cho học sinh vùng cao.</li><li data-list-item-id=\"eaaf38641f0f4801a7a3bead3f4ffa7e3\">Tài trợ mái ấm tình thương cho người nghèo.</li><li data-list-item-id=\"e37b3a96487731ffcb0c0a9f0c6188fc6\">Hỗ trợ thực phẩm, thuốc men cho người dân gặp thiên tai.</li></ul><p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Việc kết hợp yếu tố kinh doanh và chia sẻ đã giúp thương hiệu 68GAMEBAI không chỉ lớn mạnh về quy mô mà còn ghi điểm tuyệt đối trong lòng cộng đồng. Đây chính là cổng game hiếm hoi dám thể hiện tầm vóc qua hành động cụ thể, không dừng lại ở lời hứa sáo rỗng.</span><br><br>&nbsp;</p><h3 style=\"margin-left:0px;\">Tạm kết​</h3><p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Không cần lăn tăn, không cần so sánh quá nhiều, 68GAMEBAI đã và đang là lựa chọn số 1 cho những ai mong muốn vừa giải trí vừa kiếm thưởng nghiêm túc. Với sự đầu tư bài bản, nạp rút nhanh, dàn game đa dạng, cộng đồng gái xinh tương tác cực nhiệt và một trái tim biết sẻ chia – 68GAMEBAI xứng đáng là cổng game toàn diện nhất hiện nay.</span><br><br><strong>LINK ĐĂNG KÝ THAM GIA <img class=\"image_resized\" style=\"aspect-ratio:64/64;height:auto;width:1.467em;\" src=\"https://cdn.jsdelivr.net/joypixels/assets/6.6/png/unicode/64/1f449.png\" alt=\"👉\" width=\"64\" height=\"64\"> </strong><a target=\"_blank\" rel=\"noopener noreferrer\" href=\"https://au88link.pro/w1\"><strong>68GAME BÀI</strong></a></p>', '2026-05-01 12:35:56.850092', b'0', 0, '68GAME BÀI : CỔNG GAME UY TÍN SỐ TOP 1 THỊ TRƯỜNG', 1, 1, 5, NULL),
(135, b'1', '<p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Nay tháng mới lập topic bàn luận chia sẻ lê đào, cầu đẹp…. </span><a target=\"_blank\" rel=\"noopener noreferrer\" href=\"https://xamvn.cyou/members/315109/\">@locxamacvn</a><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\"> </span><a target=\"_blank\" rel=\"noopener noreferrer\" href=\"https://xamvn.cyou/members/22014/\">@Cammuoitu</a><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\"> </span><a target=\"_blank\" rel=\"noopener noreferrer\" href=\"https://xamvn.cyou/members/39307/\">@HaiCongTu</a><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\"> </span><a target=\"_blank\" rel=\"noopener noreferrer\" href=\"https://xamvn.cyou/members/131518/\">@All</a><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Anh em chốt cầu xem nào ::</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Tôi tháng trước đen quá : tháng nay mong gỡ lại !!!</span><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Nay tôi nện song lô : 93-10</span><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Ghép xiên : 93,10,57,75</span><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Nói thật cặp 575 nó ảo vl đợt trước nó ra 3 ngày đều 4 nháy. Anh em nào đánh bệt nên đánh lại</span></p>', '2026-05-01 12:36:24.556187', b'0', 0, 'Tháng 5 rực rỡ …', 0, 1, 5, NULL),
(136, b'1', '<p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Anh em sang topic mới chào đón niềm vui mới nhé </span><img style=\"height:auto;\" src=\"https://cdn.jsdelivr.net/joypixels/assets/6.6/png/unicode/64/1f923.png\" alt=\"🤣\" width=\"64\" height=\"64\"><img style=\"height:auto;\" src=\"https://cdn.jsdelivr.net/joypixels/assets/6.6/png/unicode/64/1f923.png\" alt=\"🤣\" width=\"64\" height=\"64\"><img style=\"height:auto;\" src=\"https://cdn.jsdelivr.net/joypixels/assets/6.6/png/unicode/64/1f923.png\" alt=\"🤣\" width=\"64\" height=\"64\"><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Chúc anh em 8386 đánh đâu thắng đó !!!!</span></p>', '2026-05-01 12:36:48.907180', b'0', 0, 'Lê Đào Những Ngày Cuối Tháng 4 Lịch Sử 🤣', 0, 1, 5, NULL),
(137, b'1', '<h2 style=\"margin-left:0px;\"><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">T thì đam mê bóng banh 10 năm nay, khổ nỗi chỉ dám đánh TÀI đéo dám đánh XỈU. Ngay cả HDC cũng ít, tuỳ trận mới đánh. Có AE nào mê bóng rung bóng tài thì chơi cùng t có cái nói chuyện cho vui nhé, ngồi oánh 1 mình tâm lý quá !</span></h2>', '2026-05-01 12:37:16.456899', b'0', 0, 'TOPIC DÀNH CHO ANH EM MÊ BÓNG TÀI !', 4, 1, 5, NULL),
(143, b'1', '<p>Kiểu bơi này dễ nhất</p>', '2026-05-03 09:18:00.995785', b'0', 0, 'Kiểu bơi này dễ nhất', 23, 1, 4, NULL),
(144, b'1', '<p>Ẻm đây<br><br><a target=\"_blank\" rel=\"noopener noreferrer\" href=\"https://ibb.co/Nns31HRf%20https://ibb.co/GfcJQVKN%20https://ibb.co/b5zRBD2w\">https://ibb.co/Nns31HRf https://ibb.co/GfcJQVKN https://ibb.co/b5zRBD2w</a></p><h4 style=\"margin-left:0px;\">Đính kèm</h4><ul style=\"margin-left:0px;\"><li data-list-item-id=\"ed2a3eccfd26c721318bd0898c6ceed38\"><p><a target=\"_blank\" rel=\"noopener noreferrer\" href=\"https://xamvn.cyou/attachments/702832/\"><img src=\"https://xamvn.cyou/data/attachments/702/702833-a6a8ac1c03c3d3a534d1ac4c18d7456f.jpg\" alt=\"3153675945442370008_Original.jpeg\" width=\"198\" height=\"198\"></a></p><p>3153675945442370008_Original.jpeg</p><p>270.5 KB · Xem: 18</p></li><li data-list-item-id=\"e5dc2429109233799566119e1ea93df17\"><p><a target=\"_blank\" rel=\"noopener noreferrer\" href=\"https://xamvn.cyou/attachments/702833/\"><img src=\"https://xamvn.cyou/data/attachments/702/702834-9cbb160abd96e9aeb5e456df2b5de05e.jpg\" alt=\"3153675945442444471_Original.jpeg\" width=\"198\" height=\"198\"></a></p><p>3153675945442444471_Original.jpeg</p><p>217.3 KB · Xem: 18</p></li><li data-list-item-id=\"e2e3e517448de6ee339b13cde05d1ac15\"><p><a target=\"_blank\" rel=\"noopener noreferrer\" href=\"https://xamvn.cyou/attachments/702834/\"><img src=\"https://xamvn.cyou/data/attachments/702/702835-a18e4206ab4f0fb13f43be57fbc7168a.jpg\" alt=\"3153675945434148645_Original.jpeg\" width=\"198\" height=\"198\"></a></p><p>3153675945434148645_Original.jpeg</p><p>233.7 KB · Xem: 19</p></li></ul>', '2026-05-04 22:34:15.212422', b'0', 0, 'Hot instagram snowdirection ai còn nhớ ạ', 0, 1, 4, 8),
(145, b'1', '<p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Thái nguyên vựa gái luôn mà thấy ae trầm quá </span><img style=\"height:auto;\" src=\"https://xamvn.cyou/data/assets/smilies/21.gif\" alt=\":))\" width=\"18\" height=\"18\"><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">)</span></p>', '2026-05-04 22:52:23.368891', b'0', 0, 'Gửi vào đây những e Thái Nguyên chúng m từng địt ngon nhất đi', 0, 1, 17, 8),
(146, b'1', '<p><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Với kinh nghiệm xem AV khá lâu. Hôm nay tui sẽ đưa cho 10 bộ hay nhất từ trước đến nay của JAV.</span><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Lưu ý: Không bao gồm các trang wed trả phí như Fanza, DMM,... của Nhật</span><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Nguồn này là tự tôi tổng hợp từ nhiều trang Wed Jav miễn phí trên khắp cỏi mạng, vì nó là đánh giá của nhiều người dùng trên toàn thế giới.</span><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Tiêu chí đánh giá: dựa trên lượt view, rated sao</span><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Top 1: ABP-984</span><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Kịch bản độc lạ của riêng Prestige, Remu thời đỉnh cao nhan sắc + Creampie, hard code,....Phim hay nhất 2020 và cũng được cho là hay nhất mọi thời đại</span><br>&nbsp;</p><p><img style=\"height:auto;\" src=\"https://xamvn.cyou/attachments/595939/\" alt=\"1768155892152.png\" width=\"512\" height=\"288\"></p><p><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Top 2: STARS-804</span><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Rei của SOD, tập này đỉnh cao diễn xuất, phim hay nhất năm 2023.</span><br>&nbsp;</p><p><img style=\"height:auto;\" src=\"https://xamvn.cyou/attachments/595947/\" alt=\"1768156130299.png\" width=\"512\" height=\"288\"></p><p><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Top 3: IPX-811</span><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Kaeden Karen lúc trước khi giải nghệ (đã quay trở lại), thể loại này bùng nổ năm 2022 do có nội dung quá bánh cuốn, nhưng người diễn xuất đạt chạm nóc nhất là Karen. CODE hay nhất 2022</span><br>&nbsp;</p><p><img style=\"height:auto;\" src=\"https://xamvn.cyou/attachments/595959/\" alt=\"1768156557642.png\" width=\"535\" height=\"360\"></p><p><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Top 4: SHKD-724</span><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Rin Sakuragi, phim không nhiều, giải nghệ sớm nhưng có quả CODE để đời, theo tôi CODE này có những cảnh doggy phải nói là đỉnh nhất từ trước tới nay, diễn xuất trong CODE này cũng chạm đỉnh. Hay nhất 2016</span><br>&nbsp;</p><p><img style=\"height:auto;\" src=\"https://xamvn.cyou/attachments/595962/\" alt=\"1768156741205.png\" width=\"800\" height=\"538\"></p><p><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Top 5: CAWD-365</span><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Body của Ito trong CODE này hiện lên hoàn hảo, bả bình thường body đã on top r, nhưng kỹ thuật quay phim của bộ này thật sự quá hay, tôn lên quá tốt body của bả</span><br>&nbsp;</p><p><img style=\"height:auto;\" src=\"https://xamvn.cyou/attachments/595967/\" alt=\"1768156929587.png\" width=\"800\" height=\"538\"></p><p><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">TOP 6: IPX-580</span><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Lại là Karen với quả CODE mà các cảnh hành động gần như liên tục, trong CODE này bả diễn ra nét vừa hoang dại vừa thèm muốn. Cũng lại là diễn xuất lên tiếng</span><br>&nbsp;</p><p><img style=\"height:auto;\" src=\"https://xamvn.cyou/attachments/595968/\" alt=\"1768157120329.png\" width=\"800\" height=\"538\"></p><p><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Top 7: SSNI-497</span><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Arina, vừa mới giải nghệ, nói thật tôi không thấy bộ này hay chổ nào, nó được quay vào lúc nhan sắc của bả rất bình thường luôn. Thôi anh xem và tự thẩm r cmt cho tui biết</span><br>&nbsp;</p><p><img style=\"height:auto;\" src=\"https://xamvn.cyou/attachments/595969/\" alt=\"1768157281739.png\" width=\"800\" height=\"537\"></p><p><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Top 8: START-257</span><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Kominato Yotsuha, vừa ra mắt mấy tháng trước nhưng lọt luôn vào top, phim này bả đẹp dã man, nhìn cứ kiểu ngây ngơ, dâm dâm với quyến rũ kiểu gì rất khó tả. Cộng với quả diễn viên nam đẹp trai nhất AV + kịch bản hẹn hò lãng mạn</span><br>&nbsp;</p><p><img style=\"height:auto;\" src=\"https://xamvn.cyou/attachments/595970/\" alt=\"1768157540432.png\" width=\"512\" height=\"288\"></p><p><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Top 9: SHKD-744</span><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Satomi Yuria, Chắc khá ít người biết, CODE này ontop là do cảnh bả mặc body suit ở cuối thật sự quá đỉnh cao + tự nhiên code này đẹp lạ lùng. Phim hay nhất 2017</span><br>&nbsp;</p><p><img style=\"height:auto;\" src=\"https://xamvn.cyou/attachments/595971/\" alt=\"1768157821555.png\" width=\"800\" height=\"538\"></p><p><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Top 10: IPX-679</span><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Cô gái của chúng ta đây r, cùng kịch bản với top 6, nhưng Karen đỉnh hơn. Phim hay nhất năm 2021</span><br>&nbsp;</p><p><img style=\"height:auto;\" src=\"https://xamvn.cyou/attachments/595973/\" alt=\"1768157998301.png\" width=\"800\" height=\"538\"></p><p><br><br><span style=\"background-color:rgb(254,254,254);color:rgb(20,20,20);font-size:18px;\">Đừng hỏi tôi sau không có Yua với Fukada, thật sự tôi thấy 2 má này khá mid, chẳng nổi trội ở mặc nào, nổi tiếng kiểu đại trà, còn nếu những người \"thật sự\" xem AV thì không có gì nổi bật. Và trong top 50 thì không thấy phim nào của 2 má luôn</span></p>', '2026-05-04 22:53:35.940398', b'0', 0, 'Review 10 bộ AV được đánh giá cao nhất từ trước đến nay trên các trang JAV \"miễn phí\".', 0, 1, 17, 8);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint NOT NULL,
  `password` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `password`, `username`, `avatar`, `email`) VALUES
(1, '$2a$10$9ijOKopSb6/uK3Z.ZGsrcuNOf4F16p8FDO0llFVLobiCOn5q9I2o.', 'admin', '#3f51b5', NULL),
(2, '$2a$10$jAk/ZlViZS5D3VYASEplYurbzK0lLmhwKe66h/wzwtYPz3hsFs8Ty', 'user01', NULL, NULL),
(3, '$2a$10$i52hSXKbS4RqeYimw7xAHu4YXFtxLAg5zGKkPHC37PVeG.EtWpZk2', 'tester', NULL, NULL),
(4, '$2a$10$vZ8cyER2eHAdBzyqf/w5uuxMoWLz7tfqq4pPoztnsjb7hZjRuPWfC', 'user02', NULL, NULL),
(5, '$2a$10$PWHubAcanB47WaEkH0PnZuPBlj4SJxcuKs0/LvXlI1W9mEDsEsS5a', 'user03', NULL, NULL);

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
(5, 'ROLE_USER');

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
-- AUTO_INCREMENT for table `threads`
--
ALTER TABLE `threads`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=147;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

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
