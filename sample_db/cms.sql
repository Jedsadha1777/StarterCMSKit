-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Apr 19, 2026 at 04:40 PM
-- Server version: 5.7.39
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cms`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(11) NOT NULL,
  `email` varchar(120) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `public_id` varchar(36) NOT NULL,
  `name` varchar(100) NOT NULL DEFAULT '',
  `role` enum('super_admin','admin','editor') NOT NULL DEFAULT 'admin',
  `company_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `email`, `password_hash`, `created_at`, `updated_at`, `public_id`, `name`, `role`, `company_id`) VALUES
(1, 'admin', '$2b$12$WCZdrll9MmRizFSCfW62tOD/RqS4DxuouHMm1Z7VvVOST4nT8aN5O', '2026-04-07 01:07:18', '2026-04-08 09:01:44', 'bb63a488-164f-41a3-aaa9-86560d6135a7', 'Admin Parent 102', 'admin', 1),
(2, 'admin2', '$2b$12$yMcBmmuyhJq9dMtwLnAnEuEFYBizesigKVVRvSPlyN/Wr5DR1nPQm', '2026-04-08 06:59:06', '2026-04-08 06:59:06', '23d8dc9f-f3ec-473e-ae51-e39e05febbad', 'admin2', 'admin', 2),
(3, 'admin3', '$2b$12$G7JVqJg0iy3QZVxLazGaGOV3UbE4IXoLJ5/xD8HjMHdVtIWDKH96K', '2026-04-16 08:38:41', '2026-04-16 08:38:41', 'e38e31eb-5feb-4dd2-8877-9fa2d1b0f923', 'admin3', 'admin', 3),
(4, 'admin2a', '$2b$12$2yBXfyAydM1FvJTXOyQYr.eW9Au8lL7M/Tj699/NKzst8.IEdNOyi', '2026-04-17 16:01:08', '2026-04-17 16:01:08', '7bb8e19b-ca8b-48c9-822f-68d2b0aa9cb3', 'admin2a', 'admin', 2);

--
-- Triggers `admins`
--
DELIMITER $$
CREATE TRIGGER `trg_admins_after_delete` AFTER DELETE ON `admins` FOR EACH ROW UPDATE summary SET row_count = row_count - 1, updated_at = NOW()
            WHERE table_name = 'admins'
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_admins_after_insert` AFTER INSERT ON `admins` FOR EACH ROW UPDATE summary SET row_count = row_count + 1, updated_at = NOW()
            WHERE table_name = 'admins'
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin_sessions`
--

CREATE TABLE `admin_sessions` (
  `id` varchar(36) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `refresh_token_hash` varchar(255) NOT NULL,
  `token_family` varchar(36) NOT NULL,
  `is_used` tinyint(1) DEFAULT '0',
  `used_at` datetime DEFAULT NULL,
  `status` varchar(20) DEFAULT 'active',
  `grace_until` datetime DEFAULT NULL,
  `replaced_by_session_id` varchar(36) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `last_active_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `active_admin_id` int(11) GENERATED ALWAYS AS ((case when (`status` = 'active') then `admin_id` else NULL end)) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `admin_sessions`
--

INSERT INTO `admin_sessions` (`id`, `admin_id`, `refresh_token_hash`, `token_family`, `is_used`, `used_at`, `status`, `grace_until`, `replaced_by_session_id`, `ip_address`, `user_agent`, `created_at`, `last_active_at`) VALUES
('01246318-6ab4-47fc-8be1-8b69449f9c8a', 1, '26c4d80be6313f6d4500bb72be01b3c444723776adba60cb9a8b234d8cbb1646', '9292b1f8-6335-4f2f-8851-049845a85461', 1, '2026-04-19 13:59:49', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-19 11:50:28', '2026-04-19 11:50:28'),
('05e5c359-6df8-43ee-bce0-80a0c14ec964', 1, '8118e2acbdc7a04ed65ed7e036b3172c2015150f1256824acc723a855acff80c', 'b02ffe0b-7c15-4cdb-ac1c-e1680e79a9b2', 1, '2026-04-08 08:38:43', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 08:19:21', '2026-04-08 08:34:19'),
('0a081e7d-6db7-4ad4-969b-5be0490f7353', 1, '60af318572c5c58f7c78a4be51b94b932a68332709dd33daa20517be25b6b427', '012b611d-605b-4bed-b96c-5e13e721ed84', 1, '2026-04-17 06:12:31', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-16 17:38:05', '2026-04-16 17:38:05'),
('0c133496-4783-46b2-889b-4fd8377b447a', 1, '3afc2b60ab7954b98418260082f0b84650f9254c9cc67d4a9e5932dd1d27bfe2', 'ba74f347-c92c-4091-bd38-1cf583dc78d1', 1, '2026-04-08 14:55:58', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 14:40:47', '2026-04-08 14:55:34'),
('0c398558-a976-4aab-a417-9a1dc6819627', 2, '535a0f670b8bcfa51e5e2d8c75ca5f14f096c6bd5a7b9fe90c407bc1fdc0fc88', '36a92cee-7b82-4816-837b-1416b758ea8b', 0, NULL, 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-16 05:43:36', '2026-04-16 05:44:38'),
('0e4f2276-4f93-4252-834a-ac94ab58acb1', 1, 'b77cd3a4351631c12a03fc7d81b29fdcb692cdaf6acf5c92f2351b6937de6d40', '692c5298-7ac9-409d-83b6-1f578442c6e3', 1, '2026-04-08 06:17:49', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 06:00:07', '2026-04-08 06:12:21'),
('0f55012d-e618-4472-a10c-bb9fece3a1a3', 1, '826b388f3b4c434fe71ec65b207f1d6da78e716375ff2b5dc77809fa02c5c2f0', '0ce1a519-d01a-46a7-9a07-4c586da8e1a1', 0, NULL, 'revoked', '2026-04-16 05:42:59', 'ed7dcd22-fad2-4c2d-a549-bca725e8a705', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-16 04:43:25', '2026-04-16 04:43:25'),
('0f62e008-da21-4749-99c7-9545f6faa290', 1, 'c82aed17effd8d43370fbc29339dff96227476ecd9feb946e27328b6670e613f', '16253bbf-3a16-4c73-b6c9-941789966434', 1, '2026-04-08 09:09:36', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 08:54:01', '2026-04-08 09:08:52'),
('1081cca3-8a69-4054-96dc-f7ef5eafcecd', 1, 'cdd6359f5e749bacf43bea8f731bd414b6d7b4248039397c4024109042f41eb2', 'b6cdc557-52c0-431c-b770-3543814099ac', 0, NULL, 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 10:09:41', '2026-04-17 10:09:41'),
('12833c6a-b1d6-46ca-8688-2f3de73c7c88', 1, '203c1425d708f65eb7ca08de14cc9d580908036a0ccc345a9fd0747e301e7229', '9292b1f8-6335-4f2f-8851-049845a85461', 1, '2026-04-19 15:08:03', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-19 14:52:04', '2026-04-19 14:55:35'),
('16a0b60a-0a39-44cc-a4bc-1dcdb1bda9ff', 1, 'd060aef5057f8e7706e74a696b72b1189959e523d8e5105cbd321194b6de324c', '692c5298-7ac9-409d-83b6-1f578442c6e3', 0, NULL, 'revoked', '2026-04-08 07:08:51', '3cc912a0-7d68-4f7b-8aa1-c17ef6039736', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 06:48:24', '2026-04-08 07:03:16'),
('17ecda94-341c-4988-a5e6-c7e712bf3a61', 3, 'c608be85c56faab1aab14e30f6a139a96bbcefad7a2e90df1e82d15988bceb4a', '969f3372-8403-4d6b-ad01-9f31416d2561', 1, '2026-04-16 12:35:22', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-16 08:38:56', '2026-04-16 08:38:56'),
('19171139-bce4-42ce-8c54-012e983fb60f', 1, '2c5c09bc38742916fc6f90c6e48b607c3318c3b1633b6c5def805f0ab0c7a186', '0313a359-4909-44bb-bfe8-56d34aea9ccd', 0, NULL, 'revoked', '2026-04-17 08:13:08', '3c2c8011-d474-4fa5-8dbd-449e698c1b87', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15', '2026-04-17 08:04:00', '2026-04-17 08:06:55'),
('1c392961-bdcf-4387-954e-c3659f854f06', 1, '0efa75b8b3db1316b0db826be987d7d65f2d675ff03cb84ee51f9a0361702999', '64a148fd-3690-4a94-8849-32504c32fec7', 0, NULL, 'revoked', '2026-04-17 11:11:37', '70e356a1-8be6-4433-b776-abdc1ccebb4e', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 11:05:53', '2026-04-17 11:09:46'),
('201e559a-9f74-4858-95db-97bf5a5ff55d', 1, '06f3c91f8c310e4c35d3b5f085bb5b1566be4a417c3d8423634f88256a9f7732', 'f1a0a6d5-76e4-43f6-bb09-f5d8d2b3cb1f', 1, '2026-04-17 10:44:58', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 10:28:57', '2026-04-17 10:28:57'),
('2028e163-ce6e-4e60-993e-146363e0851c', 1, 'bea337bae20eb916dd4e1c6894df574c6043b74d0db4f634a1a047233daaf598', 'f64bdea2-caf3-40fe-a662-0c6afca7ec2d', 0, NULL, 'revoked', '2026-04-17 11:03:27', '4d636755-ea4d-4cab-b913-196bcdc77c31', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15', '2026-04-17 11:02:41', '2026-04-17 11:02:41'),
('241e10fd-7e2c-4064-8832-fc5d8c11dcf0', 1, 'c27eb04453ba01b4309381f6a99433516f72fd4ec9bbd3aa97078f1070e877b0', '91793264-98c8-4982-b325-79b322dbf6d5', 0, NULL, 'revoked', '2026-04-17 06:24:14', 'bb08925f-3690-448f-8adc-4ee6d2823472', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 06:23:35', '2026-04-17 06:23:35'),
('24cfd6ae-8e73-47ed-aaf5-a7bbd16024f3', 1, '329df7104540aabf35941e64b93549bcccae5f1f9194aa9c4a1b653818b07812', '16253bbf-3a16-4c73-b6c9-941789966434', 1, '2026-04-08 10:16:29', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 09:55:56', '2026-04-08 10:10:47'),
('251a3688-657c-462d-a45d-48ddab796d7d', 1, '38d1a3a26f9bf053a58497a905a2405e06c7f38d7f1d2d743cc40520f6e228cc', '9292b1f8-6335-4f2f-8851-049845a85461', 1, '2026-04-19 14:20:04', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-19 13:59:50', '2026-04-19 14:14:22'),
('25ba4acc-48c2-4296-b179-f64b3aefea03', 1, '016c9890d5551edeedee9798d8b3e4e913a28b1a54edfa4291aff62eff526cc1', '16253bbf-3a16-4c73-b6c9-941789966434', 1, '2026-04-08 09:55:56', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 09:40:16', '2026-04-08 09:55:05'),
('25db69cf-c3df-465d-91c1-66fde1af1abe', 1, 'f220e4925bcd6ea543ca7138019180cfaad26c3e58ff63d50ba55f0713bde5fc', '2e92a5b4-04d2-4a70-95fd-0f93dcfaa26c', 0, NULL, 'revoked', '2026-04-08 08:15:40', 'ec705035-3a4a-439b-a656-52f6f9631efa', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 08:04:12', '2026-04-08 08:15:04'),
('29801c60-d2cb-4af9-8fc7-d33c05987634', 1, 'ca940ef17a0a194dbd4007574419bb1e305562e9b85be32bf6f8705ed31a5a6a', 'b6cdc557-52c0-431c-b770-3543814099ac', 1, '2026-04-17 10:09:41', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 09:53:25', '2026-04-17 10:05:12'),
('2b4f8844-ec45-473b-8478-2fc4da138fcd', 1, '9804b269920098525df32ad1f4643b6ff89a6a4fba7c961cc3df46570c4f7de7', 'af462085-63af-469d-80a7-e7a744b68de9', 1, '2026-04-17 15:59:49', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15', '2026-04-17 14:25:57', '2026-04-17 14:25:57'),
('3113bde3-9dad-4b70-a3d9-b563b54d6cd7', 1, '42cb64279f829da4900a7161d30d49bf8f32289a9dbbf6d00ac7337efd3f7f56', '45c77eb6-f2f1-4096-ac73-a26edf633764', 0, NULL, 'revoked', '2026-04-16 06:56:11', '3cf37224-2710-4f31-af86-51af943af423', '127.0.0.1', 'Werkzeug/3.1.3', '2026-04-16 06:52:38', '2026-04-16 06:52:38'),
('360c09bf-9be7-4d7d-94f3-22705ec58b86', 1, 'ed4363062fcdd83c1580ee28c720d6cd78a644af00e248db4e631b5c1918e8e7', '9292b1f8-6335-4f2f-8851-049845a85461', 1, '2026-04-19 11:50:28', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-19 09:53:27', '2026-04-19 09:53:27'),
('392b1d1a-8a38-4ece-9cbd-96159ef08bd5', 1, '68e35a0001a636c73ccba20829ee88602e86aef874d243159845adbf08cb8376', 'f1a0a6d5-76e4-43f6-bb09-f5d8d2b3cb1f', 0, NULL, 'revoked', '2026-04-17 10:49:02', '6c92e2dc-1af4-4442-9f86-dbb8427dae00', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 10:44:58', '2026-04-17 10:44:58'),
('3a86c60d-e0d7-4e2f-8844-6276228acf25', 4, '48826e584df7120fcd25c1bd433109e10e37836d446169eb19e48f4430a7c144', '2a690910-9a50-4bd2-9f16-240083b3ac8e', 0, NULL, 'grace_period', '2026-04-17 16:02:11', '783a8e4a-cba7-4fab-87fa-b2859c862454', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15', '2026-04-17 16:01:24', '2026-04-17 16:01:24'),
('3c2c8011-d474-4fa5-8dbd-449e698c1b87', 1, '162417c49a4fcc4bc85a8a2c18c6b28d0f8c0af3ce54a8298ac64445f86bf521', '1b3cd090-5a50-46c2-a859-8c03caaf4189', 0, NULL, 'revoked', '2026-04-17 08:13:44', 'ccbe31d6-b8ae-407f-b7a1-0e8c1a005b1c', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 08:12:38', '2026-04-17 08:12:38'),
('3cc912a0-7d68-4f7b-8aa1-c17ef6039736', 1, 'bdf612d66babed49f5f423828153e43b7c42e17837da5caf21390fd0d56959aa', '3f65ad6f-4f92-4875-b743-e0f9c8a56fe2', 0, NULL, 'revoked', '2026-04-08 07:09:04', '507d9ae5-f6b5-4308-8d26-7fdc5a235c7a', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 07:08:21', '2026-04-08 07:08:31'),
('3cf37224-2710-4f31-af86-51af943af423', 1, '7c6da8d28e013066114f954ccc1dc33ab625d2f8d0ba571be850a41996fbfc2f', 'f01a56ac-b303-4555-a448-ae3fd552ab57', 0, NULL, 'revoked', '2026-04-16 07:17:53', 'eae9187d-bd2f-43e0-bd33-dcf0472d0412', '127.0.0.1', 'Werkzeug/3.1.3', '2026-04-16 06:55:41', '2026-04-16 06:55:41'),
('3d3635b7-4e3c-4865-8eec-297df1e70a7f', 2, '98e9684c9beccf134e05eb05afec35064c7bd0aa015d4f1c8cdd49bb4289bb32', '78a05734-5aca-486c-9140-8be308d0c146', 0, NULL, 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15', '2026-04-17 06:17:53', '2026-04-17 06:17:53'),
('4092e219-2858-44f2-a40b-e7de805b4c46', 1, '8eaec1df0f4fc96c2f8994e35ed6e13bcc2ec5de0b4fa0435f5248ee056526a1', '9292b1f8-6335-4f2f-8851-049845a85461', 1, '2026-04-19 14:52:04', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-19 14:20:04', '2026-04-19 14:28:39'),
('41e80e10-d7cd-40a4-8a08-930f97c60d2d', 2, '1fe52fa1132124c7bae14dcee279cce7cf5cee24617d7d6088c08ca8e24ed007', '7cb7b337-142e-4716-9bf7-3cf929f2661d', 0, NULL, 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 16:01:16', '2026-04-17 16:01:16'),
('42eb525a-4739-45db-b6e3-1d4bb33cd2f3', 1, '0f5487d48c6fdc120b4fa4b2db4bfc3ec007d57609ae6953a3ff4160544ec151', 'e3c166b9-c643-4c61-beec-3f85c2eaccaa', 0, NULL, 'revoked', '2026-04-17 07:42:51', '9dbf0e21-d034-4bda-8d80-f9e701d78282', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15', '2026-04-17 07:42:12', '2026-04-17 07:42:12'),
('43f274b3-c4b4-4763-9711-f50b1ad8eb81', 1, '0a4a9cb3f0aeb0d6658f8d482b6eb16fff3b94d75cb904c2fde1fbd0589d62e0', '93ef01d8-c83e-4257-a59c-30652f41b06d', 0, NULL, 'revoked', '2026-04-17 09:38:11', '55b35246-d80b-4681-bc71-b7e76ac4d059', '127.0.0.1', 'Werkzeug/3.1.3', '2026-04-17 08:41:51', '2026-04-17 08:41:51'),
('455ce527-02d3-43ce-a9cd-683befaba4a9', 2, '087a4fd2eaa97833923b37f7d0e92191f03a1a57c23fe6c52bf62d5498239dd8', '82596c3b-2020-43fb-a75b-7fe6580967e3', 0, NULL, 'revoked', '2026-04-08 07:08:29', '987ee30c-1fd1-41b1-9864-e35e978079b9', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 07:07:39', '2026-04-08 07:07:59'),
('46fa3262-9a83-4e29-9ff7-52af8bd2ad86', 1, 'c48165fa334139c871e87334cfe7b424eb868f42b24ba07d58c005b8383172a4', 'b6cdc557-52c0-431c-b770-3543814099ac', 1, '2026-04-17 09:53:25', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 09:37:59', '2026-04-17 09:51:51'),
('4af64ec7-f763-4321-b81a-b06bb1e5fa2e', 1, '7ab46a0296dc2ad92b10241cf275ba1dfc3f23d2f40affb6dd6911b8540bc046', '1546f149-3d0b-4062-b8bc-a3e5a6c67843', 0, NULL, 'revoked', '2026-04-17 10:12:37', 'bf97a6a4-61ca-4648-9e5f-913740e3c4d2', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15', '2026-04-17 10:11:45', '2026-04-17 10:11:45'),
('4d636755-ea4d-4cab-b913-196bcdc77c31', 1, '155627fea12c0cd6b5dbf3ff3a09a8d2444b84316c090d85918fff9721051782', '099c6127-03a8-4a86-8241-480678024d8f', 0, NULL, 'revoked', '2026-04-17 11:03:49', 'be64c483-4cec-47ff-ad09-91d2576b285b', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 11:02:57', '2026-04-17 11:02:57'),
('4e491c4d-4b23-4971-b146-e38230a87f92', 1, '60b38e0b62c54388f60144b172fad0f70f8f32ee5a14e5a11e09b75ba412f306', 'd219e74b-87e7-4f51-9ff5-970f2da72e68', 0, NULL, 'revoked', '2026-04-17 07:54:55', 'abfc3d0e-220a-412a-b847-e5b66ef066ce', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 07:53:55', '2026-04-17 07:53:55'),
('4e6a4bbd-0714-400a-ac50-2b9693fbc4f3', 1, 'eafc8523bf6de1ff63f68235b3f85619eb9c0aa091bbcc75b340ddf021586f31', '6b143dd3-2223-46e9-8d0c-c92ae47f2ec8', 0, NULL, 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-16 08:38:12', '2026-04-16 08:38:12'),
('500b4a87-360e-4438-84a7-3dac60c2cb4a', 1, '728cfb6b23dde0d1c0b03df433d2b58c94790cfa1df4de4c7692df5b02759582', '24ee87c3-55f9-4631-82c4-abb249a22487', 0, NULL, 'revoked', '2026-04-17 14:02:39', 'dd0b5208-0ad3-4abf-b062-61c5070b7378', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15', '2026-04-17 14:02:03', '2026-04-17 14:02:03'),
('507d9ae5-f6b5-4308-8d26-7fdc5a235c7a', 1, '2efb9ba3b1ee178c2d6e8c3dfc71f7174d0ca304077d054176ec71f143828a63', 'd7bda157-6252-467c-b526-b779ec6b845c', 0, NULL, 'revoked', '2026-04-08 07:15:11', 'f2ff4696-861c-48cb-a5c3-f0d5f338a5d3', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 07:08:34', '2026-04-08 07:14:26'),
('509f4eca-ca45-4da0-b0d5-bbdc94f72ba4', 1, '5737981a2addcf405d9b720920ca1e5189d89a47d2e0e7147f261901bf5e2349', '09c02e0d-dc05-4bda-9856-feaa9052f076', 0, NULL, 'revoked', '2026-04-08 07:26:29', '7d724e6f-b677-48f5-a413-0072eec662de', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 07:22:15', '2026-04-08 07:22:56'),
('535dbb52-b46a-40be-8f01-2f400f403a1f', 1, '813fa43c2ac999e1cf348fd3277fc4be6113d55dce01eddd4eef4dfd886efcad', '87069cf2-b5e1-496f-bc11-e51f7ce504f3', 0, NULL, 'revoked', '2026-04-17 06:20:50', '853405d2-db31-498a-8a5c-10e8687a4fae', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15', '2026-04-17 06:18:37', '2026-04-17 06:18:37'),
('54398719-9a6c-498a-b9f8-dde91571fa43', 1, '4310ad9e224ad92edc71dd692fa470d2871ed873027f698915cc6ff78c94caf4', '53e5b915-9764-4914-b5de-0c6b8a12c473', 0, NULL, 'revoked', '2026-04-16 06:05:41', 'ec2cb7a2-1682-4ea3-93a8-91ea3dd38dc2', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-16 06:03:21', '2026-04-16 06:04:53'),
('54be4756-284d-40d8-b2ab-7d360c38bbb2', 1, 'faa0c3bda0799c206cda25a7420027f9522e85f67f669bbad1a936909393711d', '939640b8-d757-40a0-a3d8-80118608e94d', 0, NULL, 'revoked', '2026-04-17 08:22:43', '96205c35-b3df-4e4b-9f77-158a16e94663', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 08:21:51', '2026-04-17 08:21:51'),
('55b35246-d80b-4681-bc71-b7e76ac4d059', 1, 'f250f54b7d43390c8e6468bdef9679640db5e9571bfbb50e211e03f682e31404', '4bf28907-133d-4fa4-a734-81aa0ee12dae', 0, NULL, 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 09:37:41', '2026-04-17 09:37:41'),
('57dc6225-10a9-42b1-869c-fb131972d15c', 3, '1884923d6f55d814c256fd63f790746d894efb5f22b22b95395000652563aa14', 'b99bb1c0-8a98-4881-b5d8-71ce368facb6', 0, NULL, 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15', '2026-04-17 10:16:01', '2026-04-17 10:16:01'),
('5cad4971-76f9-4af2-837b-e63dbc73b194', 1, '0421637dc426986782893fc5b7a4a873502901d1eef71f219154da22fd6483ed', '16253bbf-3a16-4c73-b6c9-941789966434', 1, '2026-04-08 09:25:12', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 09:09:36', '2026-04-08 09:24:28'),
('5f8a0151-8279-4a07-8686-b46d64b4c8e4', 1, 'c253a677dfbe36a4d84db94e25027c07854a05db715436baec4589b46e470d25', 'ba74f347-c92c-4091-bd38-1cf583dc78d1', 1, '2026-04-08 15:32:16', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 15:12:23', '2026-04-08 15:27:13'),
('63aa2a89-bc7c-4f16-90b4-bf2f9c91a37b', 1, 'a6d661a0473d93b7eb0293ab55a2d1f71a3f95685abc9db55b2699853e61731e', 'e8a9d020-1118-4056-bf08-f2fc031cf92c', 0, NULL, 'revoked', '2026-04-17 07:47:25', 'c41245e7-331b-426f-a302-93a1e12ba244', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 07:42:21', '2026-04-17 07:42:21'),
('6862d5c8-0dd6-45c1-9e54-70bebaa851ba', 3, '42d70f0588f4fe43cbdb341c38c7697f5f4f98415d19abefa94f557fcce061ee', '969f3372-8403-4d6b-ad01-9f31416d2561', 0, NULL, 'grace_period', '2026-04-17 10:16:31', '57dc6225-10a9-42b1-869c-fb131972d15c', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-16 12:35:22', '2026-04-16 12:49:31'),
('6c92e2dc-1af4-4442-9f86-dbb8427dae00', 1, '2ba68b43373135dcb4d7787f59ebf99c72a0d643f3ddda8c8496697a78da189c', '69fd00e3-7f85-4073-84aa-6a8090a0eaa6', 0, NULL, 'revoked', '2026-04-17 11:00:28', '8fb6f58a-7f40-4aa4-bdc1-9995f0f71551', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15', '2026-04-17 10:48:32', '2026-04-17 10:59:46'),
('6dd10ddb-582f-4d40-bd65-2fb9096c0ea6', 2, '80d5b6724618f316a6829ed6ea33197251e0e7c6829a7b418a44d6f14005d68b', '2765e3e6-df19-4d17-99e3-f888b23188ca', 0, NULL, 'revoked', '2026-04-17 10:16:40', 'b96df80a-1942-4e13-bf9e-0f99f7fa644c', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 10:15:49', '2026-04-17 10:15:49'),
('70e356a1-8be6-4433-b776-abdc1ccebb4e', 1, 'c74efcbe6b3bf30a47df97f44cd1c47741839f465b744c7a95068dce9181dc98', 'd9bf614f-8612-42f9-8ab4-f48d7396402b', 0, NULL, 'revoked', '2026-04-17 11:15:38', '84c4e3b6-42d8-4d3d-a1fd-a71c76ffa725', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15', '2026-04-17 11:11:07', '2026-04-17 11:11:07'),
('72e051c3-5cf2-4bd8-bd21-9bbf72a36397', 1, 'ddf79e00d49767657cfb27a32ac04c45d6b1e4010b4183d08699dbc6d71d254f', '4cdce822-28f2-4b10-bb75-29255e263a16', 0, NULL, 'revoked', '2026-04-16 04:43:55', '0f55012d-e618-4472-a10c-bb9fece3a1a3', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-15 15:44:06', '2026-04-15 15:44:06'),
('734f9ba4-ab73-4218-930e-3b4654d3bd99', 1, 'ebac37e535ab4652365c2e9a9d12728fa0a29bc3dbbf6883fc8463dbc00e2ae3', '9292b1f8-6335-4f2f-8851-049845a85461', 0, NULL, 'active', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-19 15:08:03', '2026-04-19 15:08:03'),
('74558b40-e3c9-44f9-b50b-eef331640e1a', 1, '96fc4220a2084a1c571d8e78e9ba8f2bba14b0f80c85f734b86db9d95a8be19a', '6d3fae0c-9430-40b7-b1c4-d25f7fff2e44', 0, NULL, 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 16:00:48', '2026-04-17 16:00:48'),
('75899196-c505-4e4c-b5ac-c34f3b2c9496', 1, 'd98ae3e35d910e36aea74c56f451e8962125f332f975c6d1d774671d4173b9f5', '24ee87c3-55f9-4631-82c4-abb249a22487', 1, '2026-04-17 14:02:03', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15', '2026-04-17 13:22:09', '2026-04-17 13:22:09'),
('783a8e4a-cba7-4fab-87fa-b2859c862454', 4, '316927ae19a164cb37dc6b70f399dcc7e6311ea6b17c598591ef8dfad75c685d', 'e1cbd953-3534-4720-9e27-45df55d410e3', 0, NULL, 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 16:01:41', '2026-04-17 16:01:41'),
('79d195a0-4f3c-4c2b-9e85-3b40ee07b255', 1, '7ff269c25511afc84a07917311590c10f371275a2f4cba2f3f5571b023858018', '692c5298-7ac9-409d-83b6-1f578442c6e3', 1, '2026-04-08 06:33:19', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 06:17:49', '2026-04-08 06:31:25'),
('7ac7793b-cf49-4660-aef0-a51519de1532', 1, '2e09633362d37bab9d8b4c30f8856d6150230e6d59de1a4bcafb079a79ac7a0e', '16253bbf-3a16-4c73-b6c9-941789966434', 0, NULL, 'revoked', '2026-04-08 10:18:02', 'df033c97-e147-4108-814c-ebde93a133df', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 10:16:29', '2026-04-08 10:16:29'),
('7cc109c8-0205-4a8d-9bef-c5109c524669', 1, '984a82017ae6d7951984cf2029b32370bf37c2309f9a96b28899587da1708987', '16253bbf-3a16-4c73-b6c9-941789966434', 1, '2026-04-08 09:40:16', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 09:25:12', '2026-04-08 09:40:08'),
('7d724e6f-b677-48f5-a413-0072eec662de', 1, 'c3f66f671fa701a31d4c56db0efe75d8392491c9b1bcff12c1ec8b1cc554f04a', '93a9993f-4fa4-4a67-8713-717a97116851', 1, '2026-04-08 07:41:42', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 07:25:59', '2026-04-08 07:40:51'),
('7ea2ea43-9499-48a4-9369-3b04430e49cc', 1, '9f4660bfb0a8aedfc078d016b9f4ff7f63fdf1a35d063c47596f33e5d199068d', '45eed28a-e607-419d-b1cd-1c3028ce9b45', 0, NULL, 'revoked', '2026-04-17 16:01:18', '74558b40-e3c9-44f9-b50b-eef331640e1a', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15', '2026-04-17 16:00:24', '2026-04-17 16:00:24'),
('84c4e3b6-42d8-4d3d-a1fd-a71c76ffa725', 1, 'f61c5ea21db9f9e749be69c7718a081318a022bc43fad42d98fd2c8a9f534cc8', '8f3c9380-5f0c-40c3-a963-a4f6613297e8', 0, NULL, 'revoked', '2026-04-17 13:22:39', '75899196-c505-4e4c-b5ac-c34f3b2c9496', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 11:15:08', '2026-04-17 11:15:08'),
('853405d2-db31-498a-8a5c-10e8687a4fae', 1, 'b2fbac44bc18c4fbff948f19352081c00b8dd38ea19e984d2d76e820b73bd60d', '971110ab-26f8-4bee-8605-4360cc732c00', 0, NULL, 'revoked', '2026-04-17 06:24:05', '241e10fd-7e2c-4064-8832-fc5d8c11dcf0', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 06:20:20', '2026-04-17 06:22:02'),
('8564f35d-eb44-4e33-895f-f597afa5feb6', 1, '8dc284df8975ef712c66be3daef338b1f460ddc265e38b93a036d37f58cb2d62', 'bd5bfcfe-f70e-42b7-8f76-c27d7d04a2d1', 0, NULL, 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-16 08:36:23', '2026-04-16 08:36:23'),
('8be2c7ac-6230-41b8-b84e-3d53ef352590', 1, '42b3b29c255d9478b9cb23bfa805a043496818c7d5cbf9740adc45a2442c7a66', '1583f927-0c96-4f95-8b6e-bb6a8d183232', 0, NULL, 'revoked', '2026-04-16 08:36:00', 'e806c7f5-9f59-4942-82e1-ef3f0fd4ca55', '127.0.0.1', 'curl/8.6.0', '2026-04-16 08:35:30', '2026-04-16 08:35:30'),
('8c1ce7e0-31a4-47ad-b1e1-15ee0e30f031', 1, '19d8520473533e0b5cc6ecf95b228bda8cb60870b3d7866f43b3db12fde0e306', 'fc755144-f762-4db9-85c9-66e883d88bc4', 0, NULL, 'revoked', '2026-04-17 08:18:05', 'a8494445-d551-4465-a0e1-33418eb128c6', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 08:17:18', '2026-04-17 08:17:18'),
('8f04497b-9cc8-4ca2-9d70-6abc8eac088e', 1, '50e1ff3b8a9375bec9e73f42ffcfdb62b49dfaa4f600fd700405437daa408f08', 'af462085-63af-469d-80a7-e7a744b68de9', 0, NULL, 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15', '2026-04-17 15:59:49', '2026-04-17 15:59:49'),
('8fb6f58a-7f40-4aa4-bdc1-9995f0f71551', 1, 'f42e953358068b2696a8a3ce2ebbfa85af92320128fc5f596e3982db67538d87', 'f8b12f68-5c6c-440d-864e-923234e85c7c', 0, NULL, 'revoked', '2026-04-17 11:03:11', '2028e163-ce6e-4e60-993e-146363e0851c', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 10:59:58', '2026-04-17 10:59:58'),
('91aaa14e-3830-448b-afa8-d50b8ea291a9', 1, '624418c763769f20527d98712a2fa864e9607cc4e09869def7a34d36f5c82eab', '93a9993f-4fa4-4a67-8713-717a97116851', 0, NULL, 'revoked', '2026-04-08 07:50:05', 'aed384ef-aa69-4aac-94d4-7207e033ee1e', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 07:41:42', '2026-04-08 07:45:37'),
('96205c35-b3df-4e4b-9f77-158a16e94663', 1, 'ca93a7d962506dfcb7110b30371a8bb5977501f34c2a4c93f244d3af70f4eb3c', '657b11ea-50bc-4672-bf31-24e811cc5398', 0, NULL, 'revoked', '2026-04-17 08:42:21', '43f274b3-c4b4-4763-9711-f50b1ad8eb81', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15', '2026-04-17 08:22:13', '2026-04-17 08:25:55'),
('987ee30c-1fd1-41b1-9864-e35e978079b9', 2, '7e6f53cf1e3d9556357c6aaf2df3b6b3821b385575a68a8c2a7a0e13c328f7da', '7596aca0-aec2-422f-98d1-d973e36e051c', 0, NULL, 'revoked', '2026-04-16 05:44:06', '0c398558-a976-4aab-a417-9a1dc6819627', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 07:07:59', '2026-04-08 07:08:29'),
('9dbf0e21-d034-4bda-8d80-f9e701d78282', 1, 'c74fcd6b43ea8684ad147232fd4d892d881d6f4d51f0571a731b98c24807e7aa', 'fa0d00ce-a089-4bef-9b68-aad34cabad57', 0, NULL, 'revoked', '2026-04-17 07:42:51', '63aa2a89-bc7c-4f16-90b4-bf2f9c91a37b', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 07:42:21', '2026-04-17 07:42:21'),
('9feb1fb9-cbb2-4cac-9a1a-20a422770aab', 1, '5e341179aebfb8312b815bdb05db332aa25161940ee14323ef73de20e94c48b3', 'b38fad1a-bd61-48c2-98bc-a0b85f83b23e', 0, NULL, 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 15:59:57', '2026-04-17 15:59:57'),
('a03d6411-2b10-44df-a3a7-c9083c2b72f9', 1, '0dc9ffe88f90b11965c73f3599deaa9a3d6dc12f01abcaf515412c22bfbace3e', '518705ad-8dcc-42ef-849b-cd2ac7286b28', 0, NULL, 'revoked', '2026-04-16 06:46:04', 'f3f9be3c-2c56-4962-a0e1-9c346becd59f', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-16 06:27:09', '2026-04-16 06:28:36'),
('a1a52c6e-3e55-451a-a72e-0810dfee29f0', 1, 'cf33ef37c9b4946a53bcd31fe9a49fed62e9331ff1f869d90303905d81623131', 'b6249de8-2bc7-4e40-83d1-b196cc0718e9', 0, NULL, 'revoked', '2026-04-16 06:53:08', '3113bde3-9dad-4b70-a3d9-b563b54d6cd7', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-16 06:48:33', '2026-04-16 06:48:33'),
('a4f5636e-886b-4e74-977d-9b070443417b', 1, 'b680d13aa6d2526865cdd54d044269a080a05a4f19baa14d1c011ed6f5e83cbb', '4731f5bc-6302-44b3-966c-75dd73c595ba', 0, NULL, 'revoked', '2026-04-17 08:04:30', '19171139-bce4-42ce-8c54-012e983fb60f', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 08:02:27', '2026-04-17 08:03:33'),
('a81765b2-cf19-4a13-8630-5a7fe820181b', 1, 'a5b70e433c96bbe300ee8eab3d1f0b4ca98f7346faa09247925a2f33cbe43f86', '658c7cc7-c62c-4e4a-bb10-cda2db4e7b3b', 0, NULL, 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15', '2026-04-17 06:18:05', '2026-04-17 06:18:05'),
('a8494445-d551-4465-a0e1-33418eb128c6', 1, '38397cf2edd353ff598bba799b0601007119e52e6de3e7a8281df62c0b163390', '2deaa694-8757-4344-83c1-4e529ba4ef2d', 0, NULL, 'revoked', '2026-04-17 08:22:21', '54be4756-284d-40d8-b2ab-7d360c38bbb2', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15', '2026-04-17 08:17:35', '2026-04-17 08:21:47'),
('abfc3d0e-220a-412a-b847-e5b66ef066ce', 1, '782b1d321b073646ff602cf8acd62f55b35c9081c21e2aa3ea27c8b9cfdfe6ba', 'e24eac09-e395-4929-a82f-b6badc9a787b', 0, NULL, 'revoked', '2026-04-17 08:02:57', 'a4f5636e-886b-4e74-977d-9b070443417b', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15', '2026-04-17 07:54:25', '2026-04-17 08:01:37'),
('ad678270-5803-4632-8666-d391686d7bc5', 1, '1686da292e7a73179c8ebff043d8a7a0b91d676ea1a3afe91ce797d28307a522', 'ebf3c4e9-6a6b-4c1c-aefd-a7ab69b491fb', 0, NULL, 'revoked', '2026-04-08 08:04:42', '25db69cf-c3df-465d-91c1-66fde1af1abe', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 07:52:57', '2026-04-08 08:04:04'),
('aed384ef-aa69-4aac-94d4-7207e033ee1e', 1, '9122813bd4c6727b63803bfedf3b7b0d7bcfed23a35bd938d2025c05c72cec55', '393c59dc-fb9b-4927-85a9-0fbf36bc0026', 0, NULL, 'revoked', '2026-04-08 07:53:27', 'ad678270-5803-4632-8666-d391686d7bc5', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 07:49:35', '2026-04-08 07:51:51'),
('af8af6fd-1170-4a60-9cab-3216037137f1', 1, '8b0b75bc530fa4faabb572235bbdfcbc8a32b23873f503301b9eae2bf2a1fdf3', 'ba74f347-c92c-4091-bd38-1cf583dc78d1', 0, NULL, 'revoked', '2026-04-15 15:44:36', '72e051c3-5cf2-4bd8-bd21-9bbf72a36397', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 16:05:25', '2026-04-08 16:08:26'),
('b0bc10c3-bd2d-4cb3-9dea-11a11631f8c8', 1, '4eaf1de396183de7910d21973c3fa4c9e69bd1c44b39167c9f0deb2fb71cb448', '3e9ddfed-a0b1-4c47-adb7-ac7503bfc142', 0, NULL, 'revoked', '2026-04-17 10:12:15', '4af64ec7-f763-4321-b81a-b06bb1e5fa2e', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 10:11:23', '2026-04-17 10:11:23'),
('b24e28b7-7182-4fc6-aaa5-d1504b320337', 1, '9ef1cf3ebbc3b3d86916280ecfee2c203000b701dc2235173881ba765fee3885', 'efdee0c4-d6fd-45c7-9b3f-58d1aa2ed6af', 0, NULL, 'revoked', '2026-04-17 07:42:42', '42eb525a-4739-45db-b6e3-1d4bb33cd2f3', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 07:25:46', '2026-04-17 07:27:18'),
('b46c57cc-bceb-4949-96a1-73f2103f4e49', 1, '7276261444d0528d5c647186a3e5e0c7cce2588d79be045e896329567dae359f', 'ba74f347-c92c-4091-bd38-1cf583dc78d1', 1, '2026-04-08 15:12:23', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 14:55:58', '2026-04-08 15:10:45'),
('b8a38782-f272-40e1-8ea1-9636e0a87abb', 1, '99138537d4fdeaeb14c8e47842cc62c2ced63473de65c8b29112d086c58ea787', '692c5298-7ac9-409d-83b6-1f578442c6e3', 1, '2026-04-08 06:48:24', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 06:33:19', '2026-04-08 06:48:10'),
('b96df80a-1942-4e13-bf9e-0f99f7fa644c', 2, '3460c6bf6c184df784f48e0e1ddecd9cc72991e2e9917bd2995ed0b9ac561c8c', '7e2dcfbc-9656-4f3b-a093-fed02f5275b8', 0, NULL, 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15', '2026-04-17 10:16:10', '2026-04-17 10:17:14'),
('bb08925f-3690-448f-8adc-4ee6d2823472', 1, '481843e90b1705036582bca159b631cf1d36ea9ebf1b8751fd5677e25f5a52dd', 'ab683d0e-e954-47f3-93e3-d09a4b494b83', 0, NULL, 'revoked', '2026-04-17 07:26:16', 'b24e28b7-7182-4fc6-aaa5-d1504b320337', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15', '2026-04-17 06:23:44', '2026-04-17 06:23:44'),
('bc143327-990e-4416-a810-7fc6cb2def4d', 1, '386ab72795124f12a943dd03eed88b72e70bd998e9d5242abff62f657fc69c4c', 'ced41f1b-21ac-4973-b8ad-2a695c6cb924', 0, NULL, 'revoked', '2026-04-16 08:36:00', '8be2c7ac-6230-41b8-b84e-3d53ef352590', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-16 08:33:50', '2026-04-16 08:33:50'),
('bd559b89-db97-4b8c-b826-a961bb5c4ca7', 1, '66068a6fd75ceaa5e6b2bf58471d8fd1106fcddf134e53a3134f2c49b46fb946', '9ef17842-2dd5-41a1-b5da-a289c43a5ab5', 0, NULL, 'revoked', '2026-04-16 17:38:35', '0a081e7d-6db7-4ad4-969b-5be0490f7353', '127.0.0.1', 'Werkzeug/3.1.3', '2026-04-16 08:59:42', '2026-04-16 08:59:42'),
('bd641d1a-0b81-41fa-a5fe-a0862cc86e16', 1, '8e44e60424861ba5a862b5111961aecc4ca89f622477c84d751ad7b14aa9fa0b', '3896f0cd-3378-46a8-89c1-9d730dbe4342', 0, NULL, 'revoked', '2026-04-17 10:29:27', '201e559a-9f74-4858-95db-97bf5a5ff55d', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15', '2026-04-17 10:17:18', '2026-04-17 10:17:18'),
('be64c483-4cec-47ff-ad09-91d2576b285b', 1, '85c5ad5a03770a5e16dc973e53296d5d020a0c96c0fdfc869879b49fe33b000c', 'f03a6128-a5c5-4319-b953-3f4afd4cfdf2', 0, NULL, 'revoked', '2026-04-17 11:06:23', '1c392961-bdcf-4387-954e-c3659f854f06', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15', '2026-04-17 11:03:19', '2026-04-17 11:05:45'),
('bf97a6a4-61ca-4648-9e5f-913740e3c4d2', 1, '229ae0fd780c5e205153e39b6e43870ca07fcc2d2c3c9b02447c4efe3b0fef4d', '670ab978-a0c4-4ab8-ac6f-d4b8489ba0e7', 0, NULL, 'revoked', '2026-04-17 10:16:02', 'c3bbb45e-0291-47e5-8c21-e17ff198e233', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 10:12:07', '2026-04-17 10:15:09'),
('c010e1f7-8db2-4897-8ba4-ef4552f794b6', 1, 'f80c4e5e167e93524a67554ce58ca758719d34467cf69ec5d1214025c0b819eb', 'ba74f347-c92c-4091-bd38-1cf583dc78d1', 1, '2026-04-08 15:47:46', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 15:32:16', '2026-04-08 15:47:01'),
('c3bbb45e-0291-47e5-8c21-e17ff198e233', 1, '4090306c373da2e91d736cb56e4d7a7923adc405442b8be348f694181e9359f8', '0d3b2abf-6f32-4187-b410-efbee7366091', 0, NULL, 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15', '2026-04-17 10:15:32', '2026-04-17 10:15:32'),
('c41245e7-331b-426f-a302-93a1e12ba244', 1, 'f6d268a17e4e59666f509273abad87d763812246e36e7d4c0c57835a30a1a234', '5a97a594-07fa-4802-a9a5-ebefc3a4eed5', 0, NULL, 'revoked', '2026-04-17 07:54:25', '4e491c4d-4b23-4971-b146-e38230a87f92', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 07:46:55', '2026-04-17 07:50:56'),
('ca77daca-2a64-4413-ab22-20c7c6fedb10', 1, '848aeaf4c4bd1496df193dce8a3c3f111067f35bf68ff3f33bd498e0c8913b84', '9292b1f8-6335-4f2f-8851-049845a85461', 1, '2026-04-19 09:53:27', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-19 05:48:40', '2026-04-19 05:52:45'),
('ccbe31d6-b8ae-407f-b7a1-0e8c1a005b1c', 1, 'c794ec93f508b5deb0fe78d8157216e421e450713e789c0fa4d34f426c0ab784', '21bb1420-0227-448f-996d-e343513b62af', 0, NULL, 'revoked', '2026-04-17 08:17:48', '8c1ce7e0-31a4-47ad-b1e1-15ee0e30f031', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15', '2026-04-17 08:13:14', '2026-04-17 08:17:01'),
('ce8b44f5-2b4e-411f-a2f3-66a5a44960c3', 2, '85c868dff0366fdef8a4cdbc091834f4be56e09c8e9e126fe454218250ad22e5', 'd04b37b7-fc25-4ee1-a3d5-dbdb15d9040b', 0, NULL, 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-16 08:36:49', '2026-04-16 08:37:55'),
('dd0b5208-0ad3-4abf-b062-61c5070b7378', 1, 'd09661938fb26051007ccac93ffd0ca338b0d00b100c46737bfb2f94cea6e6b9', '5141f0e7-6a4a-4cdd-b44e-656d97c6832d', 0, NULL, 'revoked', '2026-04-17 14:26:27', '2b4f8844-ec45-473b-8478-2fc4da138fcd', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 14:02:09', '2026-04-17 14:04:44'),
('dd861dc2-d4d2-47a6-a540-058a0f00ae49', 1, 'eb16ab54715135b8d885441cda1a6c392e72ae2c4b2013cbae2459d205a136d6', 'f2a3d5a4-832a-4927-9fe6-415068bf130e', 0, NULL, 'revoked', '2026-04-08 08:54:31', '0f62e008-da21-4749-99c7-9545f6faa290', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 08:48:18', '2026-04-08 08:53:48'),
('df033c97-e147-4108-814c-ebde93a133df', 1, '5e0beda65ef52c0afecd2e6e3dec80420d24860903f56d353f99c67b950f0a03', 'de83915f-c70c-496c-b7b1-d5d68dd977b3', 0, NULL, 'revoked', '2026-04-08 14:41:17', '0c133496-4783-46b2-889b-4fd8377b447a', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 10:17:32', '2026-04-08 10:28:43'),
('e55e2ab6-2b69-4712-9ee9-1ed9622cc299', 1, '2f7b4eb7b5e156831d0de83bb69bd845a535684afc4e29238b44d1ed5e778cc0', '518705ad-8dcc-42ef-849b-cd2ac7286b28', 1, '2026-04-16 06:27:09', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-16 06:09:51', '2026-04-16 06:09:51'),
('e806c7f5-9f59-4942-82e1-ef3f0fd4ca55', 1, '398249b5f9c874869721c887cd74e6e06cd0998627e06a18855ed4314c3aa88b', '7df25005-3b4e-4e04-96a7-673eb6c6e529', 0, NULL, 'revoked', '2026-04-16 08:36:53', '8564f35d-eb44-4e33-895f-f597afa5feb6', '127.0.0.1', 'curl/8.6.0', '2026-04-16 08:35:30', '2026-04-16 08:35:30'),
('eae9187d-bd2f-43e0-bd33-dcf0472d0412', 1, 'b03ee97ef859860dc043803a754d78e0be98c14c3d1680a4b7c68a4e9a7dc63c', 'd3794a77-c12e-404f-8eda-8ca94648386f', 0, NULL, 'revoked', '2026-04-16 08:34:20', 'bc143327-990e-4416-a810-7fc6cb2def4d', '127.0.0.1', 'Werkzeug/3.1.3', '2026-04-16 07:17:23', '2026-04-16 07:17:23'),
('ec2cb7a2-1682-4ea3-93a8-91ea3dd38dc2', 1, '131e8e781c56ca2cf9d5f45803b0c23540b14ab87d8d8c03f4a75bb6b9d743d5', '93dc4c6d-c41b-443f-982f-3e839cb4e76d', 0, NULL, 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-16 06:05:11', '2026-04-16 06:09:34'),
('ec705035-3a4a-439b-a656-52f6f9631efa', 1, '95488f304da5f9d8a74ec126d21c7caba8b94c9797210a4f3b0527cd50115bd1', 'c7371f3b-eb80-4cb8-b653-afe541b44333', 0, NULL, 'revoked', '2026-04-08 08:19:51', '05e5c359-6df8-43ee-bce0-80a0c14ec964', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 08:15:10', '2026-04-08 08:18:52'),
('ed7dcd22-fad2-4c2d-a549-bca725e8a705', 1, 'ee1dfeefb58679c73d7eae9a83d4d3b06f3eb2594692309551fca4df74c9e03a', 'abd410a4-b1ae-479d-97da-1ef5c4f8b55d', 0, NULL, 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-16 05:42:29', '2026-04-16 05:43:29'),
('f089adf0-2e34-47dd-9372-4ad0758edd7c', 2, 'a6841166e3e47e87865c7cea0b9ec9d7fe35a1870b29ddf09b5fe8e2103fc8bc', 'a34bf197-a497-4e0f-b459-bea4b3d80cc7', 0, NULL, 'revoked', '2026-04-08 07:08:09', '455ce527-02d3-43ce-a9cd-683befaba4a9', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 06:59:42', '2026-04-08 06:59:42'),
('f2ff4696-861c-48cb-a5c3-f0d5f338a5d3', 1, '86f0c77fe18491a127c41d5781d9e5a8bf5d0c1244d8f142f0f80171fe4c647f', '11704931-0919-4494-83cb-404ce2c77a75', 0, NULL, 'revoked', '2026-04-08 07:22:45', '509f4eca-ca45-4da0-b0d5-bbdc94f72ba4', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 07:14:41', '2026-04-08 07:16:52'),
('f3cc4fd3-9796-4df2-9bbc-35acf594b55e', 1, '962ad9244ddc64c1eb0bdd5d047cd3666bdc1fd8a8b154482b0b11bedbc2bef8', 'ba74f347-c92c-4091-bd38-1cf583dc78d1', 1, '2026-04-08 16:05:25', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 15:47:46', '2026-04-08 16:02:41'),
('f3f9be3c-2c56-4962-a0e1-9c346becd59f', 1, '595a0b8a89dff1e01e2b25f4eadf335bd73b5b7caf922c225ae4f0c46cd40119', '5d168d0c-23d2-45a7-a1c6-d73fd9e4e116', 0, NULL, 'revoked', '2026-04-16 06:49:03', 'a1a52c6e-3e55-451a-a72e-0810dfee29f0', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-16 06:45:34', '2026-04-16 06:45:34'),
('f41dc3fa-3138-47ae-b327-f6b86864b8ac', 1, '6d26312046d3ab49f02192307a2e925bf8210ef985ed24fc35b43399802d79ba', 'b26f14ad-2955-4004-a042-115e340c102b', 0, NULL, 'revoked', '2026-04-17 16:00:54', '7ea2ea43-9499-48a4-9369-3b04430e49cc', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 16:00:10', '2026-04-17 16:00:10'),
('f5f354a5-7329-4a81-88af-db0d18599adc', 1, 'd743ae14a92fd1a4b2fe915c7594779796298c9046e4c39d1acec84ba9f13a72', '012b611d-605b-4bed-b96c-5e13e721ed84', 0, NULL, 'revoked', '2026-04-17 06:18:35', 'a81765b2-cf19-4a13-8630-5a7fe820181b', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-17 06:12:31', '2026-04-17 06:17:34'),
('f7a8a559-02fc-4fc2-8bda-31a9999f7313', 1, '38c896027d27f8d438de1f7ba56213dc0766356b81031c2c7e2e54047f6ec347', 'b02ffe0b-7c15-4cdb-ac1c-e1680e79a9b2', 0, NULL, 'revoked', '2026-04-08 08:48:48', 'dd861dc2-d4d2-47a6-a540-058a0f00ae49', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 08:38:43', '2026-04-08 08:44:20'),
('facc39b1-a23e-4d31-af53-7ff7004b7c2b', 1, '2797b352f838b74278c884aeb1dfb7e34a30d903860432885eaa0f75f175014f', '53e5b915-9764-4914-b5de-0c6b8a12c473', 1, '2026-04-16 06:03:21', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-16 05:45:44', '2026-04-16 05:50:46');

-- --------------------------------------------------------

--
-- Table structure for table `alembic_version`
--

CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `alembic_version`
--

INSERT INTO `alembic_version` (`version_num`) VALUES
('c9x0y1z2a3b4');

-- --------------------------------------------------------

--
-- Table structure for table `articles`
--

CREATE TABLE `articles` (
  `id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `content` text NOT NULL,
  `admin_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `version` int(11) NOT NULL DEFAULT '1',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `public_id` varchar(36) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'draft',
  `publish_date` datetime DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `articles`
--

INSERT INTO `articles` (`id`, `title`, `content`, `admin_id`, `created_at`, `updated_at`, `version`, `is_deleted`, `public_id`, `status`, `publish_date`, `company_id`) VALUES
(1, 'TEST Article1', 'Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article ', 1, '2026-04-08 06:06:44', '2026-04-08 06:07:38', 2, 0, '5c0e5d87-2f07-43d8-b685-6a8b7268f53c', 'draft', NULL, 2),
(2, 'TEST Article2', 'Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article ', 1, '2026-04-08 06:07:55', '2026-04-08 06:07:55', 1, 0, 'e43935dc-a327-458e-9478-37e2f39317cb', 'draft', NULL, 2),
(3, 'TEST Article3', 'Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article ', 1, '2026-04-08 06:08:39', '2026-04-08 06:08:39', 1, 0, 'e3492caa-e30e-4ad9-83a6-fb494ac4d0f1', 'draft', NULL, 2),
(4, 'TEST Article4', 'Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article ', 1, '2026-04-08 06:08:44', '2026-04-08 06:08:44', 1, 0, '63577b4b-0dea-4a3d-a8e4-33be9e9da510', 'draft', NULL, 2),
(5, 'TEST Article5', 'Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article ', 1, '2026-04-08 06:08:48', '2026-04-08 06:08:48', 1, 0, '039d2f13-219b-490f-8aa9-07b41f40240e', 'draft', NULL, 2),
(6, 'TEST Article6', 'Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article ', 1, '2026-04-08 06:08:51', '2026-04-08 06:08:51', 1, 0, 'a0b97a89-dedd-4280-9a3f-80754f9089e9', 'draft', NULL, 2),
(7, 'TEST Article7', 'Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article ', 1, '2026-04-08 06:08:54', '2026-04-08 06:08:54', 1, 0, '959686c9-5cdf-484b-96a7-713a6cf67407', 'draft', NULL, 2),
(8, 'TEST Article8', 'Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article ', 1, '2026-04-08 06:08:58', '2026-04-08 06:08:58', 1, 0, '6e93373f-491d-4db9-b7a8-9ea3ccbf2f67', 'draft', NULL, 2),
(9, 'TEST Article9', 'Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article ', 1, '2026-04-08 06:09:02', '2026-04-08 06:09:02', 1, 0, 'b2bb459b-ac37-442e-bba9-246a6eb32a71', 'draft', NULL, 2),
(10, 'TEST Article10', 'Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article ', 1, '2026-04-08 06:09:05', '2026-04-08 10:20:39', 2, 0, '210d265a-22bf-4981-a1d7-c39f5f471fd0', 'published', '2026-04-16 10:00:00', 2),
(11, 'TEST Article11', 'Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article ', 1, '2026-04-08 06:09:09', '2026-04-08 10:20:17', 2, 0, '71467535-a8e8-42a0-83e7-7818e463ebfe', 'published', '2026-04-08 17:20:00', 2),
(12, 'TEST Article12', 'Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article ', 1, '2026-04-08 06:09:13', '2026-04-08 10:19:07', 3, 0, 'bd9e4cd0-43fe-4bbc-a056-38d5f244ecac', 'published', '2026-04-08 10:19:07', 2),
(13, 'Test', 'Content', 1, '2026-04-16 06:55:41', '2026-04-16 06:55:41', 1, 0, 'fed5e4f6-81ad-4a2e-8dfe-582454203e5c', 'draft', NULL, 3),
(14, 'T', 'C', 1, '2026-04-16 07:17:23', '2026-04-16 07:17:23', 1, 0, '90e01262-03f8-4b58-8d66-564d29183d2d', 'published', NULL, 3);

--
-- Triggers `articles`
--
DELIMITER $$
CREATE TRIGGER `trg_articles_after_delete` AFTER DELETE ON `articles` FOR EACH ROW UPDATE summary SET row_count = row_count - 1, updated_at = NOW()
            WHERE table_name = 'articles'
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_articles_after_insert` AFTER INSERT ON `articles` FOR EACH ROW UPDATE summary SET row_count = row_count + 1, updated_at = NOW()
            WHERE table_name = 'articles'
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `companies`
--

CREATE TABLE `companies` (
  `id` int(11) NOT NULL,
  `public_id` varchar(36) NOT NULL,
  `name` varchar(200) NOT NULL,
  `parent_id` int(11) NOT NULL DEFAULT '0',
  `package_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `report_cc_email` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `companies`
--

INSERT INTO `companies` (`id`, `public_id`, `name`, `parent_id`, `package_id`, `created_at`, `updated_at`, `report_cc_email`) VALUES
(1, 'fda03c33-b3e7-4003-a419-b268fcfff78c', 'Platform', 0, NULL, '2026-04-16 12:19:18', '2026-04-16 12:19:18', NULL),
(2, '3eba89f6-995f-4645-b625-ea6744a93721', 'Default Company', 1, 1, '2026-04-16 12:19:18', '2026-04-16 12:19:18', NULL),
(3, '82bc1a37-7d74-4cb9-9586-2bc2cda941c0', 'company 3', 1, 1, '2026-04-16 13:04:02', '2026-04-16 13:04:02', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` int(11) NOT NULL,
  `public_id` varchar(36) NOT NULL,
  `customer_id` varchar(50) NOT NULL,
  `name` varchar(200) NOT NULL,
  `address` text,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `public_id`, `customer_id`, `name`, `address`, `created_by`, `created_at`, `updated_at`, `company_id`) VALUES
(9, 'c95780a5-c980-4e5a-91b1-522e313f6a37', 'cos002', 'customer2', 'address2', 1, '2026-04-16 06:27:36', '2026-04-16 06:49:18', 3),
(10, '60e94c2a-b6f8-418f-8ae3-b0402faf2e77', 'cos001', 'customer1', 'address1', 1, '2026-04-16 06:27:36', '2026-04-16 06:27:36', 3),
(11, '43dae710-27c7-4698-bf1a-6c9a8c83b9f6', 'TEST001', 'Test Customer111', '', 1, '2026-04-16 06:55:41', '2026-04-17 11:03:41', 3),
(13, '5b4e2382-a92b-4baa-bbb7-bcabe740cfc0', 'SCHEMA01', 'Test', '', 1, '2026-04-16 07:17:23', '2026-04-16 07:17:23', 3),
(14, '1c93caa2-e3ca-4694-b66c-d97878f443a7', 'SCHEMA01', 'Test', '', 2, '2026-04-16 08:37:14', '2026-04-16 08:37:14', 2),
(15, 'b8cc4db6-17da-47f9-a7f7-4452cc181eba', 'TEST001', 'Test Customer', '', 2, '2026-04-16 08:37:14', '2026-04-16 08:37:14', 2),
(17, '236d0599-e3d0-4360-b83c-5ebdea950dda', 'cos001', 'customer1', 'address1', 2, '2026-04-16 08:37:14', '2026-04-16 08:37:14', 2),
(18, 'c220cf48-e3ea-4273-9164-85cd4f63232e', 'cos002', 'customer2', 'address2', 2, '2026-04-17 10:17:01', '2026-04-17 10:17:01', 2);

--
-- Triggers `customers`
--
DELIMITER $$
CREATE TRIGGER `trg_customers_after_delete` AFTER DELETE ON `customers` FOR EACH ROW UPDATE summary SET row_count = row_count - 1, updated_at = NOW()
            WHERE table_name = 'customers'
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_customers_after_insert` AFTER INSERT ON `customers` FOR EACH ROW UPDATE summary SET row_count = row_count + 1, updated_at = NOW()
            WHERE table_name = 'customers'
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `import_histories`
--

CREATE TABLE `import_histories` (
  `id` int(11) NOT NULL,
  `public_id` varchar(36) NOT NULL,
  `original_filename` varchar(255) NOT NULL,
  `stored_filename` varchar(255) NOT NULL,
  `imported_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `resource_type` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `import_histories`
--

INSERT INTO `import_histories` (`id`, `public_id`, `original_filename`, `stored_filename`, `imported_by`, `created_at`, `company_id`, `resource_type`) VALUES
(1, 'e7bb3894-a94f-4464-b555-67e0a7fc396a', 'customers.xlsx', '0ea5223d974d4643a3c8bdde145bf76f.xlsx', 1, '2026-04-16 05:46:30', 2, ''),
(2, '33edf08e-ee5c-419d-b2e3-9c3d4b953828', 'customers.xlsx', 'f60ec740ac444ac5af53c245a816ae5a.xlsx', 1, '2026-04-16 06:27:36', 3, ''),
(3, '07e96ccc-efb9-4bd2-b913-d600985cd906', 'customers.xlsx', 'fad71af2f605460fb6315011764e057d.xlsx', 1, '2026-04-16 06:49:18', 3, 'customers'),
(4, '6da46f96-72be-46e2-b194-395ded76812a', 'customers.xlsx', '6cb1717fd110447eb1758499bf3c5434.xlsx', 2, '2026-04-16 08:37:14', 2, 'customers'),
(5, '54291511-4dd3-4384-80b6-0d3fd98ec346', 'customers.xlsx', '3c41cdcbd9914c3c985ba551ae835873.xlsx', 2, '2026-04-17 10:17:01', 2, 'customers');

-- --------------------------------------------------------

--
-- Table structure for table `inspection_items`
--

CREATE TABLE `inspection_items` (
  `id` int(11) NOT NULL,
  `public_id` varchar(36) NOT NULL,
  `item_code` varchar(50) NOT NULL,
  `item_name` varchar(200) NOT NULL,
  `spec` varchar(255) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `inspection_items`
--

INSERT INTO `inspection_items` (`id`, `public_id`, `item_code`, `item_name`, `spec`, `created_by`, `created_at`, `updated_at`, `company_id`) VALUES
(1, '0b7106f0-1dd0-4fc7-8f3f-10b44bec977e', 'IC01', 'Test', '0.005 mm.', 1, '2026-04-16 07:17:23', '2026-04-19 14:01:06', 3),
(2, 'ea1089c3-c0db-4249-b83b-61637a11cde0', 'IC02', 'Item2', '0.006 mm.', 1, '2026-04-19 14:00:58', '2026-04-19 14:00:58', 3);

--
-- Triggers `inspection_items`
--
DELIMITER $$
CREATE TRIGGER `trg_inspection_items_after_delete` AFTER DELETE ON `inspection_items` FOR EACH ROW UPDATE summary SET row_count = row_count - 1, updated_at = NOW()
            WHERE table_name = 'inspection_items'
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_inspection_items_after_insert` AFTER INSERT ON `inspection_items` FOR EACH ROW UPDATE summary SET row_count = row_count + 1, updated_at = NOW()
            WHERE table_name = 'inspection_items'
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `machine_models`
--

CREATE TABLE `machine_models` (
  `id` int(11) NOT NULL,
  `public_id` varchar(36) NOT NULL,
  `model_code` varchar(50) NOT NULL,
  `model_name` varchar(200) NOT NULL,
  `company_id` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `machine_models`
--

INSERT INTO `machine_models` (`id`, `public_id`, `model_code`, `model_name`, `company_id`, `created_by`, `created_at`, `updated_at`) VALUES
(1, '2f312bae-08e9-414b-8468-a32e7a48098a', 'model001', 'Model001', 3, 1, '2026-04-19 14:01:26', '2026-04-19 14:01:26');

-- --------------------------------------------------------

--
-- Table structure for table `machine_model_inspection_items`
--

CREATE TABLE `machine_model_inspection_items` (
  `machine_model_id` int(11) NOT NULL,
  `inspection_item_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `machine_model_inspection_items`
--

INSERT INTO `machine_model_inspection_items` (`machine_model_id`, `inspection_item_id`) VALUES
(1, 1),
(1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `packages`
--

CREATE TABLE `packages` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `packages`
--

INSERT INTO `packages` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'default', 'Default package', '2026-04-15 22:41:16', '2026-04-15 22:41:16');

-- --------------------------------------------------------

--
-- Table structure for table `package_limits`
--

CREATE TABLE `package_limits` (
  `package_id` int(11) NOT NULL,
  `resource` varchar(50) NOT NULL,
  `max_value` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `package_limits`
--

INSERT INTO `package_limits` (`package_id`, `resource`, `max_value`, `created_at`) VALUES
(1, 'articles', 50, '2026-04-15 22:41:16'),
(1, 'customers', -1, '2026-04-15 22:41:17'),
(1, 'inspection_items', -1, '2026-04-15 22:41:17'),
(1, 'machine_models', -1, '2026-04-19 18:43:20'),
(1, 'reports', -1, '2026-04-19 18:43:20'),
(1, 'users', 20, '2026-04-15 22:41:16');

-- --------------------------------------------------------

--
-- Table structure for table `package_role_permissions`
--

CREATE TABLE `package_role_permissions` (
  `package_id` int(11) NOT NULL,
  `role` enum('super_admin','admin','editor') NOT NULL,
  `resource` varchar(50) NOT NULL,
  `action` varchar(30) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `package_role_permissions`
--

INSERT INTO `package_role_permissions` (`package_id`, `role`, `resource`, `action`, `created_at`) VALUES
(1, 'admin', 'admins', 'create', '2026-04-15 22:41:16'),
(1, 'admin', 'admins', 'delete', '2026-04-15 22:41:16'),
(1, 'admin', 'admins', 'edit', '2026-04-15 22:41:16'),
(1, 'admin', 'admins', 'view', '2026-04-15 22:41:16'),
(1, 'admin', 'articles', 'create', '2026-04-15 22:41:16'),
(1, 'admin', 'articles', 'delete', '2026-04-15 22:41:16'),
(1, 'admin', 'articles', 'edit', '2026-04-15 22:41:16'),
(1, 'admin', 'articles', 'publish', '2026-04-15 22:41:16'),
(1, 'admin', 'articles', 'view', '2026-04-15 22:41:16'),
(1, 'admin', 'customers', 'create', '2026-04-15 22:41:17'),
(1, 'admin', 'customers', 'delete', '2026-04-15 22:41:17'),
(1, 'admin', 'customers', 'edit', '2026-04-15 22:41:17'),
(1, 'admin', 'customers', 'view', '2026-04-15 22:41:17'),
(1, 'admin', 'inspection_items', 'create', '2026-04-15 22:41:17'),
(1, 'admin', 'inspection_items', 'delete', '2026-04-15 22:41:17'),
(1, 'admin', 'inspection_items', 'edit', '2026-04-15 22:41:17'),
(1, 'admin', 'inspection_items', 'view', '2026-04-15 22:41:17'),
(1, 'admin', 'machine_models', 'create', '2026-04-19 18:43:20'),
(1, 'admin', 'machine_models', 'delete', '2026-04-19 18:43:20'),
(1, 'admin', 'machine_models', 'edit', '2026-04-19 18:43:20'),
(1, 'admin', 'machine_models', 'view', '2026-04-19 18:43:20'),
(1, 'admin', 'reports', 'create', '2026-04-19 18:43:20'),
(1, 'admin', 'reports', 'delete', '2026-04-19 18:43:20'),
(1, 'admin', 'reports', 'edit', '2026-04-19 18:43:20'),
(1, 'admin', 'reports', 'view', '2026-04-19 18:43:20'),
(1, 'admin', 'users', 'create', '2026-04-15 22:41:16'),
(1, 'admin', 'users', 'delete', '2026-04-15 22:41:16'),
(1, 'admin', 'users', 'edit', '2026-04-15 22:41:16'),
(1, 'admin', 'users', 'view', '2026-04-15 22:41:16'),
(1, 'editor', 'articles', 'create', '2026-04-15 22:41:16'),
(1, 'editor', 'articles', 'edit', '2026-04-15 22:41:16'),
(1, 'editor', 'articles', 'view', '2026-04-15 22:41:16'),
(1, 'editor', 'customers', 'create', '2026-04-15 22:41:17'),
(1, 'editor', 'customers', 'edit', '2026-04-15 22:41:17'),
(1, 'editor', 'customers', 'view', '2026-04-15 22:41:17'),
(1, 'editor', 'inspection_items', 'create', '2026-04-15 22:41:17'),
(1, 'editor', 'inspection_items', 'edit', '2026-04-15 22:41:17'),
(1, 'editor', 'inspection_items', 'view', '2026-04-15 22:41:17'),
(1, 'editor', 'machine_models', 'create', '2026-04-19 18:43:20'),
(1, 'editor', 'machine_models', 'edit', '2026-04-19 18:43:20'),
(1, 'editor', 'machine_models', 'view', '2026-04-19 18:43:20'),
(1, 'editor', 'reports', 'view', '2026-04-19 18:43:20');

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE `reports` (
  `id` int(11) NOT NULL,
  `public_id` varchar(36) NOT NULL,
  `report_no` varchar(50) NOT NULL,
  `form_data` json NOT NULL,
  `machine_model_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `serial_no` varchar(100) DEFAULT NULL,
  `inspector_name` varchar(200) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'submitted',
  `inspected_at` datetime DEFAULT NULL,
  `sent_at` datetime DEFAULT NULL,
  `email_recipients` json DEFAULT NULL,
  `pdf_path` varchar(500) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `report_counters`
--

CREATE TABLE `report_counters` (
  `company_id` int(11) NOT NULL,
  `year` int(11) NOT NULL,
  `last_seq` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `key` varchar(50) NOT NULL,
  `value` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`key`, `value`) VALUES
('date_format', 'YYYY-MM-DD'),
('favicon', ''),
('logo', ''),
('posts_per_page', '10'),
('primary_color', '#c4193c'),
('site_title', 'Admin Panel');

-- --------------------------------------------------------

--
-- Table structure for table `summary`
--

CREATE TABLE `summary` (
  `table_name` varchar(64) NOT NULL,
  `row_count` int(11) NOT NULL DEFAULT '0',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `summary`
--

INSERT INTO `summary` (`table_name`, `row_count`, `updated_at`) VALUES
('admins', 4, '2026-04-17 23:01:08'),
('articles', 14, '2026-04-16 14:17:22'),
('customers', 8, '2026-04-17 17:17:01'),
('inspection_items', 2, '2026-04-19 21:00:58'),
('users', 4, '2026-04-19 21:12:38');

-- --------------------------------------------------------

--
-- Table structure for table `token_blacklist`
--

CREATE TABLE `token_blacklist` (
  `id` int(11) NOT NULL,
  `jti` varchar(36) NOT NULL,
  `token_type` varchar(10) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `user_type` varchar(10) NOT NULL,
  `revoked_at` datetime NOT NULL,
  `expires_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `token_blacklist`
--

INSERT INTO `token_blacklist` (`id`, `jti`, `token_type`, `user_id`, `user_type`, `revoked_at`, `expires_at`) VALUES
(1, 'f6e7c9f7-b921-4e1d-9d89-445922dfe3d6', 'refresh', 'aee4bec3-cb51-4382-aa75-85040f027e7c', 'user', '2026-04-19 14:36:37', '2026-04-26 14:17:58'),
(2, 'cd681200-4fc3-4fe3-abaf-1463b8545274', 'refresh', 'aee4bec3-cb51-4382-aa75-85040f027e7c', 'user', '2026-04-19 15:08:59', '2026-04-26 14:36:36'),
(3, '33641ba1-80d0-4b37-a08e-c1940d262b33', 'refresh', 'aee4bec3-cb51-4382-aa75-85040f027e7c', 'user', '2026-04-19 16:21:30', '2026-04-26 15:08:59'),
(4, '922743c1-0a25-4b86-9e37-108c5e0067d8', 'refresh', 'aee4bec3-cb51-4382-aa75-85040f027e7c', 'user', '2026-04-19 16:37:05', '2026-04-26 16:21:30');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` varchar(120) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `public_id` varchar(36) NOT NULL,
  `name` varchar(100) NOT NULL DEFAULT '',
  `company_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password_hash`, `created_at`, `updated_at`, `public_id`, `name`, `company_id`) VALUES
(1, 'account1@mail.com', '$2b$12$NvlFNMGevEG7fGBMtu..cuplFEwaPc2NpZr5OvimnWgML1B612ySW', '2026-04-08 09:03:42', '2026-04-08 09:09:49', '98bb4e89-b8dc-4d30-9392-3c6076b28856', 'user1', 2),
(2, 'user3@company3.com', '$2b$12$bskdl1MeWKkjfovWKT0cOeyiB.n.mzt34v3Dh2tp4NGrnElobb3qW', '2026-04-16 06:05:54', '2026-04-16 06:05:54', 'a16437bf-3afd-44c9-9ab1-5de99e174229', 'user3', 3),
(3, 'u1@test.com', '$2b$12$mXd60WcEguazehJO5x07Mu6QmbitrVHGn2VtqJfrmFcFfspRdwkJK', '2026-04-16 07:17:23', '2026-04-16 07:17:23', '580ae36b-7a9f-4997-9c45-39649a7c4479', 'u1', 3),
(4, 'user1@email.com', '$2b$12$TPp6NEZ1nq.KhiWhi7oi4.GeD7do2mgnuC5PYeU1SoVIZP8yJj9Z6', '2026-04-19 14:12:39', '2026-04-19 14:12:39', 'aee4bec3-cb51-4382-aa75-85040f027e7c', 'user1', 3);

--
-- Triggers `users`
--
DELIMITER $$
CREATE TRIGGER `trg_users_after_delete` AFTER DELETE ON `users` FOR EACH ROW UPDATE summary SET row_count = row_count - 1, updated_at = NOW()
            WHERE table_name = 'users'
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_users_after_insert` AFTER INSERT ON `users` FOR EACH ROW UPDATE summary SET row_count = row_count + 1, updated_at = NOW()
            WHERE table_name = 'users'
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `idx_admins_public_id` (`public_id`),
  ADD KEY `fk_admins_company_id` (`company_id`);

--
-- Indexes for table `admin_sessions`
--
ALTER TABLE `admin_sessions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_one_active_per_admin` (`active_admin_id`),
  ADD KEY `replaced_by_session_id` (`replaced_by_session_id`),
  ADD KEY `idx_admin_status` (`admin_id`,`status`),
  ADD KEY `idx_family` (`token_family`);

--
-- Indexes for table `alembic_version`
--
ALTER TABLE `alembic_version`
  ADD PRIMARY KEY (`version_num`);

--
-- Indexes for table `articles`
--
ALTER TABLE `articles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_articles_public_id` (`public_id`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `idx_articles_updated_at` (`updated_at`),
  ADD KEY `idx_articles_status` (`status`),
  ADD KEY `ix_articles_company_id` (`company_id`);

--
-- Indexes for table `companies`
--
ALTER TABLE `companies`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `public_id` (`public_id`),
  ADD KEY `package_id` (`package_id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `public_id` (`public_id`),
  ADD UNIQUE KEY `uq_customers_customer_id_company` (`customer_id`,`company_id`),
  ADD KEY `ix_customers_created_by` (`created_by`),
  ADD KEY `ix_customers_customer_id` (`customer_id`),
  ADD KEY `ix_customers_company_id` (`company_id`);

--
-- Indexes for table `import_histories`
--
ALTER TABLE `import_histories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `public_id` (`public_id`),
  ADD KEY `ix_import_histories_imported_by` (`imported_by`),
  ADD KEY `ix_import_histories_company_id` (`company_id`);

--
-- Indexes for table `inspection_items`
--
ALTER TABLE `inspection_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `public_id` (`public_id`),
  ADD UNIQUE KEY `uq_inspection_items_item_code_company` (`item_code`,`company_id`),
  ADD KEY `ix_inspection_items_created_by` (`created_by`),
  ADD KEY `ix_inspection_items_item_code` (`item_code`),
  ADD KEY `ix_inspection_items_company_id` (`company_id`);

--
-- Indexes for table `machine_models`
--
ALTER TABLE `machine_models`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `public_id` (`public_id`),
  ADD UNIQUE KEY `uq_machine_model_company_code` (`company_id`,`model_code`),
  ADD KEY `ix_machine_models_company_id` (`company_id`),
  ADD KEY `ix_machine_models_created_by` (`created_by`);

--
-- Indexes for table `machine_model_inspection_items`
--
ALTER TABLE `machine_model_inspection_items`
  ADD PRIMARY KEY (`machine_model_id`,`inspection_item_id`),
  ADD KEY `inspection_item_id` (`inspection_item_id`);

--
-- Indexes for table `packages`
--
ALTER TABLE `packages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `package_limits`
--
ALTER TABLE `package_limits`
  ADD PRIMARY KEY (`package_id`,`resource`);

--
-- Indexes for table `package_role_permissions`
--
ALTER TABLE `package_role_permissions`
  ADD PRIMARY KEY (`package_id`,`role`,`resource`,`action`);

--
-- Indexes for table `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `public_id` (`public_id`),
  ADD UNIQUE KEY `uq_report_company_no` (`company_id`,`report_no`),
  ADD KEY `machine_model_id` (`machine_model_id`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `ix_reports_company_id` (`company_id`);

--
-- Indexes for table `report_counters`
--
ALTER TABLE `report_counters`
  ADD PRIMARY KEY (`company_id`,`year`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `summary`
--
ALTER TABLE `summary`
  ADD PRIMARY KEY (`table_name`);

--
-- Indexes for table `token_blacklist`
--
ALTER TABLE `token_blacklist`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ix_token_blacklist_jti` (`jti`),
  ADD KEY `ix_token_blacklist_user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `idx_users_public_id` (`public_id`),
  ADD KEY `fk_users_company_id` (`company_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `articles`
--
ALTER TABLE `articles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `companies`
--
ALTER TABLE `companies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `import_histories`
--
ALTER TABLE `import_histories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `inspection_items`
--
ALTER TABLE `inspection_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `machine_models`
--
ALTER TABLE `machine_models`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `packages`
--
ALTER TABLE `packages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `token_blacklist`
--
ALTER TABLE `token_blacklist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admins`
--
ALTER TABLE `admins`
  ADD CONSTRAINT `fk_admins_company_id` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `admin_sessions`
--
ALTER TABLE `admin_sessions`
  ADD CONSTRAINT `admin_sessions_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admins` (`id`),
  ADD CONSTRAINT `admin_sessions_ibfk_2` FOREIGN KEY (`replaced_by_session_id`) REFERENCES `admin_sessions` (`id`);

--
-- Constraints for table `articles`
--
ALTER TABLE `articles`
  ADD CONSTRAINT `articles_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admins` (`id`),
  ADD CONSTRAINT `fk_articles_company_id` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `companies`
--
ALTER TABLE `companies`
  ADD CONSTRAINT `companies_ibfk_1` FOREIGN KEY (`package_id`) REFERENCES `packages` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `customers`
--
ALTER TABLE `customers`
  ADD CONSTRAINT `customers_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `admins` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_customers_company_id` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `import_histories`
--
ALTER TABLE `import_histories`
  ADD CONSTRAINT `fk_import_histories_company_id` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `import_histories_ibfk_1` FOREIGN KEY (`imported_by`) REFERENCES `admins` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `inspection_items`
--
ALTER TABLE `inspection_items`
  ADD CONSTRAINT `fk_inspection_items_company_id` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `inspection_items_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `admins` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `machine_models`
--
ALTER TABLE `machine_models`
  ADD CONSTRAINT `machine_models_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `machine_models_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `admins` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `machine_model_inspection_items`
--
ALTER TABLE `machine_model_inspection_items`
  ADD CONSTRAINT `machine_model_inspection_items_ibfk_1` FOREIGN KEY (`machine_model_id`) REFERENCES `machine_models` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `machine_model_inspection_items_ibfk_2` FOREIGN KEY (`inspection_item_id`) REFERENCES `inspection_items` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `package_limits`
--
ALTER TABLE `package_limits`
  ADD CONSTRAINT `package_limits_ibfk_1` FOREIGN KEY (`package_id`) REFERENCES `packages` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `package_role_permissions`
--
ALTER TABLE `package_role_permissions`
  ADD CONSTRAINT `package_role_permissions_ibfk_1` FOREIGN KEY (`package_id`) REFERENCES `packages` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `reports`
--
ALTER TABLE `reports`
  ADD CONSTRAINT `reports_ibfk_1` FOREIGN KEY (`machine_model_id`) REFERENCES `machine_models` (`id`),
  ADD CONSTRAINT `reports_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  ADD CONSTRAINT `reports_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `reports_ibfk_4` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `report_counters`
--
ALTER TABLE `report_counters`
  ADD CONSTRAINT `report_counters_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_company_id` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
