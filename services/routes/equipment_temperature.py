from flask_restful import reqparse
from flask_restful import Resource
from flask import  jsonify, abort, make_response, request, g

from time import localtime, strftime
from datetime import date
import calendar
import time
import MySQLdb
import MySQLdb.cursors
import logging


from flask_inputs import Inputs
from flask_inputs.validators import JsonSchema
from jsonschema import validate

from flask_inputs import Inputs
from wtforms.validators import DataRequired

EquipmenttempsaveSchema = {
    'type': 'object',
    'properties': {
    	'store_id':{'type': 'integer'},
    	'product_id':{'type': 'integer'},
    	'product_availability_id':{'type': 'integer'},
    	'temp_time':{'type': 'string'},
    	'temperature':{'type': 'number'},
    	'initials':{'type': 'string'},
    	'status':{'type': 'string'},
    	'waste_reported_date':{'type': 'string'}

    },
	"required": ["store_id","product_id","product_availability_id","temp_time","temperature","initials","status","waste_reported_date"]
}


class EquipmentTemperatureListInputs(Inputs):
    args = {
        'waste_reported_date': [DataRequired(message='Waste Reported Date Required')],
        'store_id': [DataRequired(message='Store ID Required')],
        'category_name': [DataRequired(message='Category Name Required')]
    }

class EquipmentTemperatureList(Resource):
	def get(self):
		logger=logging.getLogger("EquipmentTemperatureList")
		logger.info("entered EquipmentTemperatureList get method")

		try:
                    inputs = EquipmentTemperatureListInputs(request)
                    if not inputs.validate():
                        return jsonify(success=False, errors=inputs.errors)

		    json = request.query_string
		    cursor = g.appdb.cursor()
		    request_Date=request.args.get("waste_reported_date")
		    request_store_id=request.args.get("store_id")
		    request_category_name=request.args.get("category_name")
		except:
			logging.error("unable to establish connection with db",exc_info=True)

		query ="""SELECT e.id as product_id, e.name as itemName, ea.availability_id as product_availability_id, CAST(et.time AS CHAR)as temp_time,
			CAST(et.temperature as char) as temperature, et.initials as initials,
			et.status as status,et.id as temp_id from equipment e
			inner join equipment_availability ea on ea.equipment_id = e.id
			inner join available_category ac on ac.id = ea.`availability_id`
			left outer join equipment_temperature et on et.equipment_id = e.id and et.equipment_availability_id = ac.id and
			et.date = %s and et.store_id = %s where ac.category_name = %s """
		cursor.execute(query,(request_Date,request_store_id,request_category_name ))
		rv = cursor.fetchall()
		logger.info("exiting from the EquipmentTemperatureList get method")
		return jsonify({"status":"success","response":rv})

#this class is for validation
class EquipmentTempSaveApiInputs(Inputs):
    json = [JsonSchema(schema=EquipmenttempsaveSchema)]


class EquipmentTempSave(Resource):
	def post(self):
		logger=logging.getLogger("EquipmentTempSave")
		logger.info("Entered EquipmentTempSave Post method")
		# inputs = EquipmentTempSaveApiInputs(request)
		# if not inputs.validate():
		# 	return jsonify(success=False, errors=inputs.errors)
		try:

                    equipTemp = request.json
                    cursor = g.appdb.cursor()

		except:
			logger.error("unable to establish connection with db", exc_info=True)
		for json in equipTemp:
                        if json["temp_id"]>0:
                            if json["temperature"] == "empty":
                                delete = """ DELETE FROM equipment_temperature where id=%s"""
                                cursor.execute(delete,(json["temp_id"], ))
                                g.appdb.commit()

                            else:
                                updatequery = """UPDATE equipment_temperature set time=%s, temperature=%s, initials=%s, status=%s where id=%s"""
                                cursor.execute(updatequery,(json["temp_time"],json["temperature"],json["initials"], json["status"], json["temp_id"]))
                                g.appdb.commit()
                        else:
                                query = """INSERT INTO equipment_temperature(`store_id`,`equipment_id`,`equipment_availability_id`,
                                        `time`,`temperature`,`initials`,`status`, `date`)VALUES(%s, %s, %s, %s, %s, %s, %s, %s)"""
				cursor.execute(query, (json["store_id"], json["product_id"], json["product_availability_id"],
                                        json["temp_time"], json["temperature"], json["initials"], json["status"], json["waste_reported_date"]))
				g.appdb.commit()
		logger.info("quiting from the EquipmentTempSave Post method")
		return jsonify({"status":"success", "response":json["temp_id"]})
