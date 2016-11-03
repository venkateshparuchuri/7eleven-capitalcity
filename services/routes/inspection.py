from flask_restful import reqparse
from flask_restful import Resource
from flask import  jsonify, abort, make_response, request, g
from time import localtime, strftime

import MySQLdb
import MySQLdb.cursors
import logging

from flask_inputs import Inputs
from flask_inputs.validators import JsonSchema
from jsonschema import validate

InspectionAnswersSchema = {
    'type': 'object',
    'properties': {
        'question_id': {'type': 'integer'},
        'Inspection_result_id' : {'type': 'integer'},
        'result_score' : {'type': 'integer'},
        'comments' : {'type': 'string'}

    },
    "required": ["question_id","Inspection_result_id","result_score","comments"]
}


class InspectionQuestion(Resource):
    def get(self):
        logger = logging.getLogger("Inspection Questions")
        logger.info('Entered into Inspection Questions  get method')
        try:
            cursor = g.appdb.cursor()
            inspection_id = request.args.get("Inspection_result_id")
            category=request.args.get("category_name")
        except:
            logger.error("Error in the database connection", exc_info=True)

        query = """SELECT i.id as question_id, i.question as question, i.score as question_score,
        i.category, ira.result_score as result_score, ira.comments, ira.id as question_answer_id FROM inspection i
        left outer join inspection_result_answers ira
        on ira.question_id = i.id and ira.Inspection_result_id = %s where i.category=%s """
        cursor.execute(query,(str(inspection_id), str(category)))
        rv = cursor.fetchall()
        query = """SELECT score from inspection_result where id =%s """
        cursor.execute(query,(str(inspection_id), ))
        result = cursor.fetchall()
        logger.info("Exited from INspection Question get method")
        return jsonify({"status":"success","response": rv, "score":result})

#this validates inspectionanswers
class InspectionAnswersApiInputs(Inputs):
    json = [JsonSchema(schema=InspectionAnswersSchema)]

class InspectionAnswers(Resource):
    def post(self):
        logger = logging.getLogger("Inspection Answers")
        logger.info('Entered into Inspection Answers  post method')

        inputs = InspectionAnswersApiInputs(request)
        if not inputs.validate():
            return jsonify(success=False, errors=inputs.errors)

        try:
            inspect = request.json
            cursor = g.appdb.cursor()
        except:
            logger.error('Database connection problem or unable to get variables from URL', exc_info=True)
        for json in inspect:
            #and json["result_score"]>0
            if json["question_answer_id"]:
                updatequery = """UPDATE inspection_result_answers set result_score=%s, comments=%s where id=%s"""
                cursor.execute(updatequery, (json["result_score"], json["comments"], json["question_answer_id"]))
                g.appdb.commit()
            else:
                query="""INSERT INTO inspection_result_answers(`question_id`,`inspection_result_id`,`result_score`,`comments`)VALUES(%s, %s, %s, %s)"""
                cursor.execute(query, (json["question_id"],json['Inspection_result_id'], json["result_score"], json['comments']))
                g.appdb.commit()
        savescore = """UPDATE inspection_result set score = (select sum(result_score) from inspection_result_answers where inspection_result_id=%s ) where id=%s"""
        cursor.execute(savescore, (json["Inspection_result_id"], json["Inspection_result_id"]))
        g.appdb.commit()
        logger.info('Exited from Inspection Answers post method')
        return jsonify({"status":"success","response":inspect})

class UpdateInspectionScore(Resource):
    def post(self):
#        inspect = request.json
#        cursor  = g.appdb.cursor()
#        savescore = """UPDATE inspection_result set score = %s where id=%s"""
#        cursor.execute(savescore, (int(inspect["total_score"]), int(inspect["Inspection_result_id"]))
#        g.appdb.commit()
        return jsonify({"status":"success","response":inspect})



class InspectionResult(Resource):
    def get(self):
        logger = logging.getLogger("Inspection Result dropdown")
        logger.info('Entered into Inspection Result dropdown  get method')
        try:
            cursor = g.appdb.cursor()
            store_id = request.args.get("storeid")
            status = request.args.get("from")
        except:
            logger.error('Connection Error with database or getting variables from the URL', exc_info=True)

        query = """ select ir.*,s.location from inspection_result ir
inner join store s on ir.store_id=s.id where store_id=%s order by inspection_date desc"""
        #category=request.args.get("category_name")
        if status=='admin':
            query = """ select ir.*,s.location from inspection_result ir
    inner join store s on ir.store_id=s.id where store_id=%s and status='completed' order by inspection_date desc"""
        #print inspection_id, category
        cursor.execute(query,(store_id,))
        rv = cursor.fetchall()
        return jsonify({"status":"success","response": rv})


class Inspection(Resource):

    def get(self):
        logger = logging.getLogger("Inspection method for score")
        logger.info('Entered into Inspection score method  get method')
        try:
            inspection_id = request.args.get("Inspection_result_id")
            cursor = g.appdb.cursor()
        except:
            logger.error('Either database connection or variables from URL error', exc_info=True)
        query = """SELECT score from inspection_result where id =%s """
        cursor.execute(query,(str(inspection_id), ))
        rv = cursor.fetchone()
        logger.info('Exited from the method Inspection get method')
        return jsonify({"status":"success","response": rv})

    def post(self):
            logger = logging.getLogger("Inspection post method")
            logger.info('Entered into Inspection score method  post method')
            try:
                inspect = request.json
                newID = 0
                cursor = g.appdb.cursor()
                current_time = strftime("%Y-%m-%d %H:%M:%S", localtime())
            except:
                logger.error('Either database connection or url variables error', exc_info=True)
            if request.json["inspection_id"]>0:
                inspection_id = request.json["inspection_id"]
                finishquery = """UPDATE inspection_result set score=%s, status=%s, inspection_overall_comments=%s where id=%s"""
                cursor.execute(finishquery, (request.json["score"], request.json["status"], request.json["comments"], request.json["inspection_id"]))
                g.appdb.commit()
            else:
                query="""INSERT INTO inspection_result (`store_id`,`manager_name`,`inspector_name`,`inspection_date`)VALUES (%s, %s, %s , %s)"""
                cursor.execute(query, (inspect["store_id"], inspect["manager_name"], inspect["inspector_name"],current_time))
                newID = cursor.lastrowid
                g.appdb.commit()
            if newID:
                inspection_id = newID
            logger.info('Exited from the Inspection POST method')
            return jsonify({"status":"success","response":inspection_id});


class ExpandInspection(Resource):
    def get(self):
        logger = logging.getLogger("Expand Inspection")
        logger.info('Entered into Expand Inspection method  get method')
        try:
            cursor = g.appdb.cursor()
            inspection_id = request.args.get("inspection_id")
        except:
            logger.error('Db connection our URL variables error', exc_info=True)
        query = """SELECT i.question, ira.comments, ira.result_score, i.category,ir.score,ir.manager_name,ir.inspection_overall_comments
        from
        inspection i
        left outer join inspection_result_answers ira on i.id = ira.question_id and ira.inspection_result_id = %s
        left outer join inspection_result ir on ir.id= %s """

        #category = request.args.get("category_name")
        cursor.execute(query, (inspection_id,inspection_id ))
        rv = cursor.fetchall()
        logger.info('Exited from ExpandInspection get method')
        return jsonify({"status":"success", "response":rv})
