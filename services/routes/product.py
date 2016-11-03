  # -*- coding: utf-8 -*-
from __future__ import division
from flask_restful import reqparse
from flask_restful import Resource
from flask import  jsonify, abort, make_response, request, g

from time import localtime, strftime
from datetime import date
from datetime import datetime
import time
import calendar
import MySQLdb
import datetime as DT
import json
import logging

from flask_inputs import Inputs
from wtforms.validators import DataRequired

from flask_inputs.validators import JsonSchema
from jsonschema import validate


ProductSoldSchema = {
    'type': 'array',
    'properties': {
        'store_id' : {'type': 'integer'},
        'id' : {'type': 'integer'},
        'sold_date' : {'type': 'string'},
        'start_hour' : {'type': 'string'},
        'end_hour' : {'type': 'string'},
        'no_of_units' : {'type': 'integer'},
        'day_of_the_week' : {'type': 'string'},

    },
    "required": ["store_id","id","sold_date","start_hour","end_hour","no_of_units","day_of_the_week"]
}


ProductFinishedSchema = {
    'type': 'object',
    'properties': {
        'product_id' : {'type': 'integer'},
        'store_id' : {'type': 'integer'},
        'waste_reported_date' : {'type': 'string'},
        'no_of_units' : {'type': 'string'},
        'unit_type' : {'type': 'string'},
        'product_availability_id' : {'type': 'integer'},
        'status' : {'type': 'string'}
    },
    "required": ["product_id","store_id","waste_reported_date","no_of_units","unit_type","product_availability_id","available_category_id","status"]
}

TemparatureProductsSchema = {
    'type': 'object',
    'properties': {
        'store_id' : {'type': 'integer'},
        'product_id' : {'type': 'integer'},
        'availability_id' : {'type': 'integer'},
        'availability_category_times_id' : {'type': 'integer'},
        'time' : {'type': 'string'},
        'temperature' : {'type': 'integer'},
        'initials' : {'type': 'string'},
        'status' : {'type': 'string'},
        'date' : {'type': 'string'}
    },
    "required": ["store_id","product_id","availability_id","availability_category_times_id","time","temperature","initials","status", "date"]
}



class ProductSoldApiInputs(Inputs):
    json = [JsonSchema(schema=ProductSoldSchema)]


class ProductSold(Resource):
    def post(self):
        logger = logging.getLogger("Products sold")
        logger.info('Entered into Products Sold  post method')

        try:
            products = request.json
            cursor = g.appdb.cursor()
        except:
            logger.error('Either connection problem or unable to get url parameters', exc_info=True)
        for value in products:
            upc=value["upc"]
            #Get Product Based on UPC
            productQuery=""" select id,name from product where upc=%s """
            cursor.execute(productQuery,(upc,))
            rv = cursor.fetchone()
            #Just Keep the Store ID the Same.
            query = """INSERT INTO product_sold(`store_id`,`product_id`,`sold_date`,
            `start_hour`,`end_hour`,`no_of_units`,`day_of_the_week`)VALUES(%s, %s, %s, %s, %s, %s, %s)"""
            cursor.execute(query, (value["store_id"], rv["id"], value["sold_date"],
            value["start_hour"], value["end_hour"], value["no_of_units"], value["day_of_the_week"]))
            g.appdb.commit()
            logger.info('Exited from Products Sold  post method')
        return jsonify({"status":"success", "response":{"count":len(products)}})

class ProductReportInputs(Inputs):
    args = {
        'storeid': [DataRequired(message='Store ID Required')],
        'product_type': [DataRequired(message='Product Type Required')],
        'start_date': [DataRequired(message='Start Date Required')],
        'end_date': [DataRequired(message='End Date Required')]
    }

class ProductReports(Resource):
    def get(self):
        logger = logging.getLogger("Product Reports get")
        logger.info('Entered into Product Reports get  method')
        try:
            inputs = ProductReportInputs(request)
            if not inputs.validate():
                return jsonify(success=False, errors=inputs.errors)

            json = request.query_string
            cursor = g.appdb.cursor()
            storeid=request.args.get("storeid")
            product_type=request.args.get("product_type")
            start_date = request.args.get("start_date")
            end_date = request.args.get("end_date")
        except:
            logger.error('Database connection or url parameters error', exc_info=True)
        if product_type in ["Finished Goods", "Ingredients"]:
            product_query = """ SELECT p.id as product_id, p.name as product_name, p.unit_type as unit_type from product p
            left outer join product_type pt on pt.id = p.product_type_id
            where pt.type = %s """
        elif product_type == "perishableGoods":
            product_query = """ SELECT p.id as product_id, p.name as product_name, p.unit_type as unit_type from product p
            left outer join product_type pt on pt.id = p.product_type_id
            where pt.type = %s and p.product_parent_id is not null"""
        else:
            product_query = """ SELECT p.id as product_id, p.name as product_name, p.unit_type as unit_type from product p
            left outer join product_type pt on pt.id = p.product_type_id
            where pt.type = %s and p.product_parent_id is not null"""
        cursor.execute(product_query,(product_type,))
        products = cursor.fetchall()
        result = []
        for product in products:
            product_id = product["product_id"]
            product_name = product["product_name"]
            previous_cost_query = """(SELECT CAST(item_cost AS CHAR) AS item_cost, product_id, effective_date_from
            FROM product_cost_history where effective_date_from <= %s
            and product_id=%s order by effective_date_from desc limit 1)
            UNION ALL
            (select CAST(p.product_cost AS CHAR) as item_cost,p.id as product_id,'' as effective_date_from from product p where p.id=%s)"""

            cost_query = """SELECT  CAST(sum(pw.no_of_units) AS CHAR) as noOfUnits,CAST(IFNULL(ROUND(sum(pw.no_of_units) * %s,4) ,0) AS CHAR) AS amount,
                ac.category_name as category_name
            from  product_waste pw  inner join available_category ac on ac.id = pw.product_availability_id
            and pw.waste_reported_date between %s and  %s and pw.store_id = %s
            where pw.product_id = %s  group by ac.id """

            previous_dates_query = """SELECT CAST(effective_date_from AS CHAR) as his_date,
            CAST(item_cost AS CHAR) as item_cost from product_cost_history pch
            where product_id = %s and effective_date_from between %s
            and %s order by effective_date_from ASC """
            cursor.execute(previous_dates_query, (product_id, start_date, end_date))
            history_dates = cursor.fetchall()
            count = 0
            costs_obj = []
            if len(history_dates)>0:
                for i in range(len(history_dates)+1):
                    if i == 0:
                        if  history_dates[i]["his_date"]== start_date:
                            item_cost = history_dates[i]["item_cost"]
                        else:
                            cursor.execute(previous_cost_query,(start_date,product_id,product_id))
                            previ_cost = cursor.fetchall()
                            item_cost = previ_cost[0]["item_cost"]
                        cost_date = start_date
                        to_date = history_dates[i]["his_date"]
                        split_date = to_date.split('-')
                        last_date = DT.date(int(split_date[0]),int(split_date[1]),int(split_date[2]))
                        prev_date = last_date - DT.timedelta(days=1)
                        to_date  = str(prev_date)
                    elif i==len(history_dates) and history_dates[i-1]!=end_date :
                        cost_date = history_dates[i-1]["his_date"]
                        to_date  = end_date
                        item_cost = history_dates[i-1]["item_cost"]
                    elif i==len(history_dates) and history_dates[i-1]==end_date :
                        cost_date = end_date
                        to_date  = end_date
                        item_cost = history_dates[i-1]["item_cost"]
                    else:
                        cost_date = history_dates[i-1]["his_date"]
                        to_date = history_dates[i]["his_date"]
                        split_date = to_date.split('-')
                        last_date = DT.date(int(split_date[0]),int(split_date[1]),int(split_date[2]))
                        prev_date = last_date - DT.timedelta(days=1)
                        to_date  = str(prev_date)
                        item_cost = history_dates[i]["item_cost"]
                    cursor.execute(cost_query,(item_cost,cost_date,to_date,storeid,product_id))
                    costs_sum = cursor.fetchall()

                    for data in costs_sum:
                        product_obj = {}
                        product_obj["product_id"] = product_id;
                        product_obj["name"] = product_name;
                        product_obj["unit_type"] = product["unit_type"]
                        product_obj["start_date"]=cost_date;
                        product_obj["end_date"]=to_date;
                        product_obj["category"]=data["category_name"];
                        product_obj["productwastetotalcost"]=data["amount"];
                        product_obj["productwastecount"]=data["noOfUnits"];
                        result.append(product_obj)
            else:
                cursor.execute(previous_cost_query,(start_date,product_id,product_id))
                previ_cost = cursor.fetchall()
                item_cost = float(previ_cost[0]["item_cost"])
                if start_date==end_date:
                    cursor.execute(cost_query,(item_cost,start_date,end_date,storeid,product_id))
                    costs_sum = cursor.fetchall()
                else:
                    cursor.execute(cost_query,(item_cost,start_date,end_date,storeid,product_id))
                    costs_sum = cursor.fetchall()

                for data in costs_sum:
                    product_obj = {}
                    product_obj["product_id"] = product_id;
                    product_obj["name"] = product_name;
                    product_obj["unit_type"] = product["unit_type"]
                    product_obj["start_date"]=start_date;
                    product_obj["end_date"]=end_date;
                    product_obj["category"]=data["category_name"];
                    product_obj["productwastetotalcost"]=data["amount"];
                    product_obj["productwastecount"]=data["noOfUnits"];
                    result.append(product_obj)
        result_obj = {}
        final_result = []
        for value in result:
            if value["category"] not in result_obj:
                result_obj[value["category"]] = [value]
            else:
                result_obj[value["category"]].append(value)
        for key in result_obj:
            final_result.append({"category":key, "products":result_obj[key]})
        logger.info('Exited from the Products Reports get  Method')
        return jsonify({"status":"success","response":final_result})

class ProductIngredientsInputs(Inputs):
    args = {
        'storeid': [DataRequired(message='Store ID Required')],
        'waste_reported_date': [DataRequired(message='Waste Reported Date Required')],
        'category_name': [DataRequired(message='Category Name Required')],
        'product_type': [DataRequired(message='Product Type Required')]
    }

class ProductIngredients(Resource):
    def get(self):
        logger = logging.getLogger("ProductIngredients get method")
        logger.info('Entered into ProductIngredients get method')
        try:
            inputs = ProductIngredientsInputs(request)
            if not inputs.validate():
                return jsonify(success=False, errors=inputs.errors)

            json = request.query_string
            cursor = g.appdb.cursor()
            storeid=request.args.get("storeid")
            waste_reported_date = request.args.get("waste_reported_date")
            category_name = request.args.get("category_name")
            product_type = request.args.get("product_type")
        except:
            logger.error('DB connection or url parameters error', exc_info=True)
        query = """ SELECT  p.id AS product_id, p.name AS itemName, ac.id AS product_availability_id,
        pw.id AS waste_id, CAST(pw.no_of_units AS CHAR) AS no_of_units, p.unit_type,pw.status
        FROM product p
        INNER JOIN product_availability pa ON p.id=pa.product_id
        INNER JOIN product_type pt ON p.`product_type_id`=pt.`id`
        INNER JOIN  available_category ac ON ac.id=pa.`availability_id`
        LEFT OUTER JOIN product_waste pw ON pw.`product_availability_id`=ac.`id`
        AND pw.`product_id`= p.id AND pw.`store_id`= %s AND waste_reported_date=%s
        WHERE ac.`category_name`= %s AND pt.`type`= %s """
        cursor.execute(query,(storeid,waste_reported_date,category_name,product_type))
        rv = cursor.fetchall()

        if len(rv)==0:
            logger.error('Returned an empty list', exc_info=True)
            return jsonify({"status":"success","response":[]})

        result = []
        for value in rv:
            obj = {}
            obj["product_id"] = value["product_id"]
            obj["itemName"] = value["itemName"]
            obj["product_availability_id"] = value["product_availability_id"]
            obj["waste_id"] = value["waste_id"]
            obj["no_of_units"] = value["no_of_units"]
            obj["unit_type"] = value["unit_type"]
            obj["status"] = value["status"]
            if value["unit_type"]=='oz':
                if obj["no_of_units"]:
                    intUnits = int(float(obj["no_of_units"]))
                    obj["no_of_pounds"] = int(intUnits/16)
                    obj["no_of_units"]= round(float(obj["no_of_units"])%16,4)
            result.append(obj)

        logger.info('Exited from ProductIngredients get method')
        return jsonify({"status":"success","response":result})

class ProductFinishedInputs(Inputs):
    args = {
        'category_name': [DataRequired(message='Category Name Required')],
        'storeid': [DataRequired(message='Store ID Required')],
        'waste_reported_date': [DataRequired(message='Waste Reported Date Required')]
        }

class ProductFinishedApiInputs(Inputs):
    json = [JsonSchema(schema=ProductFinishedSchema)]


class ProductFinished(Resource):
    def get(self):
        logger = logging.getLogger("ProductFinished get")
        logger.info('Entered into ProductFinished  get method')

        try:
            inputs = ProductFinishedInputs(request)
            if not inputs.validate():
                return jsonify(success=False, errors=inputs.errors)

            json = request.query_string
            cursor = g.appdb.cursor()
            category=request.args.get("category_name")
            storeid=request.args.get("storeid")
            waste_date=request.args.get("waste_reported_date")
        except:
            logger.error('DB connection or url parameters error', exc_info=True)
        waste_query = """ SELECT act.id as category_time_id, act.available_category_id as available_category_id,
                    act.time_range as time_range, cast(act.report_before as char) as report_before,
                    pw.product_id as product_id,pw.id as waste_id, CAST(ROUND(pw.no_of_units) AS CHAR) as no_of_units,pw.status
                    from available_category_times act
                    inner join available_category ac on act.`available_category_id` = ac.`id`
                    left outer join product_waste pw on pw.`available_category_id` = act.id and pw.`product_availability_id` = ac.`id`
                    and pw.`product_id` = %s and pw.`store_id` = %s and waste_reported_date = %s
                    where ac.`category_name` = %s """
        query = """ SELECT  p.id as product_id, p.name, ac.id from product p
              inner join product_availability pa on p.id = pa.product_id
              inner join product_type pt on p.`product_type_id` = pt.`id`
              inner join available_category ac on ac.id = pa.`availability_id`
              where ac.`category_name` = %s and pt.`type` = %s """
        cursor.execute(query,(request.args.get("category_name"), request.args.get("product_type")))
        rv = cursor.fetchall()
        result = []
        for value in rv:
            obj = {}
            productid=value["product_id"]
            cursor.execute(waste_query,(productid, storeid, waste_date, category))
            subtimes = cursor.fetchall()
            obj["product_id"] = value["product_id"]
            obj["itemName"] = value["name"]
            obj["product_availability_id"] = value["id"]
            obj["timesanddata"] = subtimes
            result.append(obj)
        logger.info('Exited from ProductFinished  get method')
        return jsonify({"status":"success","response":result})

    def post(self):
            logger = logging.getLogger("ProductFinished post")
            logger.info('Entered into ProductFinished  post method')

            try:
                productWaste = request.json
                cursor = g.appdb.cursor()
                current_time = strftime("%Y-%m-%d %H:%M:%S", localtime())
                current_date = strftime("%Y-%m-%d", localtime())
                day_of_week = calendar.day_name[date.today().weekday()]
            except:
                logger.error('Not properly caluclating the date and time', exc_info=True)

            for json in productWaste:
                if json['id']>0:
                    if float(json["no_of_units"])==0:
                        deleteQuery = """ DELETE from product_waste where id= %s """
                        cursor.execute(deleteQuery,(json['id'],))
                        g.appdb.commit()
                    else:
                        updatequery = """ UPDATE product_waste set no_of_units=%s, status=%s where id= %s """
                        cursor.execute(updatequery,(str(json["no_of_units"]),json["status"],json["id"]))
                        g.appdb.commit()
                else:
                    availableCategoryID=json['available_category_id']
                    query = """ INSERT INTO product_waste(`product_id`, `store_id`, `waste_reported_date`, `time`,
                          `no_of_units`, `unit_type`, `dayoftheweek`, `product_availability_id`,
                          `available_category_id`, `status`) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s) """
                    cursor.execute(query,(json["product_id"], json["store_id"], json["waste_reported_date"], current_time,
                    json['no_of_units'], json['unit_type'], day_of_week,
                    json['product_availability_id'], json['available_category_id'], json['status']))
                    g.appdb.commit()
            logger.info('Exited from the ProductFinished post method')
            return jsonify({"status":"success","response":productWaste});

class RollerFinishedGoods(Resource):
    def get(self):
        logger = logging.getLogger("ProductFinished get")
        logger.info('Entered into ProductFinished  get method')

        try:
            inputs = ProductFinishedInputs(request)
            if not inputs.validate():
                return jsonify(success=False, errors=inputs.errors)

            json = request.query_string
            cursor = g.appdb.cursor()
            category=request.args.get("category_name")
            storeid=request.args.get("storeid")
            waste_date=request.args.get("waste_reported_date")
            level_id = request.args.get("level_id")
        except:
            logger.error('DB connection or url parameters error', exc_info=True)
        waste_query = """ SELECT act.id as category_time_id, act.available_category_id as available_category_id,
                    act.time_range as time_range, cast(act.report_before as char) as report_before,
                    pw.product_id as product_id,pw.id as waste_id, CAST(ROUND(pw.no_of_units) AS CHAR) as no_of_units,pw.status
                    from available_category_times act
                    inner join available_category ac on act.`available_category_id`=ac.`id`
                    left outer join product_waste pw on pw.`available_category_id`=act.id and pw.`product_availability_id`=ac.`id`
                    and pw.`product_id`= %s and pw.`store_id`= %s and waste_reported_date= %s
		            inner join level_timings lt on lt.available_category_times_id = act.id
                    where ac.`category_name`= %s and lt.level_id= %s
                    order by act.id asc """
        query = """ SELECT  p.id as product_id, p.name, ac.id from product p
              inner join product_availability pa on p.id=pa.product_id
              inner join product_type pt on p.`product_type_id`=pt.`id`
              inner join available_category ac on ac.id=pa.`availability_id`
              where ac.`category_name`= %s and pt.`type`= %s """
        cursor.execute(query,(request.args.get("category_name"), request.args.get("product_type")))
        rv = cursor.fetchall()
        result = []
        for value in rv:
            obj = {}
            productid=value["product_id"]
            cursor.execute(waste_query,(productid,storeid,waste_date,category,level_id))
            subtimes = cursor.fetchall()
            obj["product_id"] = value["product_id"]
            obj["itemName"] = value["name"]
            obj["product_availability_id"] = value["id"]
            obj["timesanddata"] = subtimes
            result.append(obj)
        logger.info('Exited from ProductFinished  get method')
        return jsonify({"status":"success","response":result})


class ProductSubTimeInputs(Inputs):
    args = {
        'category_name': [DataRequired(message='Category Name Required')]
        }

class ProductSubTime(Resource):
    def get(self):
        logger = logging.getLogger("ProductFinished get")
        logger.info('Entered into ProductFinished  get method')
        try:
            inputs = ProductSubTimeInputs(request)
            if not inputs.validate():
                return jsonify(success=False, errors=inputs.errors)

            cursor = g.appdb.cursor()
            category=request.args.get("category_name")
        except:
            logger.error('DB connection or url parameters error', exc_info=True)
        query = """ SELECT act.id as category_time_id, act.available_category_id as category_id,
              act.time_range as time_range, cast(act.report_before as char) as report_before
              from available_category_times act
              inner join available_category ac on act.`available_category_id`=ac.`id`
              where ac.`category_name`= %s """
        cursor.execute(query, (category, ))
        rv = cursor.fetchall()
        logger.info('Exited from ProductFinished get method')
        return jsonify({"status":"success","response":rv})

class RollerSubTime(Resource):
    def get(self):
        logger = logging.getLogger("ProductFinished get")
        logger.info('Entered into ProductFinished  get method')
        try:
            cursor = g.appdb.cursor()
            category=request.args.get("category_name")
            level_id = request.args.get("level_id")
        except:
            logger.error('DB connection or url parameters error', exc_info=True)
        query = """ SELECT act.id as category_time_id, act.available_category_id as category_id,
              act.time_range as time_range, cast(act.report_before as char) as report_before
              from available_category_times act
              inner join available_category ac on act.`available_category_id`=ac.`id`
		      inner join level_timings lt on lt.available_category_times_id = act.id
              where ac.`category_name`= %s and lt.level_id= %s
              order by act.id asc """
        cursor.execute(query, (category, level_id))
        rv = cursor.fetchall()
        logger.info('Exited from ProductFinished get method')
        return jsonify({"status":"success","response":rv})

class LevelId(Resource):
    def get(self):
        logger = logging.getLogger("LevelId get")
        logger.info('Entered into LevelId get method')
        try:
            cursor = g.appdb.cursor()
            store_id = request.args.get("store_id")
            profile_name = request.args.get("profile_name")
        except:
            logger.error('DB connection or url parameters error', exc_info=True)
        query = """ SELECT level_id FROM store_profiles
              inner join profiles on profiles.id = store_profiles.profile_id
              where store_id = %s and profile_name = "Roller Grills" """
        cursor.execute(query, (store_id, ))
        rv = cursor.fetchall()
        logger.info('Exited from LevelId get method')
        return jsonify({"status":"success","response":rv})

class RollerLevels(Resource):
    def get(self):
        logger = logging.getLogger("RollerLevels get")
        logger.info('Entered into RollerLevels  get method')
        try:
            cursor = g.appdb.cursor()
        except:
            logger.error('DB connection or url parameters error', exc_info=True)
        query = """ SELECT l.id AS level_id, l.level_name AS level_name
              FROM levels l
              WHERE l.id in (SELECT level_id FROM level_timings) """
        cursor.execute(query)
        rv = cursor.fetchall()
        logger.info('Exited from RollerLevels get method')
        return jsonify({"status":"success","response":rv})

    def put(self):
        logger = logging.getLogger("RollerLevels PUT")
        logger.info('Entered into RollerLevels Update method')

        try:
            store_id= request.json["store_id"]
            level_id= request.json["level_id"]
            cursor = g.appdb.cursor()
        except:
            logger.error('Either connection problem or unable to get url parameters', exc_info=True)
        updateQuery = """ UPDATE `7eleven`.`store_profiles`SET `level_id` = %s
                    WHERE `store_id` = %s and `profile_id`=2 """
        cursor.execute(updateQuery, (level_id, store_id))
        g.appdb.commit()

        logger.info('Exited from RollerLevels PUT Method')
        return jsonify({"status":"success","response":level_id})


class TemparatureProductsApiInputs(Inputs):
    json = [JsonSchema(schema=TemparatureProductsSchema)]

class TemparatureProductsInputs(Inputs):
    args = {
        'waste_reported_date': [DataRequired(message='Wast Reported Date Required')],
        'store_id': [DataRequired(message='Store ID Required')],
        'category_name': [DataRequired(message='Category Name Required')]
    }

class TemparatureProducts(Resource):
    def get(self):
        logger = logging.getLogger("TemparatureProducts get")
        logger.info('Entered into TemparatureProducts  get method')
        try:
            inputs = TemparatureProductsInputs(request)
            if not inputs.validate():
                return jsonify(success=False, errors=inputs.errors)

            json = request.query_string
            cursor = g.appdb.cursor()
            waste_reported_date = request.args.get("waste_reported_date")
            storeid = request.args.get("store_id")
            category_name = request.args.get("category_name")
        except:
            logger.error('DB connection or url parameters error', exc_info=True)
        query = """ SELECT  p.id as product_id, p.name as itemName, ac.id as product_availability_id,CAST(prt.time AS CHAR)as temp_time,
              CAST(prt.temperature AS CHAR) as temperature, prt.initials, prt.status, prt.id as temp_id  from product p
              inner join product_availability pa on p.id=pa.product_id
              inner join product_type pt on p.`product_type_id`=pt.`id`
              inner join available_category ac on ac.id=pa.`availability_id`
              left outer join product_temperature prt on prt.product_id = p.id and
              prt.availability_id = ac.id and prt.date =%s AND prt.store_id = %s
              where ac.`category_name`= %s """
        cursor.execute(query, (waste_reported_date, storeid, category_name))
        rv = cursor.fetchall()
        logger.info('Exited from the TemparatureProducts get method')
        return jsonify({"status":"success","response":rv})

    def post(self):
        logger = logging.getLogger("TemparatureProducts post")
        logger.info('Entered into TemparatureProducts  post method')

        try:
            equipTemp = request.json
            cursor = g.appdb.cursor()
            current_time = strftime("%Y-%m-%d %H:%M:%S", localtime())
            day_of_week = calendar.day_name[date.today().weekday()]
        except:
            logger.error('Either db connection or date calculation error', exc_info=True)

        for value in equipTemp:
            if value['temp_id']>0:
                if value['temperature']=='empty':
                    query = """ DELETE from product_temperature where id = %s """
                    cursor.execute(query,(value['temp_id'],))
                    g.appdb.commit()
                else:
                    updatequery = """ UPDATE product_temperature pt set pt.time = %s, pt.temperature = %s, pt.initials= %s, pt.status= %s where pt.id = %s """
                    cursor.execute(updatequery,(str(value["temp_time"]),value["temperature"],value["initials"], value["status"], value["temp_id"]))
                    g.appdb.commit()
            else:
                query = """ INSERT INTO product_temperature(`store_id`, `product_id`, `availability_id`, `availability_category_times_id`, `time`, `temperature`, `initials`, `status`, `date`) VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s) """
                cursor.execute(query, (value["store_id"], value["product_id"], value["product_availability_id"], value["availability_category_times_id"],
                value["temp_time"], value["temperature"], value["initials"], value["status"], value["waste_reported_date"]))
                g.appdb.commit()

        logger.info('Exited from TemparatureProducts post method')
        return jsonify({"status":"success", "response":equipTemp})

class AdminStoresList(Resource):
    def get(self):
        logger = logging.getLogger("AdminStoresList get")
        logger.info('Entered into AdminStoresList  get method')
        try:
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)
        query = """ SELECT distinct(store_id) FROM store_profiles """
        cursor.execute(query)
        rv = cursor.fetchall()
        logger.info('Exited from AdminStoresList Get method')
        return jsonify({"status":"success", "response":rv})

class BuildtoWasteInputs(Inputs):
    args = {
        'report_date': [DataRequired(message='Report Date Required')],
        'store_id': [DataRequired(message='Store ID Required')],
        'category_name': [DataRequired(message='Category Name Required')],
        'product_type': [DataRequired(message='Product Type Required')],
        'profile_id': [DataRequired(message='Profile ID Required')]
    }

class BuildtoWaste(Resource):
    def get(self):
        logger = logging.getLogger("Anticipated Sales")
        logger.info('Entered into Build To Waste method')
        try:
            inputs = BuildtoWasteInputs(request)
            if not inputs.validate():
                return jsonify(success=False, errors=inputs.errors)

            cursor = g.appdb.cursor()
            today = request.args.get("report_date")
            store_id = request.args.get("store_id")
            category_name = str(request.args.get("category_name"))
            product_type = str(request.args.get("product_type"))
            profile_id  = request.args.get("profile_id")
            profile_name = request.args.get("profile_name")
            year = today.split('-')[0]
            month = today.split('-')[1]
            day  = today.split('-')[2]
            todaysdate = DT.date(int(year),int(month),int(day))
            dayOne = todaysdate - DT.timedelta(days=7)
            dayTwo = dayOne - DT.timedelta(days=7)
            dayThree = dayTwo - DT.timedelta(days=7)
            dayFour = dayThree - DT.timedelta(days=7)
        except:
            logger.error('DB connection or variable caluclating error', exc_info=True)
        factor_value_query = """ SELECT bs.store_id,IFNULL(bf.factor_value,100)as factor_value from buildto_stores bs
                            inner join buildto_factor bf on bf.id = bs.factor_id and bf.profile_id = %s
                            where bs.store_id = %s"""
        cursor.execute(factor_value_query,(profile_id,store_id))
        factor=cursor.fetchall()
        if len(factor)>0:
            factor_value=int(factor[0]['factor_value'])
        else:
            factor_value=100
        sub_query = """ SELECT act.time_range,
                  CAST(truncate((IFNULL(%s/100,1)*(sum(ps.no_of_units)/4)) + 0.875, 0) AS CHAR)  as average
                  FROM available_category_times act
                  left outer join product_sold ps on ps.start_hour = act.start_time and ps.sold_date
                  in (%s, %s, %s,%s)
                  and ps.product_id = %s and ps.store_id = %s
                  left outer join product_availability pa on pa.product_id = ps.product_id
                  and pa.availability_id = act.available_category_id
                  left outer join available_category ac on ac.id = act.available_category_id
                  where ac.category_name = %s group by act.id """

        query = """ SELECT  p.id as product_id, p.name from product p
              inner join product_availability pa on p.id = pa.product_id
              inner join product_type pt on p.`product_type_id` = pt.`id`
              inner join available_category ac on ac.id = pa.`availability_id`
              where ac.`category_name`= %s and pt.`id`= %s and p. product_parent_id is null """
        cursor.execute(query, (category_name, product_type))
        rv = cursor.fetchall()
        result = []
        for value in rv:
            obj = {}
            product_id = value["product_id"]
            cursor.execute(sub_query, (factor_value, str(dayOne), str(dayTwo), str(dayThree), str(dayFour), product_id, store_id, category_name))
            timesanddata = cursor.fetchall()
            obj["product_id"] = product_id
            obj["product_name"] = value["name"]
            obj["category_name"] = category_name
            obj["data"] = timesanddata
            result.append(obj)
        logger.info('Exited from Build To Waste method')
        return {"status":"success","response":result}

class RollerGrillTemparatureProductsInputs(Inputs):
    args = {
        'waste_reported_date': [DataRequired(message='Waste Report Date Required')],
        'store_id': [DataRequired(message='Store ID Required')],
        'available_category_times': [DataRequired(message='Availability Category Times Required')]
    }

class RollerGrillTemparatureProducts(Resource):
    def get(self):
        logger = logging.getLogger("TemparatureProducts get")
        logger.info('Entered into TemparatureProducts  get method')
        try:
            inputs = RollerGrillTemparatureProductsInputs(request)
            if not inputs.validate():
                return jsonify(success=False, errors=inputs.errors)

            json = request.query_string
            cursor = g.appdb.cursor()
            waste_reported_date = request.args.get("waste_reported_date")
            storeid = request.args.get("store_id")
            category_name = request.args.get("category_name")
            product_type = request.args.get("product_type")
            available_category_times = str(request.args.get("available_category_times"))
        except:
            logger.error('DB connection or url parameters error', exc_info=True)
        query = """ SELECT  p.id as product_id, p.name as itemName,prt.availability_category_times_id, ac.id as product_availability_id,CAST(prt.time AS CHAR)as temp_time,
        CAST(prt.temperature AS CHAR) as temperature, prt.initials, prt.status, prt.id as temp_id  from product p
        inner join product_availability pa on p.id = pa.product_id
        inner join product_type pt on p.`product_type_id` = pt.`id`
        inner join available_category ac on ac.id = pa.`availability_id`
        inner join available_category_times act on act.available_category_id = ac.id
        left outer join product_temperature prt on prt.product_id = p.id and
        prt.availability_id = ac.id and prt.availability_category_times_id = act.id
        and prt.date = %s AND prt.store_id = %s
        where ac.`category_name`= %s and act.id = %s and pt.type = %s """
        cursor.execute(query,(waste_reported_date, storeid, category_name, available_category_times, product_type))
        rv = cursor.fetchall()
        logger.info('Exited from the TemparatureProducts get method')
        return jsonify({"status":"success","response":rv})

class ThresholdReportRollerGrillInputs(Inputs):
    args = {
        'store_id': [DataRequired(message='Store ID Required')],
        'report_date': [DataRequired(message='Report Date Required')]
    }

class ThresholdReportRollerGrill(Resource):
    def get(self):
        logger = logging.getLogger("ThresholdReportRollerGrill get")
        logger.info('Entered into ThresholdReportRollerGrill  get method')
        try:
            inputs = ThresholdReportRollerGrillInputs(request)
            if not inputs.validate():
                return jsonify(success=False, errors=inputs.errors)
            json = request.query_string
            cursor = g.appdb.cursor()
            store_id = request.args.get("store_id")
            today = request.args.get("report_date")
            year = today.split('-')[0]
            month = today.split('-')[1]
            day  = today.split('-')[2]
            todaysdate = DT.date(int(year),int(month),int(day))
            dayOne = todaysdate - DT.timedelta(days=7)
            dayTwo = dayOne - DT.timedelta(days=7)
            dayThree = dayTwo - DT.timedelta(days=7)
            dayFour = dayThree - DT.timedelta(days=7)
        except:
            logger.error('DB connection or url parameters error', exc_info=True)
        product_query = """ SELECT id as product_id, name from product where product_type_id = 3 and product_parent_id is null """
        cursor.execute(product_query,)
        rv = cursor.fetchall()
        result = []
        for product in rv:
            result_obj = {}
            product_id = product["product_id"]
            product_name = product["name"]
            wasteSum_query = """ SELECT act.time_range, sum(pw.no_of_units)/4 as averageWaste
            FROM available_category_times act
            left join product_waste pw on act.id=pw.available_category_id
            and pw.waste_reported_date in (%s, %s, %s, %s) and pw.store_id = %s
            left join product p on pw.product_id=p.id  and p.product_parent_id = %s
            where act.available_category_id=7 group by act.id """
            cursor.execute(wasteSum_query, (str(dayOne), str(dayTwo), str(dayThree), str(dayFour), store_id, product_id))
            waste = cursor.fetchall()
            saleSum_query = """ SELECT act.time_range, sum(ps.no_of_units)/4 as averageSale
            FROM available_category_times act
            left join product_sold ps on ps.start_hour >= act.start_time  and ps.end_hour  <= act.end_time
            and sold_date in (%s, %s, %s, %s)  and ps.product_id=%s and ps.store_id = %s
            where act.available_category_id=7
            group by act.id """
            cursor.execute(saleSum_query, (str(dayOne), str(dayTwo), str(dayThree), str(dayFour), product_id, store_id))
            sale = cursor.fetchall()
            values = []
            for i in range(len(waste)):
                        if (waste[i]["averageWaste"]):
                            wasteSum = float(waste[i]["averageWaste"])
                        else:
                            wasteSum = 0
                        if (sale[i]["averageSale"]):
                            saleSum = float(sale[i]["averageSale"])
                        else:
                            saleSum = 0
                        if  (not wasteSum ==0 and  not saleSum ==0):
                            value = ((wasteSum)/(saleSum)) * 100
                        else:
                            value = 0
                        values.append({"value":str(round(value,2))})
            result_obj["product_id"] = product_id
            result_obj["name"] = product_name
            result_obj["values"] = values
            thresholdValue_query = """SELECT cast(IFNULL(tf.factor_value,100) as char) as factor_value from threshold_factor tf
            inner join threshold_stores ts on ts.threshold_id = tf.id where ts.store_id = %s """
            cursor.execute(thresholdValue_query, (store_id, ))
            thresholdValue = cursor.fetchone()
            if thresholdValue==None:
                result_obj["thresholdValue"] = 100
            else:
                result_obj["thresholdValue"] = thresholdValue["factor_value"]
            result.append(result_obj)

        logger.info('Exited from the TemparatureProducts get method')
        return jsonify({"status":"success","response":result})

class DBQAdminGetProducts(Resource):
    def get(self):
        logger = logging.getLogger("DBQAdminGetProducts get")
        logger.info('Entered into DBQAdminGetProducts get method')

        try:
            json = request.query_string
            cursor = g.appdb.cursor()
            product_type = request.args.get("product_type")

        except:
            logger.error('DB connection or url parameters error', exc_info=True)

        query = """ SELECT dbp.id AS dbq_id,dbp.product_description, dbp.product_type_id, pt.type, dbp.storage,
              dbp.size,dbp.case_qty, dbp.brand, dbp.item, dbp.dbq, dbp.max_quantity, dbp.Active_flag
              FROM 7eleven.dbq_products dbp
              inner join product_type pt on dbp.product_type_id=pt.id
              where pt.type = %s """
        cursor.execute(query,(product_type, ))
        rv = cursor.fetchall()

        logger.info('Exited from DBQAdminGetProducts get method')
        return jsonify({"status":"success","response":rv})

    def post(self):
        logger = logging.getLogger("DBQAdminGetProducts post")
        logger.info('Entered into DBQAdminGetProducts post method')

        try:
            value = request.json
            productdescription = value["productdescription"]
            product_type_id = value["product_type_id"]
            storage = value["storage"]
            size = value["size"]
            case_qty = value["case_qty"]
            brand = value["brand"]
            item = value["item"]
            dbq = value["dbq"]
            max_quantity = value['max_quantity']
            cursor = g.appdb.cursor()

        except:
            logger.error('Either db connection or date calculation error', exc_info=True)

        query = """ INSERT INTO `dbq_products` (product_description, product_type_id, storage, size, case_qty, brand, item, dbq, max_quantity) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s) """
        cursor.execute(query,(productdescription, product_type_id, storage, size, case_qty, brand, item, dbq, max_quantity))
        g.appdb.commit()
        newID = cursor.lastrowid
        logger.info('Exited from DBQAdminGetProducts post method')
        return jsonify({"status":"inserted", "response":newID})

    def delete(self):
        logger = logging.getLogger("DBQAdminGetProducts delete")
        logger.info('Entered into DBQAdminGetProducts delete method')

        try:
            dbq_id = request.json['dbq_id']
            cursor = g.appdb.cursor()

        except:
            logger.error('Either db connection or date calculation error', exc_info=True)

        deleteOrders = """ DELETE from dbq_orders where `dbqp_id` = %s """
        cursor.execute(deleteOrders, (dbq_id, ))
        g.appdb.commit()
        delete = """ DELETE FROM `dbq_products` WHERE `id`= %s """
        cursor.execute(delete,(dbq_id, ))
        g.appdb.commit()

        logger.info('Exited from DBQAdminGetProducts delete method')
        return jsonify({"status":"deleted", "response":dbq_id})

    def put(self):
        logger = logging.getLogger("DBQAdminGetProducts post")
        logger.info('Entered into DBQAdminGetProducts post method')

        try:
            dbq_id = request.json['dbq_id']
            product_description = request.json['product_description']
            product_type_id = request.json['product_type_id']
            storage = request.json['storage']
            size = request.json['size']
            case_qty = request.json['case_qty']
            brand = request.json['brand']
            item = request.json['item']
            dbq = request.json['dbq']
            max_quantity = request.json['max_quantity']
            cursor = g.appdb.cursor()

        except:
            logger.error('Either db connection or date calculation error', exc_info=True)

        update = """ UPDATE `dbq_products` SET `product_description` = %s, `product_type_id` = %s,`storage` = %s,
               `size` = %s,`case_qty` = %s,`brand` = %s,`item` = %s,`dbq` = %s,`max_quantity` = %s WHERE `id` = %s """
        cursor.execute(update, (product_description, product_type_id, storage, size, case_qty, brand, item, dbq, max_quantity, dbq_id))
        g.appdb.commit()

        logger.info('Exited from DBQAdminGetProducts post method')
        return jsonify({"status":"updated", "response":dbq_id})

    def patch(self):
        logger = logging.getLogger("DBQAdminEditProducts post")
        logger.info('Entered into DBQAdminEditProducts post method')

        try:
            flag = request.json["Active_flag"]
            dbq_id = request.json["dbq_id"]
            cursor = g.appdb.cursor()

        except:
            logger.error('Either db connection or date calculation error', exc_info=True)

        update = """ UPDATE dbq_products SET Active_flag = %s  WHERE id = %s """
        cursor.execute(update, (flag,dbq_id ))
        g.appdb.commit()

        logger.info('Exited from DBQAdminEditProducts post method')
        return jsonify({"status":"success", "response":dbq_id})

class DBQAdminEditProducts(Resource):
    def get(self):
        logger = logging.getLogger("DBQAdminEditProducts get")
        logger.info('Entered into DBQAdminEditProducts get method')

        try:
            json = request.query_string
            cursor = g.appdb.cursor()
            product_type= request.args.get("product_type")

        except:
            logger.error('DB connection or url parameters error', exc_info=True)

        query = """ SELECT dbq.id AS product_id, dbq.product_description AS itemName
              FROM dbq_products dbq
              INNER JOIN product_type pt ON pt.id = dbq.product_type_id
              WHERE pt.type = %s AND Active_flag = "false" """
        cursor.execute(query,(product_type,))
        rv = cursor.fetchall()

        logger.info('Exited from DBQAdminEditProducts get method')
        return jsonify({"status":"success","response":rv})

    def post(self):
        logger = logging.getLogger("DBQAdminEditProducts post")
        logger.info('Entered into DBQAdminEditProducts post method')

        try:
            edit = request.json
            cursor = g.appdb.cursor()

        except:
            logger.error('Either db connection or date calculation error', exc_info=True)

        for each in edit:
            Id = (each["product_id"])
            query = """ UPDATE dbq_products SET Active_flag = "true"  WHERE id = %s """
            cursor.execute(query, (Id, ))
            g.appdb.commit()

        logger.info('Exited from DBQAdminEditProducts post method')
        return jsonify({"status":"success", "response":edit})

    def delete(self):

        logger = logging.getLogger(" DBQAdminEditProducts delete call ")
        logger.info("Entered into DBQAdminEditProducts delete Method")

        try:
            dbq_id=request.json['dbq_id']
            Active_flag = request.json['Active_flag']
            cursor = g.appdb.cursor()
        except:
            logger.error('DB Connection error', exc_info=True)


        updateProducts = """ UPDATE dbq_products SET Active_flag = %s WHERE id = %s """
        cursor.execute(updateProducts,(Active_flag, dbq_id))
        g.appdb.commit()

        logger.info('Exited from DBQAdminEditProducts delete method')
        return jsonify({"status":"success", "response":dbq_id})

class DBQAdminGetOrders(Resource):
    def get(self):
        logger = logging.getLogger('DBQAdminGetOrders get')
        logger.info('Entered into DBQAdminGetOrders get method')

        try:
            json = request.query_string
            cursor = g.appdb.cursor()
            product_type = request.args.get("product_type")
            store_id = request.args.get("store_id")
            date = request.args.get("date")
        except:
            logger.error('DB connection or url parameters error', exc_info=True)

        query = """ SELECT dbqo.id AS dbqo_id, dbqp.id AS dbqp_id, dbqp.product_description AS itemName,
              dbqp.size, dbqp.case_qty, CAST(dbqo.no_of_units AS CHAR) AS no_of_units,
              dbqp.max_quantity, CAST(dbqo.total AS CHAR) AS total, dbqo.status
              FROM dbq_products dbqp
              INNER JOIN product_type pt ON pt.id = dbqp.product_type_id
              LEFT OUTER JOIN dbq_orders dbqo ON dbqo.dbqp_id = dbqp.id AND dbqo.store_id = %s AND dbqo.date = %s
              WHERE pt.type = %s AND dbqp.Active_flag = "true" AND max_quantity IS NOT NULL ORDER BY dbqp.id """
        cursor.execute(query,(store_id, date, product_type))
        rv = cursor.fetchall()

        logger.info('Exited from DBQAdminGetProducts get method')
        return jsonify({"status":"success","response":rv})

    def post(self):
        logger = logging.getLogger("DBQAdminGetOrders post")
        logger.info('Entered into DBQAdminGetOrders post method')

        try:
            order = request.json
            cursor = g.appdb.cursor()
            date_time = time.strftime("%Y-%m-%d %H:%M:%S")
        except:
            logger.error('Either db connection or date calculation error', exc_info=True)

        for each in order:
            if each['id'] > 0:
                updatequery = """ UPDATE `dbq_orders`SET `no_of_units` = %s, `date_time` = %s, `status` = %s, `total` = %s WHERE `id` = %s """
                cursor.execute(updatequery, (each['no_of_units'],date_time, each['status'], each['total'], each['id']))
                g.appdb.commit()
            else:
                query = """ INSERT INTO `dbq_orders`(`dbqp_id`,`store_id`,`no_of_units`,`date`,`date_time`,`total`,`status`,`order_placed`)VALUES(%s, %s, %s, %s, %s, %s, %s, %s)"""
                cursor.execute(query, (each['dbqp_id'], each['store_id'], each['no_of_units'], each['date'],date_time, each['total'], each['status'],'NO'))
                g.appdb.commit()

        logger.info('Exited from DBQAdminGetOrders post method')
        return jsonify({"status":"success", "response":order})
