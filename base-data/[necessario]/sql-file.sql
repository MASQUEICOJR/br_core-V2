-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           11.4.5-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              12.7.0.6850
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Copiando estrutura do banco de dados para br_core
CREATE DATABASE IF NOT EXISTS `br_core` /*!40100 DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci */;
USE `br_core`;

-- Copiando estrutura para tabela br_core.account
CREATE TABLE IF NOT EXISTS `account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steam` varchar(50) NOT NULL,
  `whitelisted` tinyint(1) DEFAULT 0,
  `banned` tinyint(1) DEFAULT 0,
  `chars` int(1) DEFAULT 1,
  `deleted` int(1) DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Copiando dados para a tabela br_core.account: ~0 rows (aproximadamente)

-- Copiando estrutura para procedure br_core.BR_ResetTables
DELIMITER //
CREATE PROCEDURE `BR_ResetTables`()
BEGIN
    SET FOREIGN_KEY_CHECKS = 0;
    
    DELETE FROM inventario;
    DELETE FROM account;
    DELETE FROM homes_permissions;
    DELETE FROM priority;
    DELETE FROM srv_data;
    DELETE FROM user_data;
    DELETE FROM user_identities;
    DELETE FROM user_ids;
    DELETE FROM user_moneys;
    DELETE FROM user_vehicles;
    DELETE FROM orgs_goals;
    DELETE FROM orgs_info;
    DELETE FROM orgs_logs;
    DELETE FROM orgs_player_infos;
    
    ALTER TABLE account AUTO_INCREMENT = 1;
    ALTER TABLE user_vehicles AUTO_INCREMENT = 1;
    ALTER TABLE orgs_logs AUTO_INCREMENT = 1;
    
    SET FOREIGN_KEY_CHECKS = 1;
END//
DELIMITER ;

-- Copiando estrutura para tabela br_core.homes_permissions
CREATE TABLE IF NOT EXISTS `homes_permissions` (
  `owner` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `garage` int(11) NOT NULL,
  `home` varchar(100) NOT NULL DEFAULT '',
  `tax` varchar(24) NOT NULL DEFAULT '',
  `chestSize` int(11) DEFAULT NULL,
  `slotsChest` int(11) NOT NULL DEFAULT 15
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Copiando dados para a tabela br_core.homes_permissions: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela br_core.inventario
CREATE TABLE IF NOT EXISTS `inventario` (
  `user_id` int(11) NOT NULL,
  `bolsos` int(11) DEFAULT NULL,
  `bolsosocupados` int(11) DEFAULT NULL,
  `img` text DEFAULT NULL,
  `banner` text DEFAULT NULL,
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela br_core.inventario: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela br_core.orgs_goals
CREATE TABLE IF NOT EXISTS `orgs_goals` (
  `user_id` int(11) NOT NULL,
  `organization` varchar(50) NOT NULL,
  `item` varchar(100) NOT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `day` int(11) NOT NULL,
  `month` int(11) NOT NULL,
  `step` int(11) DEFAULT 1,
  `reward_step` int(11) DEFAULT 0,
  UNIQUE KEY `user_id_organization_item_day` (`user_id`,`organization`,`item`,`day`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela br_core.orgs_goals: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela br_core.orgs_info
CREATE TABLE IF NOT EXISTS `orgs_info` (
  `organization` varchar(50) NOT NULL,
  `alerts` text DEFAULT '{}',
  `logo` text DEFAULT NULL,
  `discord` varchar(150) DEFAULT '',
  `bank` int(11) DEFAULT 0,
  `bank_historic` text DEFAULT '{}',
  `permissions` text DEFAULT '{}',
  `config_goals` text DEFAULT '{}',
  `salary` int(11) DEFAULT 1000,
  PRIMARY KEY (`organization`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Copiando dados para a tabela br_core.orgs_info: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela br_core.orgs_logs
CREATE TABLE IF NOT EXISTS `orgs_logs` (
  `organization` varchar(50) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `date` varchar(50) DEFAULT NULL,
  `expire_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela br_core.orgs_logs: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela br_core.orgs_player_infos
CREATE TABLE IF NOT EXISTS `orgs_player_infos` (
  `user_id` int(11) NOT NULL,
  `organization` varchar(50) DEFAULT NULL,
  `joindate` int(11) DEFAULT 0,
  `lastlogin` int(11) DEFAULT 0,
  `timeplayed` int(11) DEFAULT 0,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Copiando dados para a tabela br_core.orgs_player_infos: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela br_core.priority
CREATE TABLE IF NOT EXISTS `priority` (
  `priority` int(10) DEFAULT NULL,
  `steam` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela br_core.priority: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela br_core.srv_data
CREATE TABLE IF NOT EXISTS `srv_data` (
  `dkey` varchar(100) NOT NULL,
  `dvalue` text DEFAULT NULL,
  PRIMARY KEY (`dkey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Copiando dados para a tabela br_core.srv_data: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela br_core.user_data
CREATE TABLE IF NOT EXISTS `user_data` (
  `user_id` int(11) NOT NULL,
  `dkey` varchar(100) NOT NULL,
  `dvalue` text DEFAULT NULL,
  PRIMARY KEY (`user_id`,`dkey`),
  CONSTRAINT `fk_user_data_users` FOREIGN KEY (`user_id`) REFERENCES `account` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Copiando dados para a tabela br_core.user_data: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela br_core.user_identities
CREATE TABLE IF NOT EXISTS `user_identities` (
  `user_id` int(11) NOT NULL,
  `registration` varchar(20) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `firstname` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `age2` varchar(50) DEFAULT NULL,
  `foto` varchar(200) DEFAULT NULL,
  `foragido` int(1) NOT NULL DEFAULT 0,
  `license` int(1) NOT NULL DEFAULT 1,
  `gunLimit` int(1) NOT NULL DEFAULT 0,
  `linked_image` varchar(250) NOT NULL DEFAULT '0',
  `surname` varchar(50) NOT NULL DEFAULT '',
  `chavePix` varchar(255) DEFAULT NULL,
  `profilepicture` longtext DEFAULT NULL,
  `background` longtext DEFAULT NULL,
  `iban` longtext DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  KEY `registration` (`registration`),
  KEY `phone` (`phone`),
  CONSTRAINT `fk_user_identities_users` FOREIGN KEY (`user_id`) REFERENCES `account` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Copiando dados para a tabela br_core.user_identities: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela br_core.user_ids
CREATE TABLE IF NOT EXISTS `user_ids` (
  `identifier` varchar(100) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`identifier`),
  KEY `fk_user_ids_users` (`user_id`),
  CONSTRAINT `fk_user_ids_users` FOREIGN KEY (`user_id`) REFERENCES `account` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Copiando dados para a tabela br_core.user_ids: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela br_core.user_moneys
CREATE TABLE IF NOT EXISTS `user_moneys` (
  `user_id` int(11) NOT NULL,
  `wallet` int(11) DEFAULT NULL,
  `bank` int(11) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_user_moneys_users` FOREIGN KEY (`user_id`) REFERENCES `account` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Copiando dados para a tabela br_core.user_moneys: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela br_core.user_vehicles
CREATE TABLE IF NOT EXISTS `user_vehicles` (
  `user_id` int(11) NOT NULL,
  `vehicle` varchar(100) NOT NULL,
  `plate` varchar(20) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `arrest` int(1) NOT NULL DEFAULT 0,
  `time` int(11) NOT NULL DEFAULT 0,
  `premiumtime` int(11) NOT NULL DEFAULT 0,
  `rentaltime` int(11) NOT NULL DEFAULT 0,
  `engine` int(4) NOT NULL DEFAULT 1000,
  `body` int(4) NOT NULL DEFAULT 1000,
  `fuel` int(3) NOT NULL DEFAULT 100,
  `work` varchar(10) NOT NULL DEFAULT 'false',
  `doors` varchar(254) NOT NULL,
  `windows` varchar(254) NOT NULL,
  `tyres` varchar(254) NOT NULL,
  `alugado` tinyint(4) NOT NULL DEFAULT 0,
  `data_alugado` text DEFAULT NULL,
  `stoled_by` text DEFAULT NULL,
  `stoled_at` text DEFAULT NULL,
  `garage` int(11) DEFAULT NULL,
  `ipva` int(11) DEFAULT NULL,
  `financiado` int(255) DEFAULT NULL,
  `tax` int(50) DEFAULT NULL,
  `estado` text DEFAULT '[]',
  PRIMARY KEY (`user_id`,`vehicle`),
  KEY `user_id` (`user_id`),
  KEY `vehicle` (`vehicle`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Copiando dados para a tabela br_core.user_vehicles: ~0 rows (aproximadamente)

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
