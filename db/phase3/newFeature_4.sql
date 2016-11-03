#INSERT INTO `7eleven`.`profiles` (`id`, `profile_name`, `profile_code`) VALUES ('3', 'Perishable Goods', 'pg');
START TRANSACTION;

ALTER TABLE `7eleven`.`dbq_products`
CHANGE COLUMN `caese` `case_qty` VARCHAR(45) NOT NULL ;

ALTER TABLE `7eleven`.`dbq_products`
ADD INDEX `fk_dbq_products_1_idx` (`product_type_id` ASC),
ADD UNIQUE INDEX `index3` (`product_description` ASC);
ALTER TABLE `7eleven`.`dbq_products`
ADD CONSTRAINT `fk_dbq_products_1`
  FOREIGN KEY (`product_type_id`)
  REFERENCES `7eleven`.`product_type` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `7eleven`.`repots_users`
RENAME TO  `7eleven`.`reports_users` ;


UPDATE `7eleven`.`product_type` SET `type`='Perishable Goods' WHERE `id`='8';


UPDATE `7eleven`.`available_category` SET `category_name`='DeliCase' WHERE `id`='9';
INSERT INTO `7eleven`.`available_category` (`id`, `category_name`) VALUES ('10', 'CoolerDoor');
INSERT INTO `7eleven`.`available_category` (`id`, `category_name`) VALUES ('11', 'DeliTemp');
INSERT INTO `7eleven`.`available_category` (`id`, `category_name`) VALUES ('12', 'CoolerTemp');


UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='460';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='461';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='462';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='463';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='464';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='465';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='466';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='467';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='468';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='469';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='470';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='471';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='472';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='473';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='474';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='475';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='476';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='477';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='478';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='479';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='480';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='481';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='482';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='483';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='484';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='485';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='486';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='487';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='488';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='489';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='490';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='491';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='492';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='493';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='494';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='495';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='496';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='497';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='498';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='499';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='500';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='501';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='502';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='503';
UPDATE `7eleven`.`product_availability` SET `availability_id`='10' WHERE `id`='504';
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('11', '164', '305');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('11', '165', '306');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('11', '166', '307');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('11', '167', '308');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('11', '168', '309');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('11', '169', '310');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('11', '170', '311');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('11', '171', '312');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('11', '183', '313');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('11', '184', '314');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('11', '185', '316');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('11', '186', '317');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('11', '204', '318');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('11', '205', '319');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('11', '206', '320');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('11', '207', '321');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('11', '208', '322');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('12', '228', '323');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('12', '229', '324');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('12', '230', '325');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('12', '231', '326');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('12', '232', '327');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('12', '233', '328');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('12', '234', '329');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('12', '235', '330');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('12', '236', '331');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('12', '237', '332');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('12', '238', '333');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('12', '239', '334');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('12', '240', '335');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('12', '241', '336');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('12', '242', '337');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('12', '243', '338');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('12', '244', '339');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('12', '245', '340');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('12', '246', '341');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('12', '247', '342');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('12', '248', '343');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('12', '249', '344');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('12', '250', '346');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('12', '251', '347');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('12', '252', '348');
INSERT INTO `7eleven`.`product_availability` (`availability_id`, `product_id`, `sort_order`) VALUES ('12', '253', '349');



UPDATE `7eleven`.`available_category_times` SET `time_range`='5am-10am', `end_time`='10:00:00' WHERE `id`='55';
INSERT INTO `7eleven`.`available_category_times` (`available_category_id`, `time_range`, `report_before`, `start_time`, `end_time`) VALUES ('9', '10am-5am', '06:30:00', '10:00:00', '05:00:00');
INSERT INTO `7eleven`.`available_category_times` (`available_category_id`, `time_range`, `report_before`, `start_time`, `end_time`) VALUES ('10', '5am-10am', '11:30:00', '05:00:00', '05:00:00');
INSERT INTO `7eleven`.`available_category_times` (`available_category_id`, `time_range`, `report_before`, `start_time`, `end_time`) VALUES ('10', '10am-5am', '06:30:00', '10:00:00', '10:00:00');
INSERT INTO `7eleven`.`available_category_times` (`available_category_id`, `time_range`, `report_before`, `start_time`, `end_time`) VALUES ('11', '5am-10am', '11:30:00', '05:00:00', '05:00:00');
INSERT INTO `7eleven`.`available_category_times` (`available_category_id`, `time_range`, `report_before`, `start_time`, `end_time`) VALUES ('11', '10am-5am', '06:30:00', '10:00:00', '10:00:00');
INSERT INTO `7eleven`.`available_category_times` (`available_category_id`, `time_range`, `report_before`, `start_time`, `end_time`) VALUES ('12', '5am-10am', '11:30:00', '05:00:00', '05:00:00');
INSERT INTO `7eleven`.`available_category_times` (`available_category_id`, `time_range`, `report_before`, `start_time`, `end_time`) VALUES ('12', '10am-5am', '06:30:00', '10:00:00', '10:00:00');


INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('163', '2016-05-14', '0.03');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('164', '2016-05-14', '0.03');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('165', '2016-05-14', '0.02');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('166', '2016-05-14', '0.02');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('167', '2016-05-14', '0.04');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('168', '2016-05-14', '0.04');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('169', '2016-05-14', '0.14');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('170', '2016-05-14', '0.14');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('171', '2016-05-14', '0.03');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('172', '2016-05-14', '0.01');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('173', '2016-05-14', '0.01');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('174', '2016-05-14', '0.13');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('175', '2016-05-14', '0.13');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('176', '2016-05-14', '0.13');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('177', '2016-05-14', '0.13');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('178', '2016-05-14', '0.25');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('179', '2016-05-14', '0.25');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('180', '2016-05-14', '0.25');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('181', '2016-05-14', '0.25');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('182', '2016-05-14', '0.21');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('183', '2016-05-14', '0.01');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('184', '2016-05-14', '0.01');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('185', '2016-05-14', '0.02');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('186', '2016-05-14', '0.02');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('187', '2016-05-14', '0.11');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('188', '2016-05-14', '0.11');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('189', '2016-05-14', '0.11');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('190', '2016-05-14', '0.13');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('191', '2016-05-14', '0.05');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('192', '2016-05-14', '0.12');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('193', '2016-05-14', '0.12');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('194', '2016-05-14', '0.09');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('195', '2016-05-14', '0.09');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('196', '2016-05-14', '0.09');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('197', '2016-05-14', '0.09');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('198', '2016-05-14', '0.22');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('199', '2016-05-14', '0.22');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('200', '2016-05-14', '0.22');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('201', '2016-05-14', '0.21');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('202', '2016-05-14', '0.19');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('203', '2016-05-14', '0.17');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('204', '2016-05-14', '0.11');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('205', '2016-05-14', '0.11');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('206', '2016-05-14', '0.29');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('207', '2016-05-14', '0.22');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('208', '2016-05-14', '0.21');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('209', '2016-05-14', '0.15');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('210', '2016-05-14', '0.15');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('211', '2016-05-14', '0.15');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('212', '2016-05-14', '0.23');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('213', '2016-05-14', '0.27');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('214', '2016-05-14', '0.27');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('215', '2016-05-14', '0.01');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('216', '2016-05-14', '0.01');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('217', '2016-05-14', '0.07');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('218', '2016-05-14', '0.07');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('219', '2016-05-14', '0.07');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('220', '2016-05-14', '0.33');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('221', '2016-05-14', '0.33');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('222', '2016-05-14', '0.22');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('223', '2016-05-14', '0.22');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('224', '2016-05-14', '0.14');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('225', '2016-05-14', '0.14');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('226', '2016-05-14', '0.26');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('227', '2016-05-14', '0.26');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('228', '2016-05-14', '0.15');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('229', '2016-05-14', '0.15');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('230', '2016-05-14', '0.08');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('231', '2016-05-14', '0.09');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('232', '2016-05-14', '0.08');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('233', '2016-05-14', '0.07');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('234', '2016-05-14', '0.05');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('235', '2016-05-14', '0.06');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('236', '2016-05-14', '0.22');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('237', '2016-05-14', '0.17');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('238', '2016-05-14', '0.15');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('239', '2016-05-14', '0.14');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('240', '2016-05-14', '0.17');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('241', '2016-05-14', '0.21');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('242', '2016-05-14', '0.09');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('243', '2016-05-14', '0.09');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('244', '2016-05-14', '0.11');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('245', '2016-05-14', '0.16');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('246', '2016-05-14', '0.16');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('247', '2016-05-14', '0.15');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('248', '2016-05-14', '0.15');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('249', '2016-05-14', '0.15');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('250', '2016-05-14', '0.15');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('251', '2016-05-14', '0.07');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('252', '2016-05-14', '0.11');
INSERT INTO `7eleven`.`product_cost_history` (`product_id`, `effective_date_from`, `item_cost`) VALUES ('253', '2016-05-14', '0.22');

COMMIT;
