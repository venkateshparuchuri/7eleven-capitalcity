var stateObject = {};
var styleLoader = '<div class="col-lg-offset-5 dots-loader spinner-div-style">Loading…</div>';
$(document).ready(function() {
    anticipatedTemplate = MyApp.templates.buildtoGoods;
    anticipatedTimeTemplate = MyApp.templates.buildtoTimes;
    perishableTimeTemplate = MyApp.templates.perishableTimeSlots;
    perishableGoodsTemplate = MyApp.templates.perishableGoods;

    $('#js-antispected-today-date').val(moment().format("MMM Do YYYY"));
    $('#js-antispected-today-day').text(moment($('#js-antispected-today-date').val(), 'MMM Do YYYY').format('dddd'));


    if ($.cookie('user').role == 'Admin') {
        $('#js-antispected-today-date').datetimepicker({
            ignoreReadonly: true,
            format: 'MMM Do YYYY',
        });
        $('#js-antispected-today-day').html(moment($('#js-antispected-today-date').val(), 'MMM Do YYYY').format('dddd'));
    } else {
        $('#js-antispected-today-date').datetimepicker({
            minDate: moment().subtract(1, 'month').format('MM DD YYYY'),
            ignoreReadonly: true,
            format: 'MMM Do YYYY',
        });
        $('#js-antispected-today-day').html(moment($('#js-antispected-today-date').val(), 'MMM Do YYYY').format('dddd'));
    }

    $('#js-antispected-today-date').on('dp.change', function(ev) {
        //alert($(this).val());
        //Now we get the Date and Need to Reload the Screen with Previous Values.
        $('#js-antispected-today-day').text(moment($('#js-antispected-today-date').val(), 'MMM Do YYYY').format('dddd'));
        if ($('#js-antispected-roller').hasClass('active')) {
            buildtoRollerGrill('7');
        } else if ($('#js-antispected-capitalcity').hasClass('active')) {
            stateObject.anticipatedMainCategory = 'Breakfast';
            buildto(2);
        } else if ($('#js-antispected-freshproducts').hasClass('active')) {
            buildtoFreshproducts(8);
        }
    });
});


function buildto(product_type) {
    //alert(product_type);
    $('#rightArrow').hide();
    $('#leftArrow').hide();
    $('.js-buildto-body').html('');
    $('.js-buildto-head').html('');
    $('.build-table .dots-loader').remove();
    $('.js-buildto-body').html('<div class="col-lg-offset-5 dots-loader spinner-div-style">Loading…</div>');
    $('.js-antispated-sub-nav').show();
    $('.js-perishable-sub-nav').hide();
    if ($('#js-antispected-today-date').val()) {
        var today = moment($('#js-antispected-today-date').val(), 'MMM Do YYYY').format('YYYY-MM-DD');
    } else {
        var today = moment().format("YYYY-MM-DD");
    }
    if ($.cookie('user').role == 'Admin') {
        var storeid = $('#js-select-store').val();
    } else {
        var storeid = $.cookie('user').storeid;
    }
    if ($('.js-antispated-sub-nav li.active').data('value')) {
        stateObject.anticipatedMainCategory = $('.js-antispated-sub-nav li.active').data('value');
    };

    var defered1 = $.ajax({
        type: "GET",
        url: apiURL + "/admin/buildto",
        data: {
            "category_name": stateObject.anticipatedMainCategory,
            "report_date": today,
            "store_id": storeid,
            "product_type": 2,
            "profile_id": 1,
            "profile_name": $('#js-antispected-capitalcity a').attr('data-profile_name')
        },
        contentType: "application/json; charset=utf-8",
        success: function(response) {
            console.log(response);
        }
    });

    var defered2 = $.ajax({
        type: "GET",
        url: apiURL + "/products/time_categories",
        data: {
            "category_name": stateObject.anticipatedMainCategory
        },
        contentType: "application/json; charset=utf-8"
    });


    $.when(defered1, defered2).then(function(v1, v2) {
        var timedata = {
            times: v2[0].response
        };
        var productdata = {
            products: v1[0].response
        };
        var timeHeaderHtml = anticipatedTimeTemplate(timedata);
        var productsHtml = anticipatedTemplate(productdata);
        $('.build-table .dots-loader').remove();
        $('.js-antispated-sub-nav').show();
        $('.js-antispected-actions').show();
        $('.js-buildto-head').html(timeHeaderHtml);
        $('.js-buildto-body').html(productsHtml);
        $('.js-buildto-body').closest('.table').removeClass('freeze-table');
        $('.js-table-reponsive').css('', 0);
    }, function(err) {
        console.error(err);
    });
}

function buildtoRollerGrill(category_name) {
    //alert(product_type);
    $('.js-buildto-body').html('');
    $('.js-buildto-head').html('');
    $('.js-buildto-body').html('<div class="col-lg-offset-5 dots-loader spinner-div-style">Loading…</div>');
    $('.js-perishable-sub-nav').hide();
    $('.js-antispated-sub-nav').hide();
    if ($('#js-antispected-today-date').val()) {
        var today = moment($('#js-antispected-today-date').val(), 'MMM Do YYYY').format('YYYY-MM-DD');
    } else {
        var today = moment().format("YYYY-MM-DD");
    }
    if ($.cookie('user').role == 'Admin') {
        var storeid = $('#js-select-store').val();
    } else {
        var storeid = $.cookie('user').storeid;
    }


    var defered1 = $.ajax({
        type: "GET",
        url: apiURL + "/admin/buildto",
        data: {
            "category_name": 'Roller_anti',
            "report_date": today,
            "store_id": storeid,
            "product_type": 3,
            "profile_id": 2,
            "profile_name": $('#js-antispected-roller a').attr('data-profile_name')
        },
        contentType: "application/json; charset=utf-8",
        success: function(response) {
            console.log(response);
        }
    });

    var defered2 = $.ajax({
        type: "GET",
        url: apiURL + "/products/time_categories",
        data: {
            "category_name": 'Roller_anti'
        },
        contentType: "application/json; charset=utf-8"
    });


    $.when(defered1, defered2).then(function(v1, v2) {
        var timedata = {
            times: v2[0].response
        };
        var productdata = {
            products: v1[0].response
        };
        var timeHeaderHtml = anticipatedTimeTemplate(timedata);
        var productsHtml = anticipatedTemplate(productdata);
        $('.build-table .dots-loader').remove();
        $('.js-antispated-sub-nav').hide();
        $('.js-antispected-actions').show();
        $('#rightArrow').show();
        $('#leftArrow').show();
        $('.js-buildto-head').html(timeHeaderHtml);
        $('.js-buildto-body').html(productsHtml);
        $('.js-buildto-body').closest('.table').addClass('freeze-table');


        /*    var offset=$('.table-responsive').offset()
            var width=$('.js-buildto-head').innerWidth();
         $('.js-buildto-head').on('mousemove',function(e){
              var leftPos=e.pageX-offset.left;
              calcLeft=(leftPos/width)*750;
              $('.table-responsive').scrollLeft(calcLeft);
              //console.log(width+"|"+leftPos+"|"+calcLeft);

          });*/
        $('.js-table-reponsive').css({
            'margin-top': '-40px',
            'margin-left': '20px'
        });
        $('#leftArrow').show();
        $('#rightArrow').show();
        currentScrollPosition = $('.table-responsive').offset().left;
        $('#leftArrow').on('click', function() {
            // console.log("left Arrow");
            currentScrollPosition -= 50;
            $('.table-responsive').animate({
                'scrollLeft': currentScrollPosition
            }, 100);
        });
        $('#rightArrow').on('click', function() {
            //console.log("right Arrow");
            currentScrollPosition += 50;
            $('.table-responsive').animate({
                'scrollLeft': currentScrollPosition
            }, 100);
        });


    }, function(err) {
        console.error(err);
    });
}

function buildtoFreshproducts(product_type) {
    //alert(product_type);
    $('#rightArrow').hide();
    $('#leftArrow').hide();
    $('.js-buildto-body').html('');
    $('.js-buildto-head').html('');
    $('.build-table .dots-loader').remove();
    $('.js-buildto-body').html('<div class="col-lg-offset-5 dots-loader spinner-div-style">Loading…</div>');
    $('.js-antispated-sub-nav').hide();
    $('.js-perishable-sub-nav').show();
    if ($('#js-antispected-today-date').val()) {
        var today = moment($('#js-antispected-today-date').val(), 'MMM Do YYYY').format('YYYY-MM-DD');
    } else {
        var today = moment().format("YYYY-MM-DD");
    }
    if ($.cookie('user').role == 'Admin') {
        var storeid = $('#js-select-store').val();
    } else {
        var storeid = $.cookie('user').storeid;
    }

    $.ajax({
        type: "GET",
        url: apiURL + "/anticipated/perishableGoods",
        data: {
            "category_name": "perishableGoods",
            "report_date": today,
            "store_id": storeid,
            "product_type": product_type,
            "profile_id": 3,
            "vendor_name": $('.js-perishable-sub-nav li.active').attr('data-value')
        },
        contentType: "application/json; charset=utf-8",
        success: function(response) {
            var timedata = {
                dates: response.header_obj
            };
            var productdata = {
                products: response.response
            };
            var timeHeaderHtml = perishableTimeTemplate(timedata);
            var productsHtml = perishableGoodsTemplate(productdata);
            $('.js-antispated-sub-nav').hide();
            $('.build-table .dots-loader').remove();
            $('.js-antispected-actions').show();
            $('.js-buildto-head').html(timeHeaderHtml);
            $('.js-buildto-body').html(productsHtml);
            $('.js-buildto-body').closest('.table').removeClass('freeze-table');
            $('.js-table-reponsive').removeAttr("style");
            $('.js-table-reponsive').css('', 0);
        }
    });
}


$(document).delegate('.js-perishableData', 'click', function(ev) {
    ev.preventDefault();
    if ($(this).find('div').hasClass('table-select')) {
        $(this).find('div').removeClass('table-select');
        var columnNo = $(this).index();
        $(this).closest("table")
            .find("tr td:nth-child(" + (columnNo + 1) + ") input")
            .removeClass('table-select');

        $(this).closest('table').find('tbody tr').each(function() {
            var rowSum = 0;
            $(this).find('td').each(function() {
                if ($(this).find('input').hasClass('table-select')) {
                    rowSum = rowSum + parseInt($(this).find('input').val());
                }
            });
            if (rowSum > 0) {
                $(this).find('td.js-anticipatedTotal input').val(rowSum);
            } else {
                $(this).find('td.js-anticipatedTotal input').val('');
            }
        });
    } else {
        $(this).find('div').addClass('table-select');
        var columnNo = $(this).index();
        $(this).closest("table")
            .find("tr td:nth-child(" + (columnNo + 1) + ") input")
            .addClass('table-select');

        $(this).closest('table').find('tbody tr').each(function() {
            var rowSum = 0;
            $(this).find('td').each(function() {
                if ($(this).find('input').hasClass('table-select')) {
                    rowSum = rowSum + parseInt($(this).find('input').val());
                }
            });
            if (rowSum > 0) {
                $(this).find('td.js-anticipatedTotal input').val(rowSum);
            } else {
                $(this).find('td.js-anticipatedTotal input').val('');
            }
        })
    }
});
