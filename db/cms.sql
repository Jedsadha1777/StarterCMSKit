-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: May 05, 2026 at 04:14 AM
-- Server version: 8.0.45
-- PHP Version: 8.3.30

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
  `id` int NOT NULL,
  `email` varchar(120) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `public_id` varchar(36) NOT NULL,
  `name` varchar(100) NOT NULL DEFAULT '',
  `role` enum('super_admin','admin','editor') NOT NULL DEFAULT 'admin',
  `company_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

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
  `admin_id` int NOT NULL,
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
  `active_admin_id` int GENERATED ALWAYS AS ((case when (`status` = _utf8mb3'active') then `admin_id` else NULL end)) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `alembic_version`
--

CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `articles`
--

CREATE TABLE `articles` (
  `id` int NOT NULL,
  `title` varchar(200) NOT NULL,
  `content` text NOT NULL,
  `admin_id` int NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `version` int NOT NULL DEFAULT '1',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `public_id` varchar(36) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'draft',
  `publish_date` datetime DEFAULT NULL,
  `company_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

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
  `id` int NOT NULL,
  `public_id` varchar(36) NOT NULL,
  `name` varchar(200) NOT NULL,
  `parent_id` int NOT NULL DEFAULT '0',
  `package_id` int DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `report_cc_email` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` int NOT NULL,
  `public_id` varchar(36) NOT NULL,
  `customer_id` varchar(50) NOT NULL,
  `name` varchar(200) NOT NULL,
  `address` text,
  `created_by` int DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `company_id` int DEFAULT NULL,
  `tel` varchar(50) DEFAULT NULL,
  `fax` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

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
  `id` int NOT NULL,
  `public_id` varchar(36) NOT NULL,
  `original_filename` varchar(255) NOT NULL,
  `stored_filename` varchar(255) NOT NULL,
  `imported_by` int DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `company_id` int DEFAULT NULL,
  `resource_type` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `inspection_items`
--

CREATE TABLE `inspection_items` (
  `id` int NOT NULL,
  `public_id` varchar(36) NOT NULL,
  `item_code` varchar(50) NOT NULL,
  `item_name` varchar(200) NOT NULL,
  `spec` varchar(255) DEFAULT NULL,
  `created_by` int DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `company_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

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
  `id` int NOT NULL,
  `public_id` varchar(36) NOT NULL,
  `model_code` varchar(50) NOT NULL,
  `model_name` varchar(200) NOT NULL,
  `company_id` int DEFAULT NULL,
  `created_by` int DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `machine_model_inspection_items`
--

CREATE TABLE `machine_model_inspection_items` (
  `machine_model_id` int NOT NULL,
  `inspection_item_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `packages`
--

CREATE TABLE `packages` (
  `id` int NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `package_limits`
--

CREATE TABLE `package_limits` (
  `package_id` int NOT NULL,
  `resource` varchar(50) NOT NULL,
  `max_value` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `package_role_permissions`
--

CREATE TABLE `package_role_permissions` (
  `package_id` int NOT NULL,
  `role` enum('super_admin','admin','editor') NOT NULL,
  `resource` varchar(50) NOT NULL,
  `action` varchar(30) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `parts`
--

CREATE TABLE `parts` (
  `id` int NOT NULL,
  `public_id` varchar(36) NOT NULL,
  `company_id` int DEFAULT NULL,
  `parts_code` varchar(100) NOT NULL,
  `parts_name` varchar(255) NOT NULL,
  `unit_price` decimal(12,2) NOT NULL DEFAULT '0.00',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_by` int DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `parts_consumption`
--

CREATE TABLE `parts_consumption` (
  `id` int NOT NULL,
  `report_id` int NOT NULL,
  `company_id` int NOT NULL,
  `parts_id` int DEFAULT NULL,
  `parts_code` varchar(100) NOT NULL,
  `parts_name` varchar(255) NOT NULL,
  `qty` int NOT NULL,
  `unit_price` decimal(12,2) NOT NULL DEFAULT '0.00',
  `consumption_dt` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE `reports` (
  `id` int NOT NULL,
  `public_id` varchar(36) NOT NULL,
  `report_no` varchar(50) NOT NULL,
  `form_data` json NOT NULL,
  `machine_model_id` int DEFAULT NULL,
  `customer_id` int DEFAULT NULL,
  `serial_no` varchar(100) DEFAULT NULL,
  `inspector_name` varchar(200) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `company_id` int DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'submitted',
  `inspected_at` datetime DEFAULT NULL,
  `sent_at` datetime DEFAULT NULL,
  `email_recipients` json DEFAULT NULL,
  `pdf_path` varchar(500) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `report_counters`
--

CREATE TABLE `report_counters` (
  `company_id` int NOT NULL,
  `year` int NOT NULL,
  `last_seq` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `key` varchar(50) NOT NULL,
  `value` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `summary`
--

CREATE TABLE `summary` (
  `table_name` varchar(64) NOT NULL,
  `row_count` int NOT NULL DEFAULT '0',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `token_blacklist`
--

CREATE TABLE `token_blacklist` (
  `id` int NOT NULL,
  `jti` varchar(36) NOT NULL,
  `token_type` varchar(10) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `user_type` varchar(10) NOT NULL,
  `revoked_at` datetime NOT NULL,
  `expires_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `email` varchar(120) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `public_id` varchar(36) NOT NULL,
  `name` varchar(100) NOT NULL DEFAULT '',
  `company_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

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
-- Indexes for table `parts`
--
ALTER TABLE `parts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `public_id` (`public_id`),
  ADD UNIQUE KEY `uq_parts_company_code` (`company_id`,`parts_code`),
  ADD KEY `ix_parts_company_deleted` (`company_id`,`is_deleted`),
  ADD KEY `ix_parts_company_code` (`company_id`,`parts_code`),
  ADD KEY `ix_parts_created_by` (`created_by`);

--
-- Indexes for table `parts_consumption`
--
ALTER TABLE `parts_consumption`
  ADD PRIMARY KEY (`id`),
  ADD KEY `parts_id` (`parts_id`),
  ADD KEY `ix_pc_summary` (`company_id`,`consumption_dt`,`parts_code`),
  ADD KEY `ix_pc_report` (`report_id`),
  ADD KEY `ix_pc_bycode` (`company_id`,`parts_code`,`consumption_dt`);

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
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `articles`
--
ALTER TABLE `articles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `companies`
--
ALTER TABLE `companies`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `import_histories`
--
ALTER TABLE `import_histories`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inspection_items`
--
ALTER TABLE `inspection_items`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `machine_models`
--
ALTER TABLE `machine_models`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `packages`
--
ALTER TABLE `packages`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `parts`
--
ALTER TABLE `parts`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `parts_consumption`
--
ALTER TABLE `parts_consumption`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `token_blacklist`
--
ALTER TABLE `token_blacklist`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

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
-- Constraints for table `parts`
--
ALTER TABLE `parts`
  ADD CONSTRAINT `parts_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `parts_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `admins` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `parts_consumption`
--
ALTER TABLE `parts_consumption`
  ADD CONSTRAINT `parts_consumption_ibfk_1` FOREIGN KEY (`report_id`) REFERENCES `reports` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `parts_consumption_ibfk_2` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `parts_consumption_ibfk_3` FOREIGN KEY (`parts_id`) REFERENCES `parts` (`id`) ON DELETE SET NULL;

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
