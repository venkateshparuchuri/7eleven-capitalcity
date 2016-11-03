# -*- coding: utf-8 -*-
from __future__ import division
from flask_restful import reqparse
from flask_restful import Resource
from flask import  jsonify, abort, make_response, request, g

from time import localtime, strftime
from datetime import date
from datetime import datetime
import os
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


class PullSheetAllTogether(Resource):
    def get(self):
        logger = logging.getLogger("Products sold")
        logger.info('Entered into Products Sold  post method')

        try:
            availability_category_times_id = request.args.get("availability_category_times_id")
            today = request.args.get("reported_date")
            time_range = request.args.get("category_times")
            store_id = request.args.get("store_id")
            rollerType = request.args.get("rollerType")
            role = request.args.get("role")
            year = today.split('-')[0]
            month = today.split('-')[1]
            day  = today.split('-')[2]
            todaysdate = DT.date(int(year),int(month),int(day))
            dayOne = todaysdate - DT.timedelta(days = 7)
            dayTwo = dayOne - DT.timedelta(days = 7)
            dayThree = dayTwo - DT.timedelta(days = 7)
            dayFour = dayThree - DT.timedelta(days = 7)
            cursor = g.appdb.cursor()

        except:
            logger.error('Either connection problem or unable to get url parameters', exc_info=True)

        productNamesQuery = """ SELECT p.name as product_name,p.id as product_id
                          from product p where p.product_parent_id in (SELECT p.id from product p where p.name in (%s)) """

        historicalQuery = """ SELECT IFNULL(CAST(truncate(sum(pw.no_of_units)/4 + 0.875,0) AS CHAR),0)  AS historical_waste
        from product_waste pw where   pw.waste_reported_date
        in(%s, %s, %s, %s) and pw.product_id = %s
        and pw.store_id = %s and pw.available_category_id = %s
        group by pw.product_id  """

        historyTimeQuery = """ SELECT act.id as time_id, act.time_range from available_category_times act
        inner join available_category ac on ac.id = act.available_category_id
        where ac.category_name='Roller' and
        act.start_time = (select acct.end_time from available_category_times acct where acct.id = %s) """

        anticipatedPullQuery = """ SELECT bsf.factor_value, bsf.store_id,
                             IFNULL(cast(truncate((IFNULL(bsf.factor_value/100,1)*(sum(rpos.no_of_units)/4)) + 0.875, 0) AS CHAR), 0) as average_pull
                             FROM product p
                             left outer join rg_pull_over_sheet rpos on rpos.product_id = p.id and rpos.sheet_reported_date
                             in (%s, %s, %s, %s)
                             and rpos.product_id = %s and rpos.store_id = %s
                             left outer join product_availability pa on pa.product_id = rpos.product_id
                             left outer join available_category ac on ac.id = pa.availability_id
                             left outer join
                             (select bs.store_id, bf.factor_value FROM buildto_stores bs
                             inner join buildto_factor bf on bf.id = bs.factor_id and bf.profile_id = 2
                             where bs.store_id = %s) as bsf on rpos.store_id = bsf.store_id
                             where ac.category_name = "Roller" and rpos.available_category_times_id in
                             (select acct.id from available_category_times acct where acct.parent_time_id = %s) """

        anticipatedTimeQuery = """ SELECT act.time_range from available_category_times act where act.id = %s """
        cursor.execute(productNamesQuery,(rollerType,))

        if role == 'Admin':
            pullTimesQuery = """SELECT  act.id as pull_time, act.time_range, rgps.pull_id,
                       rgps.no_of_units as pull_value, rgps.status
                       from available_category_times act
                       left outer join rg_pull_over_sheet rgps on rgps.available_category_times_id = act.id
                       AND rgps.store_id = %s and rgps.product_id = %s  and rgps.status='completed' and
                       rgps.sheet_reported_date = %s
                       where  act.parent_time_id = %s """
        else:
            pullTimesQuery = """ SELECT  act.id as pull_time, act.time_range, rgps.pull_id,
                           rgps.no_of_units as pull_value, rgps.status
                           from available_category_times act
                           left outer join rg_pull_over_sheet rgps on rgps.available_category_times_id = act.id
                           AND rgps.store_id = %s  and rgps.product_id = %s and
                           rgps.sheet_reported_date = %s
                           where  act.parent_time_id = %s """

        pullHeadTimesQuery = """ SELECT act.time_range from available_category_times act where act.parent_time_id = %s """
        productNames = cursor.fetchall()

        cursor.execute(historyTimeQuery, (availability_category_times_id, ))
        historical_slot = cursor.fetchall()
        historical_time_id  = historical_slot[0]["time_id"]
        historical_time_range =  historical_slot[0]["time_range"]
        resultList = []
        header_obj = {}
        header_obj["historical_time"] = historical_time_range
        count = 0
        for product in productNames:
            product_obj = {}
            product_id = product["product_id"]
            product_obj["product_name"] = product["product_name"]
            product_obj["product_id"] = product_id
            if time_range == '10pm-5am':
                oneDay = dayOne + DT.timedelta(days = 1)
                twoDay = dayTwo + DT.timedelta(days = 1)
                threeDay = dayThree + DT.timedelta(days = 1)
                fourDay = dayFour + DT.timedelta(days = 1)
            else:
                oneDay = dayOne
                twoDay = dayTwo
                threeDay = dayThree
                fourDay = dayFour
            cursor.execute(historicalQuery, (str(oneDay), str(twoDay), str(threeDay), str(fourDay), product_id, store_id, historical_time_id))
            historicalWaste = cursor.fetchall()

            cursor.execute(anticipatedPullQuery, (str(dayOne), str(dayTwo), str(dayThree), str(dayFour), product_id, store_id, store_id, availability_category_times_id))
            average_pull = cursor.fetchall()

            cursor.execute(pullTimesQuery,(store_id, product_id, today, availability_category_times_id))
            timesanddata = cursor.fetchall()
            if len(historicalWaste)>0:
                product_obj["historical_waste"] = historicalWaste[0]["historical_waste"]
            else:
                product_obj["historical_waste"] = None
            if len(average_pull) > 0:
                product_obj["anticipated_sale"] = average_pull[0]["average_pull"]
            else:
                product_obj["anticipated_sale"] = None
            product_obj["timesanddata"] = timesanddata
            resultList.append(product_obj)

        cursor.execute(anticipatedTimeQuery,(availability_category_times_id,))
        anticipatedTime = cursor.fetchall()
        header_obj["anticipated_time"] = anticipatedTime[0]["time_range"]

        cursor.execute(pullHeadTimesQuery,(availability_category_times_id,))
        pullHeadTimes = cursor.fetchall()
        header_obj["pullHead_times"] = pullHeadTimes

        return jsonify({"status":"success", "response": resultList, "header_obj":header_obj})

    def post(self):
        logger = logging.getLogger("PullSheetAllTogether post")
        logger.info('Entered into PullSheetAllTogether method')

        try:
            pullover = request.json
            cursor = g.appdb.cursor()

        except:
            logger.error('Either db connection or date calculation error', exc_info=True)

        for value in pullover:
            if int(value['pull_id']) > 0:
                if value['no_of_units'] == 'empty':
                    query = """ DELETE from rg_pull_over_sheet where pull_id = %s """
                    cursor.execute(query,(value['pull_id'],))
                    g.appdb.commit()

                else:
                    updatequery = """ UPDATE rg_pull_over_sheet rpos set rpos.no_of_units = %s, rpos.status = %s where rpos.pull_id = %s """
                    cursor.execute(updatequery, (value["no_of_units"], value["status"], value["pull_id"]))
                    g.appdb.commit()
            else:
                query = """ INSERT INTO rg_pull_over_sheet (`product_id`,`store_id`,`sheet_reported_date`,`available_category_times_id`,`no_of_units`,`status`) VALUES (%s, %s, %s,%s, %s, %s) """
                cursor.execute(query, (value["product_id"], value["store_id"], value["sheet_reported_date"], value["available_category_times_id"],
                        value["no_of_units"],value["status"]))
                g.appdb.commit()

        logger.info('Exited from PullSheetAllTogether post method')
        return jsonify({"status":"success", "response":len(pullover)})


class PullSheetAllTogetherSubTime(Resource):
    def get(self):
        logger = logging.getLogger("PullSheetAllTogetherSubTime get")
        logger.info('Entered into PullSheetAllTogetherSubTime get method')

        try:
            cursor = g.appdb.cursor()
            act_id = request.args.get("act_id")
        except:
            logger.error('DB connection or url parameters error', exc_info=True)

        query = """ SELECT act.id AS act_id, act.time_range
              FROM available_category_times act where parent_time_id = %s """
        cursor.execute(query, (act_id, ))
        rv = cursor.fetchall()

        logger.info('Exited from PullSheetAllTogetherSubTime get method')
        return jsonify({"status":"success","response":rv})

class DeleteExcelReports(Resource):
    def post(self):
        logger = logging.getLogger("DeleteExcelReports POST")
        logger.info('Entered into DeleteExcelReports post method')

        try:
            sheet_location = g.config.get("excel_sheets_location")
            file_name = request.json["file_name"]
            reportId = request.json["reportId"]
            cursor = g.appdb.cursor()
        except:
            logger.error('DB connection or url parameters error', exc_info=True)

        query = """ DELETE from excel_reports where id = %s """
        cursor.execute(query,(reportId,))
        g.appdb.commit()
        if (os.path.isfile(sheet_location +'/'+ file_name)):
            os.remove(sheet_location +'/'+ file_name)
        logger.info('Exited from DeleteExcelReports post method')
        return jsonify({"status":"success","response":reportId})

class AnticipatedPerishable(Resource):
    def get(self):
        logger = logging.getLogger("AnticipatedPerishable get")
        logger.info('Entered into AnticipatedPerishable get method')

        try:
            cursor = g.appdb.cursor()
            today = request.args.get("report_date")
            store_id = request.args.get("store_id")
            category_name = str(request.args.get("category_name"))
            vendor_name = str(request.args.get("vendor_name"))
            product_type = str(request.args.get("product_type"))
            profile_id  = request.args.get("profile_id")

            year = today.split('-')[0]
            month = today.split('-')[1]
            day  = today.split('-')[2]
            todaysdate = DT.date(int(year),int(month),int(day))
            lastDate  = todaysdate + DT.timedelta(days=7)

            Dates = []
            weekDates = []
            for i in range(7):
                date = todaysdate + DT.timedelta(days=i)
                Dates.append({"day" : date.strftime("%Y-%m-%d")})
                weekDates.append(date)

        except:
            logger.error('DB connection or url parameters error', exc_info=True)

        query = """ SELECT  p.id AS product_id, p.name FROM product p
              inner join vendor_product_availability vpa on p.id = vpa.product_id
              inner join product_type pt on p.`product_type_id` = pt.`id`
              inner join vendors v on vpa.vendor_id = v.id
              inner join available_category ac on ac.id = vpa.`available_category_id`
              where ac.`category_name`= %s and v.vendor_name = %s and pt.`id`= %s """

        sub_query = """ SELECT IFNULL(cast(truncate((IFNULL(%s/100,1)*(sum(ps.no_of_units)/4)) + 0.875, 0) AS CHAR), 0) as average
                  FROM product p
                  left outer join product_sold ps on ps.product_id = p.id and ps.sold_date
                  in(%s, %s, %s, %s)
                  and ps.product_id = %s and ps.store_id = %s """

        factor_value = """SELECT bs.store_id, bf.factor_value from buildto_stores bs
                         inner join buildto_factor bf on bf.id = bs.factor_id and bf.profile_id = %s
                         where bs.store_id = %s """

        cursor.execute(factor_value, (profile_id, store_id))
        factor_value = cursor.fetchall()

        valuE = 100
        if len(factor_value) > 0:
            valuE = int(factor_value[0]["factor_value"])
        else:
            valuE == valuE

        cursor.execute(query, (category_name, vendor_name, product_type))
        rv = cursor.fetchall()
        result = []
        for value in rv:
            obj = {}
            product_id = value["product_id"]
            data = []
            for date in weekDates:
                today = date
                dayOne = today - DT.timedelta(days = 7)
                dayTwo = dayOne - DT.timedelta(days = 7)
                dayThree = dayTwo - DT.timedelta(days = 7)
                dayFour = dayThree - DT.timedelta(days = 7)
                cursor.execute(sub_query, (valuE, str(dayOne), str(dayTwo), str(dayThree), str(dayFour), product_id, store_id))
                timesanddata = cursor.fetchall()
                for j in timesanddata:
                    data.append({"average": j["average"], "date":str(today)})
            obj["product_id"] = product_id
            obj["product_name"] = value["name"]
            obj["data"]= data
            result.append(obj)

        logger.info('Exited from AnticipatedPerishable method')
        return {"status" : "success", "response" : result, "header_obj" : Dates }

class VendorNames(Resource):
    def get(self):
        logger = logging.getLogger("VendorNames get")
        logger.info('Entered into VendorNames  get method')

        try:
            cursor = g.appdb.cursor()
        except:
            logger.error('DB connection or url parameters error', exc_info=True)

        query = """ SELECT v.id AS vendor_id, v.vendor_name AS vendor_name
              FROM vendors v """
        cursor.execute(query, )
        rv = cursor.fetchall()

        logger.info('Exited from VendorNames get method')
        return jsonify({"status":"success", "response":rv})

class PerishableGoodsWaste(Resource):
    def get(self):
        logger = logging.getLogger("perishableGoodsWaste get")
        logger.info('Entered into perishableGoodsWaste  get method')

        try:
            cursor = g.appdb.cursor()
            category_name = request.args.get("category_name")
            vendor_name = request.args.get("vendor_name")
            store_id = request.args.get("storeid")
            product_type = request.args.get("product_type")
            waste_date = request.args.get("waste_reported_date")

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

        query = """ SELECT  p.id as product_id, p.name as itemName, ac.id from product p
              inner join vendor_product_availability vpa on p.id = vpa.product_id
              inner join product_type pt on p.`product_type_id` = pt.`id`
              inner join vendors v on vpa.vendor_id = v.id and v.vendor_name = %s
              inner join available_category ac on ac.id = vpa.`available_category_id`
              where ac.`category_name` = %s and pt.`type` = %s """

        cursor.execute(query, (vendor_name, category_name, product_type))
        rv = cursor.fetchall()
        result = []
        for value in rv:
            obj = {}
            product_id = value["product_id"]
            cursor.execute(waste_query, (product_id, store_id, waste_date, category_name))
            subtimes = cursor.fetchall()
            obj.update(value)
            obj["timesanddata"] = subtimes
            result.append(obj)

        logger.info('Exited from perishableGoodsWaste  get method')
        return jsonify({"status":"success","response":result})

    def post(self):
            logger = logging.getLogger("perishableGoodsWaste post")
            logger.info('Entered into perishableGoodsWaste  post method')

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

            logger.info('Exited from the perishableGoodsWaste post method')
            return jsonify({"status":"success","response":productWaste});
