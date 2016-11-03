#!flask/bin/python
from flask import Flask, jsonify, abort, make_response, request, g

from flask_restful import reqparse
from flask_restful import Resource, Api

import kaptan
import os
import time

from routes.equipment import Equipment
from routes.equipment import EquipmentList
from routes.equipment_temperature import EquipmentTempSave
from routes.equipment_temperature import EquipmentTemperatureList

from routes.product import ProductFinished
from routes.product import ProductReports
from routes.product import RollerFinishedGoods
from routes.product import ProductIngredients
from routes.product import TemparatureProducts
from routes.product import ProductSubTime
from routes.product import RollerSubTime
from routes.product import RollerLevels
from routes.product import AdminStoresList
from routes.product import BuildtoWaste
from routes.product import RollerGrillTemparatureProducts
from routes.product import ThresholdReportRollerGrill
from routes.product import DBQAdminGetProducts
from routes.product import DBQAdminEditProducts
from routes.product import DBQAdminGetOrders
from routes.product import LevelId
from routes.product import ProductSold

from routes.inspection import InspectionQuestion
from routes.inspection import Inspection
from routes.inspection import InspectionAnswers
from routes.inspection import InspectionResult
from routes.inspection import ExpandInspection
from routes.inspection import UpdateInspectionScore

from routes.report import ReportsGetUsers
from routes.report import EmailReport
from routes.report import AddStores
from routes.report import GetStores
from routes.report import ViewStores
from routes.report import ViewUsers
from routes.report import PullSheetTabs
from routes.report import ReportsGetStores


from routes.generate_csv import GenerateReports
from routes.generate_csv import SendEmail
from routes.generate_csv import Callftp

from routes.excelsheet import ExcelSheets
from routes.excelsheet import ReportStatus
from routes.excelsheet import GetReports
from routes.product_cost import Product_cost_history
from routes.product_cost import AddBuildFactor
from routes.product_cost import BuildtoFactorList
from routes.product_cost import BuildtoFactorStore
from routes.product_cost import BuildtoFactorAddStore
from routes.product_cost import BuildFactor
from routes.product_cost import Threshold
from routes.product_cost import ThresholdFactor
from routes.product_cost import ThresholdStores
from routes.product_cost import HistoryDateValidation

from routes.store import Store
from routes.store import AdminSelectedStore
from routes.store import LevelTimings
from routes.store import AddTimeSlots

from routes.survey import GetSurveyNamesList
from routes.survey import SettingsSurvey
from routes.survey import AddNewSurvey
from routes.survey import GetSurveyTable
from routes.survey import SurveyCategories
from routes.survey import SurveyQuestions
from routes.survey import GetCompletedQuestions
from routes.survey import CreateNewSurvey
from routes.survey import SaveSurveyAnswers
from routes.survey import CompletedSurvey
from routes.survey import SurveyComments
from routes.survey import EditSurvey
from routes.survey import GetProfiles
from routes.survey import SavedSurveyList
from routes.survey import DeleteSurveyList
from routes.survey import Question
from routes.survey import Category

from routes.auth import UserLogin
from routes.auth import AddUser
from routes.auth import AddUserStoresList

from routes.pullsheet import PullSheetAllTogether
from routes.pullsheet import PullSheetAllTogetherSubTime
from routes.pullsheet import DeleteExcelReports
from routes.pullsheet import AnticipatedPerishable
from routes.pullsheet import VendorNames
from routes.pullsheet import PerishableGoodsWaste


import MySQLdb
import logging
import json
import logging.config
import sys

app = Flask(__name__)

config = kaptan.Kaptan(handler="json")
config.import_config(os.getenv("CONFIG_FILE_PATH", 'config.json'))
environment = config.get('environment')

api = Api(app)
logger = logging.getLogger(__name__)


def connect_db():
    """Connects to the specific database."""
    try:
        db = MySQLdb.connect(host=config.get('dbhost'),  # your host, usually localhost
                         user=config.get("dbuser"),  # your username
                         passwd=config.get("dbpass"),  # your password
                         db=config.get("dbname"), cursorclass=MySQLdb.cursors.DictCursor,sql_mode="STRICT_TRANS_TABLES")  # name of the data base
        return db
    except:
        logger.error('Failed to Connect to the database', exc_info=True)
        sys.exit("not able to connect to database")


def get_db():
    """Opens a new database connection if there is none yet for the
    current application context.
    """
    if not hasattr(g, 'appdb'):
        g.appdb = connect_db()
    return g.appdb


@app.before_request
def before_request():
    g.appdb = get_db()
    setEmailRequirements()


@app.teardown_request
def teardown_request(exception):
    if hasattr(g, 'appdb'):
        g.appdb.close()

@app.before_first_request
def setup_logging(default_path='logconf.json', default_level=logging.INFO, env_key='LOG_CFG_PATH'):
    """Setup logging configuration"""
    path = default_path
    print "setup_logging before_first_request"
    value = os.getenv(env_key, None)
    if value:
        path = value
    if os.path.exists(path):
        with open(path, 'rt') as f:
            config = json.load(f)
        logging.config.dictConfig(config)
    else:
        logging.basicConfig(level=default_level)

def setEmailRequirements():
    if not hasattr(g, 'config'):
        g.config = config


api.add_resource(UserLogin, '/api/auth/login', endpoint='auth')
api.add_resource(AddUser, '/api/auth/addUser', endpoint='adduser')
api.add_resource(AddUserStoresList, '/api/auth/addUserStoresList', endpoint='addUserStoresList')


api.add_resource(EquipmentList, '/api/equipments', endpoint='equipments')
api.add_resource(Equipment, '/api/equipment/<id>', endpoint='equipment')
api.add_resource(EquipmentTemperatureList,
                 '/api/temparature/equipments', endpoint='equipmenttemperatures')
api.add_resource(EquipmentTempSave,
                 '/api/temparature/equipment/save', endpoint='equipmenttempsave')

api.add_resource(ProductSold, '/api/products/sold',
                 endpoint='sold')

api.add_resource(ProductReports, '/api/products/waste/reports',endpoint='reports')

api.add_resource(SendEmail, '/api/products/waste/SendEmail',endpoint='SendEmail')
api.add_resource(ProductIngredients,
                 '/api/products/ingredients', endpoint='ingredients')
api.add_resource(ProductFinished, '/api/products/finishedgoods',
                 endpoint='ProductFinished')
api.add_resource(RollerFinishedGoods, '/api/products/rollergrills', endpoint='finishedRoller')
api.add_resource(DBQAdminGetProducts, '/api/products/dbqProducts', endpoint='dbqProducts')
api.add_resource(DBQAdminEditProducts, '/api/products/dbqEditProducts', endpoint='dbqEditProducts')
api.add_resource(DBQAdminGetOrders, '/api/products/dbqOrders', endpoint='dbqOrders')
api.add_resource(LevelId, '/api/products/LevelId', endpoint='levelId')
api.add_resource(TemparatureProducts,
                 '/api/temparature/products', endpoint='temparature')
api.add_resource(
    ProductSubTime, '/api/products/time_categories', endpoint='subTime')
api.add_resource(RollerSubTime,'/api/roller/time_categories', endpoint='roller_subtime')
api.add_resource(AdminStoresList, '/api/admin/stores',
                 endpoint='storesdropdown')
api.add_resource(BuildtoWaste, '/api/admin/buildto', endpoint='adminbuildto')

api.add_resource(RollerGrillTemparatureProducts, '/api/temp/rollerGrillProducts', endpoint='rollerGrillTemp')
api.add_resource(ThresholdReportRollerGrill, '/api/admin/thresholdReport', endpoint='thresholdReport')

api.add_resource(RollerLevels, '/api/roller/levels', endpoint='levelRoller')

api.add_resource(GenerateReports, '/api/admin/generate/reports',
                 endpoint='generatecsv')

api.add_resource(ExcelSheets, '/api/admin/excel/excelsheets', endpoint='excelSheets')
api.add_resource(ReportStatus, '/api/admin/excel/reportStatus', endpoint='reportStatus')
api.add_resource(GetReports, '/api/admin/excel/getReports', endpoint='getReports')

api.add_resource(Callftp, '/api/admin/generate/Callftp',
                 endpoint='Callftp')

api.add_resource(Inspection, '/api/inspection/start', endpoint='inspection')
api.add_resource(InspectionQuestion, '/api/inspection/questions',
                 endpoint='inspectionQuestion')
api.add_resource(InspectionAnswers, '/api/inspection/saveanswers',
                 endpoint='inspectionsaveanswers')
api.add_resource(InspectionResult, '/api/inspection/results',
                 endpoint='inspectionresult')
api.add_resource(UpdateInspectionScore,
                 '/api/inspection/scoreupdate', endpoint='inspectionupdate')
api.add_resource(ExpandInspection,
                 '/api/inspection/expandinspection', endpoint='expandinspection')

api.add_resource(Product_cost_history, '/api/settings/unitPrice', endpoint='unitPrice')
api.add_resource(Product_cost_history, '/api/settings/savecost', endpoint='unitPriceSave')
api.add_resource(HistoryDateValidation, '/api/settings/unitPrice/verifyDate', endpoint='verifyDate')
api.add_resource(LevelTimings,'/api/settings/level_timings', endpoint='level_timings')
api.add_resource(AddTimeSlots, '/api/settings/levels/getTimeSlots', endpoint='getTimeSlots')


api.add_resource(AddBuildFactor, '/api/settings/buildto', endpoint = 'buildto')
api.add_resource(BuildFactor, '/api/settings/buildFactor', endpoint= 'buildFactor')
api.add_resource(Threshold, '/api/settings/threshold', endpoint= 'threshold')
api.add_resource(BuildtoFactorList, '/api/settings/initBuildto', endpoint= 'initBuild')

api.add_resource(BuildtoFactorList, '/api/settings/factor/delete', endpoint= 'deleteBuild')
api.add_resource(BuildtoFactorStore, '/api/settings/factor/store/delete', endpoint= 'deleteStoreBuild')

api.add_resource(BuildtoFactorAddStore, '/api/settings/factor/store/add', endpoint= 'addStoreBuild')
api.add_resource(SurveyCategories, '/api/survey/getCategories', endpoint='getCategories')
api.add_resource(SavedSurveyList, '/api/settings/savedSurveyList', endpoint='savedSurveyList')

api.add_resource(AdminSelectedStore, '/api/admin/getStoreDetails', endpoint='getStoreDetails')
api.add_resource(Store, '/api/settings/stores', endpoint= 'store')
api.add_resource(GetSurveyNamesList, '/api/survey/surveyNames', endpoint='getsurvey')
api.add_resource(SettingsSurvey, '/api/settings/getSurveys', endpoint='settingSurvey')
api.add_resource(AddNewSurvey, '/api/settings/survey/create', endpoint='newsurvey')
api.add_resource(EditSurvey, '/api/settings/survey/editSurvey', endpoint='EditSurvey')
api.add_resource(GetProfiles,'/api/survey/getProfiles',endpoint='getProfiles')

api.add_resource(GetSurveyTable, '/api/survey/getSurveyTable', endpoint='survey')
api.add_resource(SurveyQuestions, '/api/survey/getQuestions', endpoint='getQuestions')
api.add_resource(GetCompletedQuestions, '/api/survey/getCompletedQuestions', endpoint='getCompletedQuestions')
api.add_resource(CreateNewSurvey, '/api/survey/createNewSurvey', endpoint='CreateNewSurvey')
api.add_resource(SaveSurveyAnswers, '/api/survey/saveSurveyAnswers', endpoint='saveSurveyAnswers')
api.add_resource(CompletedSurvey, '/api/survey/completedSurvey', endpoint='completedSurvey')
api.add_resource(SurveyComments, '/api/survey/getOverallComments', endpoint='getOverallComments')
api.add_resource(Question, '/api/survey/Question', endpoint='Question')
api.add_resource(Category, '/api/survey/Category', endpoint='Category')
api.add_resource(ThresholdStores, '/api/survey/thresholdStores', endpoint='thresholdStores')
api.add_resource(ThresholdFactor, '/api/survey/ThresholdFactor', endpoint='ThresholdFactor')
api.add_resource(DeleteSurveyList,'/api/settings/deleteSurvey', endpoint='deleteSurvey')

api.add_resource(ReportsGetUsers, '/api/report/ReportsGetUsers', endpoint = 'report')
api.add_resource(EmailReport, '/api/report/EmailReport', endpoint = 'EmailReport')
api.add_resource(AddStores, '/api/report/addStores', endpoint = 'addStores')
api.add_resource(GetStores, '/api/report/getStores', endpoint = 'getStores')
api.add_resource(ViewStores, '/api/report/viewStores', endpoint = 'viewStores')
api.add_resource(ViewUsers, '/api/report/viewUsers', endpoint = 'viewUsers')
api.add_resource(PullSheetTabs, '/api/report/pullSheetTabs', endpoint = 'pullSheetTabs')
api.add_resource(ReportsGetStores, '/api/report/reportsGetStores', endpoint = 'reportsGetStores')

api.add_resource(PullSheetAllTogether,'/api/roller/pullsheets', endpoint = 'pullsheetProducts')
api.add_resource(PullSheetAllTogetherSubTime,'/api/roller/pullsheetsSubTime', endpoint = 'pullsheetsSubTime')
api.add_resource(DeleteExcelReports,'/api/excel/deleteReports', endpoint = 'deleteReports')
api.add_resource(AnticipatedPerishable,'/api/anticipated/perishableGoods', endpoint='antiPerish')
api.add_resource(VendorNames,'/api/vendor/vendorNames', endpoint='vendorNames')
api.add_resource(PerishableGoodsWaste,'/api/waste/perishableGoodsWaste', endpoint='perishableGoodsWaste')


@app.route('/api')
def index():
    # same result even with Flask-MySQL - We need to use the Index to Get
    # Values and Map to OrderedDict to create JSON.
    logger.info('Entered into Get /api Call')
    logger.debug(request.headers.get('User-Agent'))
    logger.info('Exiting from Get /api Call')
    return jsonify({"status": "success", "response": "API is up at the URL"})


def get_file_params(filename):
    filepath = g.config.get("excel_sheets_location") + '/'+filename
    with open(filepath, 'r') as f:
        content = f.read()
    return content



@app.route('/api/query/<file_id>')
def download(file_id):
    server_path = g.config.get("excel_sheets_location")
    cursor = g.appdb.cursor()
    query = """SELECT store_id, report_generation_date, file_location from excel_reports where id = %s """
    cursor.execute(query,(file_id,))
    result = cursor.fetchall()
    filename = result[0]["file_location"]
    file_size = os.path.getsize(server_path+ '/'+filename)
    FileContent=get_file_params(filename)
    response = make_response(FileContent)
    response.headers['Content-Description'] = 'File Transfer'
    response.headers['Cache-Control'] = 'no-cache'
    response.headers['Content-Type'] = 'application/octet-stream'
    response.headers['Content-Disposition'] = 'attachment; filename=%s' % filename
    response.headers['Content-Length'] = file_size
    response.headers['X-Accel-Redirect'] = server_path
    return response


#,ssl_context='adhoc'
if __name__ == '__main__':
    app.run(host=config.get("host"), debug=config.get("debug"))
