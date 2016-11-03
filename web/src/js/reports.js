var stateObject = {};
$(document).ready(function() {
  if ($('#js-select-store').val() === 0) {
    $('.aside--logo').find('img').attr('src', 'images/logo.png');
  }
  $.get('/src/js/views/adminFinishedgoods.hbs', function(data) {
    wasteReportFinishedTemplate = Handlebars.compile(data);
  });


  $.get('/src/js/views/adminIngredients.hbs', function(data) {
    wasteReportIngredientTemplate = Handlebars.compile(data);
  });

  $.get('/src/js/views/inspectionAdminTable.hbs', function(data) {
    inspectionsTemplate = Handlebars.compile(data);
  });


  var start_date = moment().startOf('week').format("LL");
  var end_date = moment().format("LL")
  $('.js-report-text').html('Reports from ' + start_date + ' To ' + end_date);
  loadStores();
  loadPullSheetTabs();
  $('#js-user-name').text($.cookie('user').username + '-' + $.cookie('user').role);
  $('#js-user-role').text($.cookie('user').role);
  $('#js-today-date').text(moment().format("MMM Do YYYY"));
  $(document).delegate('.fa-calendar', 'click', function(ev) {
    //Trigger the event on the next element.
    $(ev.target).next().trigger('select');
  });
  $('.js-side-sub-nav li').on('click', function(ev) {
    ev.preventDefault();
    $('.js-side-sub-nav li').removeClass('active');
    $(ev.target).closest('li').addClass('active');
  });
  $('#js-select-store').on('change', function(ev) {
    $('.js-side-nav li').css('pointer-events', '');
    //updateCookie($('#js-select-store').val());
  $('#store-name').html('Store '+$(ev.target).val());
    if ($('#js-select-store').val() != 0) {
      $('.js-admin-main-nav').removeClass('active');
      $('.js-admin-main-nav').find("a[data-url='anticipatedsales']").parent().addClass('active');
      $('.js-admin-wastage-div').hide();
      $("#settings-reports").hide();
      $('#js-admin-settings').parent().removeClass('active');
      $('#js-ordermanage').parent().removeClass('active');
      $('#js-admin-ccWorkbooks').parent().removeClass('active');
      $('#js-admin-settings-pop').hide();
      $('.js-admin-inspection-div').hide();
      $('#js-admin-settings-pop').hide();
      $('.js-admin-temperature-div').hide();
      $('.js-admin-antispated-div').hide();
      $('.js-admin-threshold-div').hide();
      $('.js-admin-order-management-div').hide();

      var defered1 = $.ajax({
        type: "GET",
        url: apiURL + "/admin/getStoreDetails",
        data: {
          "store_id": $('#js-select-store').val()
        },
        contentType: "application/json; charset=utf-8"
      });
      $.when(defered1).then(function(v1) {
        var storedata = {
          store: v1.response
        };
        var StoreDetails = {};
        StoreDetails.storeID = $('#js-select-store').val();
        for (var i = 0; i < storedata.store.length; i++) {
          if (storedata.store[i].profile_name === "Capital City") {
            StoreDetails.capitalCity = true;
          } else if (storedata.store[i].profile_name == "Roller Grills") {
            StoreDetails.rollerGrills = true;
          } else if (storedata.store[i].profile_name == "Perishable Goods") {
            StoreDetails.perishableGoods = true;
          }
        }
        window.StoreDetails = StoreDetails;
        $('.js-admin-antispated-div').show();
        $('.js-store-main-div').hide()
        $('.js-admin-wastage-div').hide();
        $('#js-admin-settings-pop').hide();
        $('.js-admin-inspection-div').hide();
        $('#js-admin-settings-pop').hide();
        $('.js-admin-temperature-div').hide();
        $('.js-admin-threshold-div').hide();
        $('.js-admin-pullover-div').hide();
        $('.js-admin-order-management-div').hide();
        if (window.StoreDetails.capitalCity && !window.StoreDetails.rollerGrills && !window.StoreDetails.perishableGoods) {
          // Here you show only capitalcity items
          $('.aside--logo').find('img').attr('src', 'images/capitalcity_logo.png');
          $('.js-admin-main-nav').find('[data-url="thresholdreport"]').parent().hide();
          $('.js-admin-main-nav').find('[data-url="pulloversheets"]').parent().hide();
          // admin anticipated sales
          $('.js-store-nav li').removeClass('active')
          $('#js-antispected-roller').hide();
          $("#settings-reports").hide();
          $('#js-antispected-freshproducts').hide();
          $('#js-antispected-capitalcity').show();
          $('#js-antispected-capitalcity').addClass('active');
          $('.js-antispated-sub-nav').show();
          // admin waste cost
          $('.js-wastage-main-nav li').removeClass('active');
          $('#js-capital-finishedgoods').show();
          $('#js-capital-finishedgoods').addClass('active');
          $('#js-capital-ingredients').show();
          $('#js-roller-finishedgoods').hide();
          $('#js-roller-ingredients').hide();
          $('#js-fresh-products').hide();
          // admin temperature
          $('.js-temp-main-nav li').removeClass('active')
          $('#js-capitalCity-product').show();
          $('#js-capitalCity-product').addClass('active');
          $('#js-capitalCity-equipment').show();
          $('#js-temp-rollerGrillProducts-li').hide();
          $('#js-temp-freshProducts-li').hide();

        } else if (!window.StoreDetails.capitalCity && window.StoreDetails.rollerGrills && !window.StoreDetails.perishableGoods) {
          // Here you show only rollergrills items
          $('.aside--logo').find('img').attr('src', 'images/roller.png');
          $('.js-admin-main-nav').find('[data-url="thresholdreport"]').parent().show();
          $('.js-admin-main-nav').find('[data-url="pulloversheets"]').parent().show();
          // admin anticipated sales
          $('.js-store-nav li').removeClass('active')
          $('#js-antispected-roller').show();
          $('#js-antispected-roller').addClass('active');
          $('#js-antispected-freshproducts').hide();
          $("#settings-reports").hide();
          $('#js-antispected-capitalcity').hide();
          $('.js-antispated-sub-nav').hide();
          // admin waste cost
          $('.js-wastage-main-nav li').removeClass('active');
          $('#js-capital-finishedgoods').hide();
          $('#js-capital-ingredients').hide();
          $('#js-roller-finishedgoods').show();
          $('#js-roller-finishedgoods').addClass('active');
          $('#js-roller-ingredients').show();
          $('#js-fresh-products').hide();
          // admin temperature
          $('.js-temp-main-nav li').removeClass('active')
          $('#js-capitalCity-product').hide();
          $('#js-capitalCity-equipment').hide();
          $('#js-temp-rollerGrillProducts-li').show();
          $('#js-temp-rollerGrillProducts-li').addClass('active');
          $('#js-temp-freshProducts-li').hide();
        } else if (!window.StoreDetails.capitalCity && !window.StoreDetails.rollerGrills && window.StoreDetails.perishableGoods) {
          // Here you show only perishableGoods items
          $('.aside--logo').find('img').attr('src', 'images/perishable.png');
          $('.aside--logo').find('img').css('width','200px');
          //$('.js-admin-main-nav').find('[data-url=inspection]').parent().hide();
          $('.js-admin-main-nav').find('[data-url="thresholdreport"]').parent().hide();
          $('.js-admin-main-nav').find('[data-url="pulloversheets"]').parent().hide();
          // admin anticipated sales
          $('.js-store-nav li').removeClass('active')
          $('#js-antispected-roller').hide();
          $('#js-antispected-freshproducts').show();
          $('#js-antispected-freshproducts').addClass('active');
          $('#js-antispected-capitalcity').hide();
          $("#settings-reports").hide();
          $('.js-antispated-sub-nav').hide();
          // admin waste cost
          $('.js-wastage-main-nav li').removeClass('active');
          $('#js-capital-finishedgoods').hide();
          $('#js-capital-ingredients').hide();
          $('#js-roller-finishedgoods').hide();
          $('#js-roller-ingredients').hide();
          $('#js-fresh-products').show();
          $('#js-fresh-products').addClass('active');
          // admin temperature
          $('.js-temp-main-nav li').removeClass('active')
          $('#js-capitalCity-product').hide();
          $('#js-capitalCity-equipment').hide();
          $('#js-temp-rollerGrillProducts-li').hide();
          $('#js-temp-freshProducts-li').show();
          $('#js-temp-freshProducts-li').addClass('active');
        } else if (window.StoreDetails.capitalCity && window.StoreDetails.rollerGrills && !window.StoreDetails.perishableGoods) {
          // Here you show both capitalcity items & rollerGrill items
          $('.aside--logo').find('img').attr('src', 'images/capitalcity_logo.png');
          $('.js-admin-main-nav').find('[data-url="thresholdreport"]').parent().show();
          $('.js-admin-main-nav').find('[data-url="pulloversheets"]').parent().show();
          // admin anticipated sales
          $('.js-store-nav li').removeClass('active')
          $('#js-antispected-capitalcity').show();
          $('#js-antispected-capitalcity').addClass('active');
          $('.js-antispated-sub-nav').show();
          $('#js-antispected-roller').show();
          $('#js-antispected-freshproducts').hide();
          $("#settings-reports").hide();
          // admin waste cost
          $('.js-wastage-main-nav li').removeClass('active');
          $('#js-capital-finishedgoods').show();
          $('#js-capital-finishedgoods').addClass('active');
          $('#js-capital-ingredients').show();
          $('#js-roller-finishedgoods').show();
          $('#js-roller-ingredients').show();
          $('#js-fresh-products').hide();
          // admin temperature
          $('.js-temp-main-nav li').removeClass('active')
          $('#js-capitalCity-product').show();
          $('#js-capitalCity-product').addClass('active');
          $('#js-capitalCity-equipment').show();
          $('#js-temp-rollerGrillProducts-li').show();
          $('#js-temp-freshProducts-li').hide();
        } else if (!window.StoreDetails.capitalCity && window.StoreDetails.rollerGrills && window.StoreDetails.perishableGoods) {
          // Here you show both rollerGrill items & perishableGoods
          $('.aside--logo').find('img').attr('src', 'images/roller.png');
          $('.js-admin-main-nav').find('[data-url="thresholdreport"]').parent().show();
          $('.js-admin-main-nav').find('[data-url="pulloversheets"]').parent().show();
          // admin anticipated sales
          $('.js-store-nav li').removeClass('active')
          $('#js-antispected-capitalcity').hide();
          $('.js-antispated-sub-nav').hide();
          $('#js-antispected-roller').show();
          $('#js-antispected-roller').addClass('active');
          $('#js-antispected-freshproducts').show();
          $("#settings-reports").hide();
          // admin waste cost
          $('.js-wastage-main-nav li').removeClass('active');
          $('#js-capital-finishedgoods').hide();
          $('#js-capital-ingredients').hide();
          $('#js-roller-finishedgoods').show();
          $('#js-roller-finishedgoods').addClass('active');
          $('#js-roller-ingredients').show();
          $('#js-fresh-products').show();
          // admin temperature
          $('.js-temp-main-nav li').removeClass('active')
          $('#js-capitalCity-product').hide();
          $('#js-capitalCity-equipment').hide();
          $('#js-temp-rollerGrillProducts-li').show();
          $('#js-temp-rollerGrillProducts-li').addClass('active');
          $('#js-temp-freshProducts-li').show();
        } else if (window.StoreDetails.capitalCity && !window.StoreDetails.rollerGrills && window.StoreDetails.perishableGoods) {
          // Here you show both capitalCity items & perishableGoods
          $('.aside--logo').find('img').attr('src', 'images/capitalcity_logo.png');
          $('.js-admin-main-nav').find('[data-url="thresholdreport"]').parent().hide();
          $('.js-admin-main-nav').find('[data-url="pulloversheets"]').parent().hide();
          // admin anticipated sales
          $('.js-store-nav li').removeClass('active')
          $('#js-antispected-capitalcity').show();
          $('#js-antispected-capitalcity').addClass('active');
          $('.js-antispated-sub-nav').show();
          $('#js-antispected-roller').hide();
          $('#js-antispected-freshproducts').show();
          $("#settings-reports").hide();
          // admin waste cost
          $('.js-wastage-main-nav li').removeClass('active');
          $('#js-capital-finishedgoods').show();
          $('#js-capital-finishedgoods').addClass('active');
          $('#js-capital-ingredients').show();
          $('#js-roller-finishedgoods').hide();
          $('#js-roller-ingredients').hide();
          $('#js-fresh-products').show();
          // admin temperature
          $('.js-temp-main-nav li').removeClass('active')
          $('#js-capitalCity-product').show();
          $('#js-capitalCity-product').addClass('active');
          $('#js-capitalCity-equipment').show();
          $('#js-temp-rollerGrillProducts-li').hide();
          $('#js-temp-freshProducts-li').show();
        } else if (window.StoreDetails.capitalCity && window.StoreDetails.rollerGrills && window.StoreDetails.perishableGoods) {
          // Here we show all the profiles
          $('.aside--logo').find('img').attr('src', 'images/capitalcity_logo.png');
          $('.js-admin-main-nav').find('[data-url="thresholdreport"]').parent().show();
          $('.js-admin-main-nav').find('[data-url="pulloversheets"]').parent().show();
          // admin anticipated sales
          $('.js-store-nav li').removeClass('active')
          $('#js-antispected-capitalcity').show();
          $('#js-antispected-capitalcity').addClass('active');
          $('.js-antispated-sub-nav').show();
          $('#js-antispected-roller').show();
          $('#js-antispected-freshproducts').show();
          $("#settings-reports").hide();
          // admin waste cost
          $('.js-wastage-main-nav li').removeClass('active');
          $('#js-capital-finishedgoods').show();
          $('#js-capital-finishedgoods').addClass('active');
          $('#js-capital-ingredients').show();
          $('#js-roller-finishedgoods').show();
          $('#js-roller-ingredients').show();
          $('#js-fresh-products').show();
          // admin temperature
          $('.js-temp-main-nav li').removeClass('active')
          $('#js-capitalCity-product').show();
          $('#js-capitalCity-product').addClass('active');
          $('#js-capitalCity-equipment').show();
          $('#js-temp-rollerGrillProducts-li').show();
          $('#js-temp-freshProducts-li').show();
        }
        $("#js-reports-main").show();
        $("#sub1").show();
        // need to show aniticipatd sales by default on the selectstore
        if ($('.js-store-nav li.active').attr('data-value') == 'capitalCity') {
          buildto('2');
        } else if ($('.js-store-nav li.active').attr('data-value') == 'rollerGrills') {
          buildtoRollerGrill('7');
        } else if ($('.js-store-nav li.active').attr('data-value') == 'Perishable Goods') {
          buildtoFreshproducts('8');
        }

      });
    } else {
      $('.aside--logo').find('img').attr('src', 'images/logo.png');
      $('.js-store-main-div').show();
      $('.js-admin-wastage-div').hide();
      $('.js-admin-temperature-div').hide();
      $('.js-admin-inspection-div').hide();
      $('.js-admin-antispated-div').hide();
      $('.js-admin-threshold-div').hide();
      $('.js-admin-order-management-div').hide();
      $('#js-admin-settings-pop').hide();
    }
  });
  //js-wastage-main-nav js-wastage-sub-nav
  $('.js-wastage-main-nav li').click(function(ev) {
    ev.preventDefault();
    $('.js-wastage-main-nav li').removeClass('active');
    $(ev.target).closest('li').addClass('active');
    stateObject.mainCategory = $(ev.target).closest('li').find('a').data('value');
    if (stateObject.mainCategory === 'Ingredients') {
      loadIngredients();
    } else {
      loadProductWaste();
    }
  });
  $('.js-wastage-reports-stats li').on('click', function(ev) {
    ev.preventDefault();
    $('.js-wastage-reports-stats li').removeClass('active');
    $(ev.target).parent('li').addClass('active');
    var type = $(ev.target).html();
    $('#js-dropdown-button').html($(ev.target).html() + ' <span class="caret"></span>');
    if (type == 'Weekly') {
      var start_date = moment().startOf('week').format("LL");
      var end_date = moment().format("LL")
      $('.js-report-text').html('Reports from ' + start_date + ' To ' + end_date);
    } else if (type == 'Monthly') {
      var start_date = moment().startOf('month').format("LL");
      var end_date = moment().format("LL");
      $('.js-report-text').html('Reports from ' + start_date + ' To ' + end_date);
    } else if (type == 'Daily') {
      var start_date = moment().format("LL");
      $('.js-report-text').html('Reports for ' + start_date);
    } else if (type == 'Custom') {
      $('.js-report-text').html('From: <input type="text" id="js-custom-start-date" style="height:35px" readonly="readonly"/>     To: <input type="text" id="js-custom-end-date" style="height:35px" readonly="readonly"/>');
      $('#js-custom-start-date').datetimepicker({
        format: 'MMM Do YYYY',
        ignoreReadonly: true,
        maxDate: moment()
      });
      $('#js-custom-end-date').datetimepicker({
        format: 'MMM Do YYYY',
        ignoreReadonly: true,
        useCurrent: false,
        maxDate: moment()
      });
    }
  });
  $(document).delegate("#js-custom-start-date", "dp.change", function(e) {
    $('#js-custom-end-date').data("DateTimePicker").minDate(e.date);
  });
  $(document).delegate("#js-custom-end-date", "dp.change", function(e) {
    $('#js-custom-start-date').data("DateTimePicker").maxDate(e.date);
  });
  $(document).delegate('#js-custom-start-date', 'click', function(ev) {
    $('.picker-switch').css('pointer-events', 'none');
  });
  $(document).delegate('#js-custom-end-date', 'click', function(ev) {
    $('.picker-switch').css('pointer-events', 'none');
  });
  $('.dropdown-inspect-menu li').on('click', function(ev) {
    ev.preventDefault();
    $('.dropdown-inspect-menu li').removeClass('active');
    $(ev.target).parent('li').addClass('active');
    var type = $(ev.target).html();
    $('#js-dropdown-inspection-button').html($(ev.target).html() + ' <span class="caret"></span>');
    loadResults()
  });
  $('.js-getreport-by-date').on('click', function(ev) {
    ev.preventDefault();
    if (stateObject.mainCategory === 'Ingredients') {
      loadIngredients();
    } else {
      loadProductWaste();
    }
  });
});

function loadResults() {
  if ($('#js-select-store').val() != 0) {
    var defered1 = $.ajax({
      type: "GET",
      url: apiURL + "/inspection/results",
      data: {
        "storeid": $('#js-select-store').val()
      },
      contentType: "application/json; charset=utf-8"
    });
  }

  $.when(defered1).then(function(v1) {
    if (v1) {
      var productdata = {
        inspections: v1.response
      };
      var productsHtml = inspectionsTemplate(productdata);
      $('.js-inspection-results-body').html(productsHtml);
      $('#js-inspection-run-report').hide();
      $('.js-admin-wastage-div').show();
    }
  }, function(err) {
    console.error(err);
  });

}


function loadProductWaste() {
  var selection = $('.js-wastage-reports-stats li.active').find('a').html();
  if (selection === 'Weekly') {
    var start_date = moment().startOf('week').format("YYYY-MM-DD");
    var end_date = moment().format("YYYY-MM-DD")
  } else if (selection === 'Monthly') {
    var start_date = moment().startOf('month').format("YYYY-MM-DD");
    var end_date = moment().format("YYYY-MM-DD");
  } else if (selection === 'Daily') {
    var start_date = moment().format("YYYY-MM-DD");
    var end_date = moment().format("YYYY-MM-DD");
  } else if (selection === 'Custom') {
    var start_date = moment($('#js-custom-start-date').val(), 'MMM Do YYYY').format("YYYY-MM-DD");
    var end_date = moment($('#js-custom-end-date').val(), 'MMM Do YYYY').format("YYYY-MM-DD");
  }
  var defered1 = $.ajax({
    type: "GET",
    url: apiURL + "/products/waste/reports",
    data: {
      "product_type": $('.js-wastage-main-nav li.active a').attr('data-value'),
      "storeid": $('#js-select-store').val(),
      'start_date': start_date,
      'end_date': end_date
    },
    contentType: "application/json; charset=utf-8"
  });
  $.when(defered1).then(function(v1) {
    // var productdata = {
    //   productwastage: v1.response
    // };
    var productwastageArray = [];
    var productWastage = v1.response;
    $.each(productWastage, function(i, obj) {
      productWaste = {};
      productWaste.category_name = obj.category;
      var wasteCount = 0;
      var ttalcost = 0;
      $.each(obj.products, function(i, obj) {
        wasteCount = new Number(wasteCount) + new Number(obj.productwastecount);
        ttalcost = new Number(new Number(ttalcost) + new Number(obj.productwastetotalcost)).toFixed(4);
      });
      productWaste.wastecount = wasteCount.toFixed(4);
      productWaste.wastettalcost = ttalcost;
      productWaste.products = obj.products;
      productWaste.type = $('.js-wastage-main-nav li.active').find('a').text();
      productwastageArray.push(productWaste);
    });

    var productdata = {
      productwastage: productwastageArray
    };
  var productsHtml = wasteReportFinishedTemplate(productdata);
    $('#accordion').html(productsHtml);

    var totalWaste = 0;
    var totalWasteAmount = 0;
    _.each(productwastageArray, function(elem, index, list) {
      totalWaste = new Number(totalWaste) + new Number(elem.wastecount);
      totalWasteAmount = new Number(new Number(totalWasteAmount) + new Number(elem.wastettalcost)).toFixed(4);
    });
    $('#total-finished-goods').text(totalWaste.toFixed(0));
    $('#total-finished-goods-cost').text(totalWasteAmount);
  }, function(err) {
    console.error(err);

  });

}

function loadStores() {
  var defered1 = $.ajax({
    type: "GET",
    url: apiURL + "/admin/stores",
    contentType: "application/json; charset=utf-8"
  });
  $.when(defered1).then(function(v1) {
    //console.log(v1);
    var options = [];
    var select = $('#js-select-store');
    if (select.prop) {
      options = select.prop('options');
    } else {
      options = select.attr('options');
    }

    $.each(v1.response, function(i, record) {
      options[options.length] = new Option('STORE ' + record.store_id, record.store_id);
    });

  }, function(err) {
    console.error(err);

  });
}

function loadIngredients() {
  var selection = $('.js-wastage-reports-stats li.active').find('a').html();
  if (selection === 'Weekly') {
    var start_date = moment().startOf('week').format("YYYY-MM-DD");
    var end_date = moment().format("YYYY-MM-DD")
  } else if (selection === 'Monthly') {
    var start_date = moment().startOf('month').format("YYYY-MM-DD");
    var end_date = moment().format("YYYY-MM-DD");
  } else if (selection === 'Daily') {
    var start_date = moment().format("YYYY-MM-DD");
    var end_date = moment().format("YYYY-MM-DD");
  } else if (selection === 'Custom') {
    var start_date = moment($('#js-custom-start-date').val(), 'MMM Do YYYY').format("YYYY-MM-DD");
    var end_date = moment($('#js-custom-end-date').val(), 'MMM Do YYYY').format("YYYY-MM-DD");
  }
  var defered1 = $.ajax({
    type: "GET",
    url: apiURL + "/products/waste/reports",
    data: {
      "product_type": stateObject.mainCategory,
      "storeid": $('#js-select-store').val(),
      'start_date': start_date,
      'end_date': end_date
    },
    contentType: "application/json; charset=utf-8"
  });
  $.when(defered1).then(function(v1) {
    var productwastageArray = [];
    var productWastage = v1.response;
    $.each(productWastage, function(i, obj) {
      productWaste = {};
      productWaste.category_name = obj.category;
      var wasteCount = 0;
      var ttalcost = 0;
      $.each(obj.products, function(i, obj) {
        wasteCount = new Number(new Number(wasteCount) + new Number(obj.productwastecount)).toFixed(4);
        ttalcost = new Number(new Number(ttalcost) + new Number(obj.productwastetotalcost)).toFixed(4);
      });
      productWaste.wastecount = wasteCount;
      productWaste.wastettalcost = ttalcost;
      productWaste.products = obj.products;

      productwastageArray.push(productWaste);
    });

    var productdata = {
      productwastage: productwastageArray
    };


    var productsHtml = wasteReportIngredientTemplate(productdata);
    $('#accordion').html(productsHtml);

    var totalWaste = 0;
    var totalWasteAmount = 0;
    _.each(productwastageArray, function(elem, index, list) {
      totalWaste = new Number(new Number(totalWaste) + new Number(elem.wastecount)).toFixed(4);
      totalWasteAmount = new Number(new Number(totalWasteAmount) + new Number(elem.wastettalcost)).toFixed(4);
    });
    $('#total-finished-goods').text(totalWaste);
    $('#total-finished-goods-cost').text(totalWasteAmount);

  }, function(err) {
    console.error(err);
  });

}

function AdminStoresList() {
  var defered1 = $.ajax({
    type: "GET",
    url: apiURL + "/products/waste/reports",
    data: {
      "product_type": stateObject.mainCategory,
      "storeid": $('#js-select-store').val()
    },
    contentType: "application/json; charset=utf-8"
  });
  $.when(defered1).then(function(v1) {
    var productdata = {
      productwastage: v1.response
    };
    var productsHtml = wasteReportIngredientTemplate(productdata);
    $('#accordion').html(productsHtml);

  }, function(err) {
    console.error(err);
  });

}
