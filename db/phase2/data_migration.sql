START TRANSACTION;

ALTER TABLE `7eleven`.`survey_result_answers` 
DROP FOREIGN KEY `fk_survey_result_answers_1`;

ALTER TABLE `7eleven`.`survey_result` 
CHANGE COLUMN `id` `id` BIGINT(11) NOT NULL;

ALTER TABLE `7eleven`.`survey_result_answers` 
CHANGE COLUMN `id` `id` BIGINT(11) NOT NULL;


INSERT INTO 7eleven.survey_result ( id,survey_id, store_id, manager_name, inspector_name, survey_date, survey_overall_comments, status, score) 
SELECT id,1, store_id, manager_name, inspector_name, inspection_date, inspection_overall_comments, status, score FROM 7eleven.inspection_result;


INSERT INTO 7eleven.survey_result_answers (id,survey_result_id, survey_question_id, result_score, comments)
SELECT id,inspection_result_id, question_id, result_score, comments FROM 7eleven.inspection_result_answers;


ALTER TABLE `7eleven`.`survey_result` 
CHANGE COLUMN `id` `id` BIGINT(11) NOT NULL AUTO_INCREMENT ;

ALTER TABLE `7eleven`.`survey_result_answers` 
CHANGE COLUMN `id` `id` BIGINT(11) NOT NULL AUTO_INCREMENT ;

ALTER TABLE `7eleven`.`survey_result_answers` 
ADD CONSTRAINT `fk_survey_result_answers_1`
  FOREIGN KEY (`survey_result_id`)
  REFERENCES `7eleven`.`survey_result` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

COMMIT;

