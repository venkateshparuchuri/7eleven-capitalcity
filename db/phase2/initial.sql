USE `7eleven`;

--
-- Inserting data for table `available_category`
--

INSERT INTO `available_category` (`id`,`category_name`) VALUES (7,'Roller');
INSERT INTO `available_category` (`id`,`category_name`) VALUES (8,'Roller_anti');

--
-- Inserting data for table `available_category_times`
--
# Right Order For Time Range
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (7,'5am-9am','10:30:00','05:00:00','09:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (7,'9am-2pm','15:30:00','09:00:00','14:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (7,'2pm-7pm','20:30:00','14:00:00','19:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (7,'7pm-10pm','23:30:00','19:00:00','22:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (7,'10pm-5am','06:30:00','22:00:00','05:00:00');

# Modified the script to include the right order.
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (8,'00am-1am','01:30:00','00:00:00','01:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (8,'1am-2am','02:30:00','01:00:00','02:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (8,'2am-3am','03:30:00','02:00:00','03:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (8,'3am-4am','04:30:00','03:00:00','04:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (8,'4am-5am','05:30:00','04:00:00','05:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (8,'5am-6am','06:30:00','05:00:00','06:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (8,'6am-7am','07:30:00','06:00:00','07:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (8,'7am-8am','08:30:00','07:00:00','08:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (8,'8am-9am','09:30:00','08:00:00','09:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (8,'9am-10am','10:30:00','09:00:00','10:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (8,'10am-11am','11:30:00','10:00:00','11:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (8,'11am-12pm','12:30:00','11:00:00','12:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (8,'12pm-1pm','13:30:00','12:00:00','13:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (8,'1pm-2pm','14:30:00','13:00:00','14:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (8,'2pm-3pm','15:30:00','14:00:00','15:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (8,'3pm-4pm','16:30:00','15:00:00','16:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (8,'4pm-5pm','17:30:00','16:00:00','17:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (8,'5pm-6pm','18:30:00','17:00:00','18:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (8,'6pm-7pm','19:30:00','18:00:00','19:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (8,'7pm-8pm','20:30:00','19:00:00','20:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (8,'8pm-9pm','21:30:00','20:00:00','21:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (8,'9pm-10pm','22:30:00','21:00:00','22:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (8,'10pm-11pm','23:30:00','22:00:00','23:00:00');
INSERT INTO `available_category_times` (`available_category_id`,`time_range`,`report_before`,`start_time`,`end_time`) VALUES (8,'11pm-00am','00:30:00','23:00:00','00:00:00');





--
-- Inserting data for table `product_type`
--

INSERT INTO `product_type` (`id`,`type`) VALUES (3,'Roller Grill Finished Goods');
INSERT INTO `product_type` (`id`,`type`) VALUES (4,'Roller Grill Ingredients');

--
-- Inserting data for table `product`
--

INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (91,'Hot Dogs','91',3,0.00,'NULL','each',NULL);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (92,'Tornadoes','92',3,0.00,'NULL','each',NULL);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (93,'Schwab All Beef Hot Dog','93',3,0.56,'','each',91);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (94,'Schwab Thunder Dog','94',3,0.37,'','each',91);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (95,'Schwab Cheddar Dog','95',3,0.40,'','each',91);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (96,'Schwab Jalapeno Cheddar Dog','96',3,0.48,'','each',91);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (97,'Schwab Hotlink','97',3,0.44,'','each',91);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (98,'Don Miguel Taquito Beef & Bean','98',3,0.36,'','each',91);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (99,'Johnsonville Natural Brat','99',3,0.61,'','each',91);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (100,'Johnsonville Spicy Sunrise Skillet','100',3,0.58,'','each',91);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (101,'Rollerbites Buffalo Chicken','101',3,0.63,'','each',92);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (102,'El Mont. Tornado Chicken','102',3,0.54,'','each',92);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (103,'El Mont. Tornado Ranchero Steak/Cheese','103',3,0.54,'','each',92);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (104,'El Mont. Tornado Sausage/Egg/Cheese','104',3,0.54,'','each',92);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (105,'El Mont. Tornado Bacon/Egg/Cheese','105',3,0.54,'','each',92);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (106,'El Mont. Tornado Cheese & Pepperoni','106',3,0.54,'','each',92);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (107,'El Mont. Tornado Cheesy Pepper Jack','107',3,0.54,'','each',92);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (108,'El Mont. Tornado French Toast w/Sausage','108',3,0.54,'','each',92);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (109,'El Mont. Tornado Omelet Ham/Egg/Sas/Bac','109',3,0.54,'','each',92);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (110,'Del Monte Banana Peppers','110',4,0.55,'','oz',0);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (111,'Del Monte Diced Jalapenos','111',4,0.15,'','oz',0);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (112,'Del Monte Dill Relish','112',4,0.47,'','oz',0);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (113,'Del Monte Onions White Diced','113',4,0.19,'','oz',0);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (114,'Del Monte Pico De Gallo','114',4,0.19,'','oz',0);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (115,'Del Monte Banana Sauerkaut','115',4,0.69,'','oz',0);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (116,'Gehls Chili','116',4,0.09,'','oz',0);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (117,'Gehls Cheese','117',4,0.09,'','oz',0);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (118,'Hot Dog Hinged Foam Lid','118',4,0.06,'','each',0);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (119,'Hot Dog Tray','119',4,0.04,'','each',0);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (120,'Heinz Ranch','120',4,0.09,'','each',0);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (121,'Chopped Onions 9g','121',4,0.06,'','each',0);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (122,'Salsa Del Sol Picante Sauce','122',4,0.08,'','each',0);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (123,'Nacho Chip Gehls','123',4,0.86,'','each',0);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (124,'Individually wrapped Hot dog bun','124',4,0.19,'','each',0);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (125,'Red Plaid Hot Dog Tray','125',4,0.04,'','each',0);
INSERT INTO `product` (`id`,`name`,`sku`,`product_type_id`,`product_cost`,`upc`,`unit_type`,`product_parent_id`) VALUES (126,'Individual Foil Sheets','126',4,0.02,'','each',0);

--
-- Inserting data for table `product_availability`
--

INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,93,201);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,94,202);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,95,203);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,96,204);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,97,205);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,98,206);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,99,207);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,100,208);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,101,209);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,102,210);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,103,211);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,104,212);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,105,213);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,106,214);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,107,215);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,108,216);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,109,217);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,110,218);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,111,219);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,112,220);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,113,221);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,114,222);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,115,223);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,116,224);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,117,225);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,118,226);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,119,227);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,120,228);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,121,229);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,122,230);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,123,231);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,124,232);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,125,233);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (7,126,234);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (8,91,235);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (8,92,236);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (8,93,237);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (8,94,238);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (8,95,239);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (8,96,240);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (8,97,241);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (8,98,242);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (8,99,243);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (8,100,244);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (8,101,245);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (8,102,246);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (8,103,247);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (8,104,248);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (8,105,249);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (8,106,250);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (8,107,251);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (8,108,252);
INSERT INTO `product_availability` (`availability_id`,`product_id`,`sort_order`) VALUES (8,109,253);

--
-- Dumping data for table `profiles`
--

LOCK TABLES `profiles` WRITE;
/*!40000 ALTER TABLE `profiles` DISABLE KEYS */;
INSERT INTO `profiles` VALUES (1,'Capital City','cc'),(2,'Roller Grills','rg');
/*!40000 ALTER TABLE `profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `store_profiles`
--

LOCK TABLES `store_profiles` WRITE;
/*!40000 ALTER TABLE `store_profiles` DISABLE KEYS */;
INSERT INTO `store_profiles` VALUES (1,1,20),(2,1,23),(3,1,46),(4,1,104),(5,1,114),(6,1,36104);
/*!40000 ALTER TABLE `store_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `survey`
--

LOCK TABLES `survey` WRITE;
/*!40000 ALTER TABLE `survey` DISABLE KEYS */;
INSERT INTO `survey` VALUES (1,'Inspection',1,'TRUE'),(2,'Plan to Succeed',2,'TRUE'),(3,'Assemble to Order 2.0',1,'TRUE');
/*!40000 ALTER TABLE `survey` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `survey_category`
--

LOCK TABLES `survey_category` WRITE;
/*!40000 ALTER TABLE `survey_category` DISABLE KEYS */;
INSERT INTO `survey_category` VALUES (1,2,'Delighting our Customers','TRUE'),(2,2,'100% Merchandised Checkout','TRUE'),(3,2,'100% Merchandised Coolers and Beer Door ','TRUE'),(4,2,'100% Merchandised Sandwich Window','TRUE'),(5,2,'100% Merchandised Freezer Doors','TRUE'),(6,2,'100% Merchandised Center of Store','TRUE'),(7,2,'Bright & Shiny Restrooms','TRUE'),(8,2,'Think Food','TRUE'),(9,1,'Team Member Standards','TRUE'),(10,1,'Clean Wins!','TRUE'),(11,1,'Time and Temperature Records / Logs','TRUE'),(12,1,'Sinks','TRUE'),(13,1,'Thawing','TRUE'),(14,1,'Product Identification','TRUE'),(15,1,'Scales','TRUE'),(16,1,'Coolers','TRUE'),(17,1,'Storage','TRUE'),(18,3,'Assemble to Order 2.0 10 point check ','TRUE');
/*!40000 ALTER TABLE `survey_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `survey_questions`
--

LOCK TABLES `survey_questions` WRITE;
/*!40000 ALTER TABLE `survey_questions` DISABLE KEYS */;
INSERT INTO `survey_questions` VALUES (1,9,'All 7 - Eleven team members in proper uniform attire (apron, hair pulled back, jewelry per uniform policy).',1,'TRUE'),(2,9,'No bare hand contact with ready to eat foods. Blue gloves in stock and in proper use. ',1,'TRUE'),(3,9,'Hands are clean, washed and well maintained. ',1,'TRUE'),(4,9,'No eating, drinking, or storing of 7 - Eleven Team Member cups in open kitchen area.',1,'TRUE'),(5,9,'Store Director\'s food certification certificate is up to date and posted. ',1,'TRUE'),(6,9,'Food Service Specialist demonstrates understanding of food safety knowledge leads team appropriately. ',1,'TRUE'),(7,9,'Team Members do not display any symptoms of illness (e.g. no discharges from eyes, nose, mouth).  ',2,'TRUE'),(8,10,'Utensils in use are clean and stored properly (handles sticking up when in use). ',1,'TRUE'),(9,10,'Linens properly stored. Clean with clean. Dirty in a vendor provided bin for removal.',1,'TRUE'),(10,10,'Hand sink is clean, stocked with hand soap and paper towels for use. ',2,'TRUE'),(11,10,'Food, water, ice obtained from appropriate source. ',1,'TRUE'),(12,10,'Pizza make station has portion spoons in proper local in each bucket for use per the plan o gram. ',1,'TRUE'),(13,10,'Can opener station clean, clutter free, and blade is clean with no notches/shavings present. ',1,'TRUE'),(14,10,'Team Members uses cut resistant glove when opening cans.',1,'TRUE'),(15,10,'Team Members using portion spoons appropriately during pizza making process. ',1,'TRUE'),(16,10,'All food & non-food contact surfaces are clean and sanitary (make station tables, pizza make station, refrigerators / freezer).',2,'TRUE'),(17,10,'Floors, walls, ceiling clean, free of litter, no build up around edges, corners, legs of equipment stands / tables.',1,'TRUE'),(18,10,'Mop Sink is neatly organized and equipment is stored properly. ',1,'TRUE'),(19,10,'Garbage / refuse: properly disposed. Can is clean. Heavy duty garbage bags in use.',1,'TRUE'),(20,10,'Dumpster Area: No trash on ground our outside of the trash container. Door on trash area is closed. ',1,'TRUE'),(21,10,'Sneeze guard is clean and streak free.  Cleaned when food containers are closed/covered. ',1,'TRUE'),(22,10,'3 sanitation buckets are in proper place and in use.  ',1,'TRUE'),(23,10,'Vent and light fixtures are clean, dust free, and working. ',1,'TRUE'),(24,10,'Filters on refrigeration units are clean, dust free. ',1,'TRUE'),(25,10,'Oven daily, weekly, monthly cleaning process is followed and in use. ',2,'TRUE'),(26,10,'All 3 HATCO warmers are clean, dust free. Including the top, sides and back of the unit. ',1,'TRUE'),(27,10,'Drain pipe by hand wash sink is clean, clutter free, and no build up. ',1,'TRUE'),(28,11,'Scrambled Egg (burrito) temperature log is filled out and recorded (at open, after peak, during breakdown).',4,'TRUE'),(29,11,'Breakfast Sausage log is filled out and recorded at open and after AM peak.',4,'TRUE'),(30,11,'Chorizo temperature log is filled out at open and after AM peak.',4,'TRUE'),(31,11,'Sausage patty temperature log is filled out and recorded (at open, after peak, during breakdown).',4,'TRUE'),(32,11,'Egg Patty temperature log is filled out and recorded (at open, after peak, during breakdown).',4,'TRUE'),(33,11,'Pizza Make table refrigerator top & bottom temperature log is filled out and recorded (at open, after peak, during breakdown).',4,'TRUE'),(34,11,'Thermometers are placed per plan o gram in the pizza make table station. ',4,'TRUE'),(35,11,'All products in HATCO warmer 1 are marked with 24 hour time and date. ',4,'TRUE'),(36,11,'All products in HATCO warmer 2 are marked with 24 hour time and date. ',4,'TRUE'),(37,11,'All products in HATCO warmer 3 are marked with 24 hour time and date. ',4,'TRUE'),(38,11,'Temp product in HATCO warmer 1 (Product is holding at 140 degrees).  Temp:        . Store logs are complete',2,'TRUE'),(39,11,'Temp product in HATCO warmer 2 (Product is holding at 140 degrees).  Temp:        . Store logs are complete',2,'TRUE'),(40,11,'Temp product in HATCO warmer 3 (Product is holding at 140 degrees).  Temp:        . Store logs are complete  ',2,'TRUE'),(41,12,'Sink used for intended purpose (wash, rinse, sanitize).  Hand sink used for washing hands only. ',1,'TRUE'),(42,12,'Three compartment sink stickers (wash, rinse, sanitize) are easily read and visible. ',1,'TRUE'),(43,12,'Enough product is in the soap and sanitizer containers. ',1,'TRUE'),(44,12,'Sanitizer test strips available for use.  If sink filled, test sanitizer.  PPM:      .  (200 ppp is the standard) ',2,'TRUE'),(45,12,'Utensils and small wares are air dried using the green wired shelving above the sink.',1,'TRUE'),(46,13,'Pans in the bakers rack are clean (no crumbs). ',1,'TRUE'),(47,13,'The clear plastic hoods on the thawing racks are closed when in use and are clean. ',1,'TRUE'),(48,13,'Time is marked when product is pulled out of freezer (in AM - should be close to 2 AM for breads/up to 24 hours for eggs and sausage patties).   ',3,'TRUE'),(49,14,'All containers are labeled with name of product and expiration dates.',2,'TRUE'),(50,14,'Expiration chart is updated, in use, posted in each of the required kitchen areas (freezer, refrigerators). ',2,'TRUE'),(51,14,'Boxes in freezer are stored with label of product facing out. ',1,'TRUE'),(52,14,'All cleaning chemicals are properly identified, stored per back room plan o gram and used according to directions.',1,'TRUE'),(53,14,'MSDS Complete and available.',2,'TRUE'),(54,15,'Yogurt scales tested.',1,'TRUE'),(55,16,'W/I Freezer temp near 10F. W/I Cooler temp below 41F.',2,'TRUE'),(56,17,'Clean, No potential for contamination. Food/Non-food storage ',1,'TRUE'),(57,1,'Team Members are using call button when line is 3 or more.',4,'TRUE'),(58,1,'All Team Members are in the uniform per standard',2,'TRUE'),(59,1,'Team Member focused  his/her full attention to customers during transactions (not on phone, not eating, not interrupting conversation for vendor or another Team Member.)',2,'TRUE'),(60,1,'All pumps have receipt paper in them. No message blinking at register to fill. ',1,'TRUE'),(61,1,'Team Members offer \"Thank you\" and a brief closing remark at end of the transaction / experience. ',2,'TRUE'),(62,1,'Team Member (#text#) on shift can recite mission',2,'TRUE'),(63,1,'Team Member (#text#) on shift understands travel path',2,'TRUE'),(64,1,'Team Member (#text#) on shift knows delighting the customer is #1 priority',2,'TRUE'),(65,1,'Team Member (#text#) can recite our six core values (Honest, Welcoming, Clean, Detailed, United, Grateful)',2,'TRUE'),(66,1,'Team Member (#text#) can explain peak and non peak (TM knows the peak and non peak times for store and what to do for each) ',1,'TRUE'),(67,1,'Manager / Assistant at register during peak when on work schedule. Travel path and other store activities during non peak.',1,'TRUE'),(68,2,'Permanent counter displays fully stocked, clean and priced to the standard guide ',1,'TRUE'),(69,2,'No clutter on the counters ',1,'TRUE'),(70,2,'Promotional shippers fronted, faced, priced to the standard guide (no handwritten price tags)',1,'TRUE'),(71,2,'Suggestive sell item on the counter',1,'TRUE'),(72,2,'No personal items visible to the customer.  Drinks not on register counters.',1,'TRUE'),(73,2,'Cigarettes displays 100% fronted, faced, stocked & priced ',2,'TRUE'),(74,2,'Snuff 100% in stock, fronted, faced and priced ',1,'TRUE'),(75,2,'All shelf displays, fronted, faced, stocked, priced',1,'TRUE'),(76,3,'All items in stock ',2,'TRUE'),(77,3,'Product fronted, faced, stocked, priced ',1,'TRUE'),(78,3,'No clutter, spills, trash in bottom ledges',1,'TRUE'),(79,3,'All cooler lights are working ',1,'TRUE'),(80,3,'All product is priced to standard ',1,'TRUE'),(81,3,'All door handles are current sign package . ',1,'TRUE'),(82,3,'All door static clings in proper place and current to sign package',1,'TRUE'),(83,3,'Glides are clean. All doors/ windows are clean and streak free.',1,'TRUE'),(84,4,'Front, Face product to planagram ',1,'TRUE'),(85,4,'Date rotation is correct ',1,'TRUE'),(86,4,'All items in stock',2,'TRUE'),(87,4,'Product is in date and presentable',1,'TRUE'),(88,4,'Product pulled and ready for tomorrow per build to (between 4pm and 11pm product should be in cooler thawing)',1,'TRUE'),(89,5,'Front, Face product per the standard .',1,'TRUE'),(90,5,'Date rotation is correct ',1,'TRUE'),(91,5,'Signage is in the correct spot per standard',1,'TRUE'),(92,5,'Freezer lights all working ',1,'TRUE'),(93,5,'Windows are clean and streak free. Vents and exterior of freezers are clean and dust free.',1,'TRUE'),(94,6,'Front, face, stock all end caps, shelves are clean ',1,'TRUE'),(95,6,'Front, face, stock all aisles, shelves are clean  ',1,'TRUE'),(96,6,'All items in stock',1,'TRUE'),(97,6,'No missing price tags per standard ',1,'TRUE'),(98,6,'All products are priced to planagram ',1,'TRUE'),(99,6,'Floor is clean - no visible dirt/debris',1,'TRUE'),(100,7,'100% in stock of all supplies (toilet tissue, paper towels, air freshener, soap in dispenser)',1,'TRUE'),(101,7,'Trash is no more than 1/2 full ',1,'TRUE'),(102,7,'Mirror, sink, faucets, countertops clean',1,'TRUE'),(103,7,'Vent and light fixtures are clean and dust free',1,'TRUE'),(104,7,'Toilet / Urinal is clean ',1,'TRUE'),(105,7,'All areas on the floor are clean and tidy with emphasis on the area around commode & urinal',1,'TRUE'),(106,7,'No foul odor in restroom ',1,'TRUE'),(107,7,'Walls are clean beneath air dryer and throughout the restroom',1,'TRUE'),(108,7,'Exposed plumbing/pipes under hand washing sink are clean and dust free',1,'TRUE'),(109,7,'All equipment is in working order',1,'TRUE'),(110,7,'All lights are working / well lit ',1,'TRUE'),(111,8,'Donut case is fronted, faced, stocked, clean to standard ',1,'TRUE'),(112,8,'Muffin case is fronted, faced, stocked, clean to standard ',1,'TRUE'),(113,8,'Fresh Cooler:  Product full, fronted, faced and clean. Vents are clean.',1,'TRUE'),(114,8,'Fresh Cooler:  Dates properly rotated and all out dated product pulled',1,'TRUE'),(115,8,'Microwave ovens are clean and sandwich condiments and napkins are fully stock',1,'TRUE'),(116,8,'Roller Grill: stocked by day part - temp 140 - still cooking signs in place as needed / product tags in place',1,'TRUE'),(117,8,'Roller Grill: clean (grill, counters, sneeze guard, signs, tongs, tong holders)',1,'TRUE'),(118,8,'Roller Grill: bun drawer stocked to planagram and free of any crumbs, rubberbands, wrappers, and other trash',1,'TRUE'),(119,8,'Roller Grill:  Condiments 100% in stock / clean and neatly organized  per planagram and layout/condiments in date',1,'TRUE'),(120,8,'GNG warmer:  unit is clean.  Product is in stock to planogram and day part.  Product is rotated and temperature is maintained at 140 degrees',1,'TRUE'),(121,8,'Nachos: clean, in-stock, chili and cheese dated ',1,'TRUE'),(122,8,'Fountain/ Icy: 100% in stock  ice in stock equipment clean and in proper working order.',1,'TRUE'),(123,8,'Fountain/ Icy: ledge, nozzles, and backsplash clean (second set of fountain nozzles in the back room soaking per the process). Cabinets are clean. ',1,'TRUE'),(124,8,'Fountain/Icy: Cups, lids, straws 100% in stock.  All counter tops, cabinet doors, and trash openings are clean.',1,'TRUE'),(125,8,'Brewed Tea: Product properly labeled, tea is fresh and in stock, urn is clean (interior & exterior), brewer portion of machine is clean. Equipment is working and drains/ drip tray are clean.',1,'TRUE'),(126,8,'Coffee / Cappuccino : 100% in stock to planagram. (For Cappuccino, not filled above the fill line) ',1,'TRUE'),(127,8,'Coffee / Cappuccino: No blinking lights on coffee  no spent grounds in coffee filter basket',1,'TRUE'),(128,8,'Coffee / Cappuccino:  counter clean, free of spills ',1,'TRUE'),(129,8,'Coffee / Cappuccino: Condiments are clean (no spills on lids, condiment packets, or straws). Label identifiers clean. Cabinets are clean. Cups, lids, stirrers, napkins are in stock. ',1,'TRUE'),(130,8,'Coffee / Cappuccino: Equipment is clean & spot free  Cappuccino light working. Equipment is working. Drains/drip trays clean.',1,'TRUE'),(131,8,'F\'real: Stocked, fronted, faced. No out of stocks. Equipment is working. Machine and surrounding area are clean and dust free.',1,'TRUE'),(132,8,'Red floor mats are presentable.',1,'TRUE'),(133,8,'Outside ice merchandisers are clean / no graffiti/ stocked. Propane priced to standard.',1,'TRUE'),(134,8,'Outside Lot: Pumps are clean  (includes face of the pump, nozzles, hoses, sides and top where the pump topper sits). All canopy and building lights are working (check during evening hours).  Gasoline equipment and air pump ar',1,'TRUE'),(135,8,'Outside Lot: Trash is no more than 1/2 full, trash cans wiped down with no excessive spills / stains',1,'TRUE'),(136,8,'Outside Lot: No trash in grass / dumpster gates closed',1,'TRUE'),(137,8,'Outside Lot: Washer fluid / squeegees 100% in stock; paper towels in stock, washer buckets exteriors are clean .',1,'TRUE'),(138,8,'Outside Lot: Pump toppers / washer bucket signs 100%  to current guide  ',1,'TRUE'),(139,8,'Entry area sidewalks are clean - no \"trash bag drag\".  No cigarette butts or other trash visible on ground.',1,'TRUE'),(140,8,'Front Doors are clean and door decals current to signage guide.  Trash is no more than 1/2 full.',1,'TRUE'),(141,8,'Parking spaces:  oil & grease free',1,'TRUE'),(142,8,'Windows are clean, no dirt streaks, window ledges are clean ',1,'TRUE'),(143,8,'Window sign package is 100% executed to standard (prices correct and signs are straight).',1,'TRUE'),(144,18,'HATCO one is merchandised in accordance with the ATO anticipated sales chart',1,'TRUE'),(145,18,'HATCO two is merchandised in accordance with the ATO anticipated sales chart',1,'TRUE'),(146,18,'Duke one  ingredients match the need for the hour day part anticipated sales chart',1,'TRUE'),(147,18,'Duke two ingredients match the need for the hour day part anticipated sales chart',1,'TRUE'),(148,18,'Coupons are used in the suggestive sell process at sales counter ',1,'TRUE'),(149,18,'Labor from previous day used is at or below the scheduled hours ',1,'TRUE'),(150,18,'Split order is in line with anticipated sales report using 60.5% retail mark up in dollars (within +1- 10% of retail mark up) ',1,'TRUE'),(151,18,'Recorded ingredient waste is in line with anticipated sales chart ',1,'TRUE'),(152,18,'Finished good waste is in line with anticipated sales chart ',1,'TRUE'),(153,18,'Planogram is being executed to the standard ',1,'TRUE');
/*!40000 ALTER TABLE `survey_questions` ENABLE KEYS */;
UNLOCK TABLES;
