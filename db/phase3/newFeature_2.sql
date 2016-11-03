START TRANSACTION;

#DROP TABLE `7eleven`.`email`;
DROP TABLE IF EXISTS `dbq_orders`;
DROP TABLE IF EXISTS `dbq_products`;

--
-- Table structure for table `email_config`
--

DROP TABLE IF EXISTS `email_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `store_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_email_config_1_idx` (`store_id`),
  KEY `fk_email_config_2_idx` (`user_id`),
  CONSTRAINT `fk_email_config_1` FOREIGN KEY (`store_id`) REFERENCES `store` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_email_config_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
  `product_id` bigint(20) NOT NULL,
  `max_quantity` int(10) DEFAULT NULL COMMENT '			',
  `Active_flag` varchar(20) NOT NULL DEFAULT 'true',
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_id_UNIQUE` (`product_id`),
  KEY `fk_dbq_orderForm_1_idx` (`product_id`),
  CONSTRAINT `fk_dbq_orderForm_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


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


--
-- Inserting data for table `product_type`
--

INSERT INTO `product_type` (`id`,`type`) VALUES (5,'Packaging');
INSERT INTO `product_type` (`id`,`type`) VALUES (6,'Supplies');
INSERT INTO `product_type` (`id`,`type`) VALUES (7,'Labels');
INSERT INTO `product_type` (`id`,`type`) VALUES (8,'Fresh Products');

--
-- Inserting data for table `product`
--

INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Clamshell Box','124',5,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Pizza Slice','125',5,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Pizza Breakfast Slice','126',5,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Pretzel Box','127',5,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Snack/Chicken Box','128',5,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Aluminum Foil Sheets','129',5,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Deli Tissue Paper  ','130',5,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Pizza Box','131',5,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Ziploc Bags','132',6,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Food Service Film','133',6,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Glove Nitrile Blue Medium','134',6,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Glove Nitrile Blue Large','135',6,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Glove Nitrile Blue Extra Large','136',6,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Spray Pan Release','137',6,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Floor Cleaner HP Neutral','138',6,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES('Greaselift','139',6,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Multi Surface Clnr Peroxide','140',6,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Odor Eliminator','141',6,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Pantastic','142',6,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Sanitizer Sink/Surface','143',6,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Plastic Black Cups','144',6,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Plastic Clear Lid','145',6,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Pizza Screen','146',6,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Oven Mitts','147',6,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Glove Cuttless','148',6,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Biscuit - Sausage, Egg & Cheese','149',7,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Biscuit - Sausage & Cheese','150',7,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Croissant - Sausage, Egg & Cheese','151',7,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Croissant - Bacon, Egg & Cheese','152',7,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Bagel - Bacon, Egg & Cheese','153',7,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Eng. Muffin - Turkey Sausage, Egg & Pepperjac','154',7,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('English Muffin - Bacon, Egg & Cheese','155',7,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Burrito - Sausage','156',7,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Burrito - Chorizo ','157',7,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Burrito - Bacon','158',7,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Bites - Chicken Spicy','159',7,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Bites - Chicken Regular','160',7,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Bites - Corn Dog','161',7,0.00,'','each',0);
INSERT INTO `product` (`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES ('Expiration Date','162',7,0.00,'','each',0);
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('MC Croissant Chicken Salad', '163', '8', '0.03', '746295018459', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('MC Croissant Egg Salad', '164', '8', '0.03', '746295018442', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('MC All American Meat', '165', '8', '0.02', '746295019944', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('MC Italian Sub', '166', '8', '0.02', '746295019951', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('MC Ham & Swiss', '167', '8', '0.04', '746295015076', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('MC Ham & Turkey', '168', '8', '0.04', '746295015090', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('MC Mega Bacon ChBurger', '169', '8', '0.14', '746295015069', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('MC Ham & Cheese pounder', '170', '8', '0.14', '746295018466', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('MC Tuna On Wheatberry', '171', '8', '0.03', '746295018435', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Fathers Table NY Cheesecake', '172', '8', '0.01', '10374210141', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Fathers Table Sb Cheesecake', '173', '8', '0.01', '10374210158', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('OMG Reese\'s Cheesecake', '174', '8', '0.13', '861440000001', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('OMG Cookies N Cream Cheesecake', '175', '8', '0.13', '861440000025', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('OMG Strawberry Cheesecake', '176', '8', '0.13', '861440000018', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('OMG White Chocolate Cheesecake', '177', '8', '0.13', '861440000049', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Nemos Carrot Cake', '178', '8', '0.25', '76064002045', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Nemos Banana Cake', '179', '8', '0.25', '76064003042', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Nemos Black n White Cake', '180', '8', '0.25', '76064010668', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Nemos Chocolate Cake', '181', '8', '0.25', '76064001048', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Musselmans Squeezables', '182', '8', '0.21', '37323117818', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Jamwich PB and Strawberry', '183', '8', '0.01', '71421921212', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Jamwich PB and Grape', '184', '8', '0.01', '71421921205', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Armour Lunchmakers Turkey', '185', '8', '0.02', '46600034281', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Armour Lunchmakers Ham', '186', '8', '0.02', '46600034274', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Lunchables Turkey & Cheddar', '187', '8', '0.11', '44700024553', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Lunchables Light Bologna', '188', '8', '0.11', '44700360026', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Lunchables Ham & Swiss', '189', '8', '0.11', '47700024546', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Del Monte Cantaloupe', '190', '8', '0.13', '717524414359', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Del Monte Super Fruit Medley', '191', '8', '0.05', '717524776389', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Del Monte Grapes', '192', '8', '0.12', '717524720542', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Del Monte Pine/Apple/Grapes', '193', '8', '0.12', '717524776396', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Del Monte Strawberrys', '194', '8', '0.09', '717524200280', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Del Monte Mango Slice', '195', '8', '0.09', '717524725448', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Del Monte Watermelon', '196', '8', '0.09', '717524412874', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Del Monte Seasonal Blend', '197', '8', '0.09', '717524719300', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Cheese Pleasers Colby Jack', '198', '8', '0.22', '46247211113', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Cheese Pleasers Pepper Jack', '199', '8', '0.22', '46247188880', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Wisconsin Mozzarella String', '200', '8', '0.22', '46247811115', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Cheese Pleasers Cheese & Beef', '201', '8', '0.21', '46247155561', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Kraft String Mozzarella', '202', '8', '0.19', '21000003983', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Kraft Twists Mozzarella Cheddar', '203', '8', '0.17', '21000000227', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Taylor Farms Mediterranean', '204', '8', '0.11', '30223101710', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Taylor Farms Chicken Ceasar', '205', '8', '0.11', '30223101697', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Del Cafe Chef Salad w/ Turkey', '206', '8', '0.29', '717524772039', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Almark 2p Egg', '207', '8', '0.22', '44984002421', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Del Cafe Ceasar Salad w/ Chicken', '208', '8', '0.21', '717524772015', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Sundia Peach', '209', '8', '0.15', '810051010503', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Sundia Grapefruit', '210', '8', '0.15', '810051010480', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Sundia Tropical Medley', '211', '8', '0.15', '810051010541', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Dippin Stix Apples & PB', '212', '8', '0.23', '649632000837', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Dippin Stix Apple & Caramel', '213', '8', '0.27', '649632000806', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Dippin Stix Apple & Choc Caramel', '214', '8', '0.27', '649632001285', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Gatorade Protein Shake Choc', '215', '8', '0.01', '52000101096', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Gatorade Protein Shake Cookies & Creme', '216', '8', '0.01', '52000103892', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Naked Juice Green Machine', '217', '8', '0.07', '82592720153', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Naked Juice Protein Zone', '218', '8', '0.07', '82592722157', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Naked Juice Strawberry Banana', '219', '8', '0.07', '82592194152', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Yoplait Strawberry', '220', '8', '0.33', '70470003009', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Chobani Strawberry', '221', '8', '0.33', '94700010045', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Yocrunch Strawberry', '222', '8', '0.22', '46675000105', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Yocrunch M&M', '223', '8', '0.22', '46675000792', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Horizon Chocolate Milk', '224', '8', '0.14', '742365208850', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Horizon Regular Milk', '225', '8', '0.14', '742365208256', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('P3 Ham', '226', '8', '0.26', '44700070772', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('P3 Turkey', '227', '8', '0.26', '44700070758', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Fast Bites Sausage Biscuit', '228', '8', '0.15', '71421110333', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Fast Bites Chicken Biscuit', '229', '8', '0.15', '71421110111', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Owens Biscuits 2pk', '230', '8', '0.08', '70110056501', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Johns Bisc Ssg & Gravy', '231', '8', '0.09', '77782030976', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Big Bites Double Sausage', '232', '8', '0.08', '746295018428', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('El Mont Egg & Ssg Burrito', '233', '8', '0.07', '71007144783', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Big Bites BBQ Rib', '234', '8', '0.05', '746295019241', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Big Bites Deli Ham & Cheese', '235', '8', '0.06', '746295015113', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Big Bites Twin Jala Smoked Ssg', '236', '8', '0.22', '746295011139', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Tony\'s Deep Dish Pizza', '237', '8', '0.17', '72180635280', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Big Bites Chicken n Cheese', '238', '8', '0.15', '746295015106', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Big Bites Twin Chili Melts', '239', '8', '0.14', '746295018053', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Big Bites Italian Sub', '240', '8', '0.17', '746295017520', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('LTO Big Bite', '241', '8', '0.21', '746295018305', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Big Bites Charboil Melts', '242', '8', '0.09', '746295018022', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Big Bites Jalapeno Burger', '243', '8', '0.09', '746295019234', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Foster Farms Corndog Jumbo', '244', '8', '0.11', '75278952900', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Don Miguel Beef & Green Chili', '245', '8', '0.16', '27089185544', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Don Miguel Chicken Chimi', '246', '8', '0.16', '27086185575', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Tina\'s Bean & Cheese', '247', '8', '0.15', '79606010409', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Tina\'s Beef & Bean', '248', '8', '0.15', '79606010201', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Tina\'s Red Hot Beef', '249', '8', '0.15', '79606010102', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Tina\'s Beef & Bean/Green Chili', '250', '8', '0.15', '79606010300', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Tina\'s Red Hot Beef Chimi', '251', '8', '0.07', '79606010546', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('El Mont Shredded Steak & Cheese', '252', '8', '0.11', '71007157233', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('El Mont Chimichanga', '253', '8', '0.22', '71007186141', 'each', '0');


--
-- Inserting data for table `available_category`
--

INSERT INTO `7eleven`.`available_category` (`id`, `category_name`) VALUES (9, 'FreshProd');


--
-- Inserting data for table `product_availability`
--

INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '163', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '164', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '165', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '166', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '167', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '168', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '169', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '170', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '171', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '172', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '173', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '174', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '175', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '176', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '177', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '178', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '179', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '180', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '181', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '182', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '183', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '184', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '185', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '186', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '187', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '188', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '189', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '190', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '191', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '192', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '193', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '194', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '195', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '196', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '197', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '198', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '199', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '200', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '201', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '202', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '203', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '204', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '205', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '206', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '207', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '208', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '209', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '210', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '211', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '212', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '213', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '214', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '215', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '216', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '217', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '218', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '219', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '220', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '221', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '222', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '223', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '224', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '225', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '226', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '227', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '228', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '229', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '230', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '231', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '232', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '233', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '234', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '235', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '236', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '237', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '238', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '239', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '240', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '241', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '242', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '243', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '244', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '245', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '246', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '247', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '248', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '249', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '250', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '251', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '252', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '253', '304');


--
-- Inserting data for table `available_category_times`
--

INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (9,'5am-11am','11:30:00','05:00:00','11:00:00');


--
-- Inserting data for table `profile`
--

INSERT INTO `profiles` (`id`,`profile_name`,`profile_code`) VALUES (3,'Fresh Products','fp');


COMMIT;
