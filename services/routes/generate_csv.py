# -*- coding: utf-8 -*-
from flask_restful import reqparse
from flask_restful import Resource
from flask import jsonify, abort, make_response, request, g
from time import localtime, strftime
from datetime import date
import time
import calendar
import MySQLdb
import datetime as DT
import os
import csv
import smtplib
import logging

from email.MIMEMultipart import MIMEMultipart
from email.MIMEBase import MIMEBase
from email.MIMEText import MIMEText
from email import Encoders

def mail(emailSubject, attach):
    username = g.config.get("smtpuser")
    password = g.config.get("smtppass")
    fromemail = g.config.get("fromemail")
    receipients = g.config.get("receipients").split(',')
    extracts_location = g.config.get("extracts_location")
    msg = MIMEMultipart()
    msg['From'] = fromemail
    msg['To'] = ','.join(receipients)
    msg['Subject'] = emailSubject
    msg.attach(MIMEText("Automatically Generated inspection report attached."))
    part = MIMEBase('application', 'octet-stream')
    part.set_payload(open(attach, 'rb').read())
    Encoders.encode_base64(part)
    part.add_header('Content-Disposition',
                    'attachment; filename="%s"' % os.path.basename(attach))
    mailServer = smtplib.SMTP(g.config.get(
        "smtpserver"), g.config.get("smtpport"))
    msg.attach(part)
    mailServer.ehlo()
    mailServer.starttls()
    mailServer.ehlo()
    mailServer.login(username, password)
    mailServer.sendmail(fromemail, receipients, msg.as_string())
    mailServer.close()

class GenerateReports(Resource):

    def get(self):
        json = request.json
        cursor = g.appdb.cursor()
        fileLocation = g.config.get("extracts_location")
        today_Date = str(time.strftime("%Y-%m-%d"))
        time_now_timestamp = str(DT.datetime.now())
        storesQuery = """ SELECT id as store_id from store """
        cursor.execute(storesQuery)
        storesList = cursor.fetchall()

        for store in storesList:
            survey_idQuery = """ SELECT s.survey_name, sr.id as survey_result_id, sr.manager_name as Manager_name,
            sr.survey_overall_comments as Overall_comments, sr.score as total_score
            from survey_result sr
            inner join survey s on s.idsurvey=sr.survey_id
            where store_id=%s and
            DATE(sr.survey_date) = %s and status='completed' """

            store_id = store["store_id"]
            cursor.execute(survey_idQuery, (store_id, today_Date))
            survey_idList = cursor.fetchall()
            results = {}

            for survey_id in survey_idList:
                Manager_name = survey_id["Manager_name"]
                survey_result_id = survey_id["survey_result_id"]
                Overall_comments = survey_id["Overall_comments"]
                survey_score = survey_id["total_score"]
                survey_name = survey_id["survey_name"]
                Questionsquery = """ SELECT sq.idsurvey_questions as Question_no,sq.question,sq.score as question_score,
                sra.comments as question_comments, sra.result_score as points_awarded, sc.category_name,
                sr.score as total_survey_score,sr.manager_name, sr.survey_overall_comments from survey_result sr
                inner join survey_result_answers sra on sr.id = sra.survey_result_id
                inner join survey_questions sq on sq.idsurvey_questions = sra.survey_question_id
                inner join survey_category sc on sc.idsurvey_category= sq.category_id
                where survey_result_id = %s """
                # cursor.execute(Questionsquery,(survey_result_id,))
                cursor.execute(Questionsquery, (survey_result_id,))
                results = cursor.fetchall()
                emailSubject = "Survey Reports for Store " + \
                    str(store_id) + " under " + str(survey_name) + \
                    " dated on " + str(today_Date)
                directory = fileLocation + \
                    str(store_id) + "/" + str(survey_name)
                filename = directory + "/" + time_now_timestamp + ".csv"
                if not os.path.exists(directory):
                    os.makedirs(directory)
                fp = open(filename, "wb")
                writer = csv.writer(fp, delimiter='\t',
                                    quotechar='"', quoting=csv.QUOTE_ALL)
                writer.writerow(["StoredID#" + str(store_id), "Date:" +
                                 str(today_Date), "Manager:" + str(Manager_name)])
                writer.writerow("\n")
                writer.writerow(["Question_no", "Question", "Question_score",
                                 "Points_awarded", "Comments", "Category Name"])

                count = 0
                for result in results:
                    count += 1
                    Question_no = result["Question_no"]
                    Question = result["question"]
                    question_score = result["question_score"]
                    question_comments = result["question_comments"]
                    points_awarded = result["points_awarded"]
                    category_name = result["category_name"]
                    total_survey_score = result["total_survey_score"]
                    survey_overall_comments = result["survey_overall_comments"]
                    row = [count, Question, question_score,
                           points_awarded, question_comments, category_name]
                    writer.writerow(row)
                writer.writerow(["", "", "Overall Survey Comments:" + str(
                    survey_overall_comments), "Total Score:" + str(total_survey_score)])
                fp.close()
                mail(emailSubject, filename)
        return jsonify({"success": "success", "response": survey_idList})

def send(emailSubject, attach):
    cursor=g.appdb.cursor()
    username = g.config.get("smtpuser")
    password = g.config.get("smtppass")
    extracts_location = g.config.get("extracts_location")
    frontvalues=request.json
    group_name=request.json['group_name']
    query = """ SELECT u.email FROM reports_users ru
          inner join reporting_groups rg on rg.id=ru.reporting_groups_id
          inner join user u on u.id=ru.user_id
          where rg.group_name = %s """
    cursor.execute(query,(group_name,))
    emails=cursor.fetchall()
    receipients=[]
    for recep in emails:
        receipients.append(recep['email'])
    date=frontvalues['date']
    fromemail = g.config.get("fromemail")
    msg = MIMEMultipart()
    msg['From'] = fromemail
    msg['To'] = ','.join(receipients)
    msg['Subject'] = emailSubject
    msg.attach(MIMEText("Automatically Generated inspection report attached."))
    part = MIMEBase('application', 'octet-stream')
    part.set_payload(open(attach, 'rb').read())
    Encoders.encode_base64(part)
    part.add_header('Content-Disposition',
                    'attachment; filename="%s"' % os.path.basename(attach))
    mailServer = smtplib.SMTP(g.config.get("smtpserver"), g.config.get("smtpport"))
    msg.attach(part)
    mailServer.ehlo()
    mailServer.starttls()
    mailServer.ehlo()
    mailServer.login(username, password)
    mailServer.sendmail(fromemail, receipients, msg.as_string())
    mailServer.close()

class SendEmail(Resource):

    def post(self):
        json = request.json
        group_name=json['group_name']
        frdate=json['date']
        cursor = g.appdb.cursor()

        fileLocation= g.config.get("extracts_location")
        today_Date = str(time.strftime("%Y-%m-%d"))
        time_now_timestamp = str(DT.datetime.now())
        quer = """ SELECT store_id from email_config ec
             inner join reporting_groups rg on rg.id = ec.reporting_groups_id
             where rg.group_name = %s """
        cursor.execute(quer,(group_name,))
        stores=cursor.fetchall()
        va=0
        for store in stores:
            va +=1
            survey_idQuery = """ SELECT s.survey_name, sr.id as survey_result_id, sr.manager_name as Manager_name,
                           sr.survey_overall_comments as Overall_comments, sr.score as total_score
                           from survey_result sr
                           inner join survey s on s.idsurvey = sr.survey_id
                           where store_id = %s and
                           DATE(sr.survey_date) = %s and status = 'completed' """

            cursor.execute(survey_idQuery, (store["store_id"], frdate))
            survey_idList = cursor.fetchall()
            results = {}

            emailSubject = "Survey Reports for Store " + \
                str(store["store_id"]) + " dated on " + str(frdate)
            directory = fileLocation + \
                str(store["store_id"])
            filename = directory + "/" + str(frdate) + ".csv"
            if not os.path.exists(directory):
                os.makedirs(directory)
            fp = open(filename, "wb")

            if len(survey_idList)>0:

                for survey_id in survey_idList:
                    Manager_name = survey_id["Manager_name"]
                    survey_result_id = survey_id["survey_result_id"]
                    Overall_comments = survey_id["Overall_comments"]
                    survey_score = survey_id["total_score"]
                    survey_name = survey_id["survey_name"]
                    Questionsquery = """ SELECT sq.idsurvey_questions as Question_no,sq.question,sq.score as question_score,
                    sra.comments as question_comments, sra.result_score as points_awarded, sc.category_name,
                    sr.score as total_survey_score,sr.manager_name, sr.survey_overall_comments from survey_result sr
                    inner join survey_result_answers sra on sr.id = sra.survey_result_id
                    inner join survey_questions sq on sq.idsurvey_questions = sra.survey_question_id
                    inner join survey_category sc on sc.idsurvey_category= sq.category_id
                    where survey_result_id = %s """
                    cursor.execute(Questionsquery, (survey_result_id,))
                    results = cursor.fetchall()

                    writer = csv.writer(fp, delimiter='\t',
                                        quotechar='"', quoting=csv.QUOTE_ALL)

                    writer.writerow(["StoredID#" + str(store["store_id"]), "Date:" +
                                     str(frdate), "Manager:" + str(Manager_name)])
                    writer.writerow("\n")
                    writer.writerow(["Question_no", "Question", "Question_score",
                                     "Points_awarded", "Comments", "Category Name"])

                    count = 0
                    for result in results:
                        count += 1
                        Question_no = result["Question_no"]
                        Question = result["question"]
                        question_score = result["question_score"]
                        question_comments = result["question_comments"]
                        points_awarded = result["points_awarded"]
                        category_name = result["category_name"]
                        total_survey_score = result["total_survey_score"]
                        survey_overall_comments = result["survey_overall_comments"]
                        row = [count, Question, question_score,
                               points_awarded, question_comments, category_name]
                        writer.writerow(row)
                    writer.writerow(["", "", "Overall Survey Comments:" + str(
                        survey_overall_comments), "Total Score:" + str(total_survey_score)])
                    fp.close()
                    send(emailSubject, filename)
            else:

                fp.write("No surveys are found for the following store")
                fp.write("\n")
                fp.write("StoredID#" + str(store["store_id"])+ "Date:" +str(frdate))
                fp.close()
                send(emailSubject, filename)
        if len(stores)==va:
            status="success"

        return jsonify({"status":status, "response": survey_idList, "store_id":store["store_id"], "date":frdate})

class Callftp(Resource):

    def get(self):
        logger = logging.getLogger("FTP Call")
        logger.info('FTP call get method')
        try:
            Header={'recordID':'H','employeeID':6,'storeNumber':5}

            DetailRecord={'recordID':'I','quantity':3,'dbqid':6,
                         'pad':"       ",'quantitySign':'+','unit':" ",
                         'discount':'00','price':'00000'}
            rcv_location = g.config.get("rcv_file_location")
            name=time.strftime("%Y%m%d")
            creationDate=str(date.today())
            cursor = g.appdb.cursor()
        except:
            logger.error('DB connection or variable caluclating error', exc_info=True)

        filename = rcv_location + "/" + str(name)+ ".rcv"
        if not os.path.exists(rcv_location):
            os.makedirs(rcv_location)
        rcv = open(filename, "wb")

        store_query = """SELECT distinct(store_id) FROM 7eleven.dbq_orders where date=%s and status='completed'; """
        cursor.execute(store_query,(creationDate,))
        stores=cursor.fetchall()
        for store in stores:
            empid = """SELECT ur.user_id as id, u.user_id as name from user u
                  inner join user_role ur on u.id=ur.user_id
                  inner join role r on r.id=ur.role_id
                  where r.name = 'Manager' and ur.store_id = %s """
            cursor.execute(empid, (store['store_id'],))
            empId = cursor.fetchall()

            order = """ SELECT dbo.no_of_units,dbp.dbq FROM dbq_orders dbo
                  inner join dbq_products dbp on dbp.id=dbo.dbqp_id
                  where dbo.status = 'completed' and dbo.store_id = %s and dbo.date = %s """
            cursor.execute(order, (store['store_id'],creationDate))
            orders = cursor.fetchall()

            emp=empId[0]['id']
            if len(str(emp))<Header.get('employeeID'):
                pad=Header.get('employeeID')-len(str(emp))
                employeeID='0'*pad+str(emp)
            else:
                employeeID=emp

            if len(str(store))<Header.get('storeNumber'):
                pad=Header.get('storeNumber')-len(str(store))
                storeNumber='0'*pad+str(store)
            else:
                storeNumber=store

            header= Header.get('recordID')+employeeID+str(store['store_id'])

            rcv.write(header)
            rcv.write('\r\n')

            for record in orders:

                recordID=DetailRecord.get('recordID')
                pad=DetailRecord['pad']

                if len(str(record['no_of_units']))<DetailRecord.get('quantity'):
                    pad=DetailRecord.get('quantity')-len(str(record['no_of_units']))
                    quantity='0'*pad+str(record['no_of_units'])
                else:
                    quantity=record.get['no_of_units']

                if len(str(record['dbq']))<DetailRecord['dbqid']:
                    pad=DetailRecord['dbqid']-len(str(record['dbq']))
                    dbqid='0'*pad+str(record['dbq'])
                else:
                    dbqid=record['dbq']

                quantitySign=DetailRecord['quantitySign']
                unit=DetailRecord['quantitySign']
                discount=DetailRecord['discount']
                price=DetailRecord['price']

                Drecord=recordID+str(dbqid)+"       "+str(quantity)+quantitySign+" "+discount+price
                rcv.write(Drecord)
                rcv.write('\r\n')
        rcv.close()
        logger.info('Exited from ftpcall method')
        return {"status":"success","dbqid_response":stores}
