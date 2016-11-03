ALTER TABLE `7eleven`.`product_temperature`
DROP INDEX `index5` ,
ADD UNIQUE INDEX `index5` (`product_id` ASC, `availability_id` ASC, `store_id` ASC, `date` ASC, `availability_category_times_id` ASC);
