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


from flask_inputs import Inputs
from flask_inputs.validators import JsonSchema
from jsonschema import validate
from wtforms.validators import DataRequired



Add_build_factorSchema = {
    'type': 'object',
    'properties': {
        'factor_value': {'type': 'integer'}
    },
    "required": ["factor_value"]
}



BuildtoFactorAddStoreSchema= {
    'type': 'object',
    'properties': {
        'factor_id': {'type': 'integer'},
        'store_id': {'type': 'integer'}

    },
    "required": ["factor_id","store_id"]
}

Product_cost_historySchema = {
    'type': 'object',
    'properties': {
        'itemId': {'type': 'integer'},
        'effectiveDate': {'type': 'string'},
        'cost': {'type': 'string'}
    },
    "required": ["itemId","effectiveDate","cost"]
}

ThresholdFactorSchema = {
    'type': 'object',
    'properties': {
        'factor_value': {'type': 'integer'}

    },
    "required": ["factor_value"]
}


ThresholdStoresSchema= {
    'type': 'object',
    'properties': {
        'store_id': {'type': 'integer'},
        'threshold_id': {'type': 'integer'}
    },
    "required": ["store_id","threshold_id"]
}


class Add_build_factorApiInputs(Inputs):
    json = [JsonSchema(schema=Add_build_factorSchema)]


class AddBuildFactor(Resource):
    def post(self):
        logger = logging.getLogger("Add_build_factor")
        logger.info('Entered into Add_build_factor  post method')
        value = request.json
        factor_value = int(request.json["factor_value"])
        profile_id = int(request.json["profile_id"])

        cursor = g.appdb.cursor()

        inputs = Add_build_factorApiInputs(request)
        if not inputs.validate():
            return jsonify(success=False, errors=inputs.errors)

        query = """ INSERT INTO `buildto_factor` (`factor_value`,`profile_id`)VALUES(%s, %s) """
        cursor.execute(query,(factor_value, profile_id))
        g.appdb.commit()
        logger.info('Exited from Add_build_factor post method')
        return jsonify({"status":"success", "response":factor_value})

class BuildtoFactorAddStoreApiInputs(Inputs):
    json = [JsonSchema(schema=BuildtoFactorAddStoreSchema)]

class BuildtoFactorAddStoreInputs(Inputs):
    args = {
        'profile_code': [DataRequired(message='Profile Code Required')]
        }

class BuildtoFactorAddStore(Resource):
    def post(self):

        #inputs = BuildtoFactorAddStoreApiInputs(request)
        #if not inputs.validate():
        #    return jsonify(success=False, errors=inputs.errors)

        logger = logging.getLogger("BuildtoFactorAddStore post")
        logger.info('Entered into BuildtoFactorAddStore post method')
        try:
            factor_id= int(request.json["factor_id"])
            store_id= int(request.json["store_id"])
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)

        insertQuery = """ INSERT INTO buildto_stores(factor_id, store_id) values (%s, %s) """
        cursor.execute(insertQuery,(factor_id, store_id ))
        g.appdb.commit()
        logger.info('Exited from BuildtoFactorAddStore post method')
        return jsonify({"status":"success", "response":factor_id})

    def get(self):
        logger = logging.getLogger("BuildtoFactorAddStore get")
        logger.info('Entered into BuildtoFactorAddStore GET method')
        try:
            inputs = BuildtoFactorAddStoreInputs(request)
            if not inputs.validate():
                return jsonify(success=False, errors=inputs.errors)

            cursor = g.appdb.cursor()
            profile_code = request.args.get("profile_code")
        except:
            logger.error('DB connnection error', exc_info=True)
        if profile_code == "cc":
            query = """ SELECT sp.store_id from store_profiles sp where sp.store_id not in
                  (select bs.store_id from buildto_stores bs inner join buildto_factor bf on bs.factor_id=bf.id and bf.profile_id=1)
                  and sp.profile_id = 1 """
            cursor.execute(query)
            rv = cursor.fetchall()
        elif profile_code == "rg":
            query = """ SELECT sp.store_id from store_profiles sp where sp.store_id not in
                  (select bs.store_id from buildto_stores bs inner join buildto_factor bf on bs.factor_id=bf.id and bf.profile_id=2)
                  and sp.profile_id = 2 """
            cursor.execute(query)
            rv = cursor.fetchall()
        elif profile_code == "pg":
            query = """ SELECT sp.store_id from store_profiles sp where sp.store_id not in
                  (select bs.store_id from buildto_stores bs inner join buildto_factor bf on bs.factor_id=bf.id and bf.profile_id=3)
                  and sp.profile_id = 3 """
            cursor.execute(query)
            rv = cursor.fetchall()

        logger.info('Exited from BuildtoFactorAddStore GET method')
        return jsonify({"status":"success", "response":rv})

class BuildtoFactorStore(Resource):
    def post(self):
        logger = logging.getLogger("Delete Factor get")
        logger.info('Entered into Delete factor Delete method')
        try:
            factor_id=request.json["id"]
            store_id=request.json["storeId"]
            logger.info(factor_id)
            logger.info(store_id)
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)
        deleteSubQuery = """ DELETE from buildto_stores where factor_id = %s and store_id = %s """
        cursor.execute(deleteSubQuery,(factor_id, store_id ))
        g.appdb.commit()
        logger.info('Exited from DELETE Factor')
        return jsonify({"status":"success", "response":factor_id})

class BuildtoFactorListInputs(Inputs):
    args = {
        'profile_code': [DataRequired(message='Profile Code Required')]
        }

class BuildtoFactorList(Resource):
    def post(self):
        logger = logging.getLogger("Delete Factor get")
        logger.info('Entered into Delete factor Delete method')
        try:
            factor_id=request.json["factor_id"]
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)


        deleteSubQuery = """ DELETE from buildto_stores where factor_id = %s """
        cursor.execute(deleteSubQuery,(factor_id, ))

        query = """ DELETE from buildto_factor where id = %s """
        cursor.execute(query,(factor_id, ))
        g.appdb.commit()
        logger.info('Exited from DELETE Factor')
        return jsonify({"status":"success", "response":factor_id})

    def get(self):
        logger = logging.getLogger("AdminStoresList get")
        logger.info('Entered into AdminStoresList  get method')
        try:
            inputs = BuildtoFactorAddStoreInputs(request)
            if not inputs.validate():
                return jsonify(success=False, errors=inputs.errors)

            cursor = g.appdb.cursor()
            profile_code = str(request.args.get("profile_code"))
        except:
            logger.error('DB Connection error', exc_info=True)
        query = """SELECT  bf.id as factor_id, CAST(bf.factor_value as char) as factor_value
        FROM buildto_factor bf inner join profiles pf on pf.id =bf.profile_id
        where pf.profile_code = %s """
        cursor.execute(query, (profile_code, ))
        rv = cursor.fetchall()
        result = []
        for value in rv:
            factor_id = value['factor_id']
            factor_value = value['factor_value']
            sub_query = """ SELECT store_id from buildto_stores where factor_id = %s """
            cursor.execute(sub_query,(factor_id, ))
            data = cursor.fetchall()
            result.append({"factor_id":factor_id, "stores":data, 'factor_value':factor_value, "profile_code":profile_code})
        logger.info('Exited from AdminStoresList Get method')
        return jsonify({"status":"success", "response":result})

class HistoryDateValidation(Resource):
    def get(self):
        logger = logging.getLogger("HistoryDateValidation get")
        logger.info('Entered into HistoryDateValidation  get method')
        try:
            product_id = str(request.args.get("product_id"))
            verify_date = str(request.args.get("date"))
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)
        query = """ SELECT CAST(effective_date_from as CHAR) as effective_date,
              CAST(item_cost as CHAR) as product_cost, idproduct_cost_history as history_id
              from product_cost_history where product_id = %s and effective_date_from = %s """
        cursor.execute(query,(product_id, verify_date))
        rv = cursor.fetchall()
        logger.info('Exited from HistoryDateValidation Get method')
        return jsonify({"status":"success", "response":rv})

class Product_cost_historyApiInputs(Inputs):
    json = [JsonSchema(schema=Product_cost_historySchema)]

class Product_cost_history(Resource):
    def post(self):
        inputs = Product_cost_historyApiInputs(request)
        if not inputs.validate():
            return jsonify(success=False, errors=inputs.errors)

        logger = logging.getLogger("Product_cost_history Save")
        logger.info('Entered into Product_cost_history  get Method')
        try:
            costHistory = request.json
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)
        if costHistory["history_id"]>0:
            updateQuery = """ UPDATE product_cost_history set item_cost=%s where idproduct_cost_history = %s """
            cursor.execute(updateQuery,(costHistory["cost"],costHistory["history_id"]))
            g.appdb.commit()
        else:
            insertQuery = """ INSERT INTO product_cost_history (`product_id`,`effective_date_from`,`item_cost`) VALUES(%s,%s,%s) """
            cursor.execute(insertQuery,(costHistory["itemId"],costHistory["effectiveDate"],costHistory["cost"]))
            g.appdb.commit()
        logger.info('Exited from Add Cost Hostory post method')
        return jsonify({"status":"success", "response":costHistory})

    def get(self):
        logger = logging.getLogger("Product_cost_history get")
        logger.info('Entered into Product_cost_history  get method')
        try:
            profile_code = str(request.args.get("profile_code"))
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)
        if profile_code == 'cc':
            query = """ SELECT p.id as product_id, p.name as product_name
                  from product p
                  inner join product_type pt on pt.id = p.product_type_id
                  where pt.type in('Finished Goods','Ingredients') """
        elif profile_code == 'pg':
            query = """ SELECT p.id as product_id, p.name as product_name
                  from product p
                  inner join product_type pt on pt.id = p.product_type_id
                  where p.name not in ('Fresh Cooler', 'Cooler Doors') and pt.type in ('Perishable Goods') """
        elif profile_code == 'rg':
            query = """ SELECT p.id as product_id, p.name as product_name
                  from product p
	              inner join product_type pt on pt.id = p.product_type_id
                  where pt.type in('Roller Grill Finished Goods','Roller Grill Ingredients')
                  and p.product_parent_id is not null """
        cursor.execute(query)
        rv = cursor.fetchall()

        result = []
        result_obj = {}
        for value in rv:
            product_id = value['product_id']
            product_name = value['product_name']
            cost_query = """ SELECT CAST(pch.effective_date_from AS CHAR) as effective_date,
            CAST(pch.item_cost as CHAR) as product_cost
            FROM product_cost_history pch where pch.product_id = %s
            order by idproduct_cost_history desc limit 1 """
            cursor.execute(cost_query,(product_id,))
            costDate = cursor.fetchall()

            product_cost = costDate[0]['product_cost']
            effective_date = costDate[0]['effective_date']
            sub_query = """ SELECT CAST(pch.item_cost as CHAR) as item_cost, CAST(pch.effective_date_from as CHAR) AS effective_date,
            pch.idproduct_cost_history as history_id
            from product p inner join product_cost_history pch on p.id = pch.product_id
            where pch.product_id = %s order by pch.effective_date_from desc """
            cursor.execute(sub_query, (product_id, ))
            data = cursor.fetchall()
            result.append({"product_name":product_name, "values":data, "product_id":product_id, "product_cost":product_cost,"effective_date": effective_date})
        logger.info('Exited from AdminStoresList Get method')
        return jsonify({"status":"success", "response":result})

class ThresholdFactorApiInputs(Inputs):
    json = [JsonSchema(schema=ThresholdFactorSchema)]


class ThresholdFactor(Resource):

    def post(self):
        inputs = ThresholdFactorApiInputs(request)
        if not inputs.validate():
            return jsonify(success=False, errors=inputs.errors)

        logger = logging.getLogger("ThresholdFactor post call")
        logger.info("Entered into ThresholdFactor post Method")
        try:
            factor_value=request.json["factor_value"]
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)

        insert = """ INSERT INTO `threshold_factor`(factor_value) values(%s) """
        cursor.execute(insert,(factor_value, ))
        g.appdb.commit()

        logger.info('Exited from Add Cost Hostory post method')
        return jsonify({"status":"success", "response":factor_value})

    def delete(self):

        logger = logging.getLogger("ThresholdFactorList delete call")
        logger.info("Entered into ThresholdFactorList delete Method")
        try:
            threshold_id = request.json["threshold_id"]
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)

        delcategory = """ DELETE FROM `threshold_stores` where threshold_id = %s """
        cursor.execute(delcategory,(threshold_id, ))
        g.appdb.commit()

        delete = """ DELETE FROM `threshold_factor` where id = %s """
        cursor.execute(delete,(threshold_id, ))
        g.appdb.commit()

        logger.info('Exited from ThresholdFactorList delete method')
        return jsonify({"status":"success", "response":threshold_id})

    def get(self):
        logger = logging.getLogger("ThresholdFactorList get")
        logger.info('Entered into ThresholdFactorList  get method')
        try:
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)
        query = """ SELECT  id as factor_id, CAST(factor_value as char) as factor_value FROM threshold_factor """
        cursor.execute(query)
        rv = cursor.fetchall()
        result = []
        for value in rv:
            factor_id = value['factor_id']
            factor_value = value['factor_value']
            sub_query = """ SELECT store_id from threshold_stores ts where ts.threshold_id = %s """
            cursor.execute(sub_query,(factor_id, ))
            data = cursor.fetchall()
            result.append({"factor_id":factor_id, "stores":data, 'factor_value':factor_value})
        logger.info('Exited from ThresholdFactorList Get method')
        return jsonify({"status":"success", "response":result})



class ThresholdStoresApiInputs(Inputs):
    json = [JsonSchema(schema=ThresholdStoresSchema)]

class ThresholdStores(Resource):
    def post(self):
        #inputs = ThresholdStoresApiInputs(request)
        #if not inputs.validate():
        #    return jsonify(success=False, errors=inputs.errors)

        logger = logging.getLogger("ThresholdFactorList post call")
        logger.info("Entered into ThresholdFactorList post Method")
        try:
            threshold_id=request.json["threshold_id"]
            store_id=request.json["store_id"]
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)
        costHistory = request.json
        insert = """ INSERT INTO `threshold_stores`(`threshold_id`,`store_id`)VALUES(%s, %s) """
        cursor.execute(insert,(threshold_id, store_id))
        g.appdb.commit()

        logger.info('Exited from Add Cost Hostory post method')
        return jsonify({"status":"success", "response":store_id})

    def delete(self):

        logger = logging.getLogger("ThresholdFactorList delete call")
        logger.info("Entered into ThresholdFactorList delete Method")
        try:
            store_id = request.json["store_id"]
            threshold_id = request.json["threshold_id"]
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)

        delete = """ DELETE FROM `threshold_stores` where store_id = %s and threshold_id = %s """

        cursor.execute(delete,(store_id,threshold_id))
        g.appdb.commit()
        logger.info('Exited from ThresholdFactor delete method')
        return jsonify({"status":"success", "response":store_id})

    def get(self):
        logger = logging.getLogger("ThresholdStores get")
        logger.info('Entered into ThresholdStores  get method')
        try:
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)
        query = """ SELECT sp.store_id from  store_profiles sp where sp.store_id not in (
              select ts.store_id from threshold_stores ts ) and sp.profile_id = 2 """
        cursor.execute(query,)
        rv = cursor.fetchall()
        logger.info('Exited from ThresholdFactorL Get method')
        return jsonify({"status":"success", "response":rv})


class BuildFactor(Resource):

    def get(self):
        logger = logging.getLogger(" BuildFactor get  method ")
        logger.info('Entered into BuildFactor get  method')
        try:
            cursor = g.appdb.cursor()
            factor_id = request.args.get("factor_id")
        except:
            logger.error('Database connection or url parameters error', exc_info=True)
        query = """ SELECT store_id AS store FROM buildto_stores WHERE factor_id = %s """
        cursor.execute(query,(factor_id, ))
        rv = cursor.fetchall()

        logger.info('Exited from the BuildFactor Method')
        return jsonify({"status":"success","response":rv})

class Threshold(Resource):

    def get(self):
        logger = logging.getLogger(" ThresholdStores get  method ")
        logger.info('Entered into ThresholdStores get  method')
        try:
            cursor = g.appdb.cursor()
            threshold_id = request.args.get("threshold_id")
        except:
            logger.error('Database connection or url parameters error', exc_info=True)
        query = """ SELECT store_id AS store FROM threshold_stores WHERE threshold_id = %s """
        cursor.execute(query,(threshold_id, ))
        rv = cursor.fetchall()

        logger.info('Exited from the ThresholdStores Method')
        return jsonify({"status":"success","response":rv})
