#CREATE DATABASE  IF NOT EXISTS `7eleven` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `7eleven`;

--
-- Table structure changes for table `equipment_temperature`
--

ALTER TABLE `equipment_temperature`
CHANGE COLUMN temperature temperature decimal(10,3) NOT NULL;

--
-- Table structure changes for table `product`
--

ALTER TABLE `product`
ADD COLUMN product_parent_id bigint(20) NULL AFTER unit_type;

--
-- Table structure changes for table `product_temperature`
--

ALTER TABLE `product_temperature`
ADD COLUMN availability_category_times_id bigint(20) NULL AFTER availability_id,
ADD CONSTRAINT fk_product_temperature_3 FOREIGN KEY(store_id) REFERENCES `store`(id),
ADD CONSTRAINT fk_product_temperature_4 FOREIGN KEY(availability_category_times_id) REFERENCES `available_category_times`(id),
ADD CONSTRAINT fk_product_temperature_1 FOREIGN KEY(product_id) REFERENCES `product`(id),
ADD CONSTRAINT fk_product_temperature_2 FOREIGN KEY(availability_id) REFERENCES `available_category`(id),
ADD INDEX fk_product_temperature_4_idx (availability_category_times_id);
--
-- Table structure changes for table `product_waste`
--

ALTER TABLE `product_waste`
CHANGE COLUMN no_of_units no_of_units decimal(11,4) NOT NULL;

--
-- Table structure changes for table `store`
--

ALTER TABLE `store`
CHANGE COLUMN location location varchar(100) NOT NULL,
ADD COLUMN district varchar(45) NULL AFTER location;

--
-- Table structure for table `profiles`
--

DROP TABLE IF EXISTS `profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `profiles` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `profile_name` varchar(100) NOT NULL,
  `profile_code` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `buildto_factor`
--

DROP TABLE IF EXISTS `buildto_factor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `buildto_factor` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `factor_value` int(10) unsigned NOT NULL,
  `profile_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_buildto_factor_1_idx` (`profile_id`),
  CONSTRAINT `fk_buildto_factor_1` FOREIGN KEY (`profile_id`) REFERENCES `profiles` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `buildto_stores`
--

DROP TABLE IF EXISTS `buildto_stores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `buildto_stores` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `factor_id` bigint(20) NOT NULL,
  `store_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fk_buildto_stores_3_idx` (`store_id`,`factor_id`),
  KEY `fk_buildto_stores_1_idx` (`factor_id`),
  KEY `fk_buildto_stores_2_idx` (`store_id`),
  CONSTRAINT `fk_buildto_stores_1` FOREIGN KEY (`factor_id`) REFERENCES `buildto_factor` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_buildto_stores_2` FOREIGN KEY (`store_id`) REFERENCES `store` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_cost_history`
--

DROP TABLE IF EXISTS `product_cost_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_cost_history` (
  `idproduct_cost_history` bigint(20) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) NOT NULL,
  `effective_date_from` date NOT NULL,
  `item_cost` decimal(10,2) NOT NULL,
  `active_flag` varchar(45) NOT NULL,
  PRIMARY KEY (`idproduct_cost_history`),
  UNIQUE KEY `fk_product_cost_history_2_idx` (`product_id`,`effective_date_from`,`item_cost`),
  KEY `fk_product_cost_history_1_idx` (`product_id`),
  CONSTRAINT `fk_product_cost_history_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `roller_product_temp`
--

DROP TABLE IF EXISTS `roller_product_temp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roller_product_temp` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) NOT NULL,
  `availability_id` bigint(20) NOT NULL,
  `available_category_times_id` bigint(20) DEFAULT NULL,
  `store_id` bigint(20) NOT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `initials` varchar(45) DEFAULT NULL,
  `status` varchar(45) NOT NULL,
  `temparature` decimal(10,3) NOT NULL DEFAULT '0.000',
  PRIMARY KEY (`id`),
  KEY `fk_product_temp_1_idx` (`availability_id`),
  KEY `fk_product_temp_2_idx` (`product_id`),
  KEY `fk_product_temp_3_idx` (`store_id`),
  KEY `fk_product_temp_4_idx` (`available_category_times_id`),
  CONSTRAINT `fk_product_temp_1` FOREIGN KEY (`availability_id`) REFERENCES `available_category` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_product_temp_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_product_temp_3` FOREIGN KEY (`store_id`) REFERENCES `store` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_product_temp_4` FOREIGN KEY (`available_category_times_id`) REFERENCES `available_category_times` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `store_profiles`
--

DROP TABLE IF EXISTS `store_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `store_profiles` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `profile_id` bigint(20) NOT NULL,
  `store_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_profile_store` (`profile_id`,`store_id`),
  KEY `fk_store_profiles_1_idx` (`profile_id`),
  KEY `fk_store_profiles_2_idx` (`store_id`),
  CONSTRAINT `fk_store_profiles_1` FOREIGN KEY (`profile_id`) REFERENCES `profiles` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_store_profiles_2` FOREIGN KEY (`store_id`) REFERENCES `store` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `survey`
--

DROP TABLE IF EXISTS `survey`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `survey` (
  `idsurvey` bigint(11) NOT NULL AUTO_INCREMENT,
  `survey_name` varchar(45) NOT NULL,
  `profile_id` bigint(20) NOT NULL,
  `Active_flag` varchar(20) NOT NULL DEFAULT 'TRUE',
  PRIMARY KEY (`idsurvey`),
  KEY `fk_survey_1_idx` (`profile_id`),
  CONSTRAINT `fk_survey_1` FOREIGN KEY (`profile_id`) REFERENCES `profiles` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `survey_category`
--

DROP TABLE IF EXISTS `survey_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `survey_category` (
  `idsurvey_category` bigint(11) NOT NULL AUTO_INCREMENT,
  `survey_id` bigint(11) NOT NULL,
  `category_name` varchar(45) NOT NULL,
  `Active_flag` varchar(20) NOT NULL DEFAULT 'TRUE',
  PRIMARY KEY (`idsurvey_category`),
  KEY `fk_survey_category_1_idx` (`survey_id`),
  CONSTRAINT `fk_survey_category_1` FOREIGN KEY (`survey_id`) REFERENCES `survey` (`idsurvey`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `survey_questions`
--

DROP TABLE IF EXISTS `survey_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `survey_questions` (
  `idsurvey_questions` bigint(11) NOT NULL AUTO_INCREMENT,
  `category_id` bigint(11) NOT NULL,
  `question` varchar(225) NOT NULL,
  `score` int(10) NOT NULL,
  `Active_flag` varchar(20) NOT NULL DEFAULT 'TRUE',
  PRIMARY KEY (`idsurvey_questions`),
  KEY `fk_survey_questions_1_idx` (`category_id`),
  CONSTRAINT `fk_survey_questions_1` FOREIGN KEY (`category_id`) REFERENCES `survey_category` (`idsurvey_category`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `survey_result`
--

DROP TABLE IF EXISTS `survey_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `survey_result` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `survey_id` bigint(11) NOT NULL,
  `store_id` bigint(20) NOT NULL,
  `inspector_name` varchar(45) NOT NULL,
  `manager_name` varchar(45) NOT NULL,
  `survey_date` datetime NOT NULL,
  `survey_overall_comments` varchar(2000) DEFAULT NULL,
  `status` varchar(45) DEFAULT NULL,
  `score` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_survey_result_1_idx` (`survey_id`),
  KEY `fk_survey_result_2_idx` (`store_id`),
  CONSTRAINT `fk_survey_result_1` FOREIGN KEY (`survey_id`) REFERENCES `survey` (`idsurvey`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_survey_result_2` FOREIGN KEY (`store_id`) REFERENCES `store` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `survey_result_answers`
--

DROP TABLE IF EXISTS `survey_result_answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `survey_result_answers` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `survey_result_id` bigint(11) NOT NULL,
  `survey_question_id` bigint(11) NOT NULL COMMENT '	',
  `result_score` bigint(20) DEFAULT NULL,
  `comments` varchar(2000) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fk_survey_result_answers_3_idx` (`survey_result_id`,`survey_question_id`),
  KEY `fk_survey_result_answers_1_idx` (`survey_result_id`),
  KEY `fk_survey_result_answers_2_idx` (`survey_question_id`),
  CONSTRAINT `fk_survey_result_answers_1` FOREIGN KEY (`survey_result_id`) REFERENCES `survey_result` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_survey_result_answers_2` FOREIGN KEY (`survey_question_id`) REFERENCES `survey_questions` (`idsurvey_questions`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `threshold_factor`
--

DROP TABLE IF EXISTS `threshold_factor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `threshold_factor` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `factor_value` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `threshold_stores`
--

DROP TABLE IF EXISTS `threshold_stores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `threshold_stores` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `threshold_id` bigint(20) NOT NULL,
  `store_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_1_idx` (`threshold_id`),
  KEY `fk_2_idx` (`store_id`),
  CONSTRAINT `fk_1` FOREIGN KEY (`threshold_id`) REFERENCES `threshold_factor` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_2` FOREIGN KEY (`store_id`) REFERENCES `store` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
