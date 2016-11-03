################# adding new user dbq_admin ######################

INSERT INTO `7eleven`.`role` (`id`, `name`) VALUES ('114', 'DBQ_Admin');
INSERT INTO `7eleven`.`user` (`user_id`, `name`, `email`, `password`, `initials`) VALUES ('dbqadmin', 'Mohan', 'dbqadmin@7eleven.com', '235e74373fae4154aca06bf7ad7b42e0faed5698183494d707c39c047bb5aa8f4be166850a7f51d90969bb618636296c', 'v');
INSERT INTO `7eleven`.`user_role` (`user_id`, `role_id`, `store_id`) VALUES ('146', '114', '36104');


############ added auto increment for id in user table ###########

lSET FOREIGN_KEY_CHECKS=0;

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


--
-- Inserting data for table `product`
--

INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('MC Croissant Chicken Salad', '137', '8', '0.03', '746295018459', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('MC Croissant Egg Salad', '138', '8', '0.03', '746295018442', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('MC All American Meat', '139', '8', '0.02', '746295019944', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('MC Italian Sub', '140', '8', '0.02', '746295019951', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('MC Ham & Swiss', '141', '8', '0.04', '746295015076', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('MC Ham & Turkey', '142', '8', '0.04', '746295015090', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('MC Mega Bacon ChBurger', '143', '8', '0.14', '746295015069', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('MC Ham & Cheese pounder', '144', '8', '0.14', '746295018466', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('MC Tuna On Wheatberry', '145', '8', '0.03', '746295018435', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Fathers Table NY Cheesecake', '146', '8', '0.01', '10374210141', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Fathers Table Sb Cheesecake', '147', '8', '0.01', '10374210158', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('OMG Reese\'s Cheesecake', '148', '8', '0.13', '861440000001', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('OMG Cookies N Cream Cheesecake', '149', '8', '0.13', '861440000025', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('OMG Strawberry Cheesecake', '150', '8', '0.13', '861440000018', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('OMG White Chocolate Cheesecake', '151', '8', '0.13', '861440000049', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Nemos Carrot Cake', '152', '8', '0.25', '76064002045', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Nemos Banana Cake', '153', '8', '0.25', '76064003042', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Nemos Black n White Cake', '154', '8', '0.25', '76064010668', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Nemos Chocolate Cake', '155', '8', '0.25', '76064001048', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Musselmans Squeezables', '156', '8', '0.21', '37323117818', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Jamwich PB and Strawberry', '157', '8', '0.01', '71421921212', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Jamwich PB and Grape', '158', '8', '0.01', '71421921205', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Armour Lunchmakers Turkey', '159', '8', '0.02', '46600034281', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Armour Lunchmakers Ham', '160', '8', '0.02', '46600034274', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Lunchables Turkey & Cheddar', '161', '8', '0.11', '44700024553', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Lunchables Light Bologna', '162', '8', '0.11', '44700360026', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Lunchables Ham & Swiss', '163', '8', '0.11', '47700024546', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Del Monte Cantaloupe', '164', '8', '0.13', '717524414359', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Del Monte Super Fruit Medley', '165', '8', '0.05', '717524776389', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Del Monte Grapes', '166', '8', '0.12', '717524720542', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Del Monte Pine/Apple/Grapes', '167', '8', '0.12', '717524776396', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Del Monte Strawberrys', '168', '8', '0.09', '717524200280', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Del Monte Mango Slice', '169', '8', '0.09', '717524725448', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Del Monte Watermelon', '170', '8', '0.09', '717524412874', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Del Monte Seasonal Blend', '171', '8', '0.09', '717524719300', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Cheese Pleasers Colby Jack', '172', '8', '0.22', '46247211113', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Cheese Pleasers Pepper Jack', '173', '8', '0.22', '46247188880', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Wisconsin Mozzarella String', '174', '8', '0.22', '46247811115', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Cheese Pleasers Cheese & Beef', '175', '8', '0.21', '46247155561', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Kraft String Mozzarella', '176', '8', '0.19', '21000003983', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Kraft Twists Mozzarella Cheddar', '177', '8', '0.17', '21000000227', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Taylor Farms Mediterranean', '178', '8', '0.11', '30223101710', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Taylor Farms Chicken Ceasar', '179', '8', '0.11', '30223101697', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Del Cafe Chef Salad w/ Turkey', '180', '8', '0.29', '717524772039', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Almark 2p Egg', '181', '8', '0.22', '44984002421', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Del Cafe Ceasar Salad w/ Chicken', '182', '8', '0.21', '717524772015', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Sundia Peach', '183', '8', '0.15', '810051010503', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Sundia Grapefruit', '184', '8', '0.15', '810051010480', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Sundia Tropical Medley', '185', '8', '0.15', '810051010541', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Dippin Stix Apples & PB', '186', '8', '0.23', '649632000837', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Dippin Stix Apple & Caramel', '187', '8', '0.27', '649632000806', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Dippin Stix Apple & Choc Caramel', '188', '8', '0.27', '649632001285', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Gatorade Protein Shake Choc', '189', '8', '0.01', '52000101096', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Gatorade Protein Shake Cookies & Creme', '190', '8', '0.01', '52000103892', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Naked Juice Green Machine', '191', '8', '0.07', '82592720153', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Naked Juice Protein Zone', '192', '8', '0.07', '82592722157', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Naked Juice Strawberry Banana', '193', '8', '0.07', '82592194152', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Yoplait Strawberry', '194', '8', '0.33', '70470003009', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Chobani Strawberry', '195', '8', '0.33', '94700010045', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Yocrunch Strawberry', '196', '8', '0.22', '46675000105', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Yocrunch M&M', '197', '8', '0.22', '46675000792', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Horizon Chocolate Milk', '198', '8', '0.14', '742365208850', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Horizon Regular Milk', '199', '8', '0.14', '742365208256', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('P3 Ham', '200', '8', '0.26', '44700070772', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('P3 Turkey', '201', '8', '0.26', '44700070758', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Fast Bites Sausage Biscuit', '202', '8', '0.15', '71421110333', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Fast Bites Chicken Biscuit', '203', '8', '0.15', '71421110111', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Owens Biscuits 2pk', '204', '8', '0.08', '70110056501', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Johns Bisc Ssg & Gravy', '205', '8', '0.09', '77782030976', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Big Bites Double Sausage', '206', '8', '0.08', '746295018428', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('El Mont Egg & Ssg Burrito', '207', '8', '0.07', '71007144783', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Big Bites BBQ Rib', '208', '8', '0.05', '746295019241', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Big Bites Deli Ham & Cheese', '209', '8', '0.06', '746295015113', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Big Bites Twin Jala Smoked Ssg', '210', '8', '0.22', '746295011139', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Tony\'s Deep Dish Pizza', '211', '8', '0.17', '72180635280', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Big Bites Chicken n Cheese', '212', '8', '0.15', '746295015106', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Big Bites Twin Chili Melts', '213', '8', '0.14', '746295018053', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Big Bites Italian Sub', '214', '8', '0.17', '746295017520', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('LTO Big Bite', '215', '8', '0.21', '746295018305', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Big Bites Charboil Melts', '216', '8', '0.09', '746295018022', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Big Bites Jalapeno Burger', '217', '8', '0.09', '746295019234', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Foster Farms Corndog Jumbo', '218', '8', '0.11', '75278952900', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Don Miguel Beef & Green Chili', '219', '8', '0.16', '27089185544', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Don Miguel Chicken Chimi', '220', '8', '0.16', '27086185575', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Tina\'s Bean & Cheese', '221', '8', '0.15', '79606010409', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Tina\'s Beef & Bean', '222', '8', '0.15', '79606010201', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Tina\'s Red Hot Beef', '223', '8', '0.15', '79606010102', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Tina\'s Beef & Bean/Green Chili', '224', '8', '0.15', '79606010300', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('Tina\'s Red Hot Beef Chimi', '225', '8', '0.07', '79606010546', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('El Mont Shredded Steak & Cheese', '226', '8', '0.11', '71007157233', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`, `product_cost`, `upc`, `unit_type`, `product_parent_id`) VALUES ('El Mont Chimichanga', '227', '8', '0.22', '71007186141', 'each', '0');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`) VALUES ('Fresh Cooler', '228', '8');
INSERT INTO `7eleven`.`product` (`name`, `sku`, `product_type_id`) VALUES ('Cooler Doors', '229', '8');


--
-- Inserting data for table `available_category`
--

INSERT INTO `7eleven`.`available_category` (`id`, `category_name`) VALUES (9, 'DeliCase');
INSERT INTO `7eleven`.`available_category` (`id`, `category_name`) VALUES ('10', 'CoolerDoor');
INSERT INTO `7eleven`.`available_category` (`id`, `category_name`) VALUES ('11', 'perishableTemp');


--
-- Inserting data for table `available_category`
--

INSERT INTO `7eleven`.`available_category_times` (`available_category_id`, `time_range`, `report_before`, `start_time`, `end_time`) VALUES ('9', '5am-10am', '11:30:00', '05:00:00', '10:00:00');
INSERT INTO `7eleven`.`available_category_times` (`available_category_id`, `time_range`, `report_before`, `start_time`, `end_time`) VALUES ('9', '10am-5am', '06:30:00', '10:00:00', '10:00:00');
INSERT INTO `7eleven`.`available_category_times` (`available_category_id`, `time_range`, `report_before`, `start_time`, `end_time`) VALUES ('10', '5am-10am', '11:30:00', '05:00:00', '10:00:00');
INSERT INTO `7eleven`.`available_category_times` (`available_category_id`, `time_range`, `report_before`, `start_time`, `end_time`) VALUES ('10', '10am-5am', '06:30:00', '10:00:00', '10:00:00');
INSERT INTO `7eleven`.`available_category_times` (`available_category_id`, `time_range`, `report_before`, `start_time`, `end_time`) VALUES ('11', '6am-2pm', '14:30:00', '06:00:00', '14:00:00');
INSERT INTO `7eleven`.`available_category_times` (`available_category_id`, `time_range`, `report_before`, `start_time`, `end_time`) VALUES ('11', '2pm-10pm', '22:30:00', '14:00:00', '22:00:00');
INSERT INTO `7eleven`.`available_category_times` (`available_category_id`, `time_range`, `report_before`, `start_time`, `end_time`) VALUES ('11', '10pm-6am', '06:30:00', '22:00:00', '06:00:00');


--
-- Inserting data for table `product_availability`
--

INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '137', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '138', '305');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '139', '306');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '140', '307');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '141', '308');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '142', '309');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '143', '310');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '144', '311');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '145', '312');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '146', '313');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '147', '314');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '148', '315');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '149', '316');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '150', '317');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '151', '318');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '152', '319');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '153', '320');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '154', '321');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '155', '322');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '156', '323');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '157', '324');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '158', '325');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '159', '326');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '160', '327');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '161', '328');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '162', '329');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '163', '330');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '164', '331');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '165', '332');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '166', '333');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '167', '334');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '168', '335');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '169', '336');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '170', '337');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '171', '338');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '172', '339');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '173', '340');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '174', '341');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '175', '342');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '176', '343');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '177', '344');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '178', '345');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '179', '346');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '180', '347');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '181', '348');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '182', '349');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '183', '350');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '184', '351');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '185', '352');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '186', '353');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '187', '354');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '188', '355');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '189', '356');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '190', '357');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '191', '358');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '192', '359');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '193', '360');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '194', '361');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '195', '362');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '196', '363');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '197', '364');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '198', '365');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '199', '366');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '200', '367');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '201', '368');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '202', '369');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '203', '370');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '204', '371');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '205', '372');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '206', '373');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '207', '374');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '208', '375');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '209', '376');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '210', '377');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '211', '378');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '212', '379');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '213', '380');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '214', '381');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '215', '382');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '216', '383');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '217', '384');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '218', '385');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '219', '386');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '220', '387');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '221', '388');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '222', '389');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '223', '390');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '224', '391');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '225', '392');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '226', '393');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('9', '227', '394');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '137', '304');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '138', '305');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '139', '306');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '140', '307');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '141', '308');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '142', '309');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '143', '310');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '144', '311');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '145', '312');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '146', '313');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '147', '314');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '148', '315');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '149', '316');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '150', '317');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '151', '318');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '152', '319');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '153', '320');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '154', '321');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '155', '322');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '156', '323');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '157', '324');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '158', '325');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '159', '326');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '160', '327');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '161', '328');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '162', '329');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '163', '330');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '164', '331');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '165', '332');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '166', '333');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '167', '334');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '168', '335');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '169', '336');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '170', '337');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '171', '338');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '172', '339');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '173', '340');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '174', '341');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '175', '342');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '176', '343');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '177', '344');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '178', '345');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '179', '346');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '180', '347');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '181', '348');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '182', '349');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '183', '350');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '184', '351');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '185', '352');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '186', '353');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '187', '354');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '188', '355');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '189', '356');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '190', '357');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '191', '358');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '192', '359');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '193', '360');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '194', '361');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '195', '362');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '196', '363');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '197', '364');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '198', '365');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '199', '366');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '200', '367');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '201', '368');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '202', '369');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '203', '370');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '204', '371');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '205', '372');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '206', '373');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '207', '374');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '208', '375');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '209', '376');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '210', '377');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '211', '378');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '212', '379');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '213', '380');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '214', '381');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '215', '382');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '216', '383');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '217', '384');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '218', '385');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '219', '386');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '220', '387');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '221', '388');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '222', '389');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '223', '390');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '224', '391');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '225', '392');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '226', '393');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('10', '227', '394');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('11', '228', '395');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('11', '229', '396');


--
-- Inserting data for table `product_cost_history`
--

INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('137', '2016-05-14', '0.03');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('138', '2016-05-14', '0.03');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('139', '2016-05-14', '0.02');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('140', '2016-05-14', '0.02');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('141', '2016-05-14', '0.04');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('142', '2016-05-14', '0.04');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('143', '2016-05-14', '0.14');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('144', '2016-05-14', '0.14');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('145', '2016-05-14', '0.03');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('146', '2016-05-14', '0.01');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('147', '2016-05-14', '0.01');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('148', '2016-05-14', '0.13');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('149', '2016-05-14', '0.13');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('150', '2016-05-14', '0.13');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('151', '2016-05-14', '0.13');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('152', '2016-05-14', '0.25');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('153', '2016-05-14', '0.25');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('154', '2016-05-14', '0.25');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('155', '2016-05-14', '0.25');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('156', '2016-05-14', '0.21');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('157', '2016-05-14', '0.01');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('158', '2016-05-14', '0.01');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('159', '2016-05-14', '0.02');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('160', '2016-05-14', '0.02');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('161', '2016-05-14', '0.11');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('162', '2016-05-14', '0.11');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('163', '2016-05-14', '0.11');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('164', '2016-05-14', '0.13');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('165', '2016-05-14', '0.05');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('166', '2016-05-14', '0.12');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('167', '2016-05-14', '0.12');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('168', '2016-05-14', '0.09');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('169', '2016-05-14', '0.09');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('170', '2016-05-14', '0.09');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('171', '2016-05-14', '0.09');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('172', '2016-05-14', '0.22');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('173', '2016-05-14', '0.22');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('174', '2016-05-14', '0.22');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('175', '2016-05-14', '0.21');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('176', '2016-05-14', '0.19');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('177', '2016-05-14', '0.17');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('178', '2016-05-14', '0.11');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('179', '2016-05-14', '0.11');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('180', '2016-05-14', '0.29');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('181', '2016-05-14', '0.22');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('182', '2016-05-14', '0.21');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('183', '2016-05-14', '0.15');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('184', '2016-05-14', '0.15');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('185', '2016-05-14', '0.15');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('186', '2016-05-14', '0.23');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('187', '2016-05-14', '0.27');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('188', '2016-05-14', '0.27');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('189', '2016-05-14', '0.01');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('190', '2016-05-14', '0.01');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('191', '2016-05-14', '0.07');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('192', '2016-05-14', '0.07');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('193', '2016-05-14', '0.07');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('194', '2016-05-14', '0.33');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('195', '2016-05-14', '0.33');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('196', '2016-05-14', '0.22');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('197', '2016-05-14', '0.22');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('198', '2016-05-14', '0.14');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('199', '2016-05-14', '0.14');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('200', '2016-05-14', '0.26');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('201', '2016-05-14', '0.26');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('202', '2016-05-14', '0.15');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('203', '2016-05-14', '0.15');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('204', '2016-05-14', '0.08');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('205', '2016-05-14', '0.09');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('206', '2016-05-14', '0.08');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('207', '2016-05-14', '0.07');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('208', '2016-05-14', '0.05');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('209', '2016-05-14', '0.06');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('210', '2016-05-14', '0.22');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('211', '2016-05-14', '0.17');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('212', '2016-05-14', '0.15');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('213', '2016-05-14', '0.14');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('214', '2016-05-14', '0.17');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('215', '2016-05-14', '0.21');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('216', '2016-05-14', '0.09');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('217', '2016-05-14', '0.09');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('218', '2016-05-14', '0.11');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('219', '2016-05-14', '0.16');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('220', '2016-05-14', '0.16');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('221', '2016-05-14', '0.15');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('222', '2016-05-14', '0.15');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('223', '2016-05-14', '0.15');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('224', '2016-05-14', '0.15');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('225', '2016-05-14', '0.07');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('226', '2016-05-14', '0.11');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('227', '2016-05-14', '0.22');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('228', '2016-06-21', '0.64');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('229', '2016-06-21', '0.74');


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
