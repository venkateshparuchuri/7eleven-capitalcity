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

class ReportsGetUsers(Resource):
    def get(self):
        logger = logging.getLogger(" ReportsGetUsers get  method ")
        logger.info('Entered into ReportsGetUsers get  method')
        try:
            cursor = g.appdb.cursor()
        except:
            logger.error('Database connection or url parameters error', exc_info=True)
        query = """ SELECT id, group_name FROM reporting_groups """
        cursor.execute(query)
        rv = cursor.fetchall()
        result = []
        for group in rv:
            val=[]
            obj = {}
            obj["Group_ID"] = group["id"]
            obj["Group_Name"] = group["group_name"]
            sub_query = """ SELECT ru.id, u.user_id, u.name, u.email AS Email
                      FROM user u
                      INNER JOIN reports_users ru ON ru.user_id = u.id
                      INNER JOIN reporting_groups rg ON ru.reporting_groups_id = rg.id
                      where rg.group_name = %s """
            cursor.execute(sub_query,(group['group_name'], ))
            groups = cursor.fetchall()
            val.append(groups)
            obj["values"] = groups
            result.append(obj)

        logger.info('Exited from the ReportsGetUsers Method')
        return jsonify({"status":"success","response":result})

    def post(self):
        logger = logging.getLogger("ReportsGetUsers post")
        logger.info('Entered into ReportsGetUsers  post method')

        try:
            cursor = g.appdb.cursor()
            group_name=request.json['group_name']
        except:
            logger.error('Database connection or url parameters error', exc_info=True)

        query = """ INSERT INTO `reporting_groups` (`group_name`) VALUES (%s) """
        cursor.execute(query,(group_name, ))
        g.appdb.commit()

        logger.info('Exited from ReportsGetUsers post method')
        return jsonify({"status":"successfully inserted", "response":group_name})

    def delete(self):
        logger = logging.getLogger("ReportsGetUsers delete")
        logger.info('Entered into ReportsGetUsers  delete method')

        try:
            cursor = g.appdb.cursor()
            group_id=request.json['group_id']
        except:
            logger.error('Database connection or url parameters error', exc_info=True)

        config = """DELETE from email_config where reporting_groups_id = %s """
        cursor.execute(config, (group_id, ))
        g.appdb.commit()

        user = """ DELETE from reports_users where reporting_groups_id = %s """
        cursor.execute(user, (group_id, ))
        g.appdb.commit()

        query = """ DELETE FROM reporting_groups WHERE id = %s """
        cursor.execute(query, (group_id, ))
        g.appdb.commit()

        logger.info('Exited from ReportsGetUsers delete method')
        return jsonify({"status":"deleted successfully", "response":group_id})

class EmailReport(Resource):

    def get(self):
        logger = logging.getLogger(" ReportsGetUsers get  method ")
        logger.info('Entered into ReportsGetUsers get  method')
        try:
            cursor = g.appdb.cursor()
            group_id = request.args.get("group_id")
        except:
            logger.error('Database connection or url parameters error', exc_info=True)
        query = """ SELECT u.id, u.email AS Email, u.user_id FROM user u
                    inner join user_role ur on ur.user_id = u.id
                    inner join role r on r.id = ur.role_id
                    WHERE u.id NOT IN ( SELECT user_id FROM reports_users WHERE reporting_groups_id = %s ) and r.name='Admin'"""
        cursor.execute(query,(group_id, ))
        rv = cursor.fetchall()

        logger.info('Exited from the ReportsGetUsers Method')
        return jsonify({"status":"success","response":rv})

    def post(self):
        logger = logging.getLogger("ReportsGetUsers post")
        logger.info('Entered into ReportsGetUsers  post method')

        try:
            cursor = g.appdb.cursor()
            user_id = request.json['user_id']
            group_id = request.json['group_id']

        except:
            logger.error('Database connection or url parameters error', exc_info=True)

        for user in user_id:
            query = """ INSERT INTO `reports_users`(`reporting_groups_id`,`user_id`) VALUES (%s, %s) """
            cursor.execute(query, (group_id, user ))
            g.appdb.commit()

        logger.info('Exited from ReportsGetUsers post method')
        return jsonify({"status":"successfully inserted", "response":group_id})

    def delete(self):
        logger = logging.getLogger("EmailReport delete")
        logger.info('Entered into EmailReport  delete method')

        try:
            cursor = g.appdb.cursor()
            Id = request.json['user_id']
        except:
            logger.error('Database connection or url parameters error', exc_info=True)

        query = """ DELETE FROM reports_users WHERE id = %s """
        cursor.execute(query, (Id, ))
        g.appdb.commit()

        logger.info('Exited from EmailReport delete method')
        return jsonify({"status":"deleted successfully", "response":Id})

class AddStores(Resource):

    def get(self):
        logger = logging.getLogger("AddStores get  method ")
        logger.info('Entered into AddStores get  method')
        try:
            cursor = g.appdb.cursor()
        except:
            logger.error('Database connection or url parameters error', exc_info=True)

        query = """ SELECT id, group_name FROM reporting_groups """
        cursor.execute(query)
        rv = cursor.fetchall()
        result = []
        for group in rv:
            val=[]
            obj = {}
            obj["Group_ID"] = group["id"]
            obj["Group_Name"] = group["group_name"]
            sub_query = """ SELECT s.id AS store, ec.id
                      FROM reporting_groups rg
                      INNER JOIN email_config ec ON rg.id = ec.reporting_groups_id
                      LEFT OUTER JOIN store s ON ec.store_id = s.id
                      WHERE rg.group_name = %s """
            cursor.execute(sub_query,(group['group_name'], ))
            groups = cursor.fetchall()
            val.append(groups)
            obj["values"] = groups
            result.append(obj)
        logger.info('Exited from the Emailconfig get Method')
        return jsonify({"status":"success","response":result})

    def post(self):
        logger = logging.getLogger("Emailconfig post")
        logger.info('Entered into Emailconfig  post method')

        try:
            cursor = g.appdb.cursor()
            store_id = request.json['store_id']
            group_id = request.json['group_id']
        except:
            logger.error('Database connection or url parameters error', exc_info=True)

        query = """ INSERT into email_config(reporting_groups_id, store_id) values (%s, %s) """
        cursor.execute(query, (group_id, store_id ))
        g.appdb.commit()

        logger.info('Exited from Emailconfig post method')
        return jsonify({"status":"successfully inserted", "response":store_id})

    def delete(self):
        logger = logging.getLogger("Emailconfig delete")
        logger.info('Entered into Emailconfig  delete method')

        try:
            cursor = g.appdb.cursor()
            Id = request.json['id']
        except:
            logger.error('Database connection or url parameters error', exc_info=True)

        query = """ DELETE FROM email_config WHERE id = %s """
        cursor.execute(query, (Id, ))
        g.appdb.commit()

        logger.info('Exited from Emailconfig delete method')
        return jsonify({"status":"deleted successfully", "response":Id})

class GetStores(Resource):

    def get(self):
        logger = logging.getLogger(" GetStores get  method ")
        logger.info('Entered into GetStores get  method')
        try:
            cursor = g.appdb.cursor()
            group_id = request.args.get("group_id")
        except:
            logger.error('Database connection or url parameters error', exc_info=True)
        query = """ SELECT id AS store
              FROM store
              WHERE id NOT IN ( SELECT store_id FROM email_config WHERE reporting_groups_id = %s) """
        cursor.execute(query,(group_id, ))
        rv = cursor.fetchall()

        logger.info('Exited from the GetStores Method')
        return jsonify({"status":"success","response":rv})

class ViewStores(Resource):

    def get(self):
        logger = logging.getLogger(" ViewStores get  method ")
        logger.info('Entered into ViewStores get  method')
        try:
            cursor = g.appdb.cursor()
            group_name = request.args.get("group_name")
        except:
            logger.error('Database connection or url parameters error', exc_info=True)
        query = """ SELECT ec.id, ec.store_id AS store
              FROM email_config ec
              INNER JOIN reporting_groups rg ON ec.reporting_groups_id = rg.id
              WHERE rg.group_name = %s """
        cursor.execute(query,(group_name, ))
        rv = cursor.fetchall()

        logger.info('Exited from the ViewStores Method')
        return jsonify({"status":"success","response":rv})

class ViewUsers(Resource):

    def get(self):
        logger = logging.getLogger(" ViewUsers get  method ")
        logger.info('Entered into ViewUsers get  method')
        try:
            cursor = g.appdb.cursor()
            group_name = request.args.get("group_name")

        except:
            logger.error('Database connection or url parameters error', exc_info=True)
        query = """ SELECT ru.id, u.user_id, u.name
              FROM user u
              INNER JOIN reports_users ru ON ru.user_id = u.id
              INNER JOIN reporting_groups rg ON ru.reporting_groups_id = rg.id
              where rg.group_name = %s  """
        cursor.execute(query,(group_name,))
        rv = cursor.fetchall()

        logger.info('Exited from the ViewUsers Method')
        return jsonify({"status":"success","response":rv})

class PullSheetTabs(Resource):

    def get(self):
        logger = logging.getLogger(" PullSheetTabs get  method ")
        logger.info('Entered into PullSheetTabs get  method')
        try:
            cursor = g.appdb.cursor()
        except:
            logger.error('Database connection or url parameters error', exc_info=True)
        query = """ SELECT p.id, p.name FROM product p
              INNER JOIN product_type pt ON p.product_type_id = pt.id
              WHERE pt.type = "Roller Grill Finished Goods" AND p.product_parent_id is NULL """
        cursor.execute(query,)
        rv = cursor.fetchall()

        logger.info('Exited from the PullSheetTabs Method')
        return jsonify({"status":"success","response":rv})


class ReportsGetStores(Resource):

    def get(self):
        logger = logging.getLogger(" ReportsGetStores get  method ")
        logger.info('Entered into ReportsGetStores get  method')
        try:
            cursor = g.appdb.cursor()
        except:
            logger.error('Database connection or url parameters error', exc_info=True)
        query = """ SELECT sp.store_id AS store FROM store_profiles sp
              INNER JOIN profiles p ON sp.profile_id = p.id WHERE p.profile_name = "Capital City" """
        cursor.execute(query,)
        rv = cursor.fetchall()

        logger.info('Exited from the ReportsGetStores Method')
        return jsonify({"status":"success","response":rv})
