START TRANSACTION;

#changing the order of id in user_role table

ALTER TABLE `7eleven`.`user_role`
CHANGE COLUMN `id` `id` BIGINT(20) NOT NULL AUTO_INCREMENT FIRST;

# droping the foreign key(employee_User_id) from user_role table

ALTER TABLE `7eleven`.`user_role`
DROP FOREIGN KEY `employeerole_user_id`;
ALTER TABLE `7eleven`.`user_role`
CHANGE COLUMN `id` `id` BIGINT(20) NOT NULL AUTO_INCREMENT FIRST,
DROP INDEX `employeerole_user_id_idx` ;

# droping the foreign key(user_id_fk) from vendor_portal_settings table

ALTER TABLE `7eleven`.`vendor_portal_settings`
DROP FOREIGN KEY `user_id_fk`;
ALTER TABLE `7eleven`.`vendor_portal_settings`
DROP INDEX `user_id_fk_idx` ;


# added auto increment for id in user table

ALTER TABLE `7eleven`.`user`
CHANGE COLUMN `id` `id` BIGINT(20) NOT NULL AUTO_INCREMENT ;

# added foreign key(fk_vendor_portal_settings_1_idx) from vendor_portal_settings table

ALTER TABLE `7eleven`.`vendor_portal_settings`
ADD INDEX `fk_vendor_portal_settings_1_idx` (`user_id` ASC);
ALTER TABLE `7eleven`.`vendor_portal_settings`
ADD CONSTRAINT `fk_vendor_portal_settings_1`
  FOREIGN KEY (`user_id`)
  REFERENCES `7eleven`.`user` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

# added foreign key(employeerole_user_id_idx) from user_role table

ALTER TABLE `7eleven`.`user_role`
ADD INDEX `employeerole_user_id_idx` (`user_id` ASC);
ALTER TABLE `7eleven`.`user_role`
ADD CONSTRAINT `employeerole_user_id`
  FOREIGN KEY (`user_id`)
  REFERENCES `7eleven`.`user` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

#removing duplicate entries from product_cost_history table

SET SQL_SAFE_UPDATES=0;

DELETE n1 FROM product_cost_history n1, product_cost_history n2
WHERE n1.effective_date_from = n2.effective_date_from
AND n1.product_id = n2.product_id
AND n1.item_cost < n2.item_cost;

# Dropping the active_flag from product_cost_history table

ALTER TABLE `7eleven`.`product_cost_history`
DROP COLUMN `active_flag`;

#droping foreign key (fk_product_cost_history_1) from product_cost_history table

ALTER TABLE `7eleven`.`product_cost_history`
DROP FOREIGN KEY `fk_product_cost_history_1`;
ALTER TABLE `7eleven`.`product_cost_history`
DROP INDEX `fk_product_cost_history_2_idx` ;

# adding foreign key (fk_product_cost_history_1) from product_cost_history table

ALTER TABLE `7eleven`.`product_cost_history`
ADD CONSTRAINT `fk_product_cost_history_1`
  FOREIGN KEY (`product_id`)
  REFERENCES `7eleven`.`product` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

#adding unique index (fk_product_cost_history_2_idx) to product_cost_history table

ALTER TABLE `7eleven`.`product_cost_history`
ADD UNIQUE INDEX `fk_product_cost_history_2_idx` (`product_id` ASC, `effective_date_from` ASC);

# new table levels
--
-- Table structure for table `levels`
--

DROP TABLE IF EXISTS `levels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `levels` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `level_name` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `levels`
--

LOCK TABLES `levels` WRITE;
/*!40000 ALTER TABLE `levels` DISABLE KEYS */;
INSERT INTO `levels` VALUES (1,'level 1'),(2,'level 2');
/*!40000 ALTER TABLE `levels` ENABLE KEYS */;
UNLOCK TABLES;


# new table level_timings
--
-- Table structure for table `level_timings`
--

DROP TABLE IF EXISTS `level_timings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `level_timings` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `available_category_times_id` bigint(20) NOT NULL,
  `level_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fk_level_timings_3_idx` (`available_category_times_id`,`level_id`),
  KEY `fk_level_timings_1_idx` (`available_category_times_id`),
  KEY `fk_level_timings_2_idx` (`level_id`),
  CONSTRAINT `fk_level_timings_1` FOREIGN KEY (`available_category_times_id`) REFERENCES `available_category_times` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_level_timings_2` FOREIGN KEY (`level_id`) REFERENCES `levels` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `level_timings`
--

LOCK TABLES `level_timings` WRITE;
/*!40000 ALTER TABLE `level_timings` DISABLE KEYS */;
INSERT INTO `level_timings` VALUES (1,50,1),(2,50,2),(3,51,1),(4,52,1),(5,53,1);
/*!40000 ALTER TABLE `level_timings` ENABLE KEYS */;
UNLOCK TABLES;

# added new column(level_id) in store_profiles table

ALTER TABLE `7eleven`.`store_profiles`
ADD COLUMN `level_id` BIGINT(20) NOT NULL DEFAULT 0 AFTER `profile_id`;

--
--Updating data for table `store_profiles`
--

UPDATE `7eleven`.`store_profiles` SET  `level_id` =1  WHERE `profile_id` = 2;

UPDATE `7eleven`.`store_profiles` SET  `level_id` =0  WHERE `profile_id` = 1;

#adding unique index (index5) to user_role table

ALTER TABLE `7eleven`.`user_role`
ADD UNIQUE INDEX `index5` (`role_id` ASC, `store_id` ASC);

COMMIT;


############Update Admin Password ####

SET SQL_SAFE_UPDATES=0;

UPDATE `7eleven`.`user`
SET `password` = 'bdf959cba21547b3b43e05721442d8a81eba96bce8e7c4764aeb142c7af8da12f5198dcf3bb66c291ae72bfc0a8e1539'
WHERE `user_id` = 'admin';

SET SQL_SAFE_UPDATES=1;
