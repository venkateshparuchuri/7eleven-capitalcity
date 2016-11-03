#adding unique index for(level_name) in levels table

ALTER TABLE `7eleven`.`levels`
ADD UNIQUE INDEX `index2` (`level_name` ASC);

#adding unique index for(user_id) in user table

ALTER TABLE `7eleven`.`user`
ADD UNIQUE INDEX `index2` (`user_id` ASC);

#changeing the column(question_info) VARCHAR(45) to VARCHAR(256)

ALTER TABLE `7eleven`.`survey_result_answers`
CHANGE COLUMN `question_info` `question_info` VARCHAR(256) NULL DEFAULT NULL ;


UPDATE `7eleven`.`survey_questions` SET `question`='W/I Freezer temp near 10F. W/I Cooler temp below 40F.' WHERE `idsurvey_questions`='55';
