START TRANSACTION;

DROP TABLE `7eleven`.`dbq_orders`;

DROP TABLE `7eleven`.`dbq_products`;

DROP TABLE `7eleven`.`email_config`;

DELETE FROM `7eleven`.`product`
WHERE product_type_id in (5, 6,7);

--
-- Table structure for table `reporting_groups`
--

DROP TABLE IF EXISTS `reporting_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reporting_groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_name` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index2` (`group_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Dumping data for table `reporting_groups`
--

LOCK TABLES `reporting_groups` WRITE;
/*!40000 ALTER TABLE `reporting_groups` DISABLE KEYS */;
INSERT INTO `reporting_groups` VALUES (1,'North District'),(2,'South District'),(3,'Supervisors');
/*!40000 ALTER TABLE `reporting_groups` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Table structure for table `repots_users`
--

DROP TABLE IF EXISTS `repots_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `repots_users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `reporting_groups_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_repots_users_1_idx` (`reporting_groups_id`),
  KEY `fk_repots_users_2_idx` (`user_id`),
  CONSTRAINT `fk_repots_users_1` FOREIGN KEY (`reporting_groups_id`) REFERENCES `reporting_groups` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_repots_users_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `email_config`
--

DROP TABLE IF EXISTS `email_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `reporting_groups_id` bigint(20) NOT NULL,
  `store_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index4` (`reporting_groups_id`,`store_id`),
  KEY `fk_email_config_1_idx` (`store_id`),
  KEY `fk_email_config_2_idx` (`reporting_groups_id`),
  CONSTRAINT `fk_email_config_1` FOREIGN KEY (`store_id`) REFERENCES `store` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_email_config_2` FOREIGN KEY (`reporting_groups_id`) REFERENCES `reporting_groups` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `dbq_products`
--

DROP TABLE IF EXISTS `dbq_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dbq_products` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `product_description` varchar(75) NOT NULL,
  `product_type_id` bigint(20) NOT NULL,
  `storage` varchar(45) NOT NULL,
  `size` varchar(45) NOT NULL,
  `caese` varchar(45) NOT NULL,
  `brand` varchar(45) NOT NULL,
  `item` varchar(45) NOT NULL,
  `dbq` varchar(45) NOT NULL,
  `max_quantity` int(10) DEFAULT NULL COMMENT '			',
  `Active_flag` varchar(20) NOT NULL DEFAULT 'true',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('1', 'Clamshell Box', '5', 'Dry', 'EA', '300', 'OFC', 'Sandwich', '40451');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('2', 'Pizza Slice', '5', 'Dry', 'EA', '375', 'OFC', 'Pizza', '40642');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('3', 'Pizza Breakfast Slice', '5', 'Dry', 'EA', '375', 'OFC', 'Breakfast', '40634');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('4', 'Pretzel Box', '5', 'Dry', 'EA', '275', 'OFC', 'Pretzel', '40659');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('5', 'Snack/Chicken Box', '5', 'Dry', 'EA', '400', 'OFC', 'Snack', '40139');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('6', 'Aluminum Foil Sheets', '5', 'Dry', '9\" x 10.75\"', '500 Sheets', 'Jiffy Foil', '59100', '37333');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('7', 'Deli Tissue Paper', '5', 'Dry', '12\" x 12\"', '1000 Sheets', 'Handy Wacks', '388934', '38703');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('8', 'Pizza Box', '6', 'Dry', '16\" x 16\"', '50', 'OFC', 'Pizza', '38141');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('9', 'Ziploc Bags', '6', 'Dry', 'Gal', '250 ct', 'Ziploc', '94602', '38158');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('10', 'Food Service Film', '6', 'Dry', '24\"X2000\'', '1', 'Handi-Foil', '22045', '38166');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('11', 'Glove Nitrile Blue Medium', '6', 'Dry', 'Med', '250 ct', 'Bunzl', '494', '38174');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('12', 'Glove Nitrile Blue Large', '6', 'Dry', 'Lrg', '250 ct', 'Bunzl', '495', '38182');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('13', 'Glove Nitrile Blue Extra Large', '6', 'Dry', 'XLrg', '250 ct', 'Bunzl', '496', '38190');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('14', 'Spray Pan Release', '6', 'Dry', 'EA', '14 oz', 'Prof Prep', '35039', '38208');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('15', 'Floor Cleaner HP Neutral', '6', 'Dry', 'EA', '44 oz', 'Ecolab', '6100082', '40444');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('16', 'Greaselift', '6', 'Dry', 'EA', '32 oz', 'Ecolab', '6100284', '40436');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('17', 'Multi Surface Clnr Peroxide', '6', 'Dry', 'EA', '44 oz', 'Ecolab', '6100792', '40394');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('18', 'Odor Eliminator', '6', 'Dry', 'EA', '44 oz', 'Ecolab', '6101023', '40402');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('19', 'Pantastic', '6', 'Dry', 'EA', '1 Gal', 'Ecolab', '12963', '40410');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('20', 'Sanitizer Sink/Surface', '6', 'Dry', 'EA', '2.50 Gal', 'Ecolab', '17708', '40428');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('21', 'Plastic Black Cups', '6', 'Dry', '4 oz', '200 ct', 'Dixie', '522968', '40204');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('22', 'Plastic Clear Lid', '6', 'Dry', 'EA', '100 ct', 'Dixie', '523070', '40212');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('23', 'Pizza Screen', '6', 'Dry', '16\"', '12', 'International', 'PS-16', '39271');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('24', 'Oven Mitts', '6', 'Dry', 'Large', '1 pr', 'San Jamar', '801SG15', '39289');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('25', 'Glove Cuttless', '6', 'Dry', 'Large', '1', 'Swiss', '86504', '40857');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('26', 'Biscuit - Sausage, Egg & Cheese', '7', 'Dry', 'Roll', '1000', 'Keystone', '2.5 x 3.5', '38281');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('27', 'Biscuit - Sausage & Cheese', '7', 'Dry', 'Roll', '1000', 'Keystone', '2.5 x 3.5', '38299');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('28', 'Croissant - Sausage, Egg & Cheese', '7', 'Dry', 'Roll', '1000', 'Keystone', '2.5 x 3.5', '38307');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('29', 'Croissant - Bacon, Egg & Cheese', '7', 'Dry', 'Roll', '1000', 'Keystone', '2.5 x 3.5', '38315');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('30', 'Bagel - Bacon, Egg & Cheese', '7', 'Dry', 'Roll', '1000', 'Keystone', '2.5 x 3.5', '38323');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('31', 'Eng. Muffin - Turkey Sausage, Egg & Pepperjack', '7', 'Dry', 'Roll', '1000', 'Keystone', '2.5 x 3.5', '38331');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('32', 'English Muffin - Bacon, Egg & Cheese', '7', 'Dry', 'Roll', '1000', 'Keystone', '2.5 x 3.5', '38349');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('33', 'Burrito - Sausage', '7', 'Dry', 'Roll', '1000', 'Keystone', '3\" rounds', '38406');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('34', 'Burrito - Chorizo', '7', 'Dry', 'Roll', '1000', 'Keystone', '3\" rounds', '38414');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('35', 'Burrito - Bacon', '7', 'Dry', 'Roll', '1000', 'Keystone', '3\" rounds', '40972');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('36', 'Bites - Chicken Spicy', '7', 'Dry', 'Roll', '1000', 'Keystone', '2.5 x 3.5', '40477');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('37', 'Bites - Chicken Regular', '7', 'Dry', 'Roll', '1000', 'Keystone', '2.5 x 3.5', '40469');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('38', 'Bites - Corn Dog', '7', 'Dry', 'Roll', '1000', 'Keystone', '2.5 x 3.5', '40485');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('39', 'Pretzel - Big Salty', '7', 'Dry', 'Roll', '1000', 'Keystone', '2.5 x 3.5', '38380');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `caese`, `brand`, `item`, `dbq`) VALUES ('40', 'Expiration Date', '7', 'Dry', 'Roll', '1000', 'Keystone', '3 x 1.5', '38398');


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
  `total` varchar(45) DEFAULT NULL,
  `status` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index3` (`dbqp_id`,`store_id`,`date`),
  KEY `fk_dbq_orders_2_idx` (`store_id`),
  CONSTRAINT `fk_dbq_orders_1` FOREIGN KEY (`dbqp_id`) REFERENCES `dbq_products` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_dbq_orders_2` FOREIGN KEY (`store_id`) REFERENCES `store` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

COMMIT;
