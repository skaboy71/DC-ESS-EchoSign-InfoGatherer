
-- Dumping database structure for dc_ess_data
DROP DATABASE IF EXISTS `dc_ess_data`;
CREATE DATABASE IF NOT EXISTS `dc_ess_data` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `dc_ess_data`;

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `agreements`
-- ----------------------------
DROP TABLE IF EXISTS `agreements`;
CREATE TABLE `agreements` (
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
  `isDeleted` varchar(4) DEFAULT NULL,
  PRIMARY KEY (`AgId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
delimiter ;;
CREATE TRIGGER `Add_tmp1` AFTER INSERT ON `agreements` FOR EACH ROW INSERT IGNORE INTO tmp_agreements
SET AgId = new.AgId;
 ;;
delimiter ;

-- ----------------------------
--  Table structure for `events`
-- ----------------------------
DROP TABLE IF EXISTS `events`;
CREATE TABLE `events` (
  `tid` varchar(100) NOT NULL DEFAULT '',
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
delimiter ;;
CREATE TRIGGER `uuid_events` BEFORE INSERT ON `events` FOR EACH ROW set new.tid = UUID();
 ;;
delimiter ;
delimiter ;;
CREATE TRIGGER `up_agreements_from_events` AFTER INSERT ON `events` FOR EACH ROW INSERT IGNORE INTO agreements
set AgId = new.AgId;
 ;;
delimiter ;

-- ----------------------------
--  Table structure for `formdata`
-- ----------------------------
DROP TABLE IF EXISTS `formdata`;
CREATE TABLE `formdata` (
  `tid` varchar(100) DEFAULT NULL,
  `insDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `AgId` varchar(100) DEFAULT NULL,
  `fname` tinytext,
  `fvalue` tinytext
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `logging`
-- ----------------------------
DROP TABLE IF EXISTS `logging`;
CREATE TABLE `logging` (
  `tid` varchar(60) DEFAULT NULL,
  `Time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `levDesc` varchar(500) DEFAULT NULL,
  `sc_name` varchar(255) DEFAULT NULL,
  `AgId` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
delimiter ;;
CREATE TRIGGER `uuid2` BEFORE INSERT ON `logging` FOR EACH ROW SET NEW.tid = UUID();
 ;;
delimiter ;

-- ----------------------------
--  Table structure for `participants`
-- ----------------------------
DROP TABLE IF EXISTS `participants`;
CREATE TABLE `participants` (
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
delimiter ;;
CREATE TRIGGER `uuid_part` BEFORE INSERT ON `participants` FOR EACH ROW set new.tid = UUID();
 ;;
delimiter ;

-- ----------------------------
--  Table structure for `status_values`
-- ----------------------------
DROP TABLE IF EXISTS `status_values`;
CREATE TABLE `status_values` (
  `tId` varchar(100) DEFAULT NULL,
  `stNam` varchar(500) DEFAULT NULL,
  `isTerm` char(1) DEFAULT '0',
  PRIMARY KEY (`tId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
delimiter ;;
CREATE TRIGGER `uudi_s_values` BEFORE INSERT ON `status_values` FOR EACH ROW set new.tid = UUID();
 ;;
delimiter ;

-- ----------------------------
--  Table structure for `tmp_agreements`
-- ----------------------------
DROP TABLE IF EXISTS `tmp_agreements`;
CREATE TABLE `tmp_agreements` (
  `uuid` varchar(100) NOT NULL DEFAULT '',
  `AgId` varchar(120) NOT NULL DEFAULT '',
  `inProcess` char(2) DEFAULT '0',
  PRIMARY KEY (`uuid`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8;
delimiter ;;
CREATE TRIGGER `Tid_tmp` BEFORE INSERT ON `tmp_agreements` FOR EACH ROW SET NEW.uuid = UUID();
 ;;
delimiter ;

-- ----------------------------
--  Table structure for `users`
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
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
  `rank` varchar(50) DEFAULT '0',
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  View structure for `vw_delete_events`
-- ----------------------------
DROP VIEW IF EXISTS `vw_delete_events`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_delete_events` AS select `events`.`tid` AS `tid`,`events`.`AgId` AS `AgId`,`events`.`AgName` AS `AgName`,`events`.`AgType` AS `AgType`,`events`.`EvqFor` AS `EvqFor`,`events`.`EvAcEmail` AS `EvAcEmail`,`events`.`EvIpAd` AS `EvIpAd`,`events`.`EvDateTime` AS `EvDateTime`,`events`.`EvDesc` AS `EvDesc`,`events`.`EvPtEmail` AS `EvPtEmail`,`events`.`EvType` AS `EvType`,`events`.`EvVid` AS `EvVid` from `events` where (`events`.`EvDesc` like '%deleted%');

-- ----------------------------
--  View structure for `vw_deleted_agreements`
-- ----------------------------
DROP VIEW IF EXISTS `vw_deleted_agreements`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_deleted_agreements` AS select `agreements`.`AgId` AS `AgId`,`agreements`.`trxId` AS `trxId`,`agreements`.`sender` AS `sender`,`agreements`.`AgName` AS `AgName`,`agreements`.`AgCreated` AS `AgCreated`,`agreements`.`AgStatus` AS `AgStatus`,`agreements`.`AgType` AS `AgType`,`agreements`.`PartCount` AS `PartCount`,`agreements`.`LastEv` AS `LastEv`,`agreements`.`isMegasign` AS `isMegasign`,`agreements`.`parentWidId` AS `parentWidId`,`agreements`.`isWidgetChild` AS `isWidgetChild`,`agreements`.`hasDelegates` AS `hasDelegates`,`agreements`.`lVerId` AS `lVerId`,`agreements`.`nextInfo` AS `nextInfo`,`agreements`.`isDeleted` AS `isDeleted` from `agreements` where (`agreements`.`isDeleted` = '1');

-- ----------------------------
--  View structure for `vw_external_signed`
-- ----------------------------
DROP VIEW IF EXISTS `vw_external_signed`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_external_signed` AS select `agreements`.`AgId` AS `AgId`,`agreements`.`trxId` AS `trxId`,`agreements`.`sender` AS `sender`,`agreements`.`AgName` AS `AgName`,`agreements`.`AgCreated` AS `AgCreated`,`agreements`.`AgStatus` AS `AgStatus`,`agreements`.`AgType` AS `AgType`,`agreements`.`PartCount` AS `PartCount`,`agreements`.`LastEv` AS `LastEv`,`agreements`.`isMegasign` AS `isMegasign`,`agreements`.`parentWidId` AS `parentWidId`,`agreements`.`isWidgetChild` AS `isWidgetChild`,`agreements`.`hasDelegates` AS `hasDelegates`,`agreements`.`lVerId` AS `lVerId`,`agreements`.`nextInfo` AS `nextInfo`,`agreements`.`isDeleted` AS `isDeleted` from `agreements` where ((not(`agreements`.`sender` in (select `users`.`email` from `users`))) and (`agreements`.`sender` is not null) and (`agreements`.`sender` <> ''));

-- ----------------------------
--  View structure for `vw_non_terminal_ags`
-- ----------------------------
DROP VIEW IF EXISTS `vw_non_terminal_ags`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_non_terminal_ags` AS select `agreements`.`AgId` AS `AgId`,`agreements`.`trxId` AS `trxId`,`agreements`.`sender` AS `sender`,`agreements`.`AgName` AS `AgName`,`agreements`.`AgCreated` AS `AgCreated`,`agreements`.`AgStatus` AS `AgStatus`,`agreements`.`PartCount` AS `PartCount`,`agreements`.`LastEv` AS `LastEv`,`agreements`.`isMegasign` AS `isMegasign`,`agreements`.`parentWidId` AS `parentWidId`,`agreements`.`isWidgetChild` AS `isWidgetChild`,`agreements`.`hasDelegates` AS `hasDelegates`,`agreements`.`lVerId` AS `lVerId`,`agreements`.`nextInfo` AS `nextInfo`,`agreements`.`AgType` AS `AgType`,`agreements`.`isDeleted` AS `isDeleted` from `agreements` where `agreements`.`AgStatus` in (select `status_values`.`stNam` from `status_values` where (`status_values`.`isTerm` = '0'));

-- ----------------------------
--  View structure for `vw_notxid`
-- ----------------------------
DROP VIEW IF EXISTS `vw_notxid`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_notxid` AS select `agreements`.`AgId` AS `AgId`,`agreements`.`trxId` AS `trxId`,`agreements`.`sender` AS `sender`,`agreements`.`AgName` AS `AgName`,`agreements`.`AgCreated` AS `AgCreated`,`agreements`.`AgStatus` AS `AgStatus`,`agreements`.`AgType` AS `AgType`,`agreements`.`PartCount` AS `PartCount`,`agreements`.`LastEv` AS `LastEv`,`agreements`.`isMegasign` AS `isMegasign`,`agreements`.`parentWidId` AS `parentWidId`,`agreements`.`isWidgetChild` AS `isWidgetChild`,`agreements`.`hasDelegates` AS `hasDelegates`,`agreements`.`lVerId` AS `lVerId`,`agreements`.`nextInfo` AS `nextInfo`,`agreements`.`isDeleted` AS `isDeleted` from `agreements` where (isnull(`agreements`.`trxId`) and (not(`agreements`.`AgId` in (select `vw_external_signed`.`AgId` from `vw_external_signed`))) and (`agreements`.`PartCount` > '0'));

-- ----------------------------
--  View structure for `vw_processedagreements`
-- ----------------------------
DROP VIEW IF EXISTS `vw_processedagreements`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_processedagreements` AS select `agreements`.`AgId` AS `AgId`,`agreements`.`trxId` AS `trxId`,`agreements`.`sender` AS `sender`,`agreements`.`AgName` AS `AgName`,`agreements`.`AgCreated` AS `AgCreated`,`agreements`.`AgStatus` AS `AgStatus`,`agreements`.`PartCount` AS `PartCount`,`agreements`.`LastEv` AS `LastEv`,`agreements`.`isMegasign` AS `isMegasign`,`agreements`.`parentWidId` AS `parentWidId`,`agreements`.`isWidgetChild` AS `isWidgetChild`,`agreements`.`hasDelegates` AS `hasDelegates`,`agreements`.`lVerId` AS `lVerId`,`agreements`.`nextInfo` AS `nextInfo`,`agreements`.`AgType` AS `AgType`,`agreements`.`isDeleted` AS `isDeleted` from `agreements` where ((`agreements`.`AgStatus` is not null) and (`agreements`.`AgStatus` <> ''));

-- ----------------------------
--  View structure for `vw_signed agreements`
-- ----------------------------
DROP VIEW IF EXISTS `vw_signed agreements`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_signed agreements` AS select `agreements`.`AgId` AS `AgId`,`agreements`.`sender` AS `sender`,`agreements`.`AgName` AS `AgName`,`agreements`.`AgCreated` AS `AgCreated`,`agreements`.`AgStatus` AS `AgStatus`,`agreements`.`PartCount` AS `PartCount`,`agreements`.`LastEv` AS `LastEv`,`agreements`.`isMegasign` AS `isMegasign`,`agreements`.`parentWidId` AS `parentWidId`,`agreements`.`isWidgetChild` AS `isWidgetChild`,`agreements`.`hasDelegates` AS `hasDelegates`,`agreements`.`lVerId` AS `lVerId`,`agreements`.`nextInfo` AS `nextInfo`,`agreements`.`trxId` AS `trxId`,`agreements`.`AgType` AS `AgType`,`agreements`.`isDeleted` AS `isDeleted` from `agreements` where (`agreements`.`AgStatus` = 'SIGNED');

-- ----------------------------
--  View structure for `vw_tmp_widgets`
-- ----------------------------
DROP VIEW IF EXISTS `vw_tmp_widgets`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_tmp_widgets` AS select `agreements`.`AgId` AS `AgId`,`agreements`.`trxId` AS `trxId`,`agreements`.`sender` AS `sender`,`agreements`.`AgName` AS `AgName`,`agreements`.`AgCreated` AS `AgCreated`,`agreements`.`AgStatus` AS `AgStatus`,`agreements`.`AgType` AS `AgType`,`agreements`.`PartCount` AS `PartCount`,`agreements`.`LastEv` AS `LastEv`,`agreements`.`isMegasign` AS `isMegasign`,`agreements`.`parentWidId` AS `parentWidId`,`agreements`.`isWidgetChild` AS `isWidgetChild`,`agreements`.`hasDelegates` AS `hasDelegates`,`agreements`.`lVerId` AS `lVerId`,`agreements`.`nextInfo` AS `nextInfo`,`agreements`.`isDeleted` AS `isDeleted` from `agreements` where (`agreements`.`AgType` = 'widget');

-- ----------------------------
--  Records of `status_values`
-- ----------------------------
BEGIN;
INSERT INTO `status_values` (stNam,isTerm) VALUES ('OUT_FOR_SIGNATURE', '0'), ('OUT_FOR_APPROVALW', '0'), ('WAITING_FOR_REVIEW', '0'), ('SIGNED', '1'), ('APPROVED', '1'), ('ABORTED', '1'), ('DOCUMENT_LIBRARY', '1'), ('WIDGET', '1'), ('EXPIRED', '1'), ('ARCHIVED', '1'), ('PREFILL', '0'), ('AUTHORING', '0'), ('WAITING_FOR_FAXIN', '0'), ('WAITING_FOR_VERIFICATION', '0'), ('WIDGET_WAITING_FOR_VERIFICATION', '0'), ('WAITING_FOR_PAYMENT', '0'), ('OTHER', '1');
COMMIT;


SET FOREIGN_KEY_CHECKS = 1;
