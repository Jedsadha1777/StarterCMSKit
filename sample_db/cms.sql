-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Apr 11, 2026 at 02:05 PM
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
  `package_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `email`, `password_hash`, `created_at`, `updated_at`, `public_id`, `name`, `role`, `package_id`) VALUES
(1, 'admin', '$2b$12$WCZdrll9MmRizFSCfW62tOD/RqS4DxuouHMm1Z7VvVOST4nT8aN5O', '2026-04-07 01:07:18', '2026-04-08 09:01:44', 'bb63a488-164f-41a3-aaa9-86560d6135a7', 'Admin Parent 102', 'super_admin', NULL),
(2, 'admin2', '$2b$12$yMcBmmuyhJq9dMtwLnAnEuEFYBizesigKVVRvSPlyN/Wr5DR1nPQm', '2026-04-08 06:59:06', '2026-04-08 06:59:06', '23d8dc9f-f3ec-473e-ae51-e39e05febbad', 'admin2', 'admin', 1);

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
('05e5c359-6df8-43ee-bce0-80a0c14ec964', 1, '8118e2acbdc7a04ed65ed7e036b3172c2015150f1256824acc723a855acff80c', 'b02ffe0b-7c15-4cdb-ac1c-e1680e79a9b2', 1, '2026-04-08 08:38:43', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 08:19:21', '2026-04-08 08:34:19'),
('0e4f2276-4f93-4252-834a-ac94ab58acb1', 1, 'b77cd3a4351631c12a03fc7d81b29fdcb692cdaf6acf5c92f2351b6937de6d40', '692c5298-7ac9-409d-83b6-1f578442c6e3', 1, '2026-04-08 06:17:49', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 06:00:07', '2026-04-08 06:12:21'),
('0f62e008-da21-4749-99c7-9545f6faa290', 1, 'c82aed17effd8d43370fbc29339dff96227476ecd9feb946e27328b6670e613f', '16253bbf-3a16-4c73-b6c9-941789966434', 1, '2026-04-08 09:09:36', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 08:54:01', '2026-04-08 09:08:52'),
('16a0b60a-0a39-44cc-a4bc-1dcdb1bda9ff', 1, 'd060aef5057f8e7706e74a696b72b1189959e523d8e5105cbd321194b6de324c', '692c5298-7ac9-409d-83b6-1f578442c6e3', 0, NULL, 'revoked', '2026-04-08 07:08:51', '3cc912a0-7d68-4f7b-8aa1-c17ef6039736', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 06:48:24', '2026-04-08 07:03:16'),
('24cfd6ae-8e73-47ed-aaf5-a7bbd16024f3', 1, '329df7104540aabf35941e64b93549bcccae5f1f9194aa9c4a1b653818b07812', '16253bbf-3a16-4c73-b6c9-941789966434', 1, '2026-04-08 10:16:29', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 09:55:56', '2026-04-08 10:10:47'),
('25ba4acc-48c2-4296-b179-f64b3aefea03', 1, '016c9890d5551edeedee9798d8b3e4e913a28b1a54edfa4291aff62eff526cc1', '16253bbf-3a16-4c73-b6c9-941789966434', 1, '2026-04-08 09:55:56', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 09:40:16', '2026-04-08 09:55:05'),
('25db69cf-c3df-465d-91c1-66fde1af1abe', 1, 'f220e4925bcd6ea543ca7138019180cfaad26c3e58ff63d50ba55f0713bde5fc', '2e92a5b4-04d2-4a70-95fd-0f93dcfaa26c', 0, NULL, 'revoked', '2026-04-08 08:15:40', 'ec705035-3a4a-439b-a656-52f6f9631efa', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 08:04:12', '2026-04-08 08:15:04'),
('3cc912a0-7d68-4f7b-8aa1-c17ef6039736', 1, 'bdf612d66babed49f5f423828153e43b7c42e17837da5caf21390fd0d56959aa', '3f65ad6f-4f92-4875-b743-e0f9c8a56fe2', 0, NULL, 'revoked', '2026-04-08 07:09:04', '507d9ae5-f6b5-4308-8d26-7fdc5a235c7a', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 07:08:21', '2026-04-08 07:08:31'),
('455ce527-02d3-43ce-a9cd-683befaba4a9', 2, '087a4fd2eaa97833923b37f7d0e92191f03a1a57c23fe6c52bf62d5498239dd8', '82596c3b-2020-43fb-a75b-7fe6580967e3', 0, NULL, 'grace_period', '2026-04-08 07:08:29', '987ee30c-1fd1-41b1-9864-e35e978079b9', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 07:07:39', '2026-04-08 07:07:59'),
('507d9ae5-f6b5-4308-8d26-7fdc5a235c7a', 1, '2efb9ba3b1ee178c2d6e8c3dfc71f7174d0ca304077d054176ec71f143828a63', 'd7bda157-6252-467c-b526-b779ec6b845c', 0, NULL, 'revoked', '2026-04-08 07:15:11', 'f2ff4696-861c-48cb-a5c3-f0d5f338a5d3', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 07:08:34', '2026-04-08 07:14:26'),
('509f4eca-ca45-4da0-b0d5-bbdc94f72ba4', 1, '5737981a2addcf405d9b720920ca1e5189d89a47d2e0e7147f261901bf5e2349', '09c02e0d-dc05-4bda-9856-feaa9052f076', 0, NULL, 'revoked', '2026-04-08 07:26:29', '7d724e6f-b677-48f5-a413-0072eec662de', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 07:22:15', '2026-04-08 07:22:56'),
('5cad4971-76f9-4af2-837b-e63dbc73b194', 1, '0421637dc426986782893fc5b7a4a873502901d1eef71f219154da22fd6483ed', '16253bbf-3a16-4c73-b6c9-941789966434', 1, '2026-04-08 09:25:12', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 09:09:36', '2026-04-08 09:24:28'),
('79d195a0-4f3c-4c2b-9e85-3b40ee07b255', 1, '7ff269c25511afc84a07917311590c10f371275a2f4cba2f3f5571b023858018', '692c5298-7ac9-409d-83b6-1f578442c6e3', 1, '2026-04-08 06:33:19', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 06:17:49', '2026-04-08 06:31:25'),
('7ac7793b-cf49-4660-aef0-a51519de1532', 1, '2e09633362d37bab9d8b4c30f8856d6150230e6d59de1a4bcafb079a79ac7a0e', '16253bbf-3a16-4c73-b6c9-941789966434', 0, NULL, 'revoked', '2026-04-08 10:18:02', 'df033c97-e147-4108-814c-ebde93a133df', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 10:16:29', '2026-04-08 10:16:29'),
('7cc109c8-0205-4a8d-9bef-c5109c524669', 1, '984a82017ae6d7951984cf2029b32370bf37c2309f9a96b28899587da1708987', '16253bbf-3a16-4c73-b6c9-941789966434', 1, '2026-04-08 09:40:16', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 09:25:12', '2026-04-08 09:40:08'),
('7d724e6f-b677-48f5-a413-0072eec662de', 1, 'c3f66f671fa701a31d4c56db0efe75d8392491c9b1bcff12c1ec8b1cc554f04a', '93a9993f-4fa4-4a67-8713-717a97116851', 1, '2026-04-08 07:41:42', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 07:25:59', '2026-04-08 07:40:51'),
('91aaa14e-3830-448b-afa8-d50b8ea291a9', 1, '624418c763769f20527d98712a2fa864e9607cc4e09869def7a34d36f5c82eab', '93a9993f-4fa4-4a67-8713-717a97116851', 0, NULL, 'revoked', '2026-04-08 07:50:05', 'aed384ef-aa69-4aac-94d4-7207e033ee1e', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 07:41:42', '2026-04-08 07:45:37'),
('987ee30c-1fd1-41b1-9864-e35e978079b9', 2, '7e6f53cf1e3d9556357c6aaf2df3b6b3821b385575a68a8c2a7a0e13c328f7da', '7596aca0-aec2-422f-98d1-d973e36e051c', 0, NULL, 'active', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 07:07:59', '2026-04-08 07:08:29'),
('ad678270-5803-4632-8666-d391686d7bc5', 1, '1686da292e7a73179c8ebff043d8a7a0b91d676ea1a3afe91ce797d28307a522', 'ebf3c4e9-6a6b-4c1c-aefd-a7ab69b491fb', 0, NULL, 'revoked', '2026-04-08 08:04:42', '25db69cf-c3df-465d-91c1-66fde1af1abe', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 07:52:57', '2026-04-08 08:04:04'),
('aeb422c2-53f0-4434-bf8e-27d1f3de17be', 1, 'f7408e31a4af37c48e6c2e43a05f3e4553f945ece1f3aa24ec9f4c648c13e8de', '62e3ee87-9abd-46c2-b3be-097e62a04c5c', 0, NULL, 'active', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0', '2026-04-11 14:04:14', '2026-04-11 14:04:49'),
('aed384ef-aa69-4aac-94d4-7207e033ee1e', 1, '9122813bd4c6727b63803bfedf3b7b0d7bcfed23a35bd938d2025c05c72cec55', '393c59dc-fb9b-4927-85a9-0fbf36bc0026', 0, NULL, 'revoked', '2026-04-08 07:53:27', 'ad678270-5803-4632-8666-d391686d7bc5', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 07:49:35', '2026-04-08 07:51:51'),
('b8a38782-f272-40e1-8ea1-9636e0a87abb', 1, '99138537d4fdeaeb14c8e47842cc62c2ced63473de65c8b29112d086c58ea787', '692c5298-7ac9-409d-83b6-1f578442c6e3', 1, '2026-04-08 06:48:24', 'revoked', NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 06:33:19', '2026-04-08 06:48:10'),
('dd861dc2-d4d2-47a6-a540-058a0f00ae49', 1, 'eb16ab54715135b8d885441cda1a6c392e72ae2c4b2013cbae2459d205a136d6', 'f2a3d5a4-832a-4927-9fe6-415068bf130e', 0, NULL, 'revoked', '2026-04-08 08:54:31', '0f62e008-da21-4749-99c7-9545f6faa290', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 08:48:18', '2026-04-08 08:53:48'),
('df033c97-e147-4108-814c-ebde93a133df', 1, '5e0beda65ef52c0afecd2e6e3dec80420d24860903f56d353f99c67b950f0a03', 'de83915f-c70c-496c-b7b1-d5d68dd977b3', 0, NULL, 'grace_period', '2026-04-11 14:04:44', 'aeb422c2-53f0-4434-bf8e-27d1f3de17be', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 10:17:32', '2026-04-08 10:28:43'),
('ec705035-3a4a-439b-a656-52f6f9631efa', 1, '95488f304da5f9d8a74ec126d21c7caba8b94c9797210a4f3b0527cd50115bd1', 'c7371f3b-eb80-4cb8-b653-afe541b44333', 0, NULL, 'revoked', '2026-04-08 08:19:51', '05e5c359-6df8-43ee-bce0-80a0c14ec964', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 08:15:10', '2026-04-08 08:18:52'),
('f089adf0-2e34-47dd-9372-4ad0758edd7c', 2, 'a6841166e3e47e87865c7cea0b9ec9d7fe35a1870b29ddf09b5fe8e2103fc8bc', 'a34bf197-a497-4e0f-b459-bea4b3d80cc7', 0, NULL, 'grace_period', '2026-04-08 07:08:09', '455ce527-02d3-43ce-a9cd-683befaba4a9', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 06:59:42', '2026-04-08 06:59:42'),
('f2ff4696-861c-48cb-a5c3-f0d5f338a5d3', 1, '86f0c77fe18491a127c41d5781d9e5a8bf5d0c1244d8f142f0f80171fe4c647f', '11704931-0919-4494-83cb-404ce2c77a75', 0, NULL, 'revoked', '2026-04-08 07:22:45', '509f4eca-ca45-4da0-b0d5-bbdc94f72ba4', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 07:14:41', '2026-04-08 07:16:52'),
('f7a8a559-02fc-4fc2-8bda-31a9999f7313', 1, '38c896027d27f8d438de1f7ba56213dc0766356b81031c2c7e2e54047f6ec347', 'b02ffe0b-7c15-4cdb-ac1c-e1680e79a9b2', 0, NULL, 'revoked', '2026-04-08 08:48:48', 'dd861dc2-d4d2-47a6-a540-058a0f00ae49', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '2026-04-08 08:38:43', '2026-04-08 08:44:20');

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
('k1f2g3h4i5j6');

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
  `publish_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `articles`
--

INSERT INTO `articles` (`id`, `title`, `content`, `admin_id`, `created_at`, `updated_at`, `version`, `is_deleted`, `public_id`, `status`, `publish_date`) VALUES
(1, 'TEST Article1', 'Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article ', 1, '2026-04-08 06:06:44', '2026-04-08 06:07:38', 2, 0, '5c0e5d87-2f07-43d8-b685-6a8b7268f53c', 'draft', NULL),
(2, 'TEST Article2', 'Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article ', 1, '2026-04-08 06:07:55', '2026-04-08 06:07:55', 1, 0, 'e43935dc-a327-458e-9478-37e2f39317cb', 'draft', NULL),
(3, 'TEST Article3', 'Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article ', 1, '2026-04-08 06:08:39', '2026-04-08 06:08:39', 1, 0, 'e3492caa-e30e-4ad9-83a6-fb494ac4d0f1', 'draft', NULL),
(4, 'TEST Article4', 'Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article ', 1, '2026-04-08 06:08:44', '2026-04-08 06:08:44', 1, 0, '63577b4b-0dea-4a3d-a8e4-33be9e9da510', 'draft', NULL),
(5, 'TEST Article5', 'Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article ', 1, '2026-04-08 06:08:48', '2026-04-08 06:08:48', 1, 0, '039d2f13-219b-490f-8aa9-07b41f40240e', 'draft', NULL),
(6, 'TEST Article6', 'Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article ', 1, '2026-04-08 06:08:51', '2026-04-08 06:08:51', 1, 0, 'a0b97a89-dedd-4280-9a3f-80754f9089e9', 'draft', NULL),
(7, 'TEST Article7', 'Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article ', 1, '2026-04-08 06:08:54', '2026-04-08 06:08:54', 1, 0, '959686c9-5cdf-484b-96a7-713a6cf67407', 'draft', NULL),
(8, 'TEST Article8', 'Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article ', 1, '2026-04-08 06:08:58', '2026-04-08 06:08:58', 1, 0, '6e93373f-491d-4db9-b7a8-9ea3ccbf2f67', 'draft', NULL),
(9, 'TEST Article9', 'Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article ', 1, '2026-04-08 06:09:02', '2026-04-08 06:09:02', 1, 0, 'b2bb459b-ac37-442e-bba9-246a6eb32a71', 'draft', NULL),
(10, 'TEST Article10', 'Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article ', 1, '2026-04-08 06:09:05', '2026-04-08 10:20:39', 2, 0, '210d265a-22bf-4981-a1d7-c39f5f471fd0', 'published', '2026-04-16 10:00:00'),
(11, 'TEST Article11', 'Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article ', 1, '2026-04-08 06:09:09', '2026-04-08 10:20:17', 2, 0, '71467535-a8e8-42a0-83e7-7818e463ebfe', 'published', '2026-04-08 17:20:00'),
(12, 'TEST Article12', 'Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article Test Article ', 1, '2026-04-08 06:09:13', '2026-04-08 10:19:07', 3, 0, 'bd9e4cd0-43fe-4bbc-a056-38d5f244ecac', 'published', '2026-04-08 10:19:07');

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
(1, 'default', 'Default package', '2026-04-11 21:03:58', '2026-04-11 21:03:58');

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
(1, 'articles', 50, '2026-04-11 21:03:58'),
(1, 'users', 20, '2026-04-11 21:03:58');

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
(1, 'admin', 'admins', 'create', '2026-04-11 21:03:58'),
(1, 'admin', 'admins', 'delete', '2026-04-11 21:03:58'),
(1, 'admin', 'admins', 'edit', '2026-04-11 21:03:58'),
(1, 'admin', 'admins', 'view', '2026-04-11 21:03:58'),
(1, 'admin', 'articles', 'create', '2026-04-11 21:03:58'),
(1, 'admin', 'articles', 'delete', '2026-04-11 21:03:58'),
(1, 'admin', 'articles', 'edit', '2026-04-11 21:03:58'),
(1, 'admin', 'articles', 'publish', '2026-04-11 21:03:58'),
(1, 'admin', 'articles', 'view', '2026-04-11 21:03:58'),
(1, 'admin', 'users', 'create', '2026-04-11 21:03:58'),
(1, 'admin', 'users', 'delete', '2026-04-11 21:03:58'),
(1, 'admin', 'users', 'edit', '2026-04-11 21:03:58'),
(1, 'admin', 'users', 'view', '2026-04-11 21:03:58'),
(1, 'editor', 'articles', 'create', '2026-04-11 21:03:58'),
(1, 'editor', 'articles', 'edit', '2026-04-11 21:03:58'),
(1, 'editor', 'articles', 'view', '2026-04-11 21:03:58');

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
('admins', 2, '2026-04-08 13:59:06'),
('articles', 12, '2026-04-08 13:09:13'),
('users', 1, '2026-04-08 16:03:42');

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
  `name` varchar(100) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password_hash`, `created_at`, `updated_at`, `public_id`, `name`) VALUES
(1, 'account1@mail.com', '$2b$12$NvlFNMGevEG7fGBMtu..cuplFEwaPc2NpZr5OvimnWgML1B612ySW', '2026-04-08 09:03:42', '2026-04-08 09:09:49', '98bb4e89-b8dc-4d30-9392-3c6076b28856', 'user1');

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
  ADD KEY `fk_admins_package_id` (`package_id`);

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
  ADD KEY `idx_articles_status` (`status`);

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
  ADD UNIQUE KEY `idx_users_public_id` (`public_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `articles`
--
ALTER TABLE `articles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `packages`
--
ALTER TABLE `packages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `token_blacklist`
--
ALTER TABLE `token_blacklist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admins`
--
ALTER TABLE `admins`
  ADD CONSTRAINT `fk_admins_package_id` FOREIGN KEY (`package_id`) REFERENCES `packages` (`id`);

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
  ADD CONSTRAINT `articles_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admins` (`id`);

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
