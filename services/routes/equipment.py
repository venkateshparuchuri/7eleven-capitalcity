from flask_restful import reqparse
from flask_restful import Resource
from flask import  jsonify, abort, make_response, request, g

from flask_inputs import Inputs
from flask_inputs.validators import JsonSchema
from jsonschema import validate


Equipmentlist = {
    'type': 'object',
    'properties': {
        'name': {'type': 'string'},
		'sku': {'type': 'integer'}
    },
	"required": ["name","sku"]
}

class EquipmentlistApiInputs(Inputs):
    json = [JsonSchema(schema=Equipmentlist)]

class EquipmentList(Resource):
	def get(self):
		cursor = g.appdb.cursor()
		cursor.execute("""SELECT * FROM equipment;""")
		rv = cursor.fetchall()
		return jsonify({"status":"success","response":rv})

	def post(self):
		inputs = EquipmentlistApiInputs(request)
		if not inputs.validate():
			return jsonify(success=False, errors=inputs.errors)

		json = request.json
		cursor = g.appdb.cursor()

		query=""" INSERT INTO equipment(name,sku) VALUES (%s,%s) """
		cursor.execute(query,(json["name"],json["sku"]))
		g.appdb.commit()
		return jsonify({"status":"success","response":json});


class Equipment(Resource):
	def get(self, id):
		cursor = g.appdb.cursor()
		cursor.execute("""SELECT * FROM equipment where id=%s""",(id))
		rv = cursor.fetchone()
		return jsonify({"status":"success","response":rv})

	def put(self, id):
		cursor = g.appdb.cursor()
		json = request.json;
		query=""" UPDATE `7eleven`.`equipment` set name=%s,sku=%s where id=%s; """
		cursor.execute(query,(json["name"],json["sku"],id))
		g.appdb.commit()
		return jsonify({"status":"success","response":json})

	def delete(self, id):
		cursor = g.appdb.cursor()
		query="""DELETE from equipment where id=%s;"""
		cursor.execute(query,(id))
		g.appdb.commit()
		return jsonify({"status":"success","response":id})