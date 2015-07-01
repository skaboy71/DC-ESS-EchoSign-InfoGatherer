
-- Server version:               5.5.32 - MySQL Community Server (GPL)
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping database structure for dc_ess_data
DROP DATABASE IF EXISTS `dc_ess_data`;
CREATE DATABASE IF NOT EXISTS `dc_ess_data` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `dc_ess_data`;


-- Dumping structure for table dc_ess_data.agreements
DROP TABLE IF EXISTS `agreements`;
CREATE TABLE IF NOT EXISTS `agreements` (
  `AgId` varchar(100) NOT NULL,
  `trxId` varchar(60) DEFAULT NULL,
  `sender` varchar(255) DEFAULT NULL,
  `AgName` varchar(500) DEFAULT NULL,
  `AgCreated` varchar(60) DEFAULT NULL,
  `AgStatus` varchar(100) DEFAULT NULL,
  `AgType` varchar(255) DEFAULT NULL,
  `PartCount` varchar(3) DEFAULT NULL,
  `LastEv` varchar(60) DEFAULT NULL,
  `isMegasign` varchar(4) DEFAULT NULL,
  `parentWidId` varchar(100) DEFAULT NULL,
  `isWidgetChild` varchar(4) DEFAULT NULL,
  `hasDelegates` varchar(4) DEFAULT NULL,
  `lVerId` varchar(100) DEFAULT NULL,
  `nextInfo` tinytext,
  PRIMARY KEY (`AgId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table dc_ess_data.events
DROP TABLE IF EXISTS `events`;
CREATE TABLE IF NOT EXISTS `events` (
  `tid` varchar(100) NOT NULL,
  `AgId` varchar(100) DEFAULT '',
  `AgName` varchar(500) DEFAULT NULL,
  `AgType` varchar(50) DEFAULT NULL,
  `EvqFor` varchar(255) DEFAULT NULL,
  `EvAcEmail` varchar(255) DEFAULT NULL,
  `EvIpAd` varchar(20) DEFAULT NULL,
  `EvDateTime` varchar(60) DEFAULT '',
  `EvDesc` varchar(500) DEFAULT NULL,
  `EvPtEmail` varchar(255) DEFAULT NULL,
  `EvType` varchar(40) DEFAULT '',
  `EvVid` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`tid`),
  UNIQUE KEY `AgId` (`AgId`,`EvType`,`EvDateTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table dc_ess_data.formdata
DROP TABLE IF EXISTS `formdata`;
CREATE TABLE IF NOT EXISTS `formdata` (
  `tid` varchar(100) DEFAULT NULL,
  `insDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `AgId` varchar(100) DEFAULT NULL,
  `fname` tinytext,
  `fvalue` tinytext
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table dc_ess_data.logging
DROP TABLE IF EXISTS `logging`;
CREATE TABLE IF NOT EXISTS `logging` (
  `tid` varchar(60) DEFAULT NULL,
  `Time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `levDesc` varchar(500) DEFAULT NULL,
  `sc_name` varchar(255) DEFAULT NULL,
  `AgId` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for view dc_ess_data.non_terminal_ags
DROP VIEW IF EXISTS `non_terminal_ags`;
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `non_terminal_ags` (
	`AgId` VARCHAR(100) NOT NULL COLLATE 'utf8_general_ci',
	`trxId` VARCHAR(60) NULL COLLATE 'utf8_general_ci',
	`sender` VARCHAR(255) NULL COLLATE 'utf8_general_ci',
	`AgName` VARCHAR(500) NULL COLLATE 'utf8_general_ci',
	`AgCreated` VARCHAR(60) NULL COLLATE 'utf8_general_ci',
	`AgStatus` VARCHAR(100) NULL COLLATE 'utf8_general_ci',
	`PartCount` VARCHAR(3) NULL COLLATE 'utf8_general_ci',
	`LastEv` VARCHAR(60) NULL COLLATE 'utf8_general_ci',
	`isMegasign` VARCHAR(4) NULL COLLATE 'utf8_general_ci',
	`parentWidId` VARCHAR(100) NULL COLLATE 'utf8_general_ci',
	`isWidgetChild` VARCHAR(4) NULL COLLATE 'utf8_general_ci',
	`hasDelegates` VARCHAR(4) NULL COLLATE 'utf8_general_ci',
	`lVerId` VARCHAR(100) NULL COLLATE 'utf8_general_ci',
	`nextInfo` TINYTEXT NULL COLLATE 'utf8_general_ci'
) ENGINE=MyISAM;


-- Dumping structure for table dc_ess_data.participants
DROP TABLE IF EXISTS `participants`;
CREATE TABLE IF NOT EXISTS `participants` (
  `tId` varchar(255) DEFAULT '',
  `AgId` varchar(100) DEFAULT NULL,
  `company` varchar(500) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `status` varchar(200) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `roles` varchar(500) DEFAULT NULL,
  `delegateFor` varchar(255) DEFAULT NULL,
  `isNext` varchar(2) DEFAULT NULL,
  `since` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for view dc_ess_data.processedagreements
DROP VIEW IF EXISTS `processedagreements`;
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `processedagreements` (
	`AgId` VARCHAR(100) NOT NULL COLLATE 'utf8_general_ci',
	`trxId` VARCHAR(60) NULL COLLATE 'utf8_general_ci',
	`sender` VARCHAR(255) NULL COLLATE 'utf8_general_ci',
	`AgName` VARCHAR(500) NULL COLLATE 'utf8_general_ci',
	`AgCreated` VARCHAR(60) NULL COLLATE 'utf8_general_ci',
	`AgStatus` VARCHAR(100) NULL COLLATE 'utf8_general_ci',
	`PartCount` VARCHAR(3) NULL COLLATE 'utf8_general_ci',
	`LastEv` VARCHAR(60) NULL COLLATE 'utf8_general_ci',
	`isMegasign` VARCHAR(4) NULL COLLATE 'utf8_general_ci',
	`parentWidId` VARCHAR(100) NULL COLLATE 'utf8_general_ci',
	`isWidgetChild` VARCHAR(4) NULL COLLATE 'utf8_general_ci',
	`hasDelegates` VARCHAR(4) NULL COLLATE 'utf8_general_ci',
	`lVerId` VARCHAR(100) NULL COLLATE 'utf8_general_ci',
	`nextInfo` TINYTEXT NULL COLLATE 'utf8_general_ci'
) ENGINE=MyISAM;


-- Dumping structure for view dc_ess_data.signed agreements
DROP VIEW IF EXISTS `signed agreements`;
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `signed agreements` (
	`AgId` VARCHAR(100) NOT NULL COLLATE 'utf8_general_ci',
	`sender` VARCHAR(255) NULL COLLATE 'utf8_general_ci',
	`AgName` VARCHAR(500) NULL COLLATE 'utf8_general_ci',
	`AgCreated` VARCHAR(60) NULL COLLATE 'utf8_general_ci',
	`AgStatus` VARCHAR(100) NULL COLLATE 'utf8_general_ci',
	`PartCount` VARCHAR(3) NULL COLLATE 'utf8_general_ci',
	`LastEv` VARCHAR(60) NULL COLLATE 'utf8_general_ci',
	`isMegasign` VARCHAR(4) NULL COLLATE 'utf8_general_ci',
	`parentWidId` VARCHAR(100) NULL COLLATE 'utf8_general_ci',
	`isWidgetChild` VARCHAR(4) NULL COLLATE 'utf8_general_ci',
	`hasDelegates` VARCHAR(4) NULL COLLATE 'utf8_general_ci',
	`lVerId` VARCHAR(100) NULL COLLATE 'utf8_general_ci',
	`nextInfo` TINYTEXT NULL COLLATE 'utf8_general_ci'
) ENGINE=MyISAM;


-- Dumping structure for table dc_ess_data.status_values
DROP TABLE IF EXISTS `status_values`;
CREATE TABLE IF NOT EXISTS `status_values` (
  `tId` int(11) NOT NULL AUTO_INCREMENT,
  `stNam` varchar(500) DEFAULT NULL,
  `isTerm` char(1) DEFAULT '0',
  PRIMARY KEY (`tId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table dc_ess_data.tmp_agreements
DROP TABLE IF EXISTS `tmp_agreements`;
CREATE TABLE IF NOT EXISTS `tmp_agreements` (
  `uuid` varchar(100) NOT NULL DEFAULT '',
  `AgId` varchar(120) NOT NULL DEFAULT '',
  `inProcess` char(2) DEFAULT '0',
  PRIMARY KEY (`uuid`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for view dc_ess_data.tmp_widgets
DROP VIEW IF EXISTS `tmp_widgets`;
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `tmp_widgets` (
	`AgId` VARCHAR(100) NOT NULL COLLATE 'utf8_general_ci',
	`trxId` VARCHAR(60) NULL COLLATE 'utf8_general_ci',
	`sender` VARCHAR(255) NULL COLLATE 'utf8_general_ci',
	`AgName` VARCHAR(500) NULL COLLATE 'utf8_general_ci',
	`AgCreated` VARCHAR(60) NULL COLLATE 'utf8_general_ci',
	`AgStatus` VARCHAR(100) NULL COLLATE 'utf8_general_ci',
	`AgType` VARCHAR(255) NULL COLLATE 'utf8_general_ci',
	`PartCount` VARCHAR(3) NULL COLLATE 'utf8_general_ci',
	`LastEv` VARCHAR(60) NULL COLLATE 'utf8_general_ci',
	`isMegasign` VARCHAR(4) NULL COLLATE 'utf8_general_ci',
	`parentWidId` VARCHAR(100) NULL COLLATE 'utf8_general_ci',
	`isWidgetChild` VARCHAR(4) NULL COLLATE 'utf8_general_ci',
	`hasDelegates` VARCHAR(4) NULL COLLATE 'utf8_general_ci',
	`lVerId` VARCHAR(100) NULL COLLATE 'utf8_general_ci',
	`nextInfo` TINYTEXT NULL COLLATE 'utf8_general_ci'
) ENGINE=MyISAM;


-- Dumping structure for table dc_ess_data.users
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `company` varchar(500) DEFAULT NULL,
  `email` varchar(255) NOT NULL DEFAULT '',
  `fullName` varchar(255) DEFAULT NULL,
  `groupId` varchar(100) DEFAULT NULL,
  `userId` varchar(100) DEFAULT NULL,
  `account` varchar(255) DEFAULT NULL,
  `accountType` varchar(50) DEFAULT NULL,
  `capabilities` varchar(200) DEFAULT NULL,
  `channel` varchar(255) DEFAULT NULL,
  `firstName` varchar(100) DEFAULT NULL,
  `lastName` varchar(100) DEFAULT NULL,
  `initials` varchar(10) DEFAULT NULL,
  `locale` varchar(100) DEFAULT NULL,
  `passwordExpires` varchar(60) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `roles` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `startDate` varchar(60) DEFAULT NULL,
  `lastUpd` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for trigger dc_ess_data.tid44
DROP TRIGGER IF EXISTS `tid44`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='';
DELIMITER //
CREATE TRIGGER `tid44` BEFORE INSERT ON `logging` FOR EACH ROW SET new.tid = uuid()//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Dumping structure for trigger dc_ess_data.tuuid2
DROP TRIGGER IF EXISTS `tuuid2`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='';
DELIMITER //
CREATE TRIGGER `tuuid2` BEFORE INSERT ON `events` FOR EACH ROW SET new.tid = uuid()//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Dumping structure for trigger dc_ess_data.tuuidd
DROP TRIGGER IF EXISTS `tuuidd`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='';
DELIMITER //
CREATE TRIGGER `tuuidd` BEFORE INSERT ON `formdata` FOR EACH ROW SET new.tid = uuid()//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Dumping structure for trigger dc_ess_data.upAg3
DROP TRIGGER IF EXISTS `upAg3`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='';
DELIMITER //
CREATE TRIGGER `upAg3` AFTER INSERT ON `events` FOR EACH ROW INSERT IGNORE INTO agreements
	Set AgId = NEW.AgId, AgName = NEW.AgName//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Dumping structure for trigger dc_ess_data.UpDateTemp
DROP TRIGGER IF EXISTS `UpDateTemp`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `UpDateTemp` AFTER INSERT ON `agreements` FOR EACH ROW INSERT INTO tmp_agreements
	set tmp_agreements.AgId = NEW.AgId//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Dumping structure for trigger dc_ess_data.uuid
DROP TRIGGER IF EXISTS `uuid`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `uuid` BEFORE INSERT ON `tmp_agreements` FOR EACH ROW SET new.uuid = uuid()//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Dumping structure for trigger dc_ess_data.uuidPart
DROP TRIGGER IF EXISTS `uuidPart`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `uuidPart` BEFORE INSERT ON `participants` FOR EACH ROW SET new.tId = uuid()//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Dumping structure for view dc_ess_data.non_terminal_ags
DROP VIEW IF EXISTS `non_terminal_ags`;
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `non_terminal_ags`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `non_terminal_ags` AS select `agreements`.`AgId` AS `AgId`,`agreements`.`trxId` AS `trxId`,`agreements`.`sender` AS `sender`,`agreements`.`AgName` AS `AgName`,`agreements`.`AgCreated` AS `AgCreated`,`agreements`.`AgStatus` AS `AgStatus`,`agreements`.`PartCount` AS `PartCount`,`agreements`.`LastEv` AS `LastEv`,`agreements`.`isMegasign` AS `isMegasign`,`agreements`.`parentWidId` AS `parentWidId`,`agreements`.`isWidgetChild` AS `isWidgetChild`,`agreements`.`hasDelegates` AS `hasDelegates`,`agreements`.`lVerId` AS `lVerId`,`agreements`.`nextInfo` AS `nextInfo` from `agreements` where `agreements`.`AgStatus` in (select `status_values`.`stNam` from `status_values` where (`status_values`.`isTerm` = '0'));


-- Dumping structure for view dc_ess_data.processedagreements
DROP VIEW IF EXISTS `processedagreements`;
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `processedagreements`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `processedagreements` AS select `agreements`.`AgId` AS `AgId`,`agreements`.`trxId` AS `trxId`,`agreements`.`sender` AS `sender`,`agreements`.`AgName` AS `AgName`,`agreements`.`AgCreated` AS `AgCreated`,`agreements`.`AgStatus` AS `AgStatus`,`agreements`.`PartCount` AS `PartCount`,`agreements`.`LastEv` AS `LastEv`,`agreements`.`isMegasign` AS `isMegasign`,`agreements`.`parentWidId` AS `parentWidId`,`agreements`.`isWidgetChild` AS `isWidgetChild`,`agreements`.`hasDelegates` AS `hasDelegates`,`agreements`.`lVerId` AS `lVerId`,`agreements`.`nextInfo` AS `nextInfo` from `agreements` where ((`agreements`.`AgStatus` is not null) and (`agreements`.`AgStatus` <> ''));


-- Dumping structure for view dc_ess_data.signed agreements
DROP VIEW IF EXISTS `signed agreements`;
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `signed agreements`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `signed agreements` AS select `agreements`.`AgId` AS `AgId`,`agreements`.`sender` AS `sender`,`agreements`.`AgName` AS `AgName`,`agreements`.`AgCreated` AS `AgCreated`,`agreements`.`AgStatus` AS `AgStatus`,`agreements`.`PartCount` AS `PartCount`,`agreements`.`LastEv` AS `LastEv`,`agreements`.`isMegasign` AS `isMegasign`,`agreements`.`parentWidId` AS `parentWidId`,`agreements`.`isWidgetChild` AS `isWidgetChild`,`agreements`.`hasDelegates` AS `hasDelegates`,`agreements`.`lVerId` AS `lVerId`,`agreements`.`nextInfo` AS `nextInfo` from `agreements` where (`agreements`.`AgStatus` = 'SIGNED');


-- Dumping structure for view dc_ess_data.tmp_widgets
DROP VIEW IF EXISTS `tmp_widgets`;
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `tmp_widgets`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `tmp_widgets` AS select `agreements`.`AgId` AS `AgId`,`agreements`.`trxId` AS `trxId`,`agreements`.`sender` AS `sender`,`agreements`.`AgName` AS `AgName`,`agreements`.`AgCreated` AS `AgCreated`,`agreements`.`AgStatus` AS `AgStatus`,`agreements`.`AgType` AS `AgType`,`agreements`.`PartCount` AS `PartCount`,`agreements`.`LastEv` AS `LastEv`,`agreements`.`isMegasign` AS `isMegasign`,`agreements`.`parentWidId` AS `parentWidId`,`agreements`.`isWidgetChild` AS `isWidgetChild`,`agreements`.`hasDelegates` AS `hasDelegates`,`agreements`.`lVerId` AS `lVerId`,`agreements`.`nextInfo` AS `nextInfo` from `agreements` where (`agreements`.`AgType` = 'widget');
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
