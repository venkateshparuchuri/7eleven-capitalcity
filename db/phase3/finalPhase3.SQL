################# adding new user dbq_admin ######################

INSERT INTO `7eleven`.`role` (`id`, `name`) VALUES ('114', 'DBQ_Admin');
INSERT INTO `7eleven`.`user` (`user_id`, `name`, `email`, `password`, `initials`) VALUES ('dbqadmin', 'DBQ Admin', 'dbqadmin@7eleven.com', '235e74373fae4154aca06bf7ad7b42e0faed5698183494d707c39c047bb5aa8f4be166850a7f51d90969bb618636296c', 'v');
INSERT INTO `7eleven`.`user_role` (`user_id`, `role_id`, `store_id`) VALUES ('146', '114', '36104');


############ added auto increment for id in user table ###########

SET FOREIGN_KEY_CHECKS=0;

ALTER TABLE `7eleven`.`product`
CHANGE COLUMN `id` `id` BIGINT(20) NOT NULL AUTO_INCREMENT ;

SET FOREIGN_KEY_CHECKS=1;


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
-- Inserting data for table `product_type`
--

INSERT INTO `product_type` (`id`,`type`) VALUES (5,'Packaging');
INSERT INTO `product_type` (`id`,`type`) VALUES (6,'Supplies');
INSERT INTO `product_type` (`id`,`type`) VALUES (7,'Labels');
INSERT INTO `product_type` (`id`,`type`) VALUES (8,'Perishable Goods');


ALTER TABLE `7eleven`.`product`
ADD COLUMN `case_qty` VARCHAR(45) NULL DEFAULT NULL AFTER `upc`;


--
-- Inserting data for table `product`
--

INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('179', 'Almark 2p Egg', '137', '8', '0.22', '44984002421', '10', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('180', 'Armour Lunchmakers Ham', '138', '8', '0.02', '46600034274', '18', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('181', 'Armour Lunchmakers Turkey', '139', '8', '0.02', '46600034281', '18', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('182', 'Bar-S Bolgna 12oz', '140', '8', '0', '15900000432', '16', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('183', 'Bar-S Chopped Ham', '141', '8', '0', '15900000722', '18', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('184', 'Bar-S Cooked Ham', '142', '8', '0', '15900000258', '16', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('185', 'Bar-S Hot Link', '143', '8', '0', '15900238200', '12', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('186', 'Bar-S Salami 12z', '144', '8', '0', '15900000210', '16', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('187', 'Bar-S Sliced Bacon', '145', '8', '0', '15900060009', '24', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('188', 'Bar-S Smkd Sausage', '146', '8', '0', '15900235889', '12', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('189', 'Bar-S ThickBologna', '147', '8', '0', '15900000289', '12', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('190', 'Bar-S JumbMtFrnk16z', '148', '8', '0', '15900002115', '1', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('191', 'Big Bites BBQ Rib', '149', '8', '0.05', '746000000000', '12', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('192', 'Big Bites Charboil Melts', '150', '8', '0.09', '746000000000', '12', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('193', 'Big Bites Chicken n Cheese', '151', '8', '0.15', '746000000000', '12', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('194', 'Big Bites Deli Ham & Cheese', '152', '8', '0.06', '746000000000', '12', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('195', 'Big Bites Double Sausage', '153', '8', '0.08', '746000000000', '12', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('196', 'Big Bites Deli Italian Sub', '154', '8', '0', '74629501841', '12', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('197', 'Big Bites Jalapeno Burger', '155', '8', '0.09', '746000000000', '12', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('198', 'Big Bites Twin Chili Melts', '156', '8', '0.14', '746000000000', '12', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('199', 'Big Bites Twin Jala Smoked Ssg', '157', '8', '0.22', '746000000000', '12', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('200', 'Borden ShredShpChd', '158', '8', '0', '53000053613', '12', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('201', 'Buddig Beef 2z', '159', '8', '0', '77400127132', '1', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('202', 'Buddig Chicken 2oz', '160', '8', '0', '77400127538', '1', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('203', 'Buddig Ham 2z', '161', '8', '0', '77400127231', '1', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('204', 'Buddig TkyHnyOvRst', '162', '8', '0', '77400128634', '1', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('205', 'Buddig Turkry 2z', '163', '8', '0', '77400127330', '1', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('206', 'Cheese Pleasers Cheese & Beef', '164', '8', '0.21', '46247155561', '8', 'bx', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('207', 'Cheese Pleasers Colby Jack', '165', '8', '0.22', '46247211113', '24', 'bx', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('208', 'Cheese Pleasers Pepper Jack', '166', '8', '0.22', '46247188880', '24', 'bx', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('209', 'Chobani Strawberry', '167', '8', '0.33', '94700010045', '12', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('210', 'Cntry Crock Marg', '168', '8', '0', '27400103223', '1', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('211', 'Del Cafe Ceasar Salad w/ Chicken', '169', '8', '0.21', '718000000000', '1', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('212', 'Del Cafe Chef Salad w/ Turkey', '170', '8', '0.29', '718000000000', '1', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('213', 'Del Monte Cantaloupe', '171', '8', '0.13', '718000000000', '1', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('214', 'Del Monte Grapes', '172', '8', '0.12', '718000000000', '1', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('215', 'Del Monte Mango Slice', '173', '8', '0.09', '718000000000', '1', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('216', 'Del Monte Pine/Apple/Grapes', '174', '8', '0.12', '718000000000', '1', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('217', 'Del Monte Seasonal Blend', '175', '8', '0.09', '718000000000', '1', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('218', 'Del Monte Strawberrys', '176', '8', '0.09', '718000000000', '1', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('219', 'Del Monte Super Fruit Medley', '177', '8', '0.05', '718000000000', '1', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('220', 'Del Monte Watermelon', '178', '8', '0.09', '718000000000', '1', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('221', 'Dippin Stix Apple & Caramel', '179', '8', '0.27', '650000000000', '6', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('222', 'Dippin Stix Apple & Choc Caramel', '180', '8', '0.27', '650000000000', '6', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('223', 'Dippin Stix Apples & PB', '181', '8', '0.23', '650000000000', '6', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('224', 'Don Miguel Beef & Green Chili', '182', '8', '0.16', '27089185544', '12', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('225', 'Don Miguel Chicken Chimi', '183', '8', '0.16', '27086185575', '12', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('226', 'Egglands Fresh dz', '184', '8', '0', '715000000000', '9', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('227', 'El Mont Chimichanga', '185', '8', '0.22', '71007186141', '24', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('228', 'El Mont Egg & Ssg Burrito', '186', '8', '0.07', '71007144783', '24', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('229', 'El Mont Shredded Steak & Cheese', '187', '8', '0.11', '71007157233', '24', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('230', 'Fast Bites Chicken Biscuit', '188', '8', '0.15', '71421110111', '12', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('231', 'Fast Bites Sausage Biscuit', '189', '8', '0.15', '71421110333', '12', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('232', 'Fathers Table NY Cheesecake', '190', '8', '0.01', '10374210141', '12', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('233', 'Fathers Table Sb Cheesecake', '191', '8', '0.01', '10374210158', '12', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('234', 'Horizon Chocolate Milk', '192', '8', '0.14', '742000000000', '18', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('235', 'Horizon Regular Milk', '193', '8', '0.14', '742000000000', '18', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('236', 'Jamwich PB and Grape', '194', '8', '0.01', '71421921205', '24', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('237', 'Jamwich PB and Strawberry', '195', '8', '0.01', '71421921212', '24', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('238', 'Johns Bisc Ssg & Gravy', '196', '8', '0.09', '77782030976', '16', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('239', 'Kraft AmerChsDlxSg', '197', '8', '0', '21000602513', '12', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('240', 'Kraft Americ Singl', '198', '8', '0', '21000604739', '12', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('241', 'Kraft FrnchOnion8z', '199', '8', '0', '21000613830', '1', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('242', 'Kraft Mild Cheddar', '200', '8', '0', '21000001941', '12', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('243', 'Kraft Nat StrngChs', '201', '8', '0', '21000000227', '24', 'bx', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('244', 'Kraft Phil Crm Chs', '202', '8', '0', '21000612239', '12', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('245', 'Kraft Twist-Ums', '203', '8', '0', '21000003983', '24', 'bx', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('246', 'Kraft Velveeta Chs', '204', '8', '0', '21000616909', '12', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('247', 'LTO Big Bite', '205', '8', '0.21', '746000000000', '12', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('248', 'Lunchables Ham & Swiss', '206', '8', '0.11', '47700024546', '1', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('249', 'Lunchables Light Bologna', '207', '8', '0.11', '44700360026', '1', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('250', 'Lunchables Turkey & Cheddar', '208', '8', '0.11', '44700024553', '1', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('251', 'MC All American Meat', '209', '8', '0.02', '746000000000', '8', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('252', 'MC Croissant Chicken Salad', '210', '8', '0.03', '746000000000', '6', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('253', 'MC Croissant Egg Salad', '211', '8', '0.03', '746000000000', '6', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('254', 'MC Ham & Cheese pounder', '212', '8', '0.14', '746000000000', '6', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('255', 'MC Ham & Swiss', '213', '8', '0.04', '746000000000', '6', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('256', 'MC Ham & Turkey', '214', '8', '0.04', '746000000000', '6', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('257', 'MC Italian Sub', '215', '8', '0.02', '746000000000', '8', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('258', 'MC Mega Bacon ChBurger', '216', '8', '0.14', '746000000000', '6', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('259', 'MC Tuna On Wheatberry', '217', '8', '0.03', '746000000000', '6', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('260', 'Musselmans Squeezables', '218', '8', '0.21', '37323117818', '1', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('261', 'Naked Juice Green Machine', '219', '8', '0.07', '82592720153', '8', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('262', 'Naked Juice Protein Zone', '220', '8', '0.07', '82592722157', '8', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('263', 'Naked Juice Strawberry Banana', '221', '8', '0.07', '82592194152', '8', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('264', 'Nemos Banana Cake', '222', '8', '0.25', '76064003042', '6', 'bx', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('265', 'Nemos Black n White Cake', '223', '8', '0.25', '76064010668', '6', 'bx', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('266', 'Nemos Carrot Cake', '224', '8', '0.25', '76064002045', '6', 'bx', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('267', 'Nemos Chocolate Cake', '225', '8', '0.25', '76064001048', '6', 'bx', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('268', 'OMG Cookies N Cream Cheesecake', '226', '8', '0.13', '861000000000', '12', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('269', 'OMG Reese\'s Cheesecake', '227', '8', '0.13', '861000000000', '12', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('270', 'OMG Strawberry Cheesecake', '228', '8', '0.13', '861000000000', '12', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('271', 'OMG White Chocolate Cheesecake', '229', '8', '0.13', '861000000000', '12', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('272', 'Owens Biscuits 2pk', '230', '8', '0.08', '70110056501', '24', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('273', 'P3 Ham', '231', '8', '0.26', '44700070772', '5', 'bx', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('274', 'P3 Turkey', '232', '8', '0.26', '44700070758', '5', 'bx', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('275', 'Schwab Smkd HotLnk', '233', '8', '0', '76713000040', '10', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('276', 'Sundia Grapefruit', '234', '8', '0.15', '810000000000', '12', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('277', 'Sundia Peach', '235', '8', '0.15', '810000000000', '12', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('278', 'Sundia Tropical Medley', '236', '8', '0.15', '810000000000', '12', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('279', 'Taylor Farms Chicken Ceasar', '237', '8', '0.11', '30223101697', '1', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('280', 'Taylor Farms Mediterranean', '238', '8', '0.11', '30223101710', '1', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('281', 'Tina\'s Bean & Cheese', '239', '8', '0.15', '79606010409', '12', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('282', 'Tina\'s Beef & Bean', '240', '8', '0.15', '79606010201', '12', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('283', 'Tina\'s Beef & Bean/Green Chili', '241', '8', '0.15', '79606010300', '12', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('284', 'Tina\'s Red Hot Beef', '242', '8', '0.15', '79606010102', '12', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('285', 'Tina\'s Red Hot Beef Chimi', '243', '8', '0.07', '79606010546', '12', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('286', 'Tony\'s Deep Dish Pizza', '244', '8', '0.17', '72180635280', '24', 'cs', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('287', 'Yocrunch M&M', '245', '8', '0.22', '46675000792', '12', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('288', 'Yocrunch Strawberry', '246', '8', '0.22', '46675000105', '12', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('289', 'Yoplait Strawberry', '247', '8', '0.33', '70470003009', '12', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('290', 'Imaginary Wonderful Sandwich', '248', '8', '0', '71100000001i', '1', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('291', 'Imaginary Tasty Sandwich', '249', '8', '0', '71100000002i', '1', 'ea', '0');
INSERT INTO `7eleven`.`product` (`id`, `name`, `sku`, `product_type_id`, `product_cost`, `upc`, `case_qty`, `unit_type`, `product_parent_id`) VALUES ('292', 'Imaginary Delightful Sandwich', '250', '8', '0', '71100000003i', '1', 'es', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`) VALUES ('Fresh Cooler', '293', '8');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`) VALUES ('Cooler Doors', '294', '8');


--
-- Inserting data for table `available_category`
--

INSERT INTO `7eleven`.`available_category` (`id`, `category_name`) VALUES (9, 'perishableGoods');
INSERT INTO `7eleven`.`available_category` (`id`, `category_name`) VALUES ('10', 'perishableTemp');


ALTER TABLE `available_category_times`
ADD COLUMN `parent_time_id` INT(11) NULL DEFAULT NULL AFTER `end_time`;


--
-- Inserting data for table `available_category_times`
--

UPDATE `7eleven`.`available_category_times` SET `time_range`='5am-9am', `report_before`='09:30:00', `end_time`='09:00:00' WHERE `id`='26';
UPDATE `7eleven`.`available_category_times` SET `time_range`='9am-1pm', `report_before`='13:30:00', `end_time`='13:00:00' WHERE `id`='27';
UPDATE `7eleven`.`available_category_times` SET `time_range`='1pm-5pm', `report_before`='17:30:00', `start_time`='13:00:00', `end_time`='17:00:00' WHERE `id`='28';
UPDATE `7eleven`.`available_category_times` SET `time_range`='5pm-9pm', `report_before`='21:30:00', `start_time`='17:00:00', `end_time`='21:00:00' WHERE `id`='29';
UPDATE `7eleven`.`available_category_times` SET `time_range`='9pm-1am', `report_before`='01:30:00', `start_time`='21:00:00', `end_time`='01:00:00' WHERE `id`='30';
INSERT INTO `7eleven`.`available_category_times` (`available_category_id`, `time_range`, `report_before`, `start_time`, `end_time`) VALUES ('7', '1am-5am', '05:30:00', '01:00:00', '05:00:00');
INSERT INTO `7eleven`.`available_category_times` (`available_category_id`, `time_range`, `report_before`, `start_time`, `end_time`) VALUES ('9', '12am-12pm', '12:30:00', '00:00:00', '24:00:00');
INSERT INTO `7eleven`.`available_category_times` (`available_category_id`, `time_range`, `report_before`, `start_time`, `end_time`) VALUES ('10', '6am-2pm', '14:30:00', '06:00:00', '14:00:00');
INSERT INTO `7eleven`.`available_category_times` (`available_category_id`, `time_range`, `report_before`, `start_time`, `end_time`) VALUES ('10', '2pm-10pm', '22:30:00', '14:00:00', '22:00:00');
INSERT INTO `7eleven`.`available_category_times` (`available_category_id`, `time_range`, `report_before`, `start_time`, `end_time`) VALUES ('10', '10pm-6am', '06:30:00', '22:00:00', '06:00:00');
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='26' WHERE `id`='36';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='26' WHERE `id`='37';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='26' WHERE `id`='38';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='26' WHERE `id`='39';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='27' WHERE `id`='40';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='27' WHERE `id`='41';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='27' WHERE `id`='42';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='27' WHERE `id`='43';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='28' WHERE `id`='44';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='28' WHERE `id`='45';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='28' WHERE `id`='46';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='28' WHERE `id`='47';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='29' WHERE `id`='48';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='29' WHERE `id`='49';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='29' WHERE `id`='50';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='29' WHERE `id`='51';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='30' WHERE `id`='52';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='30' WHERE `id`='53';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='30' WHERE `id`='54';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='30' WHERE `id`='31';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='55' WHERE `id`='32';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='55' WHERE `id`='33';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='55' WHERE `id`='34';
UPDATE `7eleven`.`available_category_times` SET `parent_time_id`='55' WHERE `id`='35';


--
-- Inserting data for table `product_availability`
--


INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '293', '305');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '294', '306');


--
-- Inserting data for table `product_cost_history`
--

INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (179,'2016-05-14',0.22);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (180,'2016-05-14',0.02);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (181,'2016-05-14',0.02);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (182,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (183,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (184,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (185,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (186,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (187,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (188,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (189,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (190,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (191,'2016-05-14',0.05);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (192,'2016-05-14',0.09);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (193,'2016-05-14',0.15);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (194,'2016-05-14',0.06);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (195,'2016-05-14',0.08);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (196,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (197,'2016-05-14',0.09);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (198,'2016-05-14',0.14);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (199,'2016-05-14',0.22);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (200,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (201,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (202,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (203,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (204,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (205,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (206,'2016-05-14',0.21);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (207,'2016-05-14',0.22);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (208,'2016-05-14',0.22);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (209,'2016-05-14',0.33);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (210,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (211,'2016-05-14',0.21);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (212,'2016-05-14',0.29);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (213,'2016-05-14',0.13);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (214,'2016-05-14',0.12);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (215,'2016-05-14',0.09);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (216,'2016-05-14',0.12);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (217,'2016-05-14',0.09);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (218,'2016-05-14',0.09);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (219,'2016-05-14',0.05);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (220,'2016-05-14',0.09);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (221,'2016-05-14',0.27);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (222,'2016-05-14',0.27);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (223,'2016-05-14',0.23);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (224,'2016-05-14',0.16);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (225,'2016-05-14',0.16);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (226,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (227,'2016-05-14',0.22);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (228,'2016-05-14',0.07);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (229,'2016-05-14',0.11);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (230,'2016-05-14',0.15);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (231,'2016-05-14',0.15);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (232,'2016-05-14',0.01);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (233,'2016-05-14',0.01);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (234,'2016-05-14',0.14);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (235,'2016-05-14',0.14);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (236,'2016-05-14',0.01);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (237,'2016-05-14',0.01);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (238,'2016-05-14',0.09);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (239,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (240,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (241,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (242,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (243,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (244,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (245,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (246,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (247,'2016-05-14',0.21);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (248,'2016-05-14',0.11);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (249,'2016-05-14',0.11);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (250,'2016-05-14',0.11);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (251,'2016-05-14',0.02);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (252,'2016-05-14',0.03);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (253,'2016-05-14',0.03);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (254,'2016-05-14',0.14);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (255,'2016-05-14',0.04);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (256,'2016-05-14',0.04);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (257,'2016-05-14',0.02);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (258,'2016-05-14',0.14);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (259,'2016-05-14',0.03);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (260,'2016-05-14',0.21);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (261,'2016-05-14',0.07);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (262,'2016-05-14',0.07);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (263,'2016-05-14',0.07);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (264,'2016-05-14',0.25);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (265,'2016-05-14',0.25);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (266,'2016-05-14',0.25);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (267,'2016-05-14',0.25);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (268,'2016-05-14',0.13);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (269,'2016-05-14',0.13);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (270,'2016-05-14',0.13);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (271,'2016-05-14',0.13);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (272,'2016-05-14',0.08);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (273,'2016-05-14',0.26);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (274,'2016-05-14',0.26);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (275,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (276,'2016-05-14',0.15);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (277,'2016-05-14',0.15);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (278,'2016-05-14',0.15);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (279,'2016-05-14',0.11);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (280,'2016-05-14',0.11);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (281,'2016-05-14',0.15);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (282,'2016-05-14',0.15);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (283,'2016-05-14',0.15);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (284,'2016-05-14',0.15);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (285,'2016-05-14',0.07);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (286,'2016-05-14',0.17);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (287,'2016-05-14',0.22);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (288,'2016-05-14',0.22);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (289,'2016-05-14',0.33);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (290,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (291,'2016-05-14',0.00);
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES (292,'2016-05-14',0.00);

--
-- Inserting data for table `profile`
--

INSERT INTO `7eleven`.`profiles` (`id`, `profile_name`, `profile_code`) VALUES ('3', 'Perishable Goods', 'pg');


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
-- Table structure for table `reports_users`
--

DROP TABLE IF EXISTS `reports_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reports_users` (
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
  `case_qty` varchar(45) NOT NULL,
  `brand` varchar(45) NOT NULL,
  `item` varchar(45) NOT NULL,
  `dbq` varchar(45) NOT NULL,
  `max_quantity` int(10) DEFAULT '10' COMMENT '			',
  `Active_flag` varchar(20) NOT NULL DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index3` (`product_description`),
  KEY `fk_dbq_products_1_idx` (`product_type_id`),
  CONSTRAINT `fk_dbq_products_1` FOREIGN KEY (`product_type_id`) REFERENCES `product_type` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('1', 'Clamshell Box', '5', 'Dry', 'EA', '300', 'OFC', 'Sandwich', '40451');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('2', 'Pizza Slice', '5', 'Dry', 'EA', '375', 'OFC', 'Pizza', '40642');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('3', 'Pizza Breakfast Slice', '5', 'Dry', 'EA', '375', 'OFC', 'Breakfast', '40634');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('4', 'Pretzel Box', '5', 'Dry', 'EA', '275', 'OFC', 'Pretzel', '40659');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('5', 'Snack/Chicken Box', '5', 'Dry', 'EA', '400', 'OFC', 'Snack', '40139');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('6', 'Aluminum Foil Sheets', '5', 'Dry', '9\" x 10.75\"', '500 Sheets', 'Jiffy Foil', '59100', '37333');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('7', 'Deli Tissue Paper', '5', 'Dry', '12\" x 12\"', '1000 Sheets', 'Handy Wacks', '388934', '38703');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('8', 'Pizza Box', '5', 'Dry', '16\" x 16\"', '50', 'OFC', 'Pizza', '38141');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('9', 'Ziploc Bags', '6', 'Dry', 'Gal', '250 ct', 'Ziploc', '94602', '38158');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('10', 'Food Service Film', '6', 'Dry', '24\"X2000\'', '1', 'Handi-Foil', '22045', '38166');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('11', 'Glove Nitrile Blue Medium', '6', 'Dry', 'Med', '250 ct', 'Bunzl', '494', '38174');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('12', 'Glove Nitrile Blue Large', '6', 'Dry', 'Lrg', '250 ct', 'Bunzl', '495', '38182');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('13', 'Glove Nitrile Blue Extra Large', '6', 'Dry', 'XLrg', '250 ct', 'Bunzl', '496', '38190');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('14', 'Spray Pan Release', '6', 'Dry', 'EA', '14 oz', 'Prof Prep', '35039', '38208');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('15', 'Floor Cleaner HP Neutral', '6', 'Dry', 'EA', '44 oz', 'Ecolab', '6100082', '40444');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('16', 'Greaselift', '6', 'Dry', 'EA', '32 oz', 'Ecolab', '6100284', '40436');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('17', 'Multi Surface Clnr Peroxide', '6', 'Dry', 'EA', '44 oz', 'Ecolab', '6100792', '40394');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('18', 'Odor Eliminator', '6', 'Dry', 'EA', '44 oz', 'Ecolab', '6101023', '40402');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('19', 'Pantastic', '6', 'Dry', 'EA', '1 Gal', 'Ecolab', '12963', '40410');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('20', 'Sanitizer Sink/Surface', '6', 'Dry', 'EA', '2.50 Gal', 'Ecolab', '17708', '40428');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('21', 'Plastic Black Cups', '6', 'Dry', '4 oz', '200 ct', 'Dixie', '522968', '40204');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('22', 'Plastic Clear Lid', '6', 'Dry', 'EA', '100 ct', 'Dixie', '523070', '40212');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('23', 'Pizza Screen', '6', 'Dry', '16\"', '12', 'International', 'PS-16', '39271');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('24', 'Oven Mitts', '6', 'Dry', 'Large', '1 pr', 'San Jamar', '801SG15', '39289');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('25', 'Glove Cuttless', '6', 'Dry', 'Large', '1', 'Swiss', '86504', '40857');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('26', 'Biscuit - Sausage, Egg & Cheese', '7', 'Dry', 'Roll', '1000', 'Keystone', '2.5 x 3.5', '38281');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('27', 'Biscuit - Sausage & Cheese', '7', 'Dry', 'Roll', '1000', 'Keystone', '2.5 x 3.5', '38299');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('28', 'Croissant - Sausage, Egg & Cheese', '7', 'Dry', 'Roll', '1000', 'Keystone', '2.5 x 3.5', '38307');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('29', 'Croissant - Bacon, Egg & Cheese', '7', 'Dry', 'Roll', '1000', 'Keystone', '2.5 x 3.5', '38315');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('30', 'Bagel - Bacon, Egg & Cheese', '7', 'Dry', 'Roll', '1000', 'Keystone', '2.5 x 3.5', '38323');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('31', 'Eng. Muffin - Turkey Sausage, Egg & Pepperjack', '7', 'Dry', 'Roll', '1000', 'Keystone', '2.5 x 3.5', '38331');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('32', 'English Muffin - Bacon, Egg & Cheese', '7', 'Dry', 'Roll', '1000', 'Keystone', '2.5 x 3.5', '38349');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('33', 'Burrito - Sausage', '7', 'Dry', 'Roll', '1000', 'Keystone', '3\" rounds', '38406');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('34', 'Burrito - Chorizo', '7', 'Dry', 'Roll', '1000', 'Keystone', '3\" rounds', '38414');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('35', 'Burrito - Bacon', '7', 'Dry', 'Roll', '1000', 'Keystone', '3\" rounds', '40972');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('36', 'Bites - Chicken Spicy', '7', 'Dry', 'Roll', '1000', 'Keystone', '2.5 x 3.5', '40477');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('37', 'Bites - Chicken Regular', '7', 'Dry', 'Roll', '1000', 'Keystone', '2.5 x 3.5', '40469');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('38', 'Bites - Corn Dog', '7', 'Dry', 'Roll', '1000', 'Keystone', '2.5 x 3.5', '40485');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('39', 'Pretzel - Big Salty', '5', 'Dry', 'Roll', '1000', 'Keystone', '2.5 x 3.5', '38380');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('40', 'Expiration Date', '7', 'Dry', 'Roll', '1000', 'Keystone', '3 x 1.5', '38398');
INSERT INTO `7eleven`.`dbq_products` (`id`, `product_description`, `product_type_id`, `storage`, `size`, `case_qty`, `brand`, `item`, `dbq`) VALUES ('40', 'Scour Pad', '6', 'Dry', 'Small', '1', 'Dot', '520735', '42564');


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
  `date_time` datetime NOT NULL,
  `total` varchar(45) DEFAULT NULL,
  `status` varchar(45) NOT NULL,
  `order_placed` varchar(45) NOT NULL DEFAULT 'NO',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index3` (`dbqp_id`,`store_id`,`date`),
  KEY `fk_dbq_orders_2_idx` (`store_id`),
  CONSTRAINT `fk_dbq_orders_1` FOREIGN KEY (`dbqp_id`) REFERENCES `dbq_products` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_dbq_orders_2` FOREIGN KEY (`store_id`) REFERENCES `store` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `excel_reports`
--

DROP TABLE IF EXISTS `excel_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE `excel_reports` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `store_id` bigint(11) NOT NULL,
  `monthYear` varchar(45) NOT NULL DEFAULT 'False',
  `report_generation_date` datetime NOT NULL,
  `active_flag` varchar(45) NOT NULL DEFAULT 'false',
  `file_location` varchar(200) NOT NULL DEFAULT 'False',
  PRIMARY KEY (`id`),
  KEY `fk_report_1_idx` (`store_id`),
  CONSTRAINT `fk_report_1` FOREIGN KEY (`store_id`) REFERENCES `store` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `vendors`
--

DROP TABLE IF EXISTS `vendors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vendors` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `vendor_name` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Dumping data for table `vendors`
--

LOCK TABLES `vendors` WRITE;
/*!40000 ALTER TABLE `vendors` DISABLE KEYS */;
INSERT INTO `vendors` VALUES (1,'Core-Mark'),(2,'DBQ'),(3,'Commissary');
/*!40000 ALTER TABLE `vendors` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Table structure for table `vendor_product_availability`
--

DROP TABLE IF EXISTS `vendor_product_availability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vendor_product_availability` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) NOT NULL,
  `available_category_id` bigint(20) NOT NULL,
  `vendor_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index5` (`product_id`,`vendor_id`),
  KEY `fk_vendor_product_availability_1_idx` (`available_category_id`),
  KEY `fk_vendor_product_availability_2_idx` (`product_id`),
  KEY `fk_vendor_product_availability_3_idx` (`vendor_id`),
  CONSTRAINT `fk_vendor_product_availability_1` FOREIGN KEY (`available_category_id`) REFERENCES `available_category` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_vendor_product_availability_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_vendor_product_availability_3` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vendor_product_availability`
--

LOCK TABLES `vendor_product_availability` WRITE;
/*!40000 ALTER TABLE `vendor_product_availability` DISABLE KEYS */;
INSERT INTO `vendor_product_availability` VALUES (1,179,9,1),(2,180,9,1),(3,181,9,1),(4,182,9,1),(5,183,9,1),(6,184,9,1),(7,185,9,1),(8,186,9,1),(9,187,9,1),(10,188,9,1),(11,189,9,1),(12,190,9,1),(13,191,9,1),(14,192,9,1),(15,193,9,1),(16,194,9,1),(17,195,9,1),(18,196,9,1),(19,197,9,1),(20,198,9,1),(21,199,9,1),(22,200,9,1),(23,201,9,1),(24,202,9,1),(25,203,9,1),(26,204,9,1),(27,205,9,1),(28,206,9,1),(29,207,9,1),(30,208,9,1),(31,209,9,1),(32,210,9,1),(33,211,9,1),(34,212,9,1),(35,213,9,1),(36,214,9,1),(37,215,9,1),(38,216,9,1),(39,217,9,1),(40,218,9,1),(41,219,9,1),(42,220,9,1),(43,221,9,1),(44,222,9,1),(45,223,9,1),(46,224,9,1),(47,225,9,1),(48,226,9,1),(49,227,9,1),(50,228,9,1),(51,229,9,1),(52,230,9,1),(53,231,9,1),(54,232,9,1),(55,233,9,1),(56,234,9,1),(57, 235,9,1),(58,236,9,1),(59,237,9,1),(60,238,9,1),(61,239,9,1),(62,240,9,1),(63,241,9,1),(64,242,9,1),(65,243,9,1),(66,244,9,1),(67,245,9,1),(68,246,9,1),(69,247,9,1),(70,248,9,1),(71,249,9,1),(72,250,9,1),(73,251,9,1),(74,252,9,1),(75,253,9,1),(76,254,9,1),(77,255,9,1),(78,256,9,1),(79,257,9,1),(80,258,9,1),(81,259,9,1),(82,260,9,2),(83,261,9,1),(84,262,9,1),(85,263,9,1),(86,264,9,1),(87,265,9,1),(88,266,9,1),(89,267,9,1),(90,268,9,1),(91,269,9,1),(92,270,9,1),(93,271,9,1),(94,272,9,1),(95,273,9,1),(96,274,9,1),(97,275,9,1),(98,276,9,1),(99,277,9,1),(100,278,9,1),(101,279,9,1),(102,280,9,1),(103,281,9,1),(104,282,9,1),(105,283,9,1),(106,284,9,1),(107,285,9,1),(108,286,9,1),(109,287,9,1),(110,288,9,1),(111,289,9,1),(112,290,9,3),(113,291,9,3),(114,292,9,3);
/*!40000 ALTER TABLE `vendor_product_availability` ENABLE KEYS */;
UNLOCK TABLES;

ALTER TABLE `product`
DROP COLUMN `sku`;

UPDATE available_category_times` SET `time_range`='11am-12pm' WHERE `id`='17';
