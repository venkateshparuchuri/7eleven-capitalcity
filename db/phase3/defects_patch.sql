### UPdating the question fron survey_questions table

UPDATE `7eleven`.`survey_questions` SET `question`='W/I Freezer temp near 10F. W/I Cooler temp below 40F.' WHERE `idsurvey_questions`='55';

###


## Adding unique key index for product_sold table

ALTER TABLE `7eleven`.`product_sold`
ADD UNIQUE INDEX `index4` (`product_id` ASC, `store_id` ASC, `sold_date` ASC, `start_hour` ASC);

###

## Updating  product cost up to 3 decimals in product cost history table

ALTER TABLE `7eleven`.`product_cost_history`
CHANGE COLUMN `item_cost` `item_cost` DECIMAL(10,3) NOT NULL COMMENT '' ;

###
