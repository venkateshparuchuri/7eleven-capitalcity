var stateObject = {};
var styleLoader = '<div class="col-lg-offset-5 dots-loader spinner-div-style">Loading…</div>';
$(document).ready(function() {
    $('#js-recordWaste-today-day').text(moment().format('dddd'));
    timeTemplate = MyApp.templates.times_template;
    pulloverEmployeeTemplate = MyApp.templates.pulloveremployee;
    pulloverTimeTemplate = MyApp.templates.pullovertimeslots;
    pulloverAdminTemplate = MyApp.templates.pulloveradmin;
});

function loadPullSheetTabs() {
    var html = '';
    $.ajax({
        type: "GET",
        url: apiURL + "/report/pullSheetTabs",
        contentType: "application/json; charset=utf-8",
        success: function(response) {
            if ($.cookie('user').role == 'Admin') {
                $('.js-pullover-maintabs').html('');
                for (var i = 0; i < response.response.length; i++) {
                    html = "<li data-id='" + response.response[i].id + "'data-value='" + response.response[i].name + "'><a data-value='" + response.response[i].name + "' href='#'>" + response.response[i].name + "</a></li>"
                    $('.js-pullover-maintabs').append(html);
                }
                $($('.js-pullover-maintabs li')[0]).addClass('active');
            } else {
                $('.js-pullover-employee').html('');
                for (var i = 0; i < response.response.length; i++) {
                    html = "<li data-id='" + response.response[i].id + "'data-value='" + response.response[i].name + "'><a data-value='" + response.response[i].name + "' href='#'>" + response.response[i].name + "</a></li>"
                    $('.js-pullover-employee').append(html);
                }
                if ($.cookie('stateObject') && $.cookie('stateObject').mainCategory) {
                    $('.js-pullover-employee').find('li[data-value="' + $.cookie('stateObject').mainCategory + '"]').addClass('active');
                    //$.cookie('stateObject', null);
                } else {
                    $($('.js-pullover-employee li')[0]).addClass('active');
                }
            }
            loadPulloverTimeSlots();
        }
    })
}


$('#js-pullover-today-date').val(moment().format("MMM Do YYYY"));
$('#js-pullover-today-day').text(moment($('#js-pullover-today-date').val(), 'MMM Do YYYY').format('dddd'));
$('#js-pullover-today-date').datetimepicker({
    minDate: moment().subtract(1, 'month').format('MM DD YYYY'),
    ignoreReadonly: true,
    format: 'MMM Do YYYY',
    maxDate: moment()
});
$('#js-pullover-today-date').on('dp.change', function(ev) {
    $('#js-pullover-values').html('');
    $('.build-table').append(styleLoader);
    $('#js-pullover-today-day').html(moment($('#js-pullover-today-date').val(), 'MMM Do YYYY').format('dddd'));
    if ($.cookie('user').role == 'Admin') {
        pulloverfunction($('.js-pullover-maintabs li.active').attr('data-value'));
    } else {
        stateObject.pullover_category_id = $('.js-temp-pullsheet-sub-nav li.active').attr('data-category-time-id');
        stateObject.category_times = $('.js-temp-pullsheet-sub-nav li.active').attr('data-value');
        pulloverfunction($('.js-pullover-employee li.active').attr('data-value'));
    }
});

$(document).delegate('.js-pullover-maintabs li', 'click', function(ev) {
    ev.preventDefault();
    $('.js-pullover-maintabs').find('li').removeClass('active');
    $(this).addClass('active');
    pulloverfunction($(this).attr('data-value'));
});

function pulloverfunction(parentValue) {
    $('.js-pullover-employee-tbody').html('<div class="col-lg-offset-5 dots-loader spinner-div-style">Loading…</div>');
    if ($('#js-pullover-today-date').val()) {
        var date = moment($('#js-pullover-today-date').val(), 'MMM Do YYYY').format('YYYY-MM-DD');
    } else {
        var date = moment().format("YYYY-MM-DD");
    }
    var store_id = '';
    var category_id = '';
    var category_times = '';
    if ($.cookie('user').role == 'Admin') {
        store_id = $('#js-select-store').val();
        category_id = $('.js-temp-pullsheet-sub-nav li.active').attr('data-category-time-id');
        category_times = $('.js-temp-pullsheet-sub-nav li.active').attr('data-value');
    } else {
        store_id = $.cookie('user').storeid;
        category_id = stateObject.pullover_category_id;
        category_times = stateObject.category_times;
    }
    var defered1 = $.ajax({
        type: "GET",
        url: apiURL + "/roller/pullsheets",
        data: {
            'availability_category_times_id': category_id,
            'category_times': category_times,
            'reported_date': date,
            'store_id': store_id,
            'rollerType': parentValue,
            'role': $.cookie('user').role
        },
        contentType: "application/json; charset=utf-8",
        success: function(response) {
            if ($.cookie('user').role == 'Admin') {
                var data = {
                    'response': response.response
                };
                var slotsArray = [];
                slotsArray.push(response.header_obj);
                var timeSlots = {
                    'time_slots': slotsArray
                }
                var itemsHtml = pulloverAdminTemplate(data);
                $('.js-pullover-values').html(itemsHtml);
                var slots = pulloverTimeTemplate(timeSlots);
                $('.js-pullover-timeslots').html(slots);
                $('.js-header_slot').css('width', '78px');
                $('.js-header_slot1').css('font-weight', 'bold');
                var index = $( ".js-temp-pullsheet-sub-nav li.active" ).index()
                // if ($( ".js-temp-pullsheet-sub-nav li" ).eq(index+1).length > 0) {
                //   var timeSlot = $( ".js-temp-pullsheet-sub-nav li" ).eq(index+1).attr('data-value');
                //   $('#js-historicaltime').text(timeSlot);
                // } else {
                //   var timeSlot = $( ".js-temp-pullsheet-sub-nav li" ).eq(0).attr('data-value');
                //   $('#js-historicaltime').text(timeSlot);
                // }
            } else {
                var hotdog = {
                    'response': response.response
                };
                var slotsArray = [];
                slotsArray.push(response.header_obj);
                var timeSlots = {
                    'time_slots': slotsArray
                }
                var itemsHtml = pulloverEmployeeTemplate(hotdog);
                $('.js-pullover-employee-tbody').html(itemsHtml);
                var slots = pulloverTimeTemplate(timeSlots);
                $('.js-pullover-timeslots').html(slots);
                $('.js-header_slot').css('width', '78px');
                $('.js-header_slot1').css('font-weight', 'bold');
                var index = $( ".js-temp-pullsheet-sub-nav li.active" ).index()
                // if ($( ".js-temp-pullsheet-sub-nav li" ).eq(index+1).length > 0) {
                //   var timeSlot = $( ".js-temp-pullsheet-sub-nav li" ).eq(index+1).attr('data-value');
                //   $('#js-historicaltime').text(timeSlot);
                // } else {
                //   var timeSlot = $( ".js-temp-pullsheet-sub-nav li" ).eq(0).attr('data-value');
                //   $('#js-historicaltime').text(timeSlot);
                // }

                if (moment($('#js-pullover-today-date').val(), 'MMM Do YYYY').isSame(moment(), 'day')) {
                    $('.js-pullover-actions').show();
                } else {
                    $('.js-pullover-actions').hide();
                    $('.js-pullover-employee-tbody').find('input').prop('disabled', true);
                }

                var columnCount = 0;
                $('.js-pullover-employee-tbody tr').each(function() {
                    columnCount = Math.max(columnCount, $(this).children('td').length);
                });

                var cellCounter = 1;
                for (var columnIndex = 0; columnIndex < columnCount; ++columnIndex) {
                    $('.js-pullover-employee-tbody tr').each(function() {
                        var cell = $(this).children('td').eq(columnIndex).find('input');
                        if (cell != null) {
                            cell.attr('tabindex', cellCounter++);
                        }
                    });
                }
            }
        }
    });
}


$(document).delegate('.js-pullover-action-save', 'click', function(ev) {
    ev.preventDefault();
    $('.js-pullover-action-save').button('loading');
    savePullReports('drafted');
});


$(document).delegate('.js-pullover-action-complete', 'click', function(ev) {
    ev.preventDefault();
    $('#pulloverconfirmationAction').modal('show');
    //savePullReports('completed');
});
$('#js-pullover-success-complete').on('click', function(ev) {
    ev.preventDefault();
    savePullReports('completed');
});

function savePullReports(status) {
    $('#pulloverconfirmationAction').modal('hide');
    var pullReportArray = [];
    var allTrue = true;
    $('.js-pullover-employee-tbody').find('input.js-product-waste-entry').each(function(index, el) {
        if (!$(el).is('[disabled="true"]')) {
            var thisElement = $(el);
            var pullreportObj = {};
            if (thisElement.attr('data-pull_id') > 0 && thisElement.val() == '') {
                pullreportObj.no_of_units = "empty";
            } else {
                pullreportObj.no_of_units = thisElement.val();
            }
            //pullreportObj.no_of_units = thisElement.val();
            if ((thisElement.val() <= 0 && thisElement.val() != '' )||thisElement.val().toString().length > 6) {
                allTrue = false;
                thisElement.addClass('error-whole-number');
                $('.js-pullover-action-save').button('reset');
            }
            pullreportObj.available_category_times_id = $(this).attr('data-category-time-id');
            pullreportObj.store_id = $('#js-select-store').val();
            if (thisElement.attr('data-pull_id') > 0) {
                pullreportObj.pull_id = thisElement.attr('data-pull_id');
            } else {
                pullreportObj.pull_id = 0;
            }
            pullreportObj.sheet_reported_date = moment().format('YYYY-MM-DD');

            pullreportObj.product_id = thisElement.parent().parent().find('td[data-product-id]').attr('data-product-id');
            pullreportObj.status = status;
            if ($.cookie('user').role == 'Admin') {
                pullreportObj.store_id = $('#js-select-store').val();
            } else {
                pullreportObj.store_id = $.cookie('user').storeid
            }
            if (allTrue && thisElement.val() > 0 || pullreportObj.no_of_units == "empty") {
                pullReportArray.push(pullreportObj);
            }
        }
    });
    //$('.js-pullover-action-save').button('loading');
    if (pullReportArray.length > 0 && allTrue) {
        // $('.js-pullover-action-save').button('loading');
        $.ajax({
            type: "POST",
            url: apiURL + "/roller/pullsheets",
            data: JSON.stringify(pullReportArray),
            contentType: "application/json; charset=utf-8",
            success: function(response) {
                if (status == "drafted") {
                    var test = "Saved but not completed."
                    $('.js-pullover-action-save').button('reset');
                } else {
                    var test = "Pullover sheet has been completed successfully."
                    $('.js-pullover-action-save').button('reset');
                }
                console.log(response);
                new PNotify({
                    title: 'Success!',
                    text: test,
                    type: 'success',
                    styling: 'fontawesome',
                    hide: true,
                    delay: 2000
                });
                pulloverfunction($('.js-pullover-employee li.active').attr('data-value'));
            },
            error: function(xhr, err, status) {
                new PNotify({
                    title: 'Error',
                    text: 'Save not successful',
                    type: 'error',
                    styling: 'fontawesome',
                    hide: true,
                    delay: 2000
                });
                $('.js-pullover-action-save').button('reset');
            }
        });
    } else if (!allTrue) {
        new PNotify({
            title: 'Error',
            text: 'Please fix the data fields highlighted in red.',
            type: 'error',
            styling: 'fontawesome',
            hide: true,
            delay: 2000
        });
        $('.js-pullover-action-save').button('reset');
    } else {
        $('.js-pullover-action-save').button('reset');
    }
}

function loadPulloverTimeSlots() {
    $('.js-alert-success').hide();
    if ($.cookie('user').role == 'Admin') {
        var storeid = $('#js-select-store').val();
    } else {
        var storeid = $.cookie('user').storeid;
    }
    $.ajax({
        type: "GET",
        url: apiURL + "/products/LevelId",
        data: {
            "store_id": storeid
        },
        contentType: "application/json; charset=utf-8",
        success: function(response) {
            getPullsheetslots(response.response[0].level_id);
        }
    });
}

function getPullsheetslots(level_id) {
    var defered2 = $.ajax({
        type: "GET",
        url: apiURL + "/roller/time_categories",
        data: {
            "category_name": 'Roller',
            "level_id": level_id
        },
        contentType: "application/json; charset=utf-8"
    });

    $.when(defered2).then(function(v2) {
        var timedata = {
            times: v2.response
        };

        var htm = "";
        for (var i = 0; i < timedata.times.length; i++) {
            htm += '<li data-category_name="Roller" data-category-time-id="' + timedata.times[i].category_time_id + '"data-value="' + timedata.times[i].time_range + '" id="liTimeData_' + timedata.times[i].category_time_id + '"><a href="#" data-category_name= "Roller">' + timedata.times[i].time_range + '</a></li>';
        }

        $(".js-temp-pullsheet-sub-nav").html(htm);
        $('.temperature .dots-loader').remove();
        if (stateObject.pullover_category_id && stateObject.pullover_category_id != "") {
            $('.js-temp-pullsheet-sub-nav').find('li[data-category-time-id="' + stateObject.pullover_category_id + '"]').addClass('active');
            stateObject.category_times = $('.js-temp-pullsheet-sub-nav li.active').attr('data-value');
        } else {
            $($('.js-temp-pullsheet-sub-nav li')[0]).addClass('active');
            stateObject.pullover_category_id = $('.js-temp-pullsheet-sub-nav li.active').attr('data-category-time-id');
            stateObject.category_times = $('.js-temp-pullsheet-sub-nav li.active').attr('data-value');
        }
        var i = 1;
        $('.js-pullover-employee-tbody tr').each(function(index, el) {
            var inputList = $(this).find('td input');
            for (var j = 0; j < inputList.length; j++) {
                $(inputList[j]).attr('tabindex', i++);
            }
        });
        if (!moment($('#js-pullover-today-date').val(), 'MMM Do YYYY').isSame(moment(), 'day')) {
            $('.js-pullover-employee-tbody').find('input').prop('disabled', true);
        }
        if ($.cookie('stateObject') && $.cookie('stateObject').mainCategory) {
            pulloverfunction($('.js-pullover-employee li.active').attr('data-value'));
            $.cookie('stateObject', null);
        } else if ($.cookie('user').role == 'Admin') {
           pulloverfunction($('.js-pullover-maintabs li.active').attr('data-value'));
        }
    }, function(err) {
        console.error(err);
    });
}


$(document).delegate('.js-product-waste-entry', 'keyup', function(ev) {
    ev.preventDefault();
    var data = 0;
    $(this).closest('tr').find('td').each(function(index, el) {
        if ($(el).find('input').hasClass('js-product-waste-entry')) {
            if ($(el).find('input.js-product-waste-entry').val() != '') {
                data = data + parseInt($(el).find('input.js-product-waste-entry').val());
            }
        }
    });
    $(ev.target).closest('tr').find('td.js-pull_total input').val(data);
});
