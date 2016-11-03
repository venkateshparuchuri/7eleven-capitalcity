# -*- coding: utf-8 -*-
from flask_restful import reqparse
from flask_restful import Resource
from flask import  jsonify, abort, make_response, request, g
from time import localtime, strftime
from datetime import date
import time
import calendar
import MySQLdb
import datetime as DT
import json
import logging
import MySQLdb.cursors

from flask_inputs import Inputs
from flask_inputs.validators import JsonSchema
from jsonschema import validate

from wtforms.validators import DataRequired

AddNewSurveySchema = {
    'type': 'object',
    'properties': {
        'surveyName': {'type': 'string'},
        'profile_id': {'type': 'integer'}
    },
    "required": ["surveyName","profile_id"]
}

CreateNewSurveySchema = {
    'type': 'object',
    'properties': {
        'survey_id' : {'type': 'integer'},
        'store_id' : {'type': 'integer'},
        'inspector_name' : {'type': 'string'},
        'manager_name' : {'type': 'string'}
    },
    "required": ["survey_id","store_id", "inspector_name", "manager_name"]
}


SaveSurveyAnswersSchema = {
    'type': 'object',
    'properties': {
        'question_answer_id': {'type': 'integer'},
        'survey_result_id': {'type': 'integer'},
        'survey_question_id': {'type': 'integer'},
        'question_answer_score': {'type': 'integer'},
        'question_answer_comments': {'type': 'string'},

    },
    "required": ["survey_result_id","survey_question_id","question_answer_score","question_answer_comments"]
}

SurveyCategoriesSchema= {
    'type': 'object',
    'properties': {
        'category_id': {'type': 'integer'}
    },
    "required": ["category_id"]
}


CompletedSurveySchema = {
    'type': 'object',
    'properties': {
        'status': {'type': 'string'},
        'survey_overall_comments': {'type': 'string'},
        'survey_result_id': {'type': 'integer'},
    },
    "required": ["status","survey_overall_comments","survey_result_id"]
}

QuestionSchema = {
    'type': 'object',
    'properties': {
        'category_id': {'type': 'integer'},
        'question':{'type':'string'},
        'score': {'type': 'integer'}
    },
    "required": ["category_id","question","score"]
}

CategorySchema = {
    'type': 'object',
    'properties': {
        'survey_id': {'type': 'integer'},
        'category_name': {'type': 'string'}
    },
    "required": ["survey_id","category_name"]
}

class GetSurveyNamesListInputs(Inputs):
    args = {
        'store_id': [DataRequired(message='Store ID Required')]
    }

class GetSurveyNamesList(Resource):
    def get(self):
        logger = logging.getLogger("GetSurveyNamesList get")
        logger.info('Entered into GetSurveyNamesList  get method')
        try:
            inputs = GetSurveyNamesListInputs(request)
            if not inputs.validate():
                return jsonify(success=False, errors=inputs.errors)

            store_id = str(request.args.get("store_id"))
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)
        query = """SELECT idsurvey as surveyId, survey_name from survey s
        inner join store_profiles sp on sp.profile_id = s.profile_id where sp.store_id= %s """
        cursor.execute(query,(store_id,))
        rv = cursor.fetchall()
        flag=False
        if len(rv)>0:
            for i in rv:
                if i['survey_name'] == 'Plan to Succeed':
                    flag=True
        if not flag:
            new_query = """ SELECT idsurvey as surveyId, survey_name from survey where survey_name='Plan to Succeed' """
            cursor.execute(new_query,)
            new_rv= cursor.fetchall()
            rv=rv+new_rv
        rv = sorted(rv, key=lambda k: k['surveyId'])

        result = []
        for value in rv:
            survey_obj = {}
            surveyName = value['survey_name']
            surveyId = str(value['surveyId'])
            sub_query = """ SELECT CAST(idsurvey_category AS CHAR) as categoryId, category_name as categoryName from survey_category where survey_id= %s; """
            cursor.execute(sub_query, (surveyId, ))
            categoryIds = cursor.fetchall()
            survey_obj["surveyName"] = surveyName
            survey_obj["surveyId"] = surveyId
            categories = []
            for category in categoryIds:
                category_obj = {}
                categoryId = category["categoryId"]
                categoryName = category["categoryName"]
                sub_question_query = """SELECT CAST(idsurvey_questions AS CHAR) as questionId, question, CAST(score AS CHAR) as question_score   from survey_questions where category_id= %s; """
                cursor.execute(sub_question_query, (categoryId, ))
                questions = cursor.fetchall()
                category_obj["categoryId"] = str(categoryId)
                category_obj["categoryName"] = categoryName
                category_obj["questions"] = questions
                categories.append(category_obj)
            survey_obj["categories"] = categories
            result.append(survey_obj)
        logger.info('Exited from GetSurveyNamesList Get method')
        return jsonify({"status":"success", "response":result})



class SettingsSurvey(Resource):
    def get(self):
        logger = logging.getLogger("GetSurveyNamesList get")
        logger.info('Entered into GetSurveyNamesList  get method')
        try:
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)
        query = """SELECT idsurvey as surveyId, survey_name from survey where Active_flag = "TRUE" """
        cursor.execute(query)
        rv = cursor.fetchall()
        result = []
        for value in rv:
            survey_obj = {}
            surveyName = value['survey_name']
            surveyId = str(value['surveyId'])
            sub_query = """ SELECT CAST(idsurvey_category AS CHAR) as categoryId, category_name as categoryName from survey_category where survey_id= %s and active_flag='TRUE'; """
            cursor.execute(sub_query, (surveyId, ))
            categoryIds = cursor.fetchall()
            survey_obj["surveyName"] = surveyName
            survey_obj["surveyId"] = surveyId
            categories = []
            for category in categoryIds:
                category_obj = {}
                categoryId = category["categoryId"]
                categoryName = category["categoryName"]
                sub_question_query = """SELECT CAST(idsurvey_questions AS CHAR) as questionId, question, CAST(score AS CHAR) as question_score  from survey_questions where category_id= %s and active_flag='TRUE'; """
                cursor.execute(sub_question_query, (categoryId, ))
                questions = cursor.fetchall()
                category_obj["categoryId"] = str(categoryId)
                category_obj["categoryName"] = categoryName
                category_obj["questions"] = questions
                categories.append(category_obj)
            survey_obj["categories"] = categories
            result.append(survey_obj)
        logger.info('Exited from GetSurveyNamesList Get method')
        return jsonify({"status":"success", "response":result})

class AddNewSurveyApiInputs(Inputs):
    json = [JsonSchema(schema=AddNewSurveySchema)]


class AddNewSurvey(Resource):
    def post(self):
        logger = logging.getLogger("AddNewSurvey")
        logger.info('Entered into AddNewSurvey  post method')

        inputs = AddNewSurveyApiInputs(request)
        if not inputs.validate():
            return jsonify(success=False, errors=inputs.errors)

        survey = request.json
        Active_flag="TRUE"
        cursor = g.appdb.cursor()
        query = """ INSERT INTO `survey`(`survey_name`, `profile_id`, `Active_flag`)VALUES(%s, %s, %s) """
        cursor.execute(query,(str(survey["surveyName"]), str(survey["profile_id"]),Active_flag))
        g.appdb.commit()
        logger.info('Exited from AddNewSurvey post method')
        return jsonify({"status":"success", "response":survey})

class GetSurveyTableInputs(Inputs):
    args = {
        'survey_id': [DataRequired(message='Survey ID Required')],
        'store_id': [DataRequired(message='Store ID Required')]
    }

class GetSurveyTable(Resource):
    def get(self):
        logger = logging.getLogger("GetSurveyTable get")
        logger.info('Entered into GetSurveyTable get method')
        try:
            inputs = GetSurveyTableInputs(request)
            if not inputs.validate():
                return jsonify(success=False, errors=inputs.errors)

            survey_id = request.args.get("survey_id")
            store_id = request.args.get("store_id")
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)
        query = """ SELECT sr.id as survey_result_id, store_id,survey_date,status as status,score, s.location,
                    sr.survey_overall_comments, sr.inspector_name
                    FROM survey_result sr
                    inner join store s  on s.id = sr.store_id
                    where sr.survey_id = %s and sr.store_id = %s
                    order by sr.survey_date asc """
        cursor.execute(query, (survey_id, store_id))
        rv = cursor.fetchall()
        logger.info('Exited from GetSurveyTable post method')
        return jsonify({"status":"success", "response":rv})


class SurveyCategoriesApiInputs(Inputs):
    json = [JsonSchema(schema=SurveyCategoriesSchema)]

class SurveyCategoriesInputs(Inputs):
    args = {
        'survey_result_id': [DataRequired(message='Survey Result ID Required')]
    }

class SurveyCategories(Resource):
    def get(self):
        logger = logging.getLogger("SurveyCategories get")
        logger.info('Entered into SurveyCategories get method')
        try:
            inputs = SurveyCategoriesInputs(request)
            if not inputs.validate():
                return jsonify(success=False, errors=inputs.errors)

            survey_result_id = request.args.get("survey_result_id")
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)
        query = """ SELECT sc.idsurvey_category as category_id, sc.category_name FROM survey_category sc
        left outer join survey_result sr on sr.survey_id = sc.survey_id
        where sr.id = %s and sc.Active_flag = "TRUE"; """
        cursor.execute(query, (survey_result_id, ))
        rv = cursor.fetchall()
        logger.info('Exited from SurveyCategories get method')
        return jsonify({"status":"success", "response":rv})

#///to edit the category name///
    def put(self):
        logger = logging.getLogger("editing SurveyCategory name ")
        logger.info('Entered into editing SurveyCategory name put method')
        try:
            surveyid=request.json["surveyid"]
            categoryname=request.json["categoryname"]
            idsurvey_category=request.json["idsurvey_category"]
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)
        query = """ UPDATE survey_category SET survey_id=%s, category_name=%s where idsurvey_category=%s; """
        cursor.execute(query, (str(surveyid),categoryname,str(idsurvey_category) ))
        g.appdb.commit()
        logger.info('Exited from editing SurveyCategory name put method')
        return jsonify({"status":"success", "response":idsurvey_category})

    def post(self):
        #this function deletes category from survey_category table
        logger = logging.getLogger("Deleting question and category")
        logger.info('Entered into Delete question and category')

        inputs = SurveyCategoriesApiInputs(request)
        if not inputs.validate():
            return jsonify(success=False, errors=inputs.errors)

        try:
            category_id=request.json["category_id"]
            Active_flag = "FALSE"
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)

        delcategory=""" UPDATE `survey_category` SET Active_flag=%s WHERE `idsurvey_category`=%s; """
        cursor.execute(delcategory,(Active_flag,category_id))
        g.appdb.commit()

        logger.info('Exited from Deleting question and category')
        return jsonify({"status":"success", "response":category_id})

class SurveyCategoriesInputs(Inputs):
    args = {
        'survey_result_id': [DataRequired(message='Survey Result ID Required')]
    }

class SurveyQuestions(Resource):
    def get(self):
        logger = logging.getLogger("SurveyQuestions get")
        logger.info('Entered into SurveyQuestions get method')
        try:
            inputs = SurveyCategoriesInputs(request)
            if not inputs.validate():
                return jsonify(success=False, errors=inputs.errors)
            category_id = request.args.get("category_id")
            survey_result_id = request.args.get("survey_result_id")
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)
        query = """SELECT idsurvey_questions as question_id, question, score as question_score,
        sra.comments,sra.result_score as result_score, sra.id as question_answer_id, IFNULL(sra.question_info,'') as questionInfo
        from survey_questions sq left outer join survey_result_answers sra on sra.survey_question_id = sq.idsurvey_questions
        and sra.survey_result_id = %s where sq.category_id = %s and sq.Active_flag = "TRUE" """
        cursor.execute(query, (survey_result_id, category_id))
        rv = cursor.fetchall()
        score_query = """SELECT sr.score  as total_score, CAST(sum(sq.score) AS CHAR) as TotalSurveyScore,
        survey_overall_comments as survey_comments from survey_result  sr
        inner join survey s on s.idsurvey = sr.survey_id
        inner join survey_category sc on s.idsurvey = sc.survey_id
        inner join survey_questions sq on sq.category_id = sc.idsurvey_category
        where sr.id= %s  and sq.active_flag='TRUE';"""
        cursor.execute(score_query, (survey_result_id,))
        score = cursor.fetchall()
        logger.info('Exited from SurveyQuestions get method')
        return jsonify({"status":"success", "response":rv, "surveyScore":score})



class EditSurvey(Resource):

    def put(self):
        logger = logging.getLogger("editing Survey")
        logger.info('Entered into editing survey put method')
        try:
            edit_name = request.json["edit_name"]
            edit_code = request.json["edit_code"]
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)

        query = """UPDATE `survey` SET `survey_name`=%s WHERE `idsurvey`=%s"""
        cursor.execute(query,(edit_name, str(edit_code)))
        g.appdb.commit()
        logger.info('Exited from editing survey put method')
        return jsonify({"status":"success", "response":edit_name})

class GetCompletedQuestionsInputs(Inputs):
    args = {
        'survey_result_id': [DataRequired(message='Survey Result ID Required')]
    }

class GetCompletedQuestions(Resource):

    def get(self):
        logger = logging.getLogger("GetCompletedQuestions get")
        logger.info('Entered into GetCompletedQuestions get method')
        try:
            inputs = GetCompletedQuestionsInputs(request)
            if not inputs.validate():
                return jsonify(success=False, errors=inputs.errors)

            survey_result_id = request.args.get("survey_result_id")
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)
        query = """ SELECT sc.idsurvey_category as category_id, sc.category_name FROM survey_category sc
        left outer join survey_result sr on sr.survey_id = sc.survey_id
        where sr.id = %s"""
        cursor.execute(query, (survey_result_id, ))
        rv = cursor.fetchall()
        result = []
        for category in rv:
            category_obj = {}
            category_obj["survey_result_id"] = survey_result_id
            category_id = category["category_id"]
            category_name = category["category_name"]
            sub_query = """SELECT sq.question, sra.result_score, sra.comments, sr.inspector_name, sr.score as total_score,
            sr.survey_overall_comments as overallComments, sra.question_info as questionInfo from survey_questions sq
            left outer join survey_result_answers sra on sra.survey_question_id = sq.idsurvey_questions
			left outer join survey_result  sr on sr.id = sra.survey_result_id
            where sq.category_id = %s and sra.survey_result_id= %s """
            cursor.execute(sub_query, (category_id,survey_result_id))
            questions = cursor.fetchall()
            category_obj["category_id"] = category_id
            category_obj["category_name"] = category_name
            category_obj["questions"] = questions
            result.append(category_obj)
        logger.info('Exited from GetCompletedQuestions get method')
        return jsonify({"status":"success", "response":result})


class CreateNewSurveyApiInputs(Inputs):
    json = [JsonSchema(schema=CreateNewSurveySchema)]

class CreateNewSurvey(Resource):
    def post(self):
        logger = logging.getLogger("CreateNewSurvey")
        logger.info('Entered into CreateNewSurvey  post method')

        # inputs = CreateNewSurveyApiInputs(request)
        # if not inputs.validate():
        #     return jsonify(success=False, errors=inputs.errors)

        try:
            survey_id = request.json["survey_id"]
            store_id = request.json["store_id"]
            inspector_name = request.json["inspector_name"]
            manager_name  = request.json["manager_name"]
            status='drafted'
            score='0'
            current_time =  strftime("%Y-%m-%d %H:%M:%S", localtime())
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)

        query = """INSERT INTO `survey_result` (`survey_id`,`store_id`,`inspector_name`,`manager_name`,`survey_date`,`status`,`score`) VALUES(%s,%s,%s,%s,%s,%s,%s);"""
        cursor.execute(query,(survey_id,store_id, inspector_name, manager_name, current_time, status,score))
        g.appdb.commit()
        newID = cursor.lastrowid

        logger.info('Exited from CreateNewSurvey post method')
        return jsonify({"status":"success", "response":newID})

class SaveSurveyAnswersApiInputs(Inputs):
    json = [JsonSchema(schema=SaveSurveyAnswersSchema)]

class SaveSurveyAnswers(Resource):
     def post(self):
        logger = logging.getLogger("SaveSurveyAnswers POST Method")
        logger.info('Entered into SaveSurveyAnswers  post method')

        inputs = SaveSurveyAnswersApiInputs(request)
        if not inputs.validate():
            return jsonify(success=False, errors=inputs.errors)

        questions = request.json
        time_now_timestamp = str(DT.datetime.now())
        cursor = g.appdb.cursor()

        for question in questions:
            question_answer_id = int(question["question_answer_id"])
            result_score = question["question_answer_score"]
            survey_result_id = question["survey_result_id"]
            comments = question["question_answer_comments"]
            survey_question_id = question["survey_question_id"]
            extra_info = question["question_extra_info"]
            if question_answer_id == 0:
                query = """INSERT INTO `survey_result_answers`(`survey_result_id`,
                `survey_question_id`,`result_score`,`comments`,`question_info`)
                VALUES(%s,%s,%s,%s,%s)"""
                cursor.execute(query,(survey_result_id,survey_question_id, result_score, comments,extra_info))
                g.appdb.commit()

            else:
                update_query = """UPDATE `survey_result_answers`
                SET `result_score` = %s, `comments` = %s, `question_info` = %s WHERE `id` = %s """
                cursor.execute(update_query,(result_score, comments,extra_info,question_answer_id))
                g.appdb.commit()

        score_query = """ UPDATE survey_result set `score` = (select sum(result_score) from survey_result_answers sra
        where sra.survey_result_id=%s), survey_date= %s, status = "drafted" where id=%s"""
        cursor.execute(score_query, (survey_result_id,time_now_timestamp,survey_result_id))
        g.appdb.commit()
        logger.info('Exited from SaveSurveyAnswers post method')
        return jsonify({"status":"  success", "response":questions})


class CompletedSurveyApiInputs(Inputs):
    json = [JsonSchema(schema=CompletedSurveySchema)]

class CompletedSurvey(Resource):
    def post(self):
        logger = logging.getLogger("CompletedSurvey")
        logger.info('Entered into CompletedSurvey  post method')

        time_now_timestamp = str(DT.datetime.now())
        inputs = CompletedSurveyApiInputs(request)
        if not inputs.validate():
            return jsonify(success=False, errors=inputs.errors)
        survey = request.json
        status = survey["status"]
        survey_overall_comments = survey["survey_overall_comments"]
        survey_result_id = str(survey["survey_result_id"])
        cursor = g.appdb.cursor()
        query = """ UPDATE survey_result set status = %s, survey_overall_comments = %s, survey_date=%s where id = %s """
        cursor.execute(query,(status,survey_overall_comments,time_now_timestamp,survey_result_id))
        g.appdb.commit()
        logger.info('Exited from CompletedSurvey post method')
        return jsonify({"status":"success", "response":survey})

class SurveyCommentsInputs(Inputs):
    args = {
        'survey_result_id': [DataRequired(message='Survey Result ID Required')]
    }

class SurveyComments(Resource):
    def get(self):
        logger = logging.getLogger("SurveyComments get")
        logger.info('Entered into SurveyComments get method')
        try:
            inputs = SurveyCommentsInputs(request)
            if not inputs.validate():
                return jsonify(success=False, errors=inputs.errors)

            survey_result_id = request.args.get("survey_result_id")
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)
        query = """ SELECT survey_overall_comments, score from survey_result where id=%s """
        cursor.execute(query, (survey_result_id, ))
        rv = cursor.fetchall()
        logger.info('Exited from SurveyComments get method')
        return jsonify({"status":"success", "response":rv})


class QuestionApiInputs(Inputs):
    json = [JsonSchema(schema=QuestionSchema)]


class Question(Resource):
    #This method inserts the category id, question and associated score
    def post(self):
        logger = logging.getLogger("inserting questions into survey_questions table")
        logger.info('Entered into addquestion  post method')

        inputs = QuestionApiInputs(request)
        if not inputs.validate():
            return jsonify(success=False, errors=inputs.errors)
        try:
            cursor = g.appdb.cursor()
            category_id = request.json["category_id"]
            question = request.json["question"]
            score = request.json["score"]
            active_flag="TRUE"
        except:
            logger.error('DB connection error', exc_info=True)

        addquestion = """INSERT INTO `7eleven`.`survey_questions`(`category_id`,`question`,`score`,`Active_flag`)values(%s,%s,%s,%s); """
        cursor.execute(addquestion,(str(category_id),str(question),str(score),active_flag))

        rowid=cursor.lastrowid
        g.appdb.commit()
        if '#text#' in question:
            newQuestion = '{{#textQuestion}}' + str(rowid) + '{{/textQuestion}}'
            question = question.replace('#text#', str(newQuestion))
            updateQuery = """UPDATE `7eleven`.`survey_questions`SET`question` = %s WHERE `idsurvey_questions` = %s """
            cursor.execute(updateQuery,(question,rowid))
            g.appdb.commit()
        logger.info('Exited from addquestion post method')
        return jsonify({"status":"success", "response":rowid, "newQuestion":question})

    def delete(self):
    #This method deletes question from survey_questions
        logger = logging.getLogger("Deleting question and category")
        logger.info('Entered into Delete question and category')

        try:
            question =request.json
            question_id = question["question_id"]
            active_flag= "FALSE"
            cursor = g.appdb.cursor()

        except:
            logger.error('DB Connection error', exc_info=True)
        setflag = """ UPDATE survey_questions SET active_flag=%s WHERE `idsurvey_questions`= %s """
        cursor.execute(setflag ,(active_flag, question_id ))
        g.appdb.commit()

        logger.info('Exited from Deleting question and category')
        return jsonify({"status":"success", "response":question_id})

    def put(self):
        logger = logging.getLogger("updating question into survey_questions table")
        logger.info('Entered into question put method')
        try:
            question = request.json
            question_id = question["question_id"]
            score = question["score"]
            editedQuestion = question["question"]
            cursor = g.appdb.cursor()
        except:
            logger.error('DB connection error', exc_info=True)

        update=""" UPDATE `survey_questions` SET question=%s, score= %s WHERE idsurvey_questions=%s; """
        cursor.execute(update,(editedQuestion,score, question_id))
        g.appdb.commit()
        logger.info('Exited from updating question put method')
        return jsonify({"status":"success", "response":question_id})


class CategorySchemaApiInputs(Inputs):
    json = [JsonSchema(schema=CategorySchema)]


class Category(Resource):

    def get(self):

        logger = logging.getLogger("selecting question into survey_questions table")
        logger.info('Entered into category get method')
        try:
            idsurvey_questions = request.args.get("idsurvey_questions")
            cursor = g.appdb.cursor()
        except:
            logger.error('DB connection error', exc_info=True)

        select = """ SELECT sr.id as survey_result_id, sr.store_id, sr.manager_name, sr.survey_date
        from survey_category sc
        inner join survey_result sr on sc.survey_id = sr.survey_id
        inner  join survey_questions sq on sc.idsurvey_category= sq.category_id
        where sq.idsurvey_questions = %s and sr.status = "drafted"; """

        cursor.execute(select,(idsurvey_questions,))
        rv=cursor.fetchall()

        g.appdb.commit()

        logger.info('Exited from updating question put method')
        return jsonify({"status":"success", "response":rv})


    def post(self):
        logger = logging.getLogger("inserting category into survey_category table")
        logger.info('Entered into addcategory post method')

        inputs = CategorySchemaApiInputs(request)
        if not inputs.validate():
            return jsonify(success=False, errors=inputs.errors)

        try:
            category = request.json
            survey_id = category["survey_id"]
            category_name = category["category_name"]
            cursor = g.appdb.cursor()
        except:
            logger.error('DB connection error', exc_info=True)

        addcategory ="""INSERT INTO `survey_category`(`survey_id`,`category_name`)VALUES(%s,%s)"""
        cursor.execute(addcategory,(survey_id,category_name))
        g.appdb.commit()
        rowid=cursor.lastrowid
        logger.info('Exited from addcategory post method')
        return jsonify({"status":"success", "response":rowid})

    def delete(self):
        logger = logging.getLogger("Deleting question and category")
        logger.info('Entered into Delete question and category')
        try:
            category_id =int(request.json["category_id"])
            Active_flag="FALSE"
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)
        delquestion=""" UPDATE `survey_questions` SET Active_flag=%s WHERE `category_id`=%s; """
        cursor.execute(delquestion,(Active_flag,category_id ))
        g.appdb.commit()

        delcategory=""" UPDATE `survey_category` SET Active_flag=%s WHERE `idsurvey_category`=%s; """
        cursor.execute(delcategory,(Active_flag,category_id, ))
        g.appdb.commit()

        logger.info('Exited from Deleting question and category')
        return jsonify({"status":"success", "response":category_id})

    def put(self):
        logger = logging.getLogger("inserting question into survey_questions table")
        logger.info('Entered into addquestion  post method')
        try:
            category_name = request.json["category_name"]
            idsurvey_category = request.json["idsurvey_category"]
            cursor = g.appdb.cursor()
        except:
            logger.error('DB connection error', exc_info=True)

        update=""" UPDATE `survey_category` SET `category_name`=%s WHERE `idsurvey_category`=%s; """
        cursor.execute(update,(category_name,idsurvey_category, ))
        g.appdb.commit()

        logger.info('Exited from updating question put method')
        return jsonify({"status":"success", "response":idsurvey_category})


class GetProfiles(Resource):
    def get(self):
        logger = logging.getLogger("GetProfiles get")
        logger.info('Entered into GetProfiles get method')
        try:
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)
        query = """ SELECT profile_name, id as profile_id from profiles;"""
        cursor.execute(query, )
        rv = cursor.fetchall()
        logger.info('Exited from GetProfiles get method')
        return jsonify({"status":"success", "response":rv})

class SavedSurveyListInputs(Inputs):
    args = {
        'category_id': [DataRequired(message='Category ID Required')]
    }

class SavedSurveyList(Resource):
    def get(self):
        logger = logging.getLogger("SavedSurveyList get")
        logger.info('Entered into SavedSurveyList get method')
        try:
            inputs = SavedSurveyListInputs(request)
            if not inputs.validate():
                return jsonify(success=False, errors=inputs.errors)

            cursor = g.appdb.cursor()
            category_id = request.args.get("category_id")
        except:
            logger.error('DB Connection error', exc_info=True)
        query = """ SELECT sr.id as survey_result_id, sr.store_id, sr.manager_name, sr.survey_date, sr.score, sr.inspector_name
        from survey_category sc inner join survey_result sr on
        sc.survey_id = sr.survey_id where sc.idsurvey_category = %s and sr.status="drafted";"""
        cursor.execute(query, (category_id,))
        rv = cursor.fetchall()
        logger.info('Exited from SavedSurveyList get method')
        return jsonify({"status":"success", "response":rv})
class DeleteSurveyList(Resource):
    def get(self):
        logger = logging.getLogger("DeleteSurveyList get")
        logger.info('Entered into DeleteSurveyList get method')
        try:
            #inputs = SavedSurveyListInputs(request)
            #if not inputs.validate():
            #    return jsonify(success=False, errors=inputs.errors)

            cursor = g.appdb.cursor()
            survey_id = request.args.get("survey_id")
        except:
            logger.error('DB Connection error', exc_info=True)
        query = """ SELECT sr.id as survey_result_id, sr.store_id, sr.manager_name, sr.survey_date
        from survey_result sr where sr.survey_id = %s and sr.status = 'drafted' """
        cursor.execute(query, (survey_id,))
        rv = cursor.fetchall()
        logger.info('Exited from DeleteSurveyList get method')
        return jsonify({"status":"success", "response":rv})

    def put(self):
        logger = logging.getLogger("DeleteSurveyList PUT Method")
        logger.info('Entered into DeleteSurveyList  PUT method')
        try:
            survey_id = request.json["survey_id"]
            Active_flag="FALSE"
            cursor = g.appdb.cursor()
        except:
            logger.error('DB connection error', exc_info=True)

        update=""" UPDATE `survey` SET `Active_flag`= %s WHERE `idsurvey`=%s; """
        cursor.execute(update,(Active_flag, survey_id))
        g.appdb.commit()

        logger.info('Exited from updating DeleteSurveyList put method')
        return jsonify({"status":"success", "response":survey_id})
