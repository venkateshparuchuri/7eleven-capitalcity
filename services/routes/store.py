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


StoreSchema = {
    'type': 'object',
    'properties': {
        'storeId' : {'type': 'integer'},
        'id' : {'type': 'integer'},
        'sold_date' : {'type': 'integer'},
        'start_hour' : {'type': 'integer'},
        'end_hour' : {'type': 'integer'},
        'no_of_units' : {'type': 'integer'},
        'day_of_the_week' : {'type': 'string'}
    },
    "required": ["store_id","id","sold_date","start_hour","end_hour","no_of_units","day_of_the_week"]
}

LevelTimingsSchema ={
    'type': 'object',
    'properties': {
        'factor_level' : {'type': 'string'}
    },
    "required": ["factor_level"]

}

class StoreApiInputs(Inputs):
    json = [JsonSchema(schema=StoreSchema)]

class Store(Resource):
    def get(self):
        logger = logging.getLogger("Stores")
        logger.info('Entered into Stores get  method')
        try:
            cursor = g.appdb.cursor()
        except:
            logger.error('Database connection or url parameters error', exc_info=True)
        sub_query = """ SELECT sp.store_id,sp.profile_id,p.profile_code,p.profile_name, sp.level_id,l.level_name from
                  store_profiles sp inner join profiles p on sp.profile_id=p.id
                  left outer join levels l on l.id = sp.level_id
                  where sp.store_id = %s  """
        query = """ SELECT * from store """
        cursor.execute(query)
        rv = cursor.fetchall()
        if len(rv)==0:
            logger.error('Empty list returned', exc_info=True)
            return jsonify({"status":"success","response":[]})
        result = []
        for value in rv:
            obj = {}
            store_id=value["id"]
            cursor.execute(sub_query,(store_id,))
            profiles = cursor.fetchall()
            obj["store_id"] = store_id
            obj["store_name"] = value["name"]
            obj["location"] = value["location"]
            obj["profiles"] = profiles
            result.append(obj)
        logger.info('Exited from the Store Profiles Method')
        return jsonify({"status":"success","response":result})

    def put(self):
        logger = logging.getLogger("Stores")
        logger.info('Entered into Store Profile Update method')

        try:
            store_update = request.json
            profile_id = store_update["profile_id"]
            store_id = store_update["storeId"]
            level_id = store_update["level_id"]
            cursor = g.appdb.cursor()
        except:
            logger.error('Either connection problem or unable to get url parameters', exc_info=True)
        if store_update["storeProfile"] == 1:
            #Add
            if level_id > 0:
                insertQuery = """ INSERT INTO store_profiles (profile_id, store_id, level_id) values (%s, %s, %s)  """
                cursor.execute(insertQuery,(profile_id, store_id, level_id))
                g.appdb.commit()
            else:
                insertQuery = """ INSERT INTO store_profiles (profile_id, store_id) values (%s, %s) """
                cursor.execute(insertQuery,(profile_id, store_id ))
                g.appdb.commit()
        else:
            #Delete
            deleteQuery = """ DELETE from store_profiles where profile_id=%s and store_id=%s """
            cursor.execute(deleteQuery, (profile_id, store_id))
            g.appdb.commit()


        logger.info('Exited from Insert Factor')
        return jsonify({"status":"success", "response":store_update})
    def post(self):
        logger = logging.getLogger("Stores")
        logger.info('Entered into Store Profile Update method')
        try:
            products = request.json
            cursor = g.appdb.cursor()
        except:
            logger.error('Either connection problem or unable to get url parameters', exc_info=True)
        for value in products:
            upc=value["upc"]
            #Get Product Based on UPC
            productQuery = """ SELECT id, name from product where upc = %s """
            cursor.execute(productQuery, (upc, ))
            rv = cursor.fetchone()
            #Just Keep the Store ID the Same.
            query = """ INSERT INTO product_sold(`store_id`,`product_id`,`sold_date`,
                  `start_hour`,`end_hour`,`no_of_units`,`day_of_the_week`) VALUES(%s, %s, %s, %s, %s, %s, %s) """
            cursor.execute(query, (value["store_id"], rv["id"], value["sold_date"],
            value["start_hour"], value["end_hour"], value["no_of_units"], value["day_of_the_week"]))
            g.appdb.commit()
            logger.info('Exited from Products Sold  post method')
        return jsonify({"status":"success", "response":{"count":len(products)}})

class AdminSelectedStoreInputs(Inputs):
    args = {
        'store_id': [DataRequired(message='Store ID Required')]
    }

class AdminSelectedStore(Resource):
    def get(self):
        logger = logging.getLogger("AdminSelectedStore")
        logger.info('Entered into AdminSelectedStore get  method')
        try:
            inputs = AdminSelectedStoreInputs(request)
            if not inputs.validate():
                return jsonify(success=False, errors=inputs.errors)
            cursor = g.appdb.cursor()
            store_id = str(request.args.get("store_id"))
        except:
            logger.error('Database connection or url parameters error', exc_info=True)
        query = """ SELECT profile_name from store_profiles sp
              inner join  profiles p on p.id = sp.profile_id where sp.store_id = %s """
        cursor.execute(query, (store_id, ))
        rv = cursor.fetchall()
        logger.info('Exited from the AdminSelectedStore Method')
        return jsonify({"status":"success","response":rv})

class LevelTimingsApiInputs(Inputs):
    json = [JsonSchema(schema=LevelTimingsSchema)]

class LevelTimings(Resource):
    def get(self):
        logger = logging.getLogger("LevelStores")
        logger.info('Entered into LevelStores get  method')
        try:
            cursor = g.appdb.cursor()
        except:
            logger.error('Database connection or url parameters error', exc_info=True)
        query = """ SELECT id, level_name from levels """
        cursor.execute(query)
        rv = cursor.fetchall()
        result = []
        for level in rv:
            result_obj = {}
            result_obj["level_id"] = level["id"]
            result_obj["level_name"] = level["level_name"]
            sub_query = """ SELECT lt.id level_time_id, lt.level_id, act.id as times_id,
                      CAST(act.time_range AS CHAR) as slot_name  from level_timings lt
                      inner join available_category_times act on act.id = lt.available_category_times_id
                      where lt.level_id = %s order by act.id asc """
            cursor.execute(sub_query,(level["id"], ))
            timings = cursor.fetchall()
            result_obj["level_timings"] = timings
            result.append(result_obj)
        logger.info('Exited from the LevelStores Method')
        return jsonify({"status":"success","response":result})

    def post(self):
        #inputs = LevelTimingsApiInputs(request)
        #if not inputs.validate():
        #    return jsonify(success=False, errors=inputs.errors)

        logger = logging.getLogger("Add new factor in LevelStores")
        logger.info("Entered into LevelStores post Method")
        try:
            level_name=request.json["level_name"]
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)

        insertQuery = """ INSERT into levels(level_name)value(%s) """
        cursor.execute(insertQuery, (level_name, ))
        g.appdb.commit()

        logger.info('Exited from LevelTimings post method')
        return jsonify({"status":"success", "response":level_name})

    def put(self):
        logger = logging.getLogger("LevelStores")
        logger.info('Entered into LevelStores Update method')

        try:
            store_update = request.json
            level_id = request.json["level_id"]
            cursor = g.appdb.cursor()
        except:
            logger.error('Either connection problem or unable to get url parameters', exc_info=True)
        verifyQuery = """ SELECT * from store_profiles sp where sp.level_id = %s """
        cursor.execute(verifyQuery, (level_id,))
        rv = cursor.fetchall()
        if len(rv)==0:
            deleteQuery=""" DELETE from level_timings where level_id = %s """
            cursor.execute(deleteQuery, (level_id, ))
            delete_query = """ DELETE from levels where id = %s """
            cursor.execute(delete_query, (level_id, ))
            g.appdb.commit()
            logger.info('Exited from LevelStores PUT Method')
            return jsonify({"status":"success", "response":level_id})
        else:
            raise ValueError('A very specific bad thing happened')

class AddTimeSlots(Resource):
    def get(self):
        logger = logging.getLogger("AddTimeSlots")
        logger.info('Entered into AddTimeSlots get  method')
        try:
            cursor = g.appdb.cursor()
            level_id = str(request.args.get("level_id"))
        except:
            logger.error('Database connection or url parameters error', exc_info=True)
        query =""" SELECT act.id as time_id, act.time_range as time_slot from available_category_times act
        where act.available_category_id = 7 and act.id not in
        (select available_category_times_id from level_timings where level_id = %s) """
        cursor.execute(query, (level_id,))
        rv = cursor.fetchall()
        logger.info('Exited from the AddTimeSlots Method')
        return jsonify({"status":"success","response":rv})

    def put(self):
        logger = logging.getLogger("AddTimeSlots")
        logger.info('Entered into AddTimeSlots Update method')

        try:
            level_id= request.json["level_id"]
            times_id= request.json["times_id"]
            level_time_id = request.json["level_time_id"]
            cursor = g.appdb.cursor()
        except:
            logger.error('Either connection problem or unable to get url parameters', exc_info=True)

        storeQuery = """ SELECT * from store_profiles where level_id = %s """
        cursor.execute(storeQuery, (level_id,))
        profiles = cursor.fetchall()
        if len(profiles)>0:
            timingsQuery  = """ SELECT * from level_timings lt where lt.level_id = %s """
            cursor.execute(timingsQuery, (level_id,))
            times = cursor.fetchall()
            if len(times)==1:
                raise ValueError('A very specific bad thing happened')
            else:
                deleteQuery = """ DELETE from level_timings where id=%s """
                cursor.execute(deleteQuery, (level_time_id,))
                g.appdb.commit()
        else:
            deleteQuery = """ DELETE from level_timings where id=%s """
            cursor.execute(deleteQuery, (level_time_id,))
            g.appdb.commit()
        logger.info('Exited from AddTimeSlots PUT Method')
        return jsonify({"status":"success", "response":level_time_id})

    def post(self):
        logger = logging.getLogger("AddTimeSlots POST Method")
        logger.info('Entered into AddTimeSlots Update method')
        try:
            level_id = request.json["level_id"]
            times_id  = request.json["times_id"]
            cursor = g.appdb.cursor()
        except:
            logger.error('Either connection problem or unable to get url parameters', exc_info=True)

        query = """ INSERT INTO `level_timings` (`available_category_times_id`,`level_id`) VALUES(%s, %s) """
        cursor.execute(query, (level_id, times_id))
        g.appdb.commit()

        logger.info('Exited from AddTimeSlots  post method')
        return jsonify({"status":"success", "response":level_id })
