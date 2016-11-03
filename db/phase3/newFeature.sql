--
-- Table structure for table `rg_pull_over_sheet`
--

DROP TABLE IF EXISTS `rg_pull_over_sheet`;

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE `rg_pull_over_sheet` (
  `pull_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) NOT NULL,
  `store_id` bigint(20) NOT NULL,
  `sheet_reported_date` date NOT NULL,
  `available_category_times_id` bigint(20) NOT NULL,
  `no_of_units` int(11) NOT NULL,
  `status` varchar(45) NOT NULL,
  PRIMARY KEY (`pull_id`),
  UNIQUE KEY `index5` (`product_id`,`store_id`,`sheet_reported_date`,`available_category_times_id`),
  KEY `fk_rg_pull_over_sheet_1_idx` (`product_id`),
  KEY `fk_rg_pull_over_sheet_2_idx` (`store_id`),
  KEY `fk_rg_pull_over_sheet_3_idx` (`available_category_times_id`),
  CONSTRAINT `fk_rg_pull_over_sheet_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_rg_pull_over_sheet_2` FOREIGN KEY (`store_id`) REFERENCES `store` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_rg_pull_over_sheet_3` FOREIGN KEY (`available_category_times_id`) REFERENCES `available_category_times` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `email`
--

DROP TABLE IF EXISTS `email`;

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE `email` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email_id` varchar(100) NOT NULL,
  `store_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_email_1_idx` (`store_id`),
  CONSTRAINT `fk_email_1` FOREIGN KEY (`store_id`) REFERENCES `store` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET character_set_client = @saved_cs_client */;



################# adding new user dbq_admin ######################

INSERT INTO `7eleven`.`role` (`id`, `name`) VALUES ('114', 'DBQ_Admin');
INSERT INTO `7eleven`.`user` (`user_id`, `name`, `email`, `password`, `initials`) VALUES ('dbqadmin', 'Mohan', 'dbqadmin@7eleven.com', '235e74373fae4154aca06bf7ad7b42e0faed5698183494d707c39c047bb5aa8f4be166850a7f51d90969bb618636296c', 'v');
INSERT INTO `7eleven`.`user_role` (`user_id`, `role_id`, `store_id`) VALUES ('5', '114', '36104');


############ added auto increment for id in user table ###########

SET FOREIGN_KEY_CHECKS=0;

ALTER TABLE `7eleven`.`product`
CHANGE COLUMN `id` `id` BIGINT(20) NOT NULL AUTO_INCREMENT ;

SET FOREIGN_KEY_CHECKS=1;


--
-- Table structure for table `dbq_products`
--

DROP TABLE IF EXISTS `dbq_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dbq_products` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) NOT NULL,
  `max_quantity` int(10) DEFAULT NULL,
  `Active_flag` varchar(20) NOT NULL DEFAULT 'true',
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_id_UNIQUE` (`product_id`),
  KEY `fk_dbq_orderForm_1_idx` (`product_id`),
  CONSTRAINT `fk_dbq_orderForm_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `dbq_orders`
--

DROP TABLE IF EXISTS `dbq_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dbq_orders` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dbqp_id` bigint(20) NOT NULL,
  `store_id` bigint(20) NOT NULL,
  `no_of_units` int(10) DEFAULT NULL,
  `date` date NOT NULL,
  `status` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index3` (`dbqp_id`,`store_id`,`date`),
  KEY `fk_dbq_orders_2_idx` (`store_id`),
  CONSTRAINT `fk_dbq_orders_1` FOREIGN KEY (`dbqp_id`) REFERENCES `dbq_products` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_dbq_orders_2` FOREIGN KEY (`store_id`) REFERENCES `store` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
