
--
-- Table structure for table `excel_reports`
--

DROP TABLE IF EXISTS `excel_reports`;

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;


CREATE TABLE `excel_reports` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `store_id` bigint(11) NOT NULL,
  `reported_date` datetime NOT NULL,
  `active_flag` varchar(45) NOT NULL DEFAULT 'false',
  `file_location` varchar(200) NOT NULL DEFAULT 'False',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_report_1_idx` (`store_id`),
  CONSTRAINT `fk_report_1` FOREIGN KEY (`store_id`) REFERENCES `store` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `available_category_times`
ADD COLUMN `parent_time_id` INT(11) NULL DEFAULT NULL AFTER `end_time`;

UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='50' WHERE `id`='31';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='50' WHERE `id`='32';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='50' WHERE `id`='33';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='50' WHERE `id`='34';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='51' WHERE `id`='35';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='51' WHERE `id`='36';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='51' WHERE `id`='37';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='51' WHERE `id`='38';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='51' WHERE `id`='39';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='52' WHERE `id`='40';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='52' WHERE `id`='41';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='52' WHERE `id`='42';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='52' WHERE `id`='43';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='52' WHERE `id`='44';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='53' WHERE `id`='45';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='53' WHERE `id`='46';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='53' WHERE `id`='47';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='54' WHERE `id`='48';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='54' WHERE `id`='49';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='54' WHERE `id`='26';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='54' WHERE `id`='27';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='54' WHERE `id`='28';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='54' WHERE `id`='29';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='54' WHERE `id`='30';
