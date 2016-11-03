#import smtplib
import time
import MySQLdb
import datetime as DT
import json
import logging,logging.handlers
import sys
import kaptan
import ftplib
import socket
import schedule
import time
import os
import smtplib
import logging

from datetime import date
from socket import *
from email.MIMEMultipart import MIMEMultipart
from email.MIMEBase import MIMEBase
from email.MIMEText import MIMEText
from email import Encoders
from MySQLdb import cursors as curs
from datetime import datetime as dt

config = kaptan.Kaptan(handler="json")
config.import_config(os.getenv("CONFIG_FILE_PATH", 'config.json'))

# Deafults
LOG_FILENAME = config.get("cron_log_path")
LOG_LEVEL = logging.INFO  # Could be e.g. "DEBUG" or "WARNING"

# Give the logger a unique name (good practice)
logger = logging.getLogger(__name__)

# Make a handler that writes to a file, making a new file at midnight and keeping 3 backups
handler = logging.handlers.TimedRotatingFileHandler(LOG_FILENAME, when="midnight", backupCount=3)

# Attach the handler to the logger
logger.addHandler(handler)

# Set the log level to LOG_LEVEL
logger.setLevel(LOG_LEVEL)



user = config.get("smtpuser")
passw = config.get("smtppass")
cron_time = config.get("cron_time")
dbhost = config.get("dbhost")
dbname = config.get("dbname")
dbuser = config.get("dbuser")
dbpass = config.get("dbpass")
rcv_location = config.get("rcv_file_location")
rcv_time = config.get("rcv_time")
ftp_server = config.get("ftp_server")
ftp_login = config.get("ftp_login")
ftp_pass = config.get("ftp_pass")



# Make a class we can use to capture stdout and sterr in the log
class MyLogger(object):
        def __init__(self, logger, level):
                """Needs a logger and a logger level."""
                self.logger = logger
                self.level = level

        def write(self, message):
                # Only log if there is a message (not just a new line)
                if message.rstrip() != "":
                        self.logger.log(self.level, message.rstrip())

# Replace stdout with logging to file at INFO level
sys.stdout = MyLogger(logger, logging.INFO)
# Replace stderr with logging to file at ERROR level
sys.stderr = MyLogger(logger, logging.ERROR)


def serveftp(rcvfile,dbqidlist):
    try:
        cone = MySQLdb.connect(host=dbhost,    # your host, usually localhost
                            user=dbuser,     # your username
                            passwd=dbpass,   # your password
                            db=dbname, cursorclass=curs.DictCursor,sql_mode="STRICT_TRANS_TABLES")
        curo =cone.cursor()
        logger.info("DB connection open")

    except:
        logger.error('Either connection problem or unable to get url parameters', exc_info=True)

    try:
        Name = socket.gethostname()
        filename = rcvfile +".rcv"            # file to send
        ftp = ftplib.FTP(ftp_server)
        ftp.login(ftp_login,ftp_pass)
        ftp.cwd("ftp")
        logger.info('Uploading File Now . . . Please wait . . ')

    except socket.Timeouterror as exception:
        logger.error("unable to connect to the socket : %s" % exception)

    filematch = rcv_location + "/" + rcvfile + ".rcv"
    filetocopy = open(filematch,"r")
    ftp.storlines("STOR " +filename , filetocopy)  # send the file
    logger.info('File Uploaded')
    for dbqid in dbqidlist:
        yesquery = """ UPDATE `dbq_orders` SET `order_placed` = 'YES' where id = %s"""
        curo.execute(yesquery,(dbqid,))
        cone.commit();
    cone.close()     #<--- Close the connection
    logger.info("DB Connection Close")
    ftp.quit()           # close file and FTP

def sched():
    try:
        con = MySQLdb.connect(host=dbhost,    # your host, usually localhost
                            user=dbuser,     # your username
                            passwd=dbpass,   # your password
                            db=dbname, cursorclass=curs.DictCursor,sql_mode="STRICT_TRANS_TABLES")
        curr =con.cursor()
        now = DT.datetime.now()
        today=now.strftime("%Y-%m-%d")
        now -= DT.timedelta(days=1)
        yesterday=now.strftime("%Y-%m-%d")
        logger.info("DB connection open")
        logger.info("Entered into sched() at" + str(now))
    except:
        logger.error('Either connection problem or unable to get url parameters', exc_info=True)

    groups = """SELECT id as group_id, group_name from reporting_groups """
    curr.execute(groups,)
    reporting_groups=curr.fetchall()
    for reporting_group in reporting_groups:
        group_id = reporting_group['group_id']
        query = """ SELECT u.id,u.name,u.email FROM reports_users ru
                    inner join user u on u.id=ru.user_id
                    where ru.reporting_groups_id=%s; """
        curr.execute(query,(group_id, ))
        names=curr.fetchall()

        get = """ SELECT store_id FROM email_config where reporting_groups_id = %s """
        curr.execute(get,(group_id,))
        stores = curr.fetchall()
        check_pass=[]
        for store in stores:
            store_id=store["store_id"]
            chek=""" SELECT * FROM product_waste pw where pw.waste_reported_date = %s and store_id = %s"""
            curr.execute(chek,(yesterday,store_id))
            check=curr.fetchall()
            if len(check)>0:
                logger.info("The waste has been entered for store " +str(store_id)+ " " +str(yesterday))
            else:
                storeId="store-"+str(store_id)
                check_pass.append(storeId)
        if len(check_pass) >0:
            for name in names:
                emailSubject = reporting_group['group_name']+" Stores Not Reporting Waste on "+str(yesterday)
                message = ",".join(check_pass)+""" did not complete reporting wastage dated on """+str(yesterday)
                msg = MIMEMultipart()
                msg = MIMEMultipart('alternative')
                msg['From'] = user
                msg['To'] = name['name']
                msg['Subject'] = emailSubject
                to = name['email']
                body = MIMEText(message, 'plain')
                msg.attach(body)
                mailServer = smtplib.SMTP("smtp.gmail.com",587)
                mailServer.ehlo()
                mailServer.starttls()
                mailServer.ehlo()
                mailServer.login(user,passw)
                mailServer.sendmail(user, to, msg.as_string())
                mailServer.close()
        else:
            logger.info("All stores of report group" +  reporting_group['group_name'] + "reported the wastage")

    con.close()     #<--- Close the connection
    logger.info("DB Connection Close")
    logger.info("Exited from sched() at" + str(now))

def rcvFTP():
    logger.info("Entered into rcvFTP() at")
    try:
        conn = MySQLdb.connect(host=dbhost,    # your host, usually localhost
                            user=dbuser,     # your username
                            passwd=dbpass,   # your password
                            db=dbname, cursorclass=curs.DictCursor,sql_mode="STRICT_TRANS_TABLES")
        cur =conn.cursor()
        logger.info("DB connection open")

    except:
        logger.error('Either connection problem or unable to get url parameters', exc_info=True)

    logger.info("job running")
    cursor=conn.cursor()
    Header = {'recordID':'H','employeeID':6,'storeNumber':5}

    DetailRecord = {'recordID':'I','quantity':3,'dbqid':6,
                 'pad':"       ",'quantitySign':'+','unit':" ",
                 'discount':'00','price':'00000'}
    name=str(int(time.time()))[-8:]
    creationDate = str(date.today())
    dbqidlist=[]

    store_query = """ SELECT distinct(store_id) FROM 7eleven.dbq_orders where status='completed' and order_placed = 'NO' """
    cursor.execute(store_query,)
    stores=cursor.fetchall()

    if len(stores)>0:
        filename = rcv_location + '/'+str(name) + ".rcv"
        if not os.path.exists(rcv_location):
            os.makedirs(rcv_location)
        rcv = open(filename, "wb")

        for store in stores:

            empid = """ SELECT ur.user_id as id, u.user_id as name from user u
                  inner join user_role ur on u.id = ur.user_id
                  inner join role r on r.id = ur.role_id
                  where r.name = 'Manager' and ur.store_id = %s """
            cursor.execute(empid, (store['store_id'],))
            empId = cursor.fetchall()

            order = """ SELECT dbo.id,dbo.no_of_units,dbp.dbq FROM dbq_orders dbo
                  inner join dbq_products dbp on dbp.id=dbo.dbqp_id
                  where dbo.status = 'completed' and dbo.store_id = %s and dbo.order_placed = 'NO'"""
            cursor.execute(order, (store['store_id'],))
            orders = cursor.fetchall()

            emp=empId[0]['id']
            if len(str(emp))<Header.get('employeeID'):
                pad=Header.get('employeeID')-len(str(emp))
                employeeID='0'*pad+str(emp)
            else:
                employeeID=emp

            if len(str(store["store_id"]))<Header.get('storeNumber'):
                pad=Header.get('storeNumber')-len(str(store["store_id"]))
                storeNumber='0'*pad+str(store['store_id'])
            else:
                storeNumber=store["store_id"]

            header= Header.get('recordID')+str(employeeID)+str(storeNumber)

            rcv.write(header)
            rcv.write('\r\n')

            for record in orders:
                dbqidlist.append(record['id'])
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
        rcvfile=name
        serveftp(rcvfile,dbqidlist)
    conn.close()     #<--- Close the connection
    logger.info("DB Connection Close")
    logger.info("Exited from rcvFTP() at")

schedule.every().hour.do(rcvFTP)
schedule.every().hour.do(sched)
#schedule.every().day.at(cron_time).do(sched)
logger.info("Behind the schedulers function")

while 1:
    logger.info("Inside the while loop")
    schedule.run_pending()
    time.sleep(1)
