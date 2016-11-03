var stateObject = {};
$(document).ready(function() {
  thresholdReportTemplate = MyApp.templates.thresholdReport;
  anticipatedTimeTemplate = MyApp.templates.buildtoTimes;
  $('#js-threshold-today-date').val(moment().format("MMM Do YYYY"));
  $('#js-threshold-today-day').text(moment($('#js-threshold-today-date').val(), 'MMM Do YYYY').format('dddd'));
  $('#js-threshold-today-date').datetimepicker({
    minDate: moment().subtract(1, 'month').format('MM DD YYYY'),
    ignoreReadonly: true,
    format: 'MMM Do YYYY',

  });
});

$('#js-threshold-today-date').on('dp.change', function(ev) {
  //Now we get the Date and Need to Reload the Screen with Previous Values.
  $('.js-antispected-actions').hide();
  $('#js-threshold-tableBody').html('');
  $('.build-table').append(styleLoader);
  $('#js-threshold-today-day').html(moment($('#js-threshold-today-date').val(), 'MMM Do YYYY').format('dddd'));
  thresholdReports();
});

function thresholdReports() {
  if ($('#js-threshold-today-date').val()) {
    var today = moment($('#js-threshold-today-date').val(), 'MMM Do YYYY').format('YYYY-MM-DD');
  } else {
    var today = moment().format("YYYY-MM-DD");
  }
  var store_id = parseInt($('#js-select-store').val());
  var defered1 = $.ajax({
    type: "GET",
    url: apiURL + "/admin/thresholdReport",
    data: {
      "report_date": today,
      "store_id": store_id
    },
    contentType: "application/json; charset=utf-8"
  });
  var defered2 = $.ajax({
    type: "GET",
    url: apiURL + "/products/time_categories",
    data: {
      "category_name": 'Roller'
    },
    contentType: "application/json; charset=utf-8"

  });
  $.when(defered1, defered2).then(function(v1, v2) {
    var timedata = {
      times: v2[0].response
    };
    var data = v1[0].response;
    $.each(data, function() {
      var thresholdvalue = this.thresholdValue;
      var values = this.values;
      $.each(values, function() {
        this.thresholdValue = thresholdvalue;
      });
    });
    var productdata = {
      products: data
    };
    var timeHeaderHtml = anticipatedTimeTemplate(timedata);
    var productsHtml = thresholdReportTemplate(productdata);
    $('#js-threshold-tableBody').html(productsHtml);
    $('#js-threshold-tableHead').html(timeHeaderHtml);
  }, function(err) {
    console.error(err);
  });
}
