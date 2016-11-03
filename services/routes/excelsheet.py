    # -*- coding: utf-8 -*-
from flask_restful import reqparse
from flask_restful import Resource
from flask import jsonify, abort, make_response, request, g
from time import localtime, strftime
from datetime import date
from datetime import datetime
from calendar import weekday, monthrange, SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY
import time
import calendar
import MySQLdb
import datetime as DT
import os
import logging
import xlsxwriter
from xlsxwriter.utility import xl_range
from dateutil.relativedelta import relativedelta
from decimal import Decimal, ROUND_HALF_EVEN


class ReportStatus(Resource):
    def post(self):
        logger = logging.getLogger("ReportStatus post")
        logger.info('Entered into ReportStatus post method')

        try:
            store_id = request.json["store_id"]
            cursor = g.appdb.cursor()

        except:
            logger.error('Either db connection or date calculation error', exc_info=True)

        query = """ INSERT INTO `excel_reports`(`store_id`,`report_generation_date`,`active_flag`) VALUES ( %s, now(), 'false') """
        cursor.execute(query,(store_id,))
        g.appdb.commit()
        newID = cursor.lastrowid
        logger.info('Exited from ReportStatus post method')
        return jsonify({"status":"inserted", "response":newID})

    def get(self):
        logger = logging.getLogger("ReportStatus get")
        logger.info('Entered into ReportStatus  get method')
        try:
            cursor = g.appdb.cursor()
            reportId = request.args.get("reportId")
        except:
            logger.error('DB connection or url parameters error', exc_info=True)
        query = """ SELECT active_flag from excel_reports where id = %s """
        cursor.execute(query, (reportId, ))
        rv = cursor.fetchall()
        logger.info('Exited from ReportStatus get method')
        return jsonify({"status":"success","response":rv})

class ExcelSheets(Resource):

    def get(self):
        logger = logging.getLogger("ExcelSheets get")
        logger.info('Entered into ExcelSheets  get method')

        try:
            cursor = g.appdb.cursor()
            sheet_location = g.config.get("excel_sheets_location")
            year = request.args.get("year")
            reportId = request.args.get("reportId")
            month = int(request.args.get("month"))
            store_id = int(request.args.get("store_id"))

        except:
            logger.error('Problem connection with the Database')

        product_waste = """ SELECT pw.store_id AS Store, p.name AS Product, CAST(pw.waste_reported_date as char) AS Date,
                      CAST(ROUND(pw.no_of_units)AS CHAR)  AS Quantity, pw.dayoftheweek AS Day
                      FROM  product p
                      INNER JOIN  product_waste pw ON p.id = pw.product_id
                      INNER JOIN product_type pt ON p.product_type_id = pt.id AND pt.type = "Finished Goods"
                      WHERE month(pw.waste_reported_date) = %s AND year(pw.waste_reported_date) = %s AND pw.store_id = %s
                      GROUP BY pw.waste_reported_date, p.name """
        cursor.execute(product_waste, (month, year, store_id) )
        product_waste = cursor.fetchall()

        plu_by_time_store = """ SELECT ps.store_id as store, CAST(ps.sold_date AS CHAR) as call_date, CAST(ps.start_hour AS CHAR) as hour,
                          p.upc as plu, 'summary' as sale_type,
                          CAST(ps.no_of_units AS CHAR) as quantity, p.product_cost as amout,p.name as name
                          from product_sold ps
                          inner join product p on p.id = ps.product_id
                          INNER JOIN product_type pt ON p.product_type_id = pt.id AND pt.type = "Finished Goods"
                          where month(ps.sold_date) = %s AND year(ps.sold_date) = %s AND ps.store_id = %s
                          GROUP BY ps.sold_date, ps.start_hour, p.name """
        cursor.execute(plu_by_time_store, (month, year, store_id) )
        plu_by_time_store = cursor.fetchall()

        Cleanup = """ SELECT CAST(ps.sold_date AS CHAR) as call_date, CAST(ps.start_hour AS CHAR) as hour, CAST(ps.no_of_units AS CHAR) as quantity,
                CAST(p.product_cost AS CHAR) as amout, p.name as name, ps.day_of_the_week as day
                from product_sold ps
                inner join product p on p.id = ps.product_id
                INNER JOIN product_type pt ON p.product_type_id = pt.id AND pt.type = "Finished Goods"
                where month(ps.sold_date) = %s AND year(ps.sold_date) = %s AND ps.store_id = %s
                GROUP BY ps.sold_date, ps.start_hour, p.name """
        cursor.execute(Cleanup, (month, year, store_id) )
        Cleanup = cursor.fetchall()

        Table = """ SELECT CAST(ps.sold_date AS CHAR) AS call_date, CAST(ps.start_hour AS CHAR) AS hour, CAST(ps.no_of_units AS CHAR) AS quantity,
              CAST(p.product_cost AS CHAR) AS amout, p.name AS name, ps.day_of_the_week AS day
              FROM product_sold ps
              INNER JOIN product p ON p.id = ps.product_id
              INNER JOIN product_type pt ON p.product_type_id = pt.id AND pt.type = "Finished Goods"
              where month(ps.sold_date) = %s AND year(ps.sold_date) = %s AND ps.store_id = %s
              GROUP BY ps.sold_date, ps.start_hour, p.name """
        cursor.execute(Table, (month, year, store_id) )
        Table = cursor.fetchall()

        Time_of_Day_Sheet = """ SELECT  CAST(ps.start_hour AS CHAR) AS hour, CAST(SUM(ps.no_of_units)AS CHAR) AS quantity
                          FROM product_sold ps
                          INNER JOIN product p ON ps.product_id = p.id
                          INNER JOIN product_type pt ON p.product_type_id = pt.id AND pt.type = "Finished Goods"
                          WHERE month(ps.sold_date) = %s AND year(ps.sold_date) = %s AND ps.store_id = %s
                          GROUP BY ps.start_hour """
        cursor.execute(Time_of_Day_Sheet, (month, year, store_id) )
        Time_of_Day_Sheet = cursor.fetchall()

        Graph_Sales = """ SELECT p.name AS name, SUM(ps.no_of_units) AS Quantity
                    FROM product_sold ps
                    INNER JOIN product p ON p.id = ps.product_id
                    INNER JOIN product_type pt ON p.product_type_id = pt.id AND pt.type = "Finished Goods"
                    WHERE month(ps.sold_date) = %s AND year(ps.sold_date) = %s AND ps.store_id = %s
                    GROUP BY p.name """
        cursor.execute(Graph_Sales, (month, year, store_id) )
        Graph_Sales = cursor.fetchall()

        Pivot_Table = """ SELECT CAST(ps.sold_date AS CHAR) AS call_date, CAST(SUM(ps.no_of_units) AS CHAR) AS quantity, p.name AS name
                    FROM product_sold ps
                    INNER JOIN  product p ON p.id = ps.product_id
                    INNER JOIN product_type pt ON p.product_type_id = pt.id AND pt.type = "Finished Goods"
                    WHERE month(ps.sold_date) = %s AND year(ps.sold_date) = %s AND ps.store_id = %s
                    GROUP BY ps.sold_date, p.name """
        cursor.execute(Pivot_Table, (month, year, store_id) )
        rv = cursor.fetchall()

        result = {}
        productNames = []

        for value in rv:
            if value['name'] not in productNames:
                productNames.append(value['name'])
            if value['name'] not in result:
                result[value['name']] = {}
                result[value['name']][value['call_date']] = value['quantity']
            else:
                result[value['name']][value['call_date']] = value['quantity']

        noDays = calendar.monthrange(int(year), int(month))[1]
        days = [str(DT.date(int(year),int(month),day)) for day in range(1,noDays+1)]

        dayName = []
        for dat in days:
            namE=calendar.day_name[DT.datetime.strptime(dat, "%Y-%m-%d").weekday()]
            dayName.append(namE)

        Waste_Pivot_Table = """ SELECT CAST(pw.waste_reported_date AS CHAR) AS waste_date, ROUND(CAST(SUM(pw.no_of_units) AS CHAR)) AS quantity,
                          p.name AS name, p.id as product_id
                          FROM product p
                          INNER JOIN product_type pt ON p.product_type_id = pt.id AND pt.type = "Finished Goods"
                          INNER JOIN product_waste pw ON p.id = pw.product_id
                          WHERE month(pw.waste_reported_date) = %s AND year(pw.waste_reported_date) = %s AND pw.store_id = %s
                          GROUP BY pw.waste_reported_date , p.name """
        cursor.execute(Waste_Pivot_Table, (month, year, store_id) )
        Waste_Pivot_Table = cursor.fetchall()

        obj = {}
        Names = []
        productIds = []

        for value in Waste_Pivot_Table:
            if value['name'] not in Names:
                Names.append(value['name'])
            if value["product_id"] not in productIds:
                productIds.append(value["product_id"])
            if value['name'] not in obj:
                obj[value['name']] = {}
                obj[value['name']][value['waste_date']] = value['quantity']
            else:
                obj[value['name']][value['waste_date']] = value['quantity']

        March_16_Chart = """ SELECT p.name AS name, p.id as product_id, CAST(ps.sold_date AS CHAR) AS sold_date, p.product_cost AS amount,
                       CAST(SUM(ps.no_of_units) AS CHAR) AS quantity
                       FROM product_sold ps
                       INNER JOIN  product p ON p.id = ps.product_id
                       INNER JOIN product_type pt ON p.product_type_id = pt.id AND pt.type = "Finished Goods"
                       WHERE month(ps.sold_date) = %s AND year(ps.sold_date) = %s AND ps.store_id = %s
                       GROUP BY ps.sold_date, p.name """
        cursor.execute(March_16_Chart, (month, year, store_id) )
        March_16_Chart = cursor.fetchall()
        dic = {}
        prodNames = []
        chartProductIds = []
        for value in March_16_Chart:
            if value['name'] not in prodNames:
                prodNames.append(value['name'])
            if value["product_id"] not in chartProductIds:
                chartProductIds.append(value["product_id"])
            if value['name'] not in dic:
                dic[value['name']] = {}
                dic[value['name']][value['sold_date']] = value['quantity']
            else:
                dic[value['name']][value['sold_date']] = value['quantity']

        filename = "Store "+str(store_id)+" "+str(year)+"-"+str(month)+" Report - Created "+str(strftime("%Y-%m-%d %H-%M-%S"))+".xlsx"
        if not os.path.exists(sheet_location):
            os.makedirs(sheet_location)
        workbook = xlsxwriter.Workbook(sheet_location +'/'+ filename)
        worksheet1 = workbook.add_worksheet('product_waste')
        worksheet2 = workbook.add_worksheet('plu_by_time_store' + "_" +str(store_id))
        worksheet3 = workbook.add_worksheet('Data Cleanup')
        worksheet4 = workbook.add_worksheet('Table')
        worksheet13 = workbook.add_worksheet('Day Averages')
        worksheet11 = workbook.add_worksheet('Day & Time Comparison')
        worksheet5 = workbook.add_worksheet('Time of Day Sheet')
        worksheet8 = workbook.add_worksheet('Waste Pivot Table')
        worksheet7 = workbook.add_worksheet('Pivot Table')
        worksheet12 = workbook.add_worksheet('waste')
        worksheet6 = workbook.add_worksheet('Graph Sales')
        worksheet9 = workbook.add_worksheet(calendar.month_abbr[month] + " " + year + " " + 'Chart')
        worksheet10 = workbook.add_worksheet('Monthly Report')

        monthyear = calendar.month_abbr[month] + " " + year

        file_location = sheet_location +'/'+ filename
        fileLocationQuery = """ UPDATE `excel_reports` SET `monthYear` = %s, `file_location` = %s WHERE `id` = %s """
        cursor.execute(fileLocationQuery, (monthyear, filename, reportId))
        g.appdb.commit()

        # Set tab colors
        worksheet2.set_tab_color('#00FFFF')
        worksheet3.set_tab_color('#FFFFFF')
        worksheet4.set_tab_color('#FF6600')
        worksheet5.set_tab_color('#0000FF')
        worksheet6.set_tab_color('#C0C0C0')
        worksheet7.set_tab_color('#000000')
        worksheet8.set_tab_color('#FF00FF')
        worksheet9.set_tab_color('#00FF00')
        worksheet10.set_tab_color('#000080')
        worksheet12.set_tab_color('#FF0000')
        worksheet13.set_tab_color('#FFFF00')


        # Set the column
        worksheet1.set_column('A:A', 12)
        worksheet1.set_column('B:B', 29)
        worksheet1.set_column('C:E', 12)
        worksheet2.set_column('A:G', 12)
        worksheet2.set_column('H:H', 29)
        worksheet3.set_column('A:D', 12)
        worksheet3.set_column('E:E', 29)
        worksheet4.set_column('A:D', 12)
        worksheet4.set_column('E:E', 29)
        worksheet4.set_column('G:G', 12)
        worksheet5.set_column('A:B', 12)
        worksheet6.set_column('A:A', 10)
        worksheet6.set_column('B:T', 20)
        worksheet7.set_column('A:A', 10)
        worksheet7.set_column('B:T', 20)
        worksheet8.set_column('A:A', 10)
        worksheet8.set_column('B:T', 20)
        worksheet9.set_column('A:U', 20)
        worksheet10.set_column('A:A', 34)
        worksheet12.set_column('A:B', 12)

        # Set the autofilter.
        worksheet1.autofilter('A1:E1')
        worksheet4.autofilter('A1:F1')
        worksheet7.autofilter('A2')
        worksheet8.autofilter('A4')

        # Add a format for the header cells.
        header_format = workbook.add_format({
            'border': 1,
            'bg_color': '#C6EFCE',
            'bold': True,
            'text_wrap': True,
            'valign': 'vcenter',
            'indent': 1,
        })

        #format for money
        money_format = workbook.add_format({'num_format':'$#,##0.00'})
        percent_format = workbook.add_format({'num_format': '0.00"%"',
            'bold': 2
            })

        # Create a format to use in the merged range

        merge_format = workbook.add_format({
            'bold': 2,
            'border': 2,
            'align': 'center',
            'valign': 'vcenter'})

        # formatting definitions
        bold = workbook.add_format({'bold': 1})

        logger.info("started sheet1 product waste")

        # sets up the header row
        worksheet1.write('A1', 'Store', bold)
        worksheet1.write('B1', 'Product', bold)
        worksheet1.write('C1', 'Date', bold)
        worksheet1.write('D1', 'Quantity', bold)
        worksheet1.write('E1', 'Day', bold)

        row = 0
        for i in product_waste:
            row += 1
            col = 0
            worksheet1.write(row, col , i.get('Store'))
            worksheet1.write(row, col + 1, i.get('Product'))
            worksheet1.write(row, col + 2, i.get('Date'))
            worksheet1.write(row, col + 3, i.get('Quantity'))
            worksheet1.write(row, col + 4, i.get('Day'))
        logger.info("written sheet1 product waste")

        logger.info("started sheet2 plu by_time_store")

        # sets up the header row
        worksheet2.write('A1', 'store', bold)
        worksheet2.write('B1', 'call_date', bold)
        worksheet2.write('C1', 'hour', bold)
        worksheet2.write('D1', 'plu', bold)
        worksheet2.write('E1', 'sale_type', bold)
        worksheet2.write('F1', 'quantity', bold)
        worksheet2.write('G1', 'amout', bold)
        worksheet2.write('H1', 'name', bold)

        row = 0
        col = 0
        for i in plu_by_time_store:
            row += 1
            worksheet2.write(row, col , i.get('store'))
            worksheet2.write(row, col + 1, i["call_date"])
            time = str(i["hour"])
            hour = time.replace(":", "")
            worksheet2.write(row, col + 2, hour[0:4])
            worksheet2.write(row, col + 3, i.get('plu'))
            worksheet2.write(row, col + 4, i.get('sale_type'))
            worksheet2.write(row, col + 5, i.get('quantity'))
            worksheet2.write(row, col + 6, i.get('amout'))
            worksheet2.write(row, col + 7, i.get('name'))
        logger.info("written sheet2 plu by_time_store")

        logger.info("started sheet3 Data")

        # sets up the header row
        worksheet3.write('A1', 'call_date', bold)
        worksheet3.write('B1', 'hour', bold)
        worksheet3.write('C1', 'quantity', bold)
        worksheet3.write('D1', 'amout', bold)
        worksheet3.write('E1', 'name', bold)
        worksheet3.write('F1', 'day', bold)

        row = 0
        for i in Cleanup:
            row += 1
            col = 0
            worksheet3.write(row, col , i.get('call_date'))
            time = str(i["hour"])
            hour = time.replace(":", "")
            worksheet3.write(row, col + 1, hour[0:4])
            worksheet3.write(row, col + 2, i.get('quantity'))
            worksheet3.write(row, col + 3, i.get('amout'))
            worksheet3.write(row, col + 4, i.get('name'))
            worksheet3.write(row, col + 5, calendar.day_name[DT.datetime.strptime(str(i.get('call_date')), "%Y-%m-%d").weekday()])
        logger.info("written sheet3 data")

        logger.info("started sheet4 Table")

        # sets up the header row
        worksheet4.write('A1', 'call_date', bold)
        worksheet4.write('B1', 'hour', bold)
        worksheet4.write('C1', 'quantity', bold)
        worksheet4.write('D1', 'amout', bold)
        worksheet4.write('E1', 'name', bold)
        worksheet4.write('F1', 'day', bold)

        row = 0
        for i in Table:
            row += 1
            col = 0
            worksheet4.write(row, col , i.get('call_date'))
            time = str(i["hour"])
            hour = time.replace(":", "")
            worksheet4.write(row, col + 1, hour[0:4])
            worksheet4.write(row, col + 2, i.get('quantity'))
            worksheet4.write(row, col + 3, i.get('amout'))
            worksheet4.write(row, col + 4, i.get('name'))
            worksheet4.write(row, col + 5, calendar.day_name[DT.datetime.strptime(str(i.get('call_date')), "%Y-%m-%d").weekday()])
        logger.info("written sheet4 Table")

        logger.info("started sheet5 time of day sheet")

        # sets up the header row
        worksheet5.write('A1', 'hour', bold)
        worksheet5.write('B1', 'quantity', bold)

        row = 0
        for i in Time_of_Day_Sheet:
            row += 1
            col = 0
            time = str(i["hour"])
            hour = time.replace(":", "")
            worksheet5.write(row, col, hour[0:4])
            worksheet5.write(row, col + 1, int(i.get('quantity')))
        worksheet5.write(row +1, col, 'Total Result', bold)
        worksheet5.write(row +1, col + 1, '=SUM(B2:B'+str(row+1)+')', bold)

        #Create a new Chart object.
        chart_1 = workbook.add_chart({'type': 'column'})

        # Configure the charts. In simplest case we just add some data series.
        chart_1.add_series({
        'name': '=Time of Day Sheet!$B$1',
        'categories': '=Time of Day Sheet!$A$2:$A$' + str(row + 1),
        'values': '=Time of Day Sheet!$B$2:$B$' + str(row + 1),
        })

        # Add a chart title and some axis labels.
        chart_1.set_title ({'name': 'Store'+" "+ str(store_id) + " " + calendar.month_abbr[month] + " " + "Monthly Sales By Hour"})

        # Set an Excel chart style. Colors with white outline and shadow.
        chart_1.set_style(10)

        # Insert the chart into the worksheet.
        chart_1.set_size({'x_scale': 5, 'y_scale': 2.5})

        worksheet5.insert_chart('D7', chart_1)
        logger.info("finished sheet5 time of day sheet")

        logger.info("started sheet6 graph sales")

        # sets up the header row
        worksheet6.write('A1', 'name', bold)
        worksheet6.write('B1', 'quantity', bold)

        rowG = 1
        totalG = 0
        for i in Graph_Sales:

            worksheet6.write(rowG , 0, i.get('name'))
            worksheet6.write(rowG, 1, int(i.get('Quantity')))
            rowG +=1
            totalG = totalG + int(i.get('Quantity'))

        worksheet6.write(rowG, 0, 'Total Result', bold)
        worksheet6.write( rowG, 1, totalG, bold)

        #Create a new Chart object.
        chart_2 = workbook.add_chart({'type': 'column'})

        #Configure the charts. In simplest case we just add some data series.
        chart_2.add_series({
        'name': '=Graph Sales!$B$1',
        'categories': '=Graph Sales!$A$2:$A$' + str(rowG),
        'values': '=Graph Sales!$B$2:$B$' + str(rowG)
        })

        # Set an Excel chart style. Colors with white outline and shadow.
        chart_2.set_style(10)

        # Add a chart title and some axis labels.
        chart_2.set_title ({'name': 'Store'+" "+ str(store_id) + " " + calendar.month_abbr[month] + " " +"Totals"})

        # Insert the chart into the worksheet.
        chart_2.set_size({'x_scale': 5, 'y_scale': 2.5})

        worksheet6.insert_chart('E9', chart_2)
        logger.info("written sheet6 graph sales")

        logger.info("started sheet7 pivot table")

        # sets up the header row
        worksheet7.write('A1', 'Sum - quantity')
        worksheet7.write('A2', 'call_date')
        worksheet7.write('B1', 'name')

        col = 0
        for product in productNames:
            col +=1
            worksheet7.write(1, col, product)
        worksheet7.write(1, col+1, "Total Result", bold)
        row = 1

        for date in days:
            row +=1
            col = 0
            worksheet7.write(row, 0, date)
            rowTotal = 0
            for product in productNames:
                col +=1
                try:
                    value = result[product][date]
                except:
                    value = 0
                rowTotal = rowTotal + int(value)
                worksheet7.write(row, col, value)
            worksheet7.write(row, col+1, rowTotal, bold)
        worksheet7.write(row+1, 0, "Total Result", bold)

        chartSheetGrand = """ SELECT sum(ps.no_of_units) as total from product_sold  ps where
                        month(ps.sold_date) = %s and year(ps.sold_date) = %s and ps.product_id = %s and ps.store_id = %s
                        group by month(ps.sold_date) """
        count = 0
        pivotTotal = 0
        for id in chartProductIds:
            count +=1
            cursor.execute(chartSheetGrand,(month, year, id, store_id))
            total  = cursor.fetchall()
            pivotTotal = pivotTotal + int(total[0]["total"])
            worksheet7.write(row+1, count , total[0]["total"], bold)
        worksheet7.write(row+1, count+1, pivotTotal, bold)
        logger.info("started sheet7 pivot table")

        logger.info("started sheet8 Waste Pivot Table")

        # sets up the header row
        worksheet8.write('A1', 'Store')
        worksheet8.write('B1', store_id)
        worksheet8.write('A3', 'Sum of Amount')
        worksheet8.write('B3', 'Column Labels')
        worksheet8.write('A4', 'Row Labels')

        col = 0
        for i in Names:
            col +=1
            worksheet8.write(3, col, i)
        worksheet8.write(3, col+1, "Grand Total",bold)
        row = 3
        for date in days:
            row +=1
            col = 0
            worksheet8.write(row, 0, date)
            rowSum = 0
            for i in Names:
                col +=1
                try:
                    value = int(obj[i][date])
                except:
                    value = 0
                rowSum = rowSum + value
                worksheet8.write(row, col, value)
            worksheet8.write(row, col+1, rowSum, bold)
        worksheet8.write(row+1, 0, "Grand Total",bold)

        grandTotalQuery = """ SELECT sum(pw.no_of_units) as total from product_waste  pw where
                        month(pw.waste_reported_date) = %s and year(pw.waste_reported_date) = %s and pw.product_id = %s
                        and pw.store_id = %s
                        group by month(pw.waste_reported_date) """
        count = 0
        grandTotalValue = 0
        for id in productIds:
            count +=1
            cursor.execute(grandTotalQuery,(month, year, id, store_id))
            totalValue = cursor.fetchall()
            grandTotalValue = grandTotalValue + int(totalValue[0]["total"])
            worksheet8.write(row+1, count, totalValue[0]["total"],bold)
        worksheet8.write(row+1, count+1, grandTotalValue, bold)
        logger.info("written sheet8 Waste Pivot Table")

        logger.info("started sheet9")

        # sets up the header row
        worksheet9.write('A1', 'Store' + "  "+ str(store_id), header_format)
        worksheet9.write('A2', 'Day of week', header_format)
        worksheet9.write('B2', 'Row Labels', header_format)

        col = 1
        for prod in prodNames:
            col +=1
            worksheet9.write(1, col, prod, header_format)
        worksheet9.write(1, col +1 , "Grand Total", header_format)

        a = 1
        for f in  dayName:
            a += 1
            worksheet9.write(a, 0, f)

        row = 1
        for date in days:
            row +=1
            col = 1
            worksheet9.write(row, 1, date)
            rowTotal = 0
            for prod in prodNames:
                col +=1
                try:
                    value = int(result[prod][date])
                except:
                    value = 0
                rowTotal = rowTotal + value
                worksheet9.write(row, col, value)
            worksheet9.write(row, col+1, rowTotal, bold)
        worksheet9.write(row+1,1,"Grand Total", bold)
        worksheet9.write(row+3,1,"Grand Total", bold)

        productCostQuery = """ SELECT pch.item_cost  from product_cost_history pch
                         where pch. product_id = %s order by pch.effective_date_from desc """
        count = 1
        chartGrandTotal = 0
        grandTotalMoney = 0
        for id in chartProductIds:
            count +=1
            cursor.execute(chartSheetGrand,(month, year, id, store_id))
            total  = cursor.fetchall()
            chartGrandTotal = chartGrandTotal + int(total[0]["total"])
            worksheet9.write(row+1, count , total[0]["total"], bold)
            cursor.execute(productCostQuery,(id,))
            productCosts = cursor.fetchall()
            worksheet9.write(row+2, count, productCosts[0]["item_cost"], money_format)
            worksheet9.write(row+3, count, productCosts[0]["item_cost"]*total[0]["total"], money_format)
            grandTotalMoney = grandTotalMoney + productCosts[0]["item_cost"]*total[0]["total"]
        worksheet9.write(row+1, count+1, chartGrandTotal, bold)
        worksheet9.write(row+3, count+1, grandTotalMoney, money_format)
        logger.info("Finished sheet9")

        logger.info("started sheet10 Monthly Report")
        worksheet10.merge_range(
            'A1:N1', 'Store' + " " + str(store_id) + " " + 'Monthly Comparison', merge_format)
        worksheet10.merge_range(
            'C3:D3', calendar.month_abbr[month-2]+'-'+str(year)[-2:], merge_format)
        worksheet10.merge_range(
            'E3:F3', calendar.month_abbr[month-1]+'-'+str(year)[-2:], merge_format)
        worksheet10.merge_range(
            'G3:H3', calendar.month_abbr[month]+'-'+str(year)[-2:], merge_format)
        worksheet10.merge_range(
            'J3:K3', '% Change for'+" "+ calendar.month_abbr[month-1]+ '&'+ calendar.month_abbr[month], merge_format)
        worksheet10.write('A5','Breakfast', header_format)
        worksheet10.write('C5','Units', header_format)
        worksheet10.write('D5','Sales', header_format)
        worksheet10.write('E5','Units', header_format)
        worksheet10.write('F5','Sales', header_format)
        worksheet10.write('G5','Units', header_format)
        worksheet10.write('H5','Sales', header_format)
        worksheet10.set_column('I:I', 2)
        worksheet10.write('J5','Units', header_format)
        worksheet10.write('K5','Sales', header_format)

        productQuery = """ SELECT p.id, p.name, CAST(p.product_cost AS CHAR) AS product_cost
                     from product p
                     inner join product_availability pa on pa.product_id = p.id
                     inner join available_category ac on ac.id = pa.availability_id
                     inner join product_type pt on pt.id = p.product_type_id
                     where ac.category_name = %s and pt.type= %s """
        cursor.execute(productQuery,('Breakfast','Finished Goods'))
        productList = cursor.fetchall()

        row = 4
        col = 0
        unitsQuery = """ SELECT id, IFNULL(total,0) as total from (
        select %s as id
        UNION ALL
        select %s as id
        UNION ALL
        select %s as id) fake
        left outer join
        (select  IFNULL(sum(no_of_units),0) as total, month(ps.sold_date) as soldMonth  from product_sold ps
        where month(ps.sold_date) in (%s, %s, %s) AND year(ps.sold_date) = %s AND ps.store_id = %s and ps.product_id = %s
        group by month(ps.sold_date) order by month(ps.sold_date)) solquery on fake.id = solquery.soldMonth """
        graphValues = []
        graphNames =  []

        for product in productList:
            row +=1
            worksheet10.write(row, col, product["name"])
            graphNames.append(product["name"])
            cursor.execute(unitsQuery,(month - 2, month - 1, month, month - 2, month - 1, month, year, store_id, product["id"],))
            units = cursor.fetchall()
            count = 0
            for value in units:
                count = count + 2
                worksheet10.write(row, col + count, value["total"])
                worksheet10.write(row, col + count+1, float(value["total"]) * float(product["product_cost"]), money_format)
            if int(units[-1]["total"])==0 or int(units[-2]["total"])==0:
                worksheet10.write(row, col + count+3, 0)
                worksheet10.write(row, col + count+4, 0, money_format)
            else:
                worksheet10.write(row, col + count+3, float((units[-1]["total"]-units[-2]["total"])/units[-2]["total"])*100 )
                worksheet10.write(row, col + count+4, float((units[-1]["total"]-units[-2]["total"])/units[-2]["total"])*100, money_format )
            graphVal = float(value["total"]) * float(product["product_cost"])
            graphValues.append(graphVal)
        # plt.pie(graphValues,  labels=graphNames,  autopct='%1.1f%%', shadow=True, startangle=90)
        # plt.axis('equal')
        # plt.tight_layout()
        # plt.title('Store '+ str(store_id)+ 'Breakfast Sales')
        # imageName = "Breakfast" + str(store_id) + "-" + str(month) + "-" + str(year) + ".png"
        # plt.savefig(imageName,bbox_inches='tight')

        # Create an example Pie chart like above.
        chart_3 = workbook.add_chart({'type': 'pie'})

        # Configure the series.
        chart_3.add_series({
        'name': 'Pie sales data',
        'categories': '=Monthly Report!$A$6:$A$' + str(row),
        'values':     '=Monthly Report!$H$6:$H$' + str(row),
        })


        # Add a title.
        chart_3.set_title({'name': "Breakfast" + " " + str(store_id) + " "+ "-" + " " + str(month) + " "+ "-" + " " + str(year)})

        # Change the angle/rotation of the first segment.
        chart_3.set_rotation(180)

        # Insert the chart into the worksheet (with an offset).
        worksheet10.insert_chart('S13', chart_3)

        worksheet10.write(row+2, col, 'Total', bold)
        worksheet10.write(row+2, col+2, '=SUM(C6:C'+str(row+1)+')')
        worksheet10.write(row+2, col+3, '=SUM(D6:D'+str(row+1)+')', money_format)
        worksheet10.write(row+2, col+4, '=SUM(E6:E'+str(row+1)+')')
        worksheet10.write(row+2, col+5, '=SUM(F6:F'+str(row+1)+')', money_format)
        worksheet10.write(row+2, col+6, '=SUM(G6:G'+str(row+1)+')')
        worksheet10.write(row+2, col+7, '=SUM(H6:H'+str(row+1)+')', money_format)
        worksheet10.write(row+2, col+9, '=SUM(J6:J'+str(row+1)+')')
        worksheet10.write(row+2, col+10, '=SUM(K6:K'+str(row+1)+')', money_format)

        # Insert the chart into the worksheet (with an offset).
        # worksheet10.insert_image('P2', imageName, {'x_offset': 100, 'y_offset': 100})

        newrow = row+4

        worksheet10.write(newrow, col, 'Lunch', header_format)
        worksheet10.write(newrow, col+2,'Units', header_format)
        worksheet10.write(newrow, col+3,'Sales', header_format)
        worksheet10.write(newrow, col+4,'Units', header_format)
        worksheet10.write(newrow, col+5,'Sales', header_format)
        worksheet10.write(newrow, col+6,'Units', header_format)
        worksheet10.write(newrow, col+7,'Sales', header_format)
        worksheet10.write(newrow, col+9,'Units', header_format)
        worksheet10.write(newrow, col+10,'Sales', header_format)

        cursor.execute(productQuery,('Lunch','Finished Goods'))
        lunchproductList = cursor.fetchall()
        lunchNames = []
        lunchGraphValues = []
        for lunchproducts in lunchproductList:
            newrow +=1
            worksheet10.write(newrow, col, lunchproducts["name"])
            lunchNames.append(lunchproducts["name"])
            cursor.execute(unitsQuery,(month - 2, month - 1, month, month - 2, month - 1, month, year, store_id, product["id"],))
            lunchunits = cursor.fetchall()

            count = 0
            for values in lunchunits:
                count = count + 2
                worksheet10.write(newrow, col + count, values["total"])
                worksheet10.write(newrow, col + count+1, float(values["total"]) * float(lunchproducts["product_cost"]), money_format)
            if int(lunchunits[-1]["total"])==0 or int(lunchunits[-2]["total"])==0:
                worksheet10.write(newrow, col + count+3, 0)
                worksheet10.write(newrow, col + count+4, 0, money_format)
            else:
                worksheet10.write(newrow, col + count+3, float((lunchunits[-1]["total"]-lunchunits[-2]["total"])/lunchunits[-2]["total"])*100 )
                worksheet10.write(newrow, col + count+4, float((lunchunits[-1]["total"]-lunchunits[-2]["total"])/lunchunits[-2]["total"])*100, money_format)
            graphVal = float(values["total"]) * float(lunchproducts["product_cost"])
            lunchGraphValues.append(graphVal)
        # plt.pie(lunchGraphValues,  labels=lunchNames,  autopct='%1.1f%%', shadow=True, startangle=90)
        # plt.axis('equal')
        # plt.tight_layout()
        # plt.title('Store '+ str(store_id)+ 'Lunch Sales')
        # imageLunchName = "Lunch"+str(store_id) + "-"+ str(month)+"-"+str(year)+".png"
        # plt.savefig(imageLunchName,bbox_inches='tight')

        # Create an example Pie chart like above.
        chart_4 = workbook.add_chart({'type': 'pie'})

        # Configure the series.
        chart_4.add_series({
        'name': 'Pie sales data',
        'categories': '=Monthly Report!$A$' +str(row+5)+ ':$A' +str(newrow),
        'values':     '=Monthly Report!$H$' +str(row+5)+ ':$H' +str(newrow),
        })


        # Add a title.
        chart_4.set_title({'name': "Lunch" + " " + str(store_id) + " "+ "-" + " " + str(month) + " "+ "-" + " " + str(year)})

        # Change the angle/rotation of the first segment.
        chart_4.set_rotation(180)

        # Insert the chart into the worksheet (with an offset).
        worksheet10.insert_chart('S30', chart_4)

        worksheet10.write(newrow+2, col, 'Total', bold)
        worksheet10.write(newrow+2, col+2, '=SUM(C'+str(row+6)+':C'+str(newrow+1)+')')
        worksheet10.write(newrow+2, col+3, '=SUM(D'+str(row+6)+':D'+str(newrow+1)+')', money_format)
        worksheet10.write(newrow+2, col+4, '=SUM(E'+str(row+6)+':E'+str(newrow+1)+')')
        worksheet10.write(newrow+2, col+5, '=SUM(F'+str(row+6)+':F'+str(newrow+1)+')', money_format)
        worksheet10.write(newrow+2, col+6, '=SUM(G'+str(row+6)+':G'+str(newrow+1)+')')
        worksheet10.write(newrow+2, col+7, '=SUM(H'+str(row+6)+':H'+str(newrow+1)+')', money_format)
        worksheet10.write(newrow+2, col+9, '=SUM(J'+str(row+6)+':J'+str(newrow+1)+')')
        worksheet10.write(newrow+2, col+10, '=SUM(K'+str(row+6)+':K'+str(newrow+1)+')', money_format)

        # Insert the chart into the worksheet (with an offset).
        # worksheet10.insert_image('P35', imageLunchName, {'x_offset': 100, 'y_offset': 100})
        logger.info("started sheet10 monthly Report")

        logger.info('started sheet11 Day & Time Comparison')

        # Merge cells
        worksheet11.merge_range(
            'A1:Q1', 'Store'+ "  " + str(store_id) + " "+ 'Monthly Comparison of Day & Time', merge_format)
        worksheet11.merge_range(
            'A6:B6', 'Day of Week', merge_format)
        worksheet11.merge_range(
            'D5:E5', calendar.month_abbr[month-1] , merge_format)
        worksheet11.merge_range(
            'G5:H5', calendar.month_abbr[month], merge_format)
        worksheet11.merge_range(
            'L5:M5', calendar.month_abbr[month-1], merge_format)
        worksheet11.merge_range(
            'O5:P5', calendar.month_abbr[month], merge_format)

        worksheet11.merge_range ('A14:A16', 'Weekly Avg Units Sold', merge_format)
        worksheet11.set_column('A:A', 12)
        worksheet11.set_column('B:B', 8)
        worksheet11.set_column('C:C', 2)
        worksheet11.set_column('D:E', 15)
        worksheet11.set_column('F:F', 2)
        worksheet11.set_column('G:H', 15)
        worksheet11.set_column('I:I', 2)
        worksheet11.set_column('J:J', 15)
        worksheet11.set_column('K:K', 2)
        worksheet11.set_column('L:M', 15)
        worksheet11.set_column('N:N', 2)
        worksheet11.set_column('O:P', 15)

        worksheet11.write('D6','Avg. Units', header_format)
        worksheet11.write('E6','% of Total', header_format)
        worksheet11.write('G6','Avg. Units', header_format)
        worksheet11.write('H6','% of Total', header_format)
        worksheet11.write('J6','Time of Day', header_format)
        worksheet11.write('L6','Total Units', header_format)
        worksheet11.write('M6','% of Total', header_format)
        worksheet11.write('O6','Total Units', header_format)
        worksheet11.write('P6','% of Total', header_format)

        byWeekQuery = """ SELECT CAST(sum(ps.no_of_units) AS CHAR) as weekSum from product_sold ps
                    INNER JOIN product p ON ps.product_id = p.id
                    INNER JOIN product_type pt ON p.product_type_id = pt.id AND pt.type = "Finished Goods"
                    where year(ps.sold_date) = %s and month(ps.sold_date) = %s and dayofweek(ps.sold_date) = %s
                    and ps.store_id = %s
                    group by dayofweek(ps.sold_date) """

        Day_Time_ComparisionQuery = """ SELECT   fake.val as hour, IFNULL(solquery.quantity,0)  as quantity from
        ( select '04:00:00' as val
        union select '05:00:00'
        union select '06:00:00'
        union select '07:00:00'
        union select '08:00:00'
        union select '09:00:00'
        union select '10:00:00'
        union select '11:00:00'
        union select '12:00:00'
        union select '13:00:00'
        union select '14:00:00'
        union select '15:00:00'
        union select '16:00:00'
        union select '17:00:00'
        union select '18:00:00'
        union select '19:00:00'
        union select '20:00:00'
        union select '21:00:00'
        union select '22:00:00'
        union select '23:00:00') fake
        left outer join (SELECT CAST(ps.start_hour as char) as start_hour, CAST(SUM(ps.no_of_units) AS CHAR) AS quantity
                                   FROM product_sold ps
                                   INNER JOIN product p ON ps.product_id = p.id
                                   INNER JOIN product_type pt ON p.product_type_id = pt.id AND pt.type = "Finished Goods"
                                   WHERE month(ps.sold_date) =%s AND year(ps.sold_date) = %s AND ps.store_id = %s
                                   GROUP BY ps.start_hour) solquery on solquery.start_hour = fake.val """

        cursor.execute(Day_Time_ComparisionQuery, (month - 1 , year, store_id) )
        Day_Time_Comparison_1 = cursor.fetchall()
        cursor.execute(Day_Time_ComparisionQuery, (month, year, store_id) )
        Day_Time_Comparison_2 = cursor.fetchall()

        row = 5
        col = 9
        comparision1Total = 0
        for i in Day_Time_Comparison_1:
            row += 1
            time_value = datetime.strptime(str(i["hour"]), "%H:%M:%S")
            worksheet11.write(row, col , time_value.strftime("%I:%M %p"))
            worksheet11.write(row, col + 2, int(i["quantity"]))
            comparision1Total += int(i["quantity"])
        worksheet11.write(row +1, col , "Total Units", merge_format)
        worksheet11.write(row + 1, col + 2, comparision1Total, merge_format)
        worksheet11.write(row+1, col + 3, "100%" , merge_format)

        ROW = 5
        comparision2Total = 0
        for j in Day_Time_Comparison_2:
            ROW += 1
            comparision2Total += int(j['quantity'])
            worksheet11.write(ROW, col + 5, int(j['quantity']))
        worksheet11.write(ROW + 1, col + 5, comparision2Total, merge_format)
        worksheet11.write(ROW + 1, col + 6, "100%", merge_format)

        weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        row = 6

        prev = DT.date(int(year), int(month),1)+relativedelta(months=-1)

        noDays = calendar.monthrange(int(year), int(month))[1]
        lastMonthnoDays = calendar.monthrange(int(prev.year), int(prev.month))[1]
        days = [str(DT.date(int(year),int(month),day)) for day in range(1, noDays+1)]
        lastMonthDates = [str(DT.date(int(prev.year),int(prev.month),day)) for day in range(1,lastMonthnoDays+1)]

        dayName = []
        for dat in days:
            namE=calendar.day_name[DT.datetime.strptime(dat, "%Y-%m-%d").weekday()]
            dayName.append(namE)

        lastMonthDays = []
        for dat in lastMonthDates:
            namE=calendar.day_name[DT.datetime.strptime(dat, "%Y-%m-%d").weekday()]
            lastMonthDays.append(namE)

        lastMonthTotal = 0
        thisMonthTotal = 0
        weekValuesLastMonth = {}
        weekValuesThisMonth  = {}
        for day in weekDays:
            worksheet11.write(row, 0, day)
            worksheet11.write(row,1, str(lastMonthDays.count(day)) + "/" + str(dayName.count(day)))
            index = weekDays.index(day)
            cursor.execute(byWeekQuery,(year,month-1, index+1, store_id))
            lastMonthWeekSum = cursor.fetchall()

            if len(lastMonthWeekSum) >0:
                lastMonthTotal = lastMonthTotal + int(lastMonthWeekSum[0]["weekSum"])/lastMonthDays.count(day)
                worksheet11.write(row,3, (Decimal(float(lastMonthWeekSum[0]["weekSum"])/lastMonthDays.count(day))).quantize(Decimal('0'), rounding=ROUND_HALF_EVEN))
                weekValuesLastMonth[day] = int(lastMonthWeekSum[0]["weekSum"])/lastMonthDays.count(day)
            else:
                worksheet11.write(row,3, 0)
                weekValuesLastMonth[day] = 0

            cursor.execute(byWeekQuery,(year,month, index+1, store_id))
            thisMonthWeekSum = cursor.fetchall()

            if len(thisMonthWeekSum) > 0:
                thisMonthTotal = thisMonthTotal + int(thisMonthWeekSum[0]["weekSum"])/dayName.count(day)
                worksheet11.write(row, 6, (Decimal(float(thisMonthWeekSum[0]["weekSum"])/dayName.count(day))).quantize(Decimal('0'), rounding=ROUND_HALF_EVEN))
                weekValuesThisMonth[day] = int(thisMonthWeekSum[0]["weekSum"])/dayName.count(day)
            else:
                worksheet11.write(row, 6,0)
                weekValuesThisMonth[day] = 0
            row +=1

        worksheet11.write('D14', lastMonthTotal, merge_format)
        worksheet11.write('E14', 100, merge_format)
        worksheet11.write('G14',thisMonthTotal, merge_format)
        worksheet11.write('H14', 100, merge_format)

        row = 6
        for i in range(len(weekDays)):
            if lastMonthTotal == 0:
                lastMonthValue = 0
            else:
                lastMonthValue = (Decimal(str((float(int(weekValuesLastMonth[weekDays[i]]))/float(lastMonthTotal)) * 100))).quantize(Decimal('0.00'), rounding=ROUND_HALF_EVEN)
            worksheet11.write('E'+str(row+1),lastMonthValue )
            if thisMonthTotal == 0:
                thisMonthValue = 0
            else:
                thisMonthValue = (Decimal(str((float(int(weekValuesThisMonth[weekDays[i]]))/float(thisMonthTotal)) * 100))).quantize(Decimal('0.00'), rounding=ROUND_HALF_EVEN)
            worksheet11.write('H'+str(row+1), thisMonthValue)
            row +=1

        row = 6
        for i in range(len(Day_Time_Comparison_1)):
            if comparision1Total ==0:
                totalPercent1 = 0
            else:
                totalPercent1 = (Decimal(str(float(Day_Time_Comparison_1[i]["quantity"])/float(comparision1Total)*100))).quantize(Decimal('0.00'), rounding=ROUND_HALF_EVEN)
            worksheet11.write('M'+str(row+1), totalPercent1)

            if comparision2Total==0:
                totalPercent2 = 0
            else:
                totalPercent2 = (Decimal(str(float(Day_Time_Comparison_2[i]["quantity"])/float(comparision2Total)*100))).quantize(Decimal('0.00'), rounding=ROUND_HALF_EVEN)
            worksheet11.write('P'+str(row+1), totalPercent2)
            row +=1

        logger.info('written sheet11 Day & Time Comparison')

        logger.info('started sheet12 waste')

        #Breakfast
        for i in range(4, 50, 10):
            worksheet12.write(0, i ,"BREAKFAST", bold)
        proname = """ SELECT p.id, p.name from product p
                inner join product_availability pa on p.id = pa.product_id
                inner join available_category ac on pa.availability_id = ac.id and ac.category_name = %s
                where p.product_type_id = 2 """

        soldQuery = """SELECT  IFNULL(sum(ps.no_of_units),0) as totalSold FROM product p
                  inner join product_sold ps on p.id = ps.product_id
                  where p.id = %s and ps.sold_date = %s and ps.store_id = %s """
        wasteQuery = """SELECT  cast(IFNULL(sum(pw.no_of_units),0) as char) as totalWaste FROM product p
                   inner join product_waste pw on p.id = pw.product_id
                   where p.id = %s and pw.waste_reported_date = %s and pw.store_id = %s """

        #Breakfast
        daysObj={}
        daynames=['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday']
        for day in days:
            weekname=calendar.day_name[DT.datetime.strptime(day, "%Y-%m-%d").weekday()]
            if weekname not in daysObj:
                daysObj[weekname] = [day]
            else:
                daysObj[weekname].append(day)
        cursor.execute(proname,("Breakfast", ))
        brekpros=cursor.fetchall()
        cursor.execute(proname,("Lunch", ))
        lunpros=cursor.fetchall()
        itnames=2
        row=1
        worksheet12.write(2,0,"Date")
        worksheet12.write(2,1,"Day")
        for name in brekpros:
            worksheet12.write(row,itnames,name['name'],bold)
            worksheet12.write(row,itnames+4,"Totals",bold)
            worksheet12.write(row+1,itnames+4, "sold")
            worksheet12.write(row+1,itnames+5, "waste")
            worksheet12.write(row+1,itnames+6, "totalmade")
            worksheet12.write(row+1,itnames+7, "wastePercent")
            worksheet12.write(row+1,itnames,'sold')
            worksheet12.write(row+1,itnames+1,'waste')
            worksheet12.write(row+1,itnames+2,'totalmade')
            worksheet12.write(row+1,itnames+3,"wastePercent")
            itnames+=4
        row=4
        space=3
        prorow=row
        col=2
        col5=0
        for day in daynames:
            col5=row
            for date in daysObj[day]:
                colu=col
                worksheet12.write(row,0,date)
                worksheet12.write(row,1,day)
                totsol=0
                totwas=0
                for name in brekpros:
                    cursor.execute(soldQuery,(name["id"],date,store_id))
                    prosold=cursor.fetchall()
                    cursor.execute(wasteQuery,(name["id"],date,store_id))
                    prowaste=cursor.fetchall()
                    totsol=totsol+float(prosold[0]['totalSold'])
                    totwas=totwas+float(prowaste[0]['totalWaste'])
                    totmad=totsol+totwas
                    made=float(prosold[0]['totalSold'])+float(prowaste[0]['totalWaste'])
                    if prowaste[0]['totalWaste'] == 0 or int(made) == 0:
                        wasper='0.00%'
                    else:
                        wsper = (float(prowaste[0]["totalWaste"])/float(made))*100
                        wasper =str(wsper)[:5]+'%'
                    if totmad == 0 or totwas == 0:
                        towasper='0.00%'
                    else:
                        twsper = (totwas/float(totmad))*100
                        towasper =str(round(twsper,2))+'%'
                    worksheet12.write(row,colu,prosold[0]['totalSold'])
                    worksheet12.write(row,colu+1, int(float(prowaste[0]['totalWaste'])))
                    worksheet12.write(row,colu+2,made)
                    worksheet12.write(row,colu+3,wasper)
                    worksheet12.write(row, colu+4, totsol, bold)
                    worksheet12.write(row, colu+5, totwas, bold)
                    worksheet12.write(row, colu+6, totmad, bold)
                    worksheet12.write(row, colu+7, towasper, bold)
                    colu+=4
                row+=1
            worksheet12.write(row+1,1,'Totals',bold)

            for i in range(2,((len(brekpros)+1)*4)+2,4):
                waste = xl_range(col5, i, col5+4, i)
                wastetot='=SUM(' +waste + ')'
                sold = xl_range(col5, i+1, col5+4, i+1)
                soldtot='=SUM(' + sold + ')'
                worksheet12.write_formula(row+1,i,wastetot, bold)
                worksheet12.write_formula(row+1,i+1,soldtot, bold)
                made = xl_range(col5, i+2, col5+4, i+2)
                madetot = '=SUM(' + made + ')'
                worksheet12.write_formula(row+1, i+2, madetot, bold)
                totalWastePosition  =  xl_range(row+1,i+1,row+1,i+1)
                totalMadePosition = xl_range(row+1, i+2,row+1, i+2)
                marginpercen= '=ROUND(SUM(' + totalWastePosition + ')/SUM(' +  totalMadePosition+ ')*100,2)'
                worksheet12.write_formula(row+1,i+3,marginpercen, percent_format)
            row+=3
        tpm=1
        accsold=0
        accwaste=0
        worksheet12.write(row,tpm,"Grand Total", bold)
        for rt in brekpros:
            grandsol = """SELECT IFNULL(sum(ps.no_of_units),0)as sold from product_sold ps
                        inner join product p on p.id=ps.product_id
                        where year(ps.sold_date) = %s and month(ps.sold_date) = %s and p.name = %s and ps.store_id = %s """

            grandwas = """SELECT IFNULL(sum(pw.no_of_units),0)as waste from product_waste pw
                        inner join product p on p.id = pw.product_id
                        where year(pw.waste_reported_date) = %s and month(pw.waste_reported_date) = %s and p.name = %s and pw.store_id=%s"""

            cursor.execute(grandsol,(year,month,rt['name'],store_id))
            grandsold=cursor.fetchall()
            accsold=accsold+grandsold[0]['sold']
            cursor.execute(grandwas,(year,month,rt['name'],store_id))
            grandwaste=cursor.fetchall()
            accwaste=accwaste+grandwaste[0]['waste']
            if grandsold[0]['sold']==0 or grandwaste[0]['waste']==0:
                tre = '00.00%'
            else:
                tred = (grandwaste[0]['waste']/(grandsold[0]['sold']+grandwaste[0]['waste']))*100
                tre = str(tred)[:5]+'%'
            if accsold==0 or accwaste==0:
                accmar='00.00%'
            else:
                accmar=(accwaste/(accsold+accwaste))*100
            worksheet12.write(row,tpm+1,grandsold[0]['sold'], bold)
            worksheet12.write(row,tpm+2,grandwaste[0]['waste'], bold)
            worksheet12.write(row,tpm+3,grandsold[0]['sold']+grandwaste[0]['waste'], bold)
            worksheet12.write(row,tpm+4,tre, bold)
            worksheet12.write(row,tpm+5,accsold, bold)
            worksheet12.write(row,tpm+6,accwaste, bold)
            worksheet12.write(row,tpm+7,accwaste+accsold, bold)
            worksheet12.write(row,tpm+8,str(accmar)[:4]+'%', bold)
            tpm+=4

        #lunch
        worksheet12.write(row+2, 5, "LUNCH", bold)
        worksheet12.write(row+2, 21, "LUNCH", bold)

        itnames=2
        row=row+4
        worksheet12.write(row+1,0,"Date")
        worksheet12.write(row+1,1,"Day")
        for name in lunpros:
            worksheet12.write(row,itnames,name['name'],bold)
            worksheet12.write(row,itnames+4,"Totals",bold)
            worksheet12.write(row+1,itnames+4, "sold")
            worksheet12.write(row+1,itnames+5, "waste")
            worksheet12.write(row+1,itnames+6, "totalmade")
            worksheet12.write(row+1,itnames+7, "wastePercent")
            worksheet12.write(row+1,itnames,'sold')
            worksheet12.write(row+1,itnames+1,'waste')
            worksheet12.write(row+1,itnames+2,'totalmade')
            worksheet12.write(row+1,itnames+3,"wastePercent")
            itnames+=4

        row=row+3
        space=3
        prorow=row
        col=2
        col5=0
        for day in daynames:
            col5=row
            for date in daysObj[day]:
                colu=col
                worksheet12.write(row,0,date)
                worksheet12.write(row,1,day)
                totsol=0
                totwas=0

                for name in lunpros:
                    cursor.execute(soldQuery,(name["id"],date,store_id))
                    prosold=cursor.fetchall()
                    cursor.execute(wasteQuery,(name["id"],date,store_id))
                    prowaste=cursor.fetchall()

                    totsol= totsol+float(prosold[0]['totalSold'])
                    totwas= totwas+float(prowaste[0]['totalWaste'])
                    totmad= totsol+totwas
                    made=float(prosold[0]['totalSold'])+float(prowaste[0]['totalWaste'])

                    if float(prowaste[0]['totalWaste']) == 0 and int(made) == 0:
                        wasper='0.00%'
                    else:
                        wsper = (float(prowaste[0]["totalWaste"])/float(made))*100
                        wasper =str(wsper)[:5]+'%'

                    if totmad == 0 or totwas == 0:
                        towasper='0.00%'
                    else:
                        twsper = (float(totwas)/float(totmad))*100
                        towasper =str(round(twsper,2))+'%'

                    worksheet12.write(row,colu,prosold[0]['totalSold'])
                    worksheet12.write(row,colu+1,int(float(prowaste[0]['totalWaste'])))
                    worksheet12.write(row,colu+2,made)
                    worksheet12.write(row,colu+3,wasper)
                    worksheet12.write(row, colu+4, totsol, bold)
                    worksheet12.write(row, colu+5, totwas, bold)
                    worksheet12.write(row, colu+6, totmad, bold)
                    worksheet12.write(row, colu+7, towasper, bold)
                    colu+=4
                row+=1
            worksheet12.write(row+1,1,'Totals',bold)
            for i in range(2,((len(lunpros)+1)*4)+2,4):
                waste = xl_range(col5, i, col5+4, i)
                wastetot='=SUM(' +waste + ')'
                sold = xl_range(col5, i+1, col5+4, i+1)
                soldtot='=SUM(' + sold + ')'
                worksheet12.write_formula(row+1,i,wastetot, bold)
                worksheet12.write_formula(row+1,i+1,soldtot, bold)
                made = xl_range(col5, i+2, col5+4, i+2)
                madetot = '=SUM(' + made + ')'
                worksheet12.write_formula(row+1, i+2, madetot, bold)
                totalWastePosition  =  xl_range(row+1,i+1,row+1,i+1)
                totalMadePosition = xl_range(row+1, i+2,row+1, i+2)
                marginpercen= '=ROUND(SUM(' + totalWastePosition + ')/SUM(' +  totalMadePosition+ ')*100,2)'
                worksheet12.write_formula(row+1,i+3,marginpercen, percent_format)
            row+=3
        tpm=1
        accsold=0
        accwaste=0
        worksheet12.write(row,tpm,"Grand Total", bold)
        for rt in lunpros:
            grandsol = """SELECT IFNULL(sum(ps.no_of_units),0)as sold from product_sold ps
                        inner join product p on p.id=ps.product_id
                        where year(ps.sold_date) = %s and month(ps.sold_date) = %s and p.name = %s and ps.store_id = %s """

            grandwas = """SELECT IFNULL(sum(pw.no_of_units),0)as waste from product_waste pw
                        inner join product p on p.id = pw.product_id
                        where year(pw.waste_reported_date) = %s and month(pw.waste_reported_date) = %s and p.name = %s and pw.store_id=%s"""

            cursor.execute(grandsol,(year,month,rt['name'],store_id))
            grandsold=cursor.fetchall()
            accsold=accsold+grandsold[0]['sold']
            cursor.execute(grandwas,(year,month,rt['name'],store_id))
            grandwaste=cursor.fetchall()
            accwaste=accwaste+grandwaste[0]['waste']
            if grandwaste[0]['waste']==0 or grandsold[0]['sold']==0:
                tre = '00.00%'
            else:
                tred = (grandwaste[0]['waste']/(grandsold[0]['sold']+grandwaste[0]['waste']))*100
                tre = str(tred)[:5]+'%'
            if accwaste==0 or accsold==0:
                accmar='00.00%'
            else:
                accmar=(accwaste/(accsold+accwaste))*100
            worksheet12.write(row,tpm+1,grandsold[0]['sold'], bold)
            worksheet12.write(row,tpm+2,grandwaste[0]['waste'], bold)
            worksheet12.write(row,tpm+3,grandsold[0]['sold']+grandwaste[0]['waste'], bold)
            worksheet12.write(row,tpm+4,tre, bold)
            worksheet12.write(row,tpm+5,accsold, bold)
            worksheet12.write(row,tpm+6,accwaste, bold)
            worksheet12.write(row,tpm+7,accwaste+accsold, bold)
            worksheet12.write(row,tpm+8,str(accmar)[:4]+'%', bold)
            tpm+=4

        row+=1
        worksheet12.write(row+1,1,"Breakfast By Day of Week",bold)
        worksheet12.write(row+1,9,"Lunch By Day of Week",bold)
        worksheet12.write(row+2,0,"Date")
        worksheet12.write(row+2,1,"Day")
        worksheet12.write(row+2,2,"Sold")
        worksheet12.write(row+2,3,"Waste")
        worksheet12.write(row+2,4,"Total Made")
        worksheet12.write(row+2,5,"margin waste")
        worksheet12.write(row+2,8,"Date")
        worksheet12.write(row+2,9,"Day")
        worksheet12.write(row+2,10,"Sold")
        worksheet12.write(row+2,11,"Waste")
        worksheet12.write(row+2,12,"Total Made")
        worksheet12.write(row+2,13,"margin waste")
        row+=2

        #this writes date wise
        soldbreak=0
        wastebreak=0
        soldlun=0
        wastelun=0
        for day in days:
            row +=1
            namE = calendar.day_name[DT.datetime.strptime(day, "%Y-%m-%d").weekday()]
            brelunsold = """ SELECT IFNULL(SUM(ps.no_of_units),0) AS sold_quantity FROM product_sold ps
                       INNER JOIN product p ON ps.product_id = p.id
                       inner join product_availability pa on pa.product_id = p.id
                       inner join available_category ac on ac.id = pa.availability_id
                       INNER JOIN product_type pt ON p.product_type_id = pt.id AND pt.type = "Finished Goods"
                       WHERE ps.sold_date = %s and ac.category_name = %s AND ps.store_id = %s """
            cursor.execute(brelunsold,(day,'Breakfast',store_id))
            breaksold=cursor.fetchall()
            soldbreak=soldbreak+breaksold[0]["sold_quantity"]

            cursor.execute(brelunsold,(day,'Lunch',store_id))
            lunsold=cursor.fetchall()
            soldlun=soldlun+lunsold[0]["sold_quantity"]

            brelunwaste = """SELECT IFNULL(SUM(pw.no_of_units),0) AS waste_quantity FROM product_waste pw
                        INNER JOIN product p ON pw.product_id = p.id
                        inner join product_availability pa on pa.product_id = p.id
                        inner join available_category ac on ac.id = pa.availability_id
                        INNER JOIN product_type pt ON p.product_type_id = pt.id AND pt.type = "Finished Goods"
                        WHERE pw.waste_reported_date = %s and ac.category_name = %s AND pw.store_id = %s """
            cursor.execute(brelunwaste,(day,'Breakfast',store_id))
            breakwaste=cursor.fetchall()

            wastebreak=wastebreak+breakwaste[0]["waste_quantity"]
            cursor.execute(brelunwaste,(day,'Lunch',store_id))
            lunwaste=cursor.fetchall()
            wastelun=wastelun+lunwaste[0]["waste_quantity"]

            breaktot=breaksold[0]['sold_quantity']+breakwaste[0]['waste_quantity']
            if int(breaktot) == 0 and int(breakwaste[0]["waste_quantity"]) == 0:
                brekmargin = '0.00%'
            else:
                brekmar=(float(breakwaste[0]['waste_quantity'])/float(breaktot))*100
                brekmargin = str(brekmar)[:4] + '%'

            luntot=lunsold[0]['sold_quantity']+lunwaste[0]['waste_quantity']
            if int(lunwaste[0]["waste_quantity"]) == 0 or int(luntot) == 0:
                lunmargin = '0.00%'
            else:
                lunmar=(float(lunwaste[0]['waste_quantity'])/float(luntot))*100
                lunmargin = str(lunmar)[:4] + '%'

            worksheet12.write(row, 0, day)
            worksheet12.write(row, 1, namE)
            worksheet12.write(row, 2, breaksold[0]['sold_quantity'])
            worksheet12.write(row, 3, breakwaste[0]['waste_quantity'])
            worksheet12.write(row, 4, breaktot)
            worksheet12.write(row, 5, brekmargin)
            worksheet12.write(row, 8, day)
            worksheet12.write(row, 9, namE)
            worksheet12.write(row, 10, lunsold[0]['sold_quantity'])
            worksheet12.write(row, 11, lunwaste[0]['waste_quantity'])
            worksheet12.write(row, 12, luntot)
            worksheet12.write(row, 13, lunmargin)

        totbreak = soldbreak+wastebreak

        if wastebreak == 0 or totbreak ==0:
            totmarbre = 0
        else:
            totmarbre = (float(wastebreak)/float(totbreak))*100

        totlun = soldlun+wastelun

        if wastelun == 0 or totlun == 0:
            totmarlun = 0
        else:
            totmarlun=(float(wastelun)/float(totlun))*100

        worksheet12.write(row+1,1,"Totals",bold)
        worksheet12.write(row+1,2,soldbreak,bold)
        worksheet12.write(row+1,3,wastebreak,bold)
        worksheet12.write(row+1,4,totbreak,bold)
        worksheet12.write(row+1,5,str(totmarbre)[:5]+'%',bold)
        worksheet12.write(row+1, 9, "Totals",bold)
        worksheet12.write(row+1, 10, soldlun,bold)
        worksheet12.write(row+1, 11, wastelun,bold)
        worksheet12.write(row+1, 12, totlun,bold)
        worksheet12.write(row+1, 13, str(totmarlun)[:5]+'%',bold)

        row +=3

        worksheet12.write(row+1,1,"Breakfast By Day of Week",bold)
        worksheet12.write(row+1,9,"Lunch By Day of Week",bold)
        worksheet12.write(row+2,0,"Date")
        worksheet12.write(row+2,1,"Day")
        worksheet12.write(row+2,2,"Sold")
        worksheet12.write(row+2,3,"Waste")
        worksheet12.write(row+2,4,"Total Made")
        worksheet12.write(row+2,5,"margin waste")
        worksheet12.write(row+2,8,"Date")
        worksheet12.write(row+2,9,"Day")
        worksheet12.write(row+2,10,"Sold")
        worksheet12.write(row+2,11,"Waste")
        worksheet12.write(row+2,12,"Total Made")
        worksheet12.write(row+2,13,"margin waste")
        row+=3

        #this writes day name wise
        soldbreak=0
        wastebreak=0
        soldlun=0
        wastelun=0

        for day in daynames:
            for date in daysObj[day]:
                row +=1
                brelunsold = """ SELECT IFNULL(SUM(ps.no_of_units),0) AS sold_quantity FROM product_sold ps
                           INNER JOIN product p ON ps.product_id = p.id
                           inner join product_availability pa on pa.product_id = p.id
                           inner join available_category ac on ac.id = pa.availability_id
                           INNER JOIN product_type pt ON p.product_type_id = pt.id AND pt.type = "Finished Goods"
                           WHERE ps.sold_date = %s and ac.category_name = %s AND ps.store_id = %s """
                cursor.execute(brelunsold,(date,'Breakfast',store_id))
                breaksold=cursor.fetchall()
                soldbreak=soldbreak+breaksold[0]["sold_quantity"]

                cursor.execute(brelunsold,(date,'Lunch',store_id))
                lunsold=cursor.fetchall()
                soldlun=soldlun+lunsold[0]["sold_quantity"]

                brelunwaste = """ SELECT IFNULL(SUM(pw.no_of_units),0) AS waste_quantity FROM product_waste pw
                            INNER JOIN product p ON pw.product_id = p.id
                            inner join product_availability pa on pa.product_id = p.id
                            inner join available_category ac on ac.id = pa.availability_id
                            INNER JOIN product_type pt ON p.product_type_id = pt.id AND pt.type = "Finished Goods"
                            WHERE pw.waste_reported_date = %s and ac.category_name = %s AND pw.store_id = %s """
                cursor.execute(brelunwaste,(date,'Breakfast',store_id))
                breakwaste=cursor.fetchall()
                wastebreak=wastebreak+breakwaste[0]["waste_quantity"]
                cursor.execute(brelunwaste,(date,'Lunch',store_id))
                lunwaste=cursor.fetchall()
                wastelun=wastelun+lunwaste[0]["waste_quantity"]

                breaktot=breaksold[0]['sold_quantity']+breakwaste[0]['waste_quantity']
                if int(breaktot) == 0 and int(breakwaste[0]["waste_quantity"]) == 0:
                    brekmargin = '0.00%'
                else:
                    brekmar=(float(breakwaste[0]['waste_quantity'])/float(breaktot))*100
                    brekmargin = str(brekmar)[:4] + '%'

                luntot=lunsold[0]['sold_quantity']+lunwaste[0]['waste_quantity']
                if int(lunwaste[0]["waste_quantity"]) == 0 and int(luntot) == 0:
                    lunmargin = '0.00%'
                else:
                    lunmar=(float(lunwaste[0]['waste_quantity'])/float(luntot))*100
                    lunmargin = str(lunmar)[:4] + '%'

                worksheet12.write(row, 0, date)
                worksheet12.write(row, 1, day)
                worksheet12.write(row, 2, breaksold[0]['sold_quantity'])
                worksheet12.write(row, 3, breakwaste[0]['waste_quantity'])
                worksheet12.write(row, 4, breaktot)
                worksheet12.write(row, 5, brekmargin)
                worksheet12.write(row, 8, date)
                worksheet12.write(row, 9, day)
                worksheet12.write(row, 10, lunsold[0]['sold_quantity'])
                worksheet12.write(row, 11, lunwaste[0]['waste_quantity'])
                worksheet12.write(row, 12, luntot)
                worksheet12.write(row, 13, lunmargin)

            totbreak=soldbreak+wastebreak
            totlun=soldlun+wastelun
            if wastebreak == 0:
                totmarbre="0.000%"
            else:
                totmarbre=(float(wastebreak)/float(totbreak))*100
            if wastelun == 0:
                totmarlun="0.000%"
            else:
                totmarlun=(float(wastelun)/float(totlun))*100

            worksheet12.write(row+1,1,"Totals",bold)
            worksheet12.write(row+1,2,soldbreak,bold)
            worksheet12.write(row+1,3,wastebreak,bold)
            worksheet12.write(row+1,4,totbreak,bold)
            worksheet12.write(row+1,5,str(totmarbre)[:5]+'%',bold)
            worksheet12.write(row+1, 9, "Totals",bold)
            worksheet12.write(row+1, 10, soldlun,bold)
            worksheet12.write(row+1, 11, wastelun,bold)
            worksheet12.write(row+1, 12, totlun,bold)
            worksheet12.write(row+1, 13, str(totmarlun)[:5]+'%',bold)
        logger.info('written sheet12 waste')

        logger.info('started sheet13 day averages')
        worksheet13.set_column('A:A',42)
        worksheet13.set_column('B:AAA',12)
        moname = DT.date(int(year), int(month), 1).strftime('%B')
        worksheet13.merge_range('A1:Z1',str(store_id) + " " + 'Average Units Sold By Hour & By Day of Week For The Month Of  '+str(moname), merge_format)
        cordon=0

        #pile=26
        dayname=["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
        hrs=['00:00:00','01:00:00','02:00:00','03:00:00','04:00:00','05:00:00','06:00:00','07:00:00','08:00:00','09:00:00','10:00:00','11:00:00','12:00:00',
            '13:00:00','14:00:00','15:00:00','16:00:00','17:00:00','18:00:00','19:00:00','20:00:00','21:00:00','22:00:00','23:00:00',]
        for day in dayname:
            sold_date = dayname.index(day)+1
            pronamesquery = """SELECT p.id, p.name from product p
                          inner join product_type pt on p.product_type_id = pt.id
                          where pt.type = "Finished Goods" """
            cursor.execute(pronamesquery,)
            pronames=cursor.fetchall()
            cordon+=4
            worksheet13.write(cordon,0,day,bold)
            pile=1
            itera=pile

            for hr in hrs:
                time_value = datetime.strptime(str(hr), "%H:%M:%S")
                worksheet13.write(cordon,pile,time_value.strftime("%I:%M:%S %p"),bold)
                worksheet13.write(cordon,pile+1,"Totals",bold)
                pile+=1

            totAl = pile
            start = cordon+1
            for name in pronames:
                pileu=0
                cordon+=1
                fetch = """ SELECT CAST(act.start_time AS CHAR) AS hour, IFNULL(sum(ps.no_of_units),0) as total FROM product_sold ps
                      INNER JOIN product p ON ps.product_id = p.id and p.id = %s
                      inner join product_availability pa on p.id = pa.product_id
                      inner join available_category ac on pa.availability_id = ac.id
                      right outer join available_category_times act on ps.start_hour = act.start_time
                      and dayofweek(ps.sold_date) = %s and month(ps.sold_date) = %s and year(ps.sold_date) = %s  and ps.store_id = %s
                      group by act.start_time """
                cursor.execute(fetch,(name['id'],sold_date,month,year,store_id))
                eachpro=cursor.fetchall()
                worksheet13.write(cordon,pileu,name["name"])
                con=0
                total=0
                for was in eachpro:
                    con+=1
                    if was['total']==0:
                        worksheet13.write(cordon,con," ")
                    else:
                        worksheet13.write(cordon,con,was['total'])
                        total=total+was['total']
                        worksheet13.write(cordon,totAl,total,bold)
            end = cordon
            worksheet13.write(cordon+1,0,'Grand Total',bold)

            for itera in range(1,len(hrs)+2):
                gtot=xl_range(start,itera,end,itera)
                grandtot='=SUM(' + gtot+ ')'
                worksheet13.write_formula(end+1,itera,grandtot, bold)

        logger.info('written sheet13 day averages')

        workbook.close()

        # os.remove(imageName)
        # os.remove(imageLunchName)

        return jsonify({"status": "success", "response":reportId})


    def put(self):
        logger = logging.getLogger("ExcelSheets PUT")
        logger.info('Entered into ExcelSheets Update method')

        try:
            reportId = request.json["reportId"]
            cursor = g.appdb.cursor()
        except:
            logger.error('Either connection problem or unable to get url parameters', exc_info=True)

        completeQuery = """ UPDATE `excel_reports` SET `active_flag` = 'true' WHERE `id` = %s """
        cursor.execute(completeQuery, (reportId, ))
        g.appdb.commit()

        logger.info('Exited from ExcelSheets PUT Method')
        return jsonify({"status":"success","response":reportId})

class GetReports(Resource):
    def get(self):
        logger = logging.getLogger("GetReports get")
        logger.info('Entered into GetReports get method')
        try:
            cursor = g.appdb.cursor()

        except:
            logger.error('DB connection or url parameters error', exc_info=True)
        query = """ SELECT id AS reports_id, CAST(report_generation_date AS CHAR) AS date, store_id, file_location, active_flag, monthYear
              FROM excel_reports ORDER BY id DESC """
        cursor.execute(query, )
        rv = cursor.fetchall()
        result = []
        for value in rv:
            obj = {}
            obj["file_location"] = value["file_location"]
            obj["active_flag"] = value["active_flag"]
            obj["store_id"] = value["store_id"]
            obj["reports_id"] = value["reports_id"]
            obj["monthYear"] = value["monthYear"]
            obj["Date"] = value["date"].split(" ")[0]
            result.append(obj)
        logger.info('Exited from GetReports get method')
        return jsonify({"status":"success","response":result})
