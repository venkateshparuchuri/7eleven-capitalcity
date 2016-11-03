USE `7eleven`;

--
-- Dumping data for table `available_category`
--

LOCK TABLES `available_category` WRITE;
/*!40000 ALTER TABLE `available_category` DISABLE KEYS */;
INSERT INTO `available_category` VALUES (1,'Breakfast'),(2,'Lunch'),(3,'Dinner'),(4,'Open'),(5,'Peak'),(6,'Breakdown');
/*!40000 ALTER TABLE `available_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `available_category_times`
--

LOCK TABLES `available_category_times` WRITE;
/*!40000 ALTER TABLE `available_category_times` DISABLE KEYS */;
INSERT INTO `available_category_times` VALUES (11,1,'5am-6am','06:30:00','05:00:00','06:00:00'),(12,1,'6am-7am','07:30:00','06:00:00','07:00:00'),(13,1,'7am-8am','08:30:00','07:00:00','08:00:00'),(14,1,'8am-9am','09:30:00','08:00:00','09:00:00'),(15,1,'9am-10am','10:30:00','09:00:00','10:00:00'),(16,1,'10am-11am','11:30:00','10:00:00','11:00:00'),(17,2,'11am-12am','12:30:00','11:00:00','12:00:00'),(18,2,'12pm-1pm','13:30:00','12:00:00','13:00:00'),(19,2,'1pm-2pm','14:30:00','13:00:00','14:00:00'),(20,2,'2pm-3pm','15:30:00','14:00:00','15:00:00'),(21,3,'3pm-4pm','16:30:00','15:00:00','16:00:00'),(22,3,'4pm-5pm','17:30:00','16:00:00','17:00:00'),(23,3,'5pm-6pm','18:30:00','17:00:00','18:00:00'),(24,3,'6pm-7pm','19:30:00','18:00:00','19:00:00'),(25,3,'7pm-8pm','20:30:00','19:00:00','20:00:00');
/*!40000 ALTER TABLE `available_category_times` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `equipment`
--

LOCK TABLES `equipment` WRITE;
/*!40000 ALTER TABLE `equipment` DISABLE KEYS */;
INSERT INTO `equipment` VALUES (1,'Walkin freezer','36104'),(2,'Pizza shelf freezer','36104'),(3,'Pizza Shelf Make Freezer','36104'),(4,'Hatco 1 ','36109'),(5,'Hatco 2 ','30190'),(6,'Duke 1 ','30190'),(7,'Duke 2 ','2345');
/*!40000 ALTER TABLE `equipment` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Dumping data for table `equipment_availability`
--

LOCK TABLES `equipment_availability` WRITE;
/*!40000 ALTER TABLE `equipment_availability` DISABLE KEYS */;
INSERT INTO `equipment_availability` VALUES (1,4,1,1),(2,4,2,2),(3,4,3,3),(4,4,4,4),(5,4,5,5),(6,4,6,6),(7,4,7,7),(8,5,1,1),(9,5,2,2),(10,5,3,3),(11,5,4,4),(12,5,5,5),(13,5,6,6),(14,5,7,7),(15,6,1,1),(16,6,2,2),(17,6,3,3),(18,6,4,4),(19,6,5,5),(20,6,6,6),(21,6,7,7);
/*!40000 ALTER TABLE `equipment_availability` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Dumping data for table `inspection`
--

LOCK TABLES `inspection` WRITE;
/*!40000 ALTER TABLE `inspection` DISABLE KEYS */;
INSERT INTO `inspection` VALUES (1,'All 7 - Eleven team members in proper uniform attire (apron, hair pulled back, jewelry per uniform policy).',1,'Team Member Standards',1),(2,'No bare hand contact with ready to eat foods. Blue gloves in stock and in proper use. ',1,'Team Member Standards',2),(3,'Hands are clean, washed and well maintained. ',1,'Team Member Standards',3),(4,'No eating, drinking, or storing of 7 - Eleven Team Member cups in open kitchen area.',1,'Team Member Standards',4),(5,'Store Director\'s food certification certificate is up to date and posted. ',1,'Team Member Standards',5),(6,'Food Service Specialist demonstrates understanding of food safety knowledge leads team appropriately. ',1,'Team Member Standards',6),(7,'Team Members do not display any symptoms of illness (e.g. no discharges from eyes, nose, mouth).  ',2,'Team Member Standards',7),(8,'Utensils in use are clean and stored properly (handles sticking up when in use). ',1,'Clean Wins',8),(9,'Linens properly stored. Clean with clean. Dirty in a vendor provided bin for removal.',1,'Clean Wins',9),(10,'Hand sink is clean, stocked with hand soap and paper towels for use. ',2,'Clean Wins',10),(11,'Food, water, ice obtained from appropriate source. ',1,'Clean Wins',11),(12,'Pizza make station has portion spoons in proper local in each bucket for use per the plan o gram. ',1,'Clean Wins',12),(13,'Can opener station clean, clutter free, and blade is clean with no notches/shavings present. ',1,'Clean Wins',13),(14,'Team Members uses cut resistant glove when opening cans.',2,'Clean Wins',14),(15,'Team Members using portion spoons appropriately during pizza making process. ',1,'Clean Wins',15),(16,'All food & non-food contact surfaces are clean and sanitary (make station tables, pizza make station, refrigerators / freezer).',2,'Clean Wins',16),(17,'Floors, walls, ceiling clean, free of litter, no build up around edges, corners, legs of equipment stands / tables.',1,'Clean Wins',17),(18,'Mop Sink is neatly organized and equipment is stored properly. ',1,'Clean Wins',18),(19,'Garbage / refuse: properly disposed. Can is clean. Heavy duty garbage bags in use.',1,'Clean Wins',19),(20,'Dumpster Area: No trash on ground our outside of the trash container. Door on trash area is closed. ',1,'Clean Wins',20),(21,'Sneeze guard is clean and streak free.  Cleaned when food containers are closed/covered. ',1,'Clean Wins',21),(22,'3 sanitation buckets are in proper place and in use.  ',1,'Clean Wins',22),(23,'Vent and light fixtures are clean, dust free, and working. ',1,'Clean Wins',23),(24,'Filters on refrigeration units are clean, dust free. ',1,'Clean Wins',24),(25,'Oven daily, weekly, monthly cleaning process is followed and in use. ',2,'Clean Wins',25),(26,'All 3 HATCO warmers are clean, dust free. Including the top, sides and back of the unit. ',1,'Clean Wins',26),(27,'Drain pipe by hand wash sink is clean, clutter free, and no build up. ',1,'Clean Wins',27),(28,'Scrambled Egg (burrito) temperature log is filled out and recorded (at open, after peak, during breakdown).',4,'Time and Temperature Records / Logs',28),(29,'Breakfast Sausage log is filled out and recorded at open and after AM peak.',4,'Time and Temperature Records / Logs',29),(30,'Chorizo temperature log is filled out at open and after AM peak.',4,'Time and Temperature Records / Logs',30),(31,'Sausage patty temperature log is filled out and recorded (at open, after peak, during breakdown).',4,'Time and Temperature Records / Logs',31),(32,'Egg Patty temperature log is filled out and recorded (at open, after peak, during breakdown).',4,'Time and Temperature Records / Logs',32),(33,'Pizza Make table refrigerator top & bottom temperature log is filled out and recorded (at open, after peak, during breakdown).',4,'Time and Temperature Records / Logs',33),(34,'Thermometers are placed per plan o gram in the pizza make table station. ',4,'Time and Temperature Records / Logs',34),(35,'All products in HATCO warmer 1 are marked with 24 hour time and date. ',4,'Time and Temperature Records / Logs',35),(36,'All products in HATCO warmer 2 are marked with 24 hour time and date. ',4,'Time and Temperature Records / Logs',36),(37,'All products in HATCO warmer 3 are marked with 24 hour time and date. ',4,'Time and Temperature Records / Logs',37),(38,'Temp product in HATCO warmer 1 (Product is holding at 140 degrees).  Temp:        . Store logs are complete',3,'Time and Temperature Records / Logs',38),(39,'Temp product in HATCO warmer 2 (Product is holding at 140 degrees).  Temp:        . Store logs are complete',3,'Time and Temperature Records / Logs',39),(40,'Temp product in HATCO warmer 3 (Product is holding at 140 degrees).  Temp:        . Store logs are complete  ',3,'Time and Temperature Records / Logs',40),(41,'Sink used for intended purpose (wash, rinse, sanitize).  Hand sink used for washing hands only. ',1,'Sinks',41),(42,'Three compartment sink stickers (wash, rinse, sanitize) are easily read and visible. ',1,'Sinks',42),(43,'Enough product is in the soap and sanitizer containers. ',1,'Sinks',43),(44,'Sanitizer test strips available for use.  If sink filled, test sanitizer.  PPM:      .  (200 ppp is the standard) ',2,'Sinks',44),(45,'Utensils and small wares are air dried using the green wired shelving above the sink.',1,'Sinks',45),(46,'Pans in the bakers rack are clean (no crumbs). ',1,'Thawi ng',46),(47,'The clear plastic hoods on the thawing racks are closed when in use and are clean. ',1,'Thawi ng',47),(48,'Time is marked when product is pulled out of freezer (in AM - should be close to 2 AM for breads/up to 24 hours for eggs and sausage patties).   ',3,'Thawi ng',48),(49,'All containers are labeled with name of product and expiration dates.',2,'Product Identification',49),(50,'Expiration chart is updated, in use, posted in each of the required kitchen areas (freezer, refrigerators). ',2,'Product Identification',50),(51,'Boxes in freezer are stored with label of product facing out. ',1,'Product Identification',51),(52,'All cleaning chemicals are properly identified, stored per back room plan o gram and used according to directions.',1,'Product Identification',52),(53,'MSDS Complete and available.',2,'Product Identification',53);
/*!40000 ALTER TABLE `inspection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,'Sausage, Egg, & Cheese Biscuit','1',2,0.99,'71101001005','each'),(2,'Sausage & Cheese Biscuit','2',2,0.77,'71101001104','each'),(3,'Sausage, Egg, & Cheese Croissant','3',2,0.23,'71101001203','each'),(4,'Bacon, Egg & Cheese Croissant','4',2,1.41,'71101001302','each'),(5,'Bacon, Egg & Cheese Bagel','5',2,1.12,'71101001401','each'),(6,'Sausage, Egg & Cheese Burrito','6',2,1.06,'71101001500','each'),(7,'Chorizo, Egg, & Cheese Burrito','7',2,1.24,'71101001609','each'),(8,'Breakfast Pizza','8',2,0.88,'71101003207','each'),(9,'Turkey Sausage, EggW&PJ','9',2,0.90,'71101001807','each'),(10,'Bacon, Egg  & Cheese English Muffin','10',2,0.98,'71101001906','each'),(11,'Cheese Pizza','11',2,0.53,'','each'),(12,'Sausage Pizza','12',2,0.69,'','each'),(13,'Pepperoni Pizza','13',2,0.58,'','each'),(14,'Supreme Pizza','14',2,0.79,'','each'),(15,'Beef Pizza','15',2,0.74,'','each'),(16,'Ham/Pineapple Pizza','16',2,0.67,'','each'),(17,'Chicken Bites- Spicy','17',2,1.73,'71101002903','each'),(18,'Chicken Bites- Regular','18',2,1.60,'71101003009','each'),(19,'Nathan Hot Dog','19',2,1.10,'','each'),(20,'Salty Pretzel','20',2,1.55,'','each'),(21,'Cheese Pizza','21',2,0.53,'','each'),(22,'Sausage Pizza','22',2,0.69,'','each'),(23,'Pepperoni Pizza','23',2,0.58,'','each'),(24,'Supreme Pizza','24',2,0.79,'','each'),(25,'Beef Pizza','25',2,0.74,'','each'),(26,'Ham/Pineapple Pizza','26',2,0.67,'','each'),(27,'Chicken Bites- Spicy','27',2,1.73,'','each'),(28,'Chicken Bites- Regular','28',2,1.60,'','each'),(29,'Nathan Hot Dog','29',2,1.10,'','each'),(30,'Salty Pretzel','30',2,1.55,'','each'),(31,'Bagel','31',1,0.36,'','each'),(32,'English Muffin','32',1,0.21,'','each'),(33,'Biscuit','33',1,0.39,'','each'),(34,'Croissant','34',1,0.64,'','each'),(35,'Flour Tortilla','35',1,0.11,'','each'),(36,'Cheese Blend','36',1,0.18,'','each'),(37,'Cheese Amer Slice 160 ct','37',1,0.13,'','each'),(38,'Pepper Jack Cheese ','38',1,0.20,'','each'),(39,'Fried Egg Patty BI Pepp','39',1,0.22,'','each'),(40,'Egg White Puff','40',1,0.21,'','each'),(41,'Scrambled Egg','41',1,0.13,'','oz'),(42,'Liquid Whole Egg','42',1,0.09,'','oz'),(43,'Sausage Patty','43',1,0.25,'','each'),(44,'Chorizo Small Crumble  ','44',1,0.22,'','oz'),(45,'Bacon One  ','45',1,0.21,'','each'),(46,'Turkey Sausage ','46',1,0.27,'','each'),(47,'Breakfast Sausage Crumble ','47',1,0.14,'','oz'),(48,'Pre Cooked Bacon Pieces ','48',1,0.36,'','oz'),(49,'Dough Pizza 16\" Fold Edge ','49',1,1.61,'','each'),(50,'Cheese Mozzarella Qlc ','50',1,0.13,'','oz'),(51,'Ham Topping Sliced and Quartered','51',1,0.23,'','oz'),(52,'Sausage Italian Pizza Topping ','52',1,0.15,'','oz'),(53,'Beef Pizza Topping ','53',1,0.20,'','oz'),(54,'Pepperoni ','54',1,0.17,'','oz'),(55,'Mushroom Pieces & Stems ','55',1,0.11,'','oz'),(56,'Pineapple Tidbits Cho ','56',1,0.10,'','oz'),(57,'Pepper Jalapeno Slice','57',1,0.05,'','oz'),(58,'Olive Ripe Slice ','58',1,0.17,'','oz'),(59,'Onion Red Dice 1/4 inch ','59',1,0.11,'','oz'),(60,'Pepper Bell Green Diced 3/8\" ','60',1,0.10,'','oz'),(61,'Sauce Pizza Pizzaiolo ','61',1,0.04,'','oz'),(62,'Cheese Parmesan Pc. .17','62',1,0.06,'','each'),(63,'Pepper Red Crushed Pc. .06','63',1,0.05,'','each'),(64,'Italian Seasoning ','64',1,0.33,'','each'),(65,'Cheese Parmesan Grate ','65',1,0.20,'','oz'),(66,'Gehl Cheese in a Cup ','66',1,0.45,'','each'),(67,'Pretzel J & J ','67',1,1.10,'','each'),(68,'Ken\'s Barbecue Sauce ','68',1,0.14,'','each'),(69,'Ken\'s Sweet & Sour Sauce ','69',1,0.14,'','each'),(70,'Ken\'s Buttermilk Ranch','70',1,0.14,'','each'),(71,'Ken\'s Honey Mustard','71',1,0.15,'','each'),(72,'Ken\'s Boom Boom Sauce','72',1,0.14,'','each'),(73,'Pierce Chicken Wing Dings ','73',1,0.27,'','oz'),(74,'Pierce Chicken Wing Zing','74',1,0.27,'','oz'),(75,'Nathans Hot Dog Bite','75',1,0.22,'','each'),(76,'Clamshell ','76',1,0.21,'','each'),(77,'Pizza Slice','77',1,0.22,'','each'),(78,'Pizza Box ','78',1,0.64,'','each'),(79,'Burrito Wrap ','79',1,0.05,'','each'),(80,'Pretzel ','80',1,0.30,'','each'),(81,'Label','81',1,0.02,'',NULL);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `product_availability`
--

LOCK TABLES `product_availability` WRITE;
/*!40000 ALTER TABLE `product_availability` DISABLE KEYS */;
INSERT INTO `product_availability` VALUES (1,1,1,1),(2,1,2,2),(3,1,3,3),(4,1,4,4),(5,1,5,5),(6,1,6,6),(7,1,7,7),(8,1,8,8),(9,1,9,9),(10,1,10,10),(11,2,11,11),(12,2,12,12),(13,2,13,13),(14,2,14,14),(15,2,15,15),(16,2,16,16),(17,2,17,17),(18,2,18,18),(19,2,19,19),(20,2,20,20),(21,3,11,21),(22,3,12,22),(23,3,13,23),(24,3,14,24),(25,3,15,25),(26,3,16,26),(27,3,17,27),(28,3,18,28),(29,3,19,29),(30,3,20,30),(31,1,31,31),(32,1,32,32),(33,1,33,33),(34,1,34,34),(35,1,35,35),(36,1,36,36),(37,1,37,37),(38,1,38,38),(39,1,39,39),(40,1,40,40),(41,1,41,41),(42,1,42,42),(43,1,43,43),(44,1,44,44),(45,1,45,45),(46,1,46,46),(47,1,47,47),(48,1,48,48),(49,1,49,49),(50,1,50,50),(51,1,51,51),(52,1,52,52),(53,1,53,53),(54,1,54,54),(55,1,55,55),(56,1,56,56),(57,1,57,57),(58,1,58,58),(59,1,59,59),(60,1,60,60),(61,1,61,61),(62,1,62,62),(63,1,63,63),(64,1,64,64),(65,1,65,65),(66,1,66,66),(67,1,67,67),(68,1,68,68),(69,1,69,69),(70,1,70,70),(71,1,71,71),(72,1,72,72),(73,1,73,73),(74,1,74,74),(75,1,75,75),(76,1,76,76),(77,1,77,77),(78,1,78,78),(79,1,79,79),(80,1,80,80),(81,1,81,81),(82,2,31,31),(83,2,32,32),(84,2,33,33),(85,2,34,34),(86,2,35,35),(87,2,36,36),(88,2,37,37),(89,2,38,38),(90,2,39,39),(91,2,40,40),(92,2,41,41),(93,2,42,42),(94,2,43,43),(95,2,44,44),(96,2,45,45),(97,2,46,46),(98,2,47,47),(99,2,48,48),(100,2,49,49),(101,2,50,50),(102,2,51,51),(103,2,52,52),(104,2,53,53),(105,2,54,54),(106,2,55,55),(107,2,56,56),(108,2,57,57),(109,2,58,58),(110,2,59,59),(111,2,60,60),(112,2,61,61),(113,2,62,62),(114,2,63,63),(115,2,64,64),(116,2,65,65),(117,2,66,66),(118,2,67,67),(119,2,68,68),(120,2,69,69),(121,2,70,70),(122,2,71,71),(123,2,72,72),(124,2,73,73),(125,2,74,74),(126,2,75,75),(127,2,76,76),(128,2,77,77),(129,2,78,78),(130,2,79,79),(131,2,80,80),(132,2,81,81),(133,3,31,31),(134,3,32,32),(135,3,33,33),(136,3,34,34),(137,3,35,35),(138,3,36,36),(139,3,37,37),(140,3,38,38),(141,3,39,39),(142,3,40,40),(143,3,41,41),(144,3,42,42),(145,3,43,43),(146,3,44,44),(147,3,45,45),(148,3,46,46),(149,3,47,47),(150,3,48,48),(151,3,49,49),(152,3,50,50),(153,3,51,51),(154,3,52,52),(155,3,53,53),(156,3,54,54),(157,3,55,55),(158,3,56,56),(159,3,57,57),(160,3,58,58),(161,3,59,59),(162,3,60,60),(163,3,61,61),(164,3,62,62),(165,3,63,63),(166,3,64,64),(167,3,65,65),(168,3,66,66),(169,3,67,67),(170,3,68,68),(171,3,69,69),(172,3,70,70),(173,3,71,71),(174,3,72,72),(175,3,73,73),(176,3,74,74),(177,3,75,75),(178,3,76,76),(179,3,77,77),(180,3,78,78),(181,3,79,79),(182,3,80,80),(183,3,81,81),(184,4,1,82),(185,4,2,83),(186,4,3,84),(187,4,4,85),(188,4,5,86),(189,4,6,87),(190,4,7,88),(191,4,8,89),(192,4,9,90),(193,4,10,91),(194,4,11,92),(195,4,12,93),(196,4,13,94),(197,4,14,95),(198,4,15,96),(199,4,16,97),(200,4,17,98),(201,4,18,99),(202,4,19,100),(203,4,20,101),(204,4,39,102),(205,4,40,103),(206,4,41,104),(207,4,43,105),(208,4,44,106),(209,4,46,107),(210,4,47,108),(211,4,73,109),(212,4,74,110),(213,4,75,111),(214,5,1,112),(215,5,2,113),(216,5,3,114),(217,5,4,115),(218,5,5,116),(219,5,6,117),(220,5,7,118),(221,5,8,119),(222,5,9,120),(223,5,10,121),(224,5,11,122),(225,5,12,123),(226,5,13,124),(227,5,14,125),(228,5,15,126),(229,5,16,127),(230,5,17,128),(231,5,18,129),(232,5,19,130),(233,5,20,131),(234,5,39,132),(235,5,40,133),(236,5,41,134),(237,5,43,135),(238,5,44,136),(239,5,46,137),(240,5,47,138),(241,5,73,139),(242,5,74,140),(243,5,75,141),(244,6,1,142),(245,6,2,143),(246,6,3,144),(247,6,4,145),(248,6,5,146),(249,6,6,147),(250,6,7,148),(251,6,8,149),(252,6,9,150),(253,6,10,151),(254,6,11,152),(255,6,12,153),(256,6,13,154),(257,6,14,155),(258,6,15,156),(259,6,16,157),(260,6,17,158),(261,6,18,159),(262,6,19,160),(263,6,20,161),(264,6,39,162),(265,6,40,163),(266,6,41,164),(267,6,43,165),(268,6,44,166),(269,6,46,167),(270,6,47,168),(271,6,73,169),(272,6,74,170),(273,6,75,171);
/*!40000 ALTER TABLE `product_availability` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `product_type`
--

LOCK TABLES `product_type` WRITE;
/*!40000 ALTER TABLE `product_type` DISABLE KEYS */;
INSERT INTO `product_type` VALUES (1,'Ingredients'),(2,'Finished Goods');
/*!40000 ALTER TABLE `product_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (111,'Manager'),(112,'Employee'),(113,'Admin'),(114,'Manager'),(115,'employee');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `store`
--

LOCK TABLES `store` WRITE;
/*!40000 ALTER TABLE `store` DISABLE KEYS */;
INSERT INTO `store` VALUES (20,'7eleven','1920 BRYAN ST SUITE 102'),(23,'capital','TX, Austin'),(46,'Local','San diego, CA'),(104,'FoodCo','CA, Long Beach'),(114,'7eleven1114','kansas'),(36104,'7eleven','1919 BRYAN ST SUITE 102');
/*!40000 ALTER TABLE `store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'test01','Venkat Dulipalli','test01@7eleven.com','test@01','A'),(2,'test02','Pam ','test02@7eleven.com','test@02','P'),(3,'test03','Andrew','test@andrew.com','test@03','S');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `user_role`
--

LOCK TABLES `user_role` WRITE;
/*!40000 ALTER TABLE `user_role` DISABLE KEYS */;
INSERT INTO `user_role` VALUES (1,112,36104,1),(2,114,36104,2),(3,113,36104,3);
/*!40000 ALTER TABLE `user_role` ENABLE KEYS */;
UNLOCK TABLES;
