var stateObject = {};
$(document).ready(function() {
  if ($.cookie('user').storeid && $.cookie('user').role === "Employee") {
    document.title = "Employee";
  } else if ($.cookie('user').storeid && $.cookie('user').role === "Manager") {
    document.title = "Manager";
  }
  //loadRollerTimeSlots();
  $('#js-recordTemperature-today-day').text(moment().format('dddd'));
  $('#js-temperature-today-day').text(moment().format('dddd'));
  $('.js-temp-sub-nav').hide();
  if (stateObject.tempMainCategory == 'Roller Grill Products' || stateObject.tempMainCategory == 'Perishable Goods') {
    if (stateObject.category_time_id && stateObject.category_time_id == "") {
      stateObject.category_time_id = "";
    }
  }
  if (stateObject.tempMainCategory == 'Equipment' || stateObject.tempMainCategory == 'Product') {
    stateObject.category_time_id = "";
  }
  stateObject.tempSubCategory = "Open";

  if ($.cookie('user').role == 'Admin') {
    tempProdTemplate = MyApp.templates.tempAdmin;
  } else {
    tempProdTemplate = MyApp.templates.temp_names;
  }

  $('#js-today-date-tmp,#js-today-date-admin-tmp').text(moment().format("MMM Do YYYY"));
  $('#js-today-date-tmp,#js-today-date-admin-tmp').val(moment().format("MMM Do YYYY"));
  $('#js-today-date-tmp').datetimepicker({
    minDate: moment().subtract(1, 'month').format('MM DD YYYY'),
    ignoreReadonly: true,
    format: 'MMM Do YYYY',
    maxDate: moment()
  });
  $('#js-today-date-admin-tmp').datetimepicker({
    ignoreReadonly: true,
    format: 'MMM Do YYYY',
    maxDate: moment()
  });
  $('#js-today-date-tmp,#js-today-date-admin-tmp').on('dp.change', function(ev) {
    if ($('#js-today-date-admin-tmp').val()) {
      $('#js-temperature-today-day').text(moment($('#js-today-date-admin-tmp').val(), 'MMM Do YYYY').format('dddd'));
    } else if ($('#js-today-date-tmp').val()) {
      $('#js-recordTemperature-today-day').text(moment($('#js-today-date-tmp').val(), 'MMM Do YYYY').format('dddd'));
    }
    stateObject.tempMainCategory = $('.js-temp-main-nav li.active a').data('value');
    if (stateObject.tempMainCategory === 'Equipment') {
      loadEquipments();
      $('.temperature').append('<div class="col-lg-offset-5 dots-loader spinner-div-style">Loading…</div>');
    } else if (stateObject.tempMainCategory === 'Roller Grill Products') {
      rollerTimeStampTab(stateObject.category_time_id);
      //loadRollerTimeSlots();
    } else if (stateObject.tempMainCategory === 'Perishable Goods') {
      loadTempFreshProducts();
    } else {
      loadProducts();
      $('.temperature').append('<div class="col-lg-offset-5 dots-loader spinner-div-style">Loading…</div>');
    }
  });

  $('.js-temp-body').delegate('.js-temp-time-temp', 'keyup', function(ev) {
    if ($(this).val()) {
      $(this).closest('tr').find('td:last').find('.js-temp-time-field').text(moment().format("HH:mm"));
    } else {
      $(this).closest('tr').find('td:last').find('.js-temp-time-field').text('');
    }
  });

  $('#js-temperature-div').delegate('.js-product-temp-entry', 'keyup', function(ev) {
    if ($(this).hasClass('error-whole-number')) {
      $(this).removeClass('error-whole-number');
    }
  });

  $('.js-temp-body').delegate('.js-product-temp-entry-initials', 'keypress', function(ev) {
    if (ev.which === 13) {
      var tabindex = parseInt($(this).attr('tabindex')) + 1;
      console.log(tabindex);
      console.log($('.js-temp-body').find('input[tabindex="' + tabindex + '"]'));
      $('.js-temp-body').find('input[tabindex="' + tabindex + '"]').focus();
    }
  });

  //js-temp-main-nav js-temp-sub-nav
  // $('.js-temp-main-nav li').click(function(ev) {
  //   ev.preventDefault();
  //   $('.js-temp-main-nav li').removeClass('active');
  //   $(ev.target).closest('li').addClass('active');
  //   stateObject.tempMainCategory = $(ev.target).closest('li').find('a').data('value');
  //   console.log(stateObject);
  //   if (stateObject.tempMainCategory === 'Equipment') {
  //     loadEquipments();
  //     $('.js-temp-roller-sub-nav').hide();
  //   } else if (stateObject.tempMainCategory === 'Roller Grill Products') {
  //     $('.js-temp-roller-sub-nav').show();
  //     //loadRollerTimeSlots();
  //   } else {
  //     $('.js-temp-roller-sub-nav').hide();
  //     loadProducts();
  //   }
  //   $('.temperature .dots-loader').remove();
  //   $('.js-temp-actions').hide();
  //   //$('.temperature .js-temp-head').html('');
  //   $('.temperature .js-temp-body').html('');
  //   $('.temperature').append('<div class="col-lg-offset-5 dots-loader spinner-div-style">Loading…</div>');
  // });

  // $('.js-temp-sub-nav li').click(function(ev) {
  //   ev.preventDefault();
  //   $('.js-temp-sub-nav li').removeClass('active');
  //   $(ev.target).closest('li').addClass('active');
  //   stateObject.tempSubCategory = $(ev.target).closest('li').data('value');
  //   if (stateObject.tempMainCategory === 'Equipment') {
  //     loadEquipments();
  //   } else {
  //     loadProducts();
  //   }
  //   $('.temperature .dots-loader').remove();
  //   $('.js-temp-actions').hide();
  //   //$('.temperature .js-temp-head').html('');
  //   $('.temperature .js-temp-body').html('');
  //   $('.temperature').append('<div class="col-lg-offset-5 dots-loader spinner-div-style">Loading…</div>');
  // });

  $('.js-product-temp-complete').on('click', function(ev) {
    ev.preventDefault();
    $('#confirmationAction-temperature').modal('show');
    //saveEquipmentTemp('complete');
  });
  $('.js-product-temp-save').on('click', function(ev) {
    ev.preventDefault();
    $('.js-product-temp-save').button('loading');
    saveEquipmentTemp('draft');
  });

  $('#js-complete-temperature').on('click', function(ev) {
    ev.preventDefault();
    saveEquipmentTemp('complete');
  });


});


function saveEquipmentTemp(status) {
  $('#confirmationAction-temperature').modal('hide');
  var productWasteArray = [];
  var allValid = true;
  var notifyMsg = false;

  $('.js-temp-body').find('.js-temp-row').each(function(index, el) {
    var equipmentTemp = {};
    equipmentTemp.product_id = $($(el).find('td')[0]).data('product-id');
    equipmentTemp.store_id = parseInt($.cookie('user').storeid);
    equipmentTemp.product_availability_id = $($(el).find('td')[0]).data('product-availability-id');
    var $tempInput = $($(el).find('td input')[0]);
    if ($(el).find('td input#getTemp').data('temp-id')) {
      if ($tempInput.val()) {
        equipmentTemp.temperature = parseFloat($tempInput.val());
      } else {
        equipmentTemp.temperature = "empty";
      }
    } else {
      equipmentTemp.temperature = parseFloat($tempInput.val());
    }
    var initials = $($(el).find('td input')[1]).val();
    var initialsTrue = false;
    if (equipmentTemp.temperature == "empty" && initials == '') {
      initialsTrue = true;
      equipmentTemp.initials = true;
    } else if (equipmentTemp.temperature == "empty" && initials != '') {
      equipmentTemp.temperature = '';
      initialsTrue = true;
      equipmentTemp.initials = initials.trim();
    } else if (initials) {
      if (/^[a-zA-Z ]*$/.test(initials)) {
        initialsTrue = true;
        equipmentTemp.initials = initials.trim();
      }
    }




    equipmentTemp.status = status;
    if (stateObject.tempMainCategory == 'Perishable Goods') {
      if (stateObject.pershible_category_time_id == '') {
        equipmentTemp.availability_category_times_id = null;
      } else {
        equipmentTemp.availability_category_times_id = stateObject.pershible_category_time_id;
      }
    } else {
      if (stateObject.category_time_id == '') {
        equipmentTemp.availability_category_times_id = null;
      } else {
        equipmentTemp.availability_category_times_id = stateObject.category_time_id;
      }
    }


    if ($($(el).find('td input')[0]).data('temp-id')) {
      equipmentTemp.temp_id = $($(el).find('td input')[0]).data('temp-id');
    } else {
      equipmentTemp.temp_id = 0;
    }
    if ($(el).find('td:last').find('.js-temp-time-field').text()) {
      equipmentTemp.temp_time = $(el).find('td:last').find('.js-temp-time-field').text();
    } else {
      equipmentTemp.temp_time = moment().format("HH:mm:ss");
    }
    equipmentTemp.waste_reported_date = moment($('#js-today-date-tmp').val(), 'MMM Do YYYY').format('YYYY-MM-DD');

    var tempNegative = true;

    if ((stateObject.tempMainCategory === 'Product' || stateObject.tempMainCategory === 'Roller Grill Products' || stateObject.tempMainCategory === 'Perishable Goods') && equipmentTemp.temperature) {
      if (equipmentTemp.temperature == 'empty') {

      } else if (equipmentTemp.temperature < 0) {
        allValid = false;
        tempNegative = false;
        $($(el).find('td input')[0]).addClass('error-whole-number');
        if ($('.ui-pnotify').length <= 1) {
          //console.log($('.ui-pnotify').length);
          notifyMsg = true;
        }
      }
    }

    if (equipmentTemp.temperature && initialsTrue && !$tempInput.prop('disabled') && tempNegative) {
      productWasteArray.push(equipmentTemp);
      //if (status === 'complete') {
      //$(el).find('input').prop('disabled', true);
      //}
    } else if (equipmentTemp.temperature && !initialsTrue) {
      allValid = false;
      $($(el).find('td input')[1]).addClass('error-whole-number');
      if ($('.ui-pnotify').length <= 1) {

        notifyMsg = true;
      }

    } else if (!equipmentTemp.temperature && equipmentTemp.initials) {
      allValid = false;
      $($(el).find('td input')[0]).addClass('error-whole-number');
      if ($('.ui-pnotify').length <= 1) {

        notifyMsg = true;

      }

    }
  });
  if (notifyMsg) {
    new PNotify({
      title: 'Error',
      text: 'Please fix the data fields highlighted in red.',
      type: 'error',
      styling: 'fontawesome',
      hide: true,
      delay: 2000
    });
    $('.js-product-temp-save').button('reset');
  }
  if (allValid && productWasteArray.length > 0) {
    if (stateObject.tempMainCategory === 'Equipment') {
      //$('.js-product-temp-save').button('loading');
      $.ajax({
        type: "POST",
        url: apiURL + "/temparature/equipment/save",
        data: JSON.stringify(productWasteArray),
        contentType: "application/json; charset=utf-8",
        success: function(response) {
          if (status == "draft") {
            var test = "Saved but not completed."
          } else {
            var test = "Record Temperature has been completed successfully."
            $('.js-product-temp-save').button('reset');
          }
          $('#confirmationAction-temperature').modal('hide');
          $('.js-product-temp-save').button('reset');
          new PNotify({
            title: 'Success!',
            text: test,
            type: 'success',
            styling: 'fontawesome',
            hide: true,
            delay: 2000
          });
            $('.js-product-temp-save').button('reset');
          loadEquipments();
        },
        error: function(err) {
          $('.js-product-temp-save').button('reset');
          new PNotify({
            title: 'Error',
            text: 'Enter Valid Number',
            type: 'error',
            styling: 'fontawesome',
            hide: true,
            delay: 2000
          });
          $('.js-product-temp-save').button('reset');
        }
      });
    } else {
      $.ajax({
        type: "POST",
        url: apiURL + "/temparature/products",
        data: JSON.stringify(productWasteArray),
        contentType: "application/json; charset=utf-8",
        success: function(response) {
          if (status == "draft") {
            var test = "Saved but not completed."
          } else {
            var test = "Record Temperature has been completed successfully."
            $('.js-product-temp-save').button('reset');
          }
          // $('.js-product-temp-save').button('reset');
          new PNotify({
            title: 'Success!',
            text: test,
            type: 'success',
            styling: 'fontawesome',
            hide: true,
            delay: 2000
          });
          $('.js-product-temp-save').button('reset');
          if (stateObject.tempMainCategory === 'Roller Grill Products') {
            $('.js-temp-roller-sub-nav').show();
            rollerTimeStampTab(stateObject.category_time_id);
          } else if (stateObject.tempMainCategory === 'Perishable Goods') {
            loadTempFreshProducts();
          } else {
            $('.js-today-date-admin-tmp').hide();
            $('.js-temp-roller-sub-nav').hide();
            loadProducts();
          }
          // $('.js-alert-success').removeClass('hide');
          //$('.js-alert-success').show();js-today-date-admin-tmp
        },
        error: function(err) {
          $('.js-product-temp-save').button('reset');
          new PNotify({
            title: 'Error',
            text: 'Enter Valid Number',
            type: 'error',
            styling: 'fontawesome',
            hide: true,
            delay: 2000
          });
          $('.js-product-temp-save').button('reset');
        }
      });
    }
  } else {
    $('.js-product-temp-save').button('reset');
  }
}

function loadProducts() {
  $('.js-alert-success').hide();
  var reporteddate;
  if ($.cookie('user').role == 'Admin') {
    var storeid = $('#js-select-store').val();
    reporteddate = moment($('#js-today-date-admin-tmp').val(), 'MMM Do YYYY').format('YYYY-MM-DD');
    if (moment($('#js-today-date-admin-tmp').val(), 'MMM Do YYYY').format('YYYY-MM-DD') != "Invalid date") {
      var reporteddate = moment($('#js-today-date-admin-tmp').val(), 'MMM Do YYYY').format('YYYY-MM-DD');
    } else {
      var reporteddate = moment().format("YYYY-MM-DD");
    }
  } else {
    var storeid = $.cookie('user').storeid;
    reporteddate = moment($('#js-today-date-tmp').val(), 'MMM Do YYYY').format('YYYY-MM-DD');
    if (moment($('#js-today-date-tmp').val(), 'MMM Do YYYY').format('YYYY-MM-DD') != "Invalid date") {
      var reporteddate = moment($('#js-today-date-tmp').val(), 'MMM Do YYYY').format('YYYY-MM-DD');
    } else {
      var reporteddate = moment().format("YYYY-MM-DD");
    }
  }
  console.log(reporteddate);
  var defered1 = $.ajax({
    type: "GET",
    url: apiURL + "/temparature/products",
    data: {
      "category_name": $('.js-temp-sub-nav li.active').attr('data-value'),
      "waste_reported_date": reporteddate,
      "store_id": storeid
    },
    contentType: "application/json; charset=utf-8"
  });


  $.when(defered1).then(function(v1) {
    var productdata = {
      products: v1.response
    };
    //console.log(productdata);
    var productsHtml = tempProdTemplate(productdata);
    //console.log(productsHtml);
    $('.temperature .dots-loader').remove();
    $('.js-temp-actions').show();
    $('.js-temp-body').html(productsHtml);
    $('.js-temp-sub-nav').show();
    $('.js-temp-roller-sub-nav').hide();
    var i = 1;
    $('.js-temp-body tr').each(function(index, el) {
      var inputList = $(this).find('td input');
      for (var j = 0; j < inputList.length; j++) {
        $(inputList[j]).attr('tabindex', i++);
      }
    });
    if (moment($('#js-today-date-tmp').val(), 'MMM Do YYYY').isSame(moment(), 'day')) {
      $('.js-product-temp-save').show();
      $('.js-product-temp-complete').show();
    } else {
      if ($('#js-today-date-tmp').val() == moment().add(-1, 'days').format('MMM Do YYYY')) {
        if (moment(moment(moment(), 'day').format("YYYY-MM-DD HH:mm:ss")).unix() <= moment(moment().add('day').format("YYYY-MM-DD " + $.cookie('user').lockTime)).unix()) {
          $('.js-product-temp-save').show();
          $('.js-product-temp-complete').show();
        } else {
          $('.js-temp-body').find('input').prop('disabled', true);
          $('.js-temp-actions').hide();
        }
      } else {
        $('.js-temp-body').find('input').prop('disabled', true);
        $('.js-temp-actions').hide();
      }
    }
  }, function(err) {
    console.error(err);
  });
}


function loadEquipments() {
  if ($.cookie('user').role == 'Admin') {
    var storeid = $('#js-select-store').val();
    var reporteddate = moment($('#js-today-date-admin-tmp').val(), 'MMM Do YYYY').format('YYYY-MM-DD');
    if (moment($('#js-today-date-admin-tmp').val(), 'MMM Do YYYY').format('YYYY-MM-DD') != "Invalid date") {
      var reporteddate = moment($('#js-today-date-admin-tmp').val(), 'MMM Do YYYY').format('YYYY-MM-DD');
    } else {
      var reporteddate = moment().format("YYYY-MM-DD");
    }
  } else {
    var storeid = $.cookie('user').storeid;
    var reporteddate = moment($('#js-today-date-tmp').val(), 'MMM Do YYYY').format('YYYY-MM-DD');
    if (moment($('#js-today-date-tmp').val(), 'MMM Do YYYY').format('YYYY-MM-DD') != "Invalid date") {
      var reporteddate = moment($('#js-today-date-tmp').val(), 'MMM Do YYYY').format('YYYY-MM-DD');
    } else {
      var reporteddate = moment().format("YYYY-MM-DD");
    }
  }
  var defered1 = $.ajax({
    type: "GET",
    url: apiURL + "/temparature/equipments",
    data: {
      "category_name": $('.js-temp-sub-nav li.active').attr('data-value'),
      "waste_reported_date": reporteddate,
      "store_id": storeid
    },
    contentType: "application/json; charset=utf-8"
  });

  $.when(defered1).then(function(v1) {
    var productdata = {
      products: v1.response
    };
    //console.log(productdata);
    var productsHtml = tempProdTemplate(productdata);
    //console.log(productsHtml);
    $('.temperature .dots-loader').remove();
    $('.js-temp-actions').show();
    $('.js-temp-body').html(productsHtml);
    $('.js-temp-sub-nav').show();
    $('.js-temp-roller-sub-nav').hide();
    var i = 1;
    $('.js-temp-body tr').each(function(index, el) {
      var inputList = $(this).find('td input');
      for (var j = 0; j < inputList.length; j++) {
        $(inputList[j]).attr('tabindex', i++);
      }
    });
    if (moment($('#js-today-date-tmp').val(), 'MMM Do YYYY').isSame(moment(), 'day')) {
      $('.js-product-temp-save').show();
      $('.js-product-temp-complete').show();
    } else {
      if ($('#js-today-date-tmp').val() == moment().add(-1, 'days').format('MMM Do YYYY')) {
        if (moment(moment(moment(), 'day').format("YYYY-MM-DD HH:mm:ss")).unix() <= moment(moment().add('day').format("YYYY-MM-DD " + $.cookie('user').lockTime)).unix()) {
          $('.js-product-temp-save').show();
          $('.js-product-temp-complete').show();
        } else {
          $('.js-temp-body').find('input').prop('disabled', true);
          $('.js-temp-actions').hide();
        }
      } else {
        $('.js-temp-body').find('input').prop('disabled', true);
        $('.js-temp-actions').hide();
      }
    }
  }, function(err) {
    console.error(err);
  });
}

function loadRollerTimeSlots() {
  $('.js-alert-success').hide();
  if ($.cookie('user').role == 'Admin') {
    var storeid = $('#js-select-store').val();
    var reporteddate = moment($('#js-today-date-admin-tmp').val(), 'MMM Do YYYY').format('YYYY-MM-DD');
  } else {
    var storeid = $.cookie('user').storeid;
    var reporteddate = moment($('#js-today-date-tmp').val(), 'MMM Do YYYY').format('YYYY-MM-DD');
  }
  $.ajax({
    type: "GET",
    url: apiURL + "/products/LevelId",
    data: {
      "store_id": storeid
    },
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      gettimeslots(response.response[0].level_id);
    }
  });
}

function gettimeslots(level_id) {
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
      htm += '<li data-category_name="Roller" data-category-time-id="' + timedata.times[i].category_time_id + '"data-value="' + timedata.times[i].time_range + '" id="liTimeData_' + timedata.times[i].category_time_id + '" class="active"><a href="#" data-category_name= "Roller">' + timedata.times[i].time_range + '</a></li>';
    }

    $(".js-temp-roller-sub-nav").html(htm);
    $('.temperature .dots-loader').remove();
    $('.js-temp-actions').hide();

    $('.js-temp-sub-nav').hide();
    var i = 1;
    $('.js-temp-body tr').each(function(index, el) {
      var inputList = $(this).find('td input');
      for (var j = 0; j < inputList.length; j++) {
        $(inputList[j]).attr('tabindex', i++);
      }
    });
    if (!moment($('#js-today-date-tmp').val(), 'MMM Do YYYY').isSame(moment(), 'day')) {
      $('.js-temp-body').find('input').prop('disabled', true);
      $('.js-temp-actions').hide();
      $('.js-temp-sub-nav').hide();
    }
    if (stateObject && stateObject.category_time_id) {
      rollerTimeStampTab(stateObject.category_time_id);
    } else {
      rollerTimeStampTab(timedata.times[0].category_time_id);
    }
  }, function(err) {
    console.error(err);
  });
}


$(document).delegate('#js-roller_select-level', 'change', function(ev) {
  ev.preventDefault();
  $('.js-alert-success').hide();
  if ($.cookie('user').role == 'Admin') {
    var storeid = $('#js-select-store').val();
    var reporteddate = moment($('#js-today-date-admin-tmp').val(), 'MMM Do YYYY').format('YYYY-MM-DD');
  } else {
    var storeid = $.cookie('user').storeid;
    var reporteddate = moment($('#js-today-date-tmp').val(), 'MMM Do YYYY').format('YYYY-MM-DD');
  }
  var defered2 = $.ajax({
    type: "GET",
    url: apiURL + "/roller/time_categories",
    data: {
      "category_name": 'Roller',
      "level_name": $('#js-roller_select-level option:selected').val()
    },
    contentType: "application/json; charset=utf-8"
  });
  $.when(defered2).then(function(v2) {
    var timedata = {
      times: v2.response
    };

    var htm = "";
    for (var i = 0; i < timedata.times.length; i++) {
      htm += '<li data-value="' + timedata.times[i].time_range + '" id="liTimeData_' + timedata.times[i].category_time_id + '" class="active"><a href="#" onclick="rollerTimeStampTab(\'' + timedata.times[i].category_time_id + '\')">' + timedata.times[i].time_range + '</a></li>';
    }

    $(".js-temp-roller-sub-nav").html(htm);
    $('.temperature .dots-loader').remove();
    $('.js-temp-actions').hide();

    $('.js-temp-sub-nav').hide();
    var i = 1;
    $('.js-temp-body tr').each(function(index, el) {
      var inputList = $(this).find('td input');
      for (var j = 0; j < inputList.length; j++) {
        $(inputList[j]).attr('tabindex', i++);
      }
    });
    if (!moment($('#js-today-date-tmp').val(), 'MMM Do YYYY').isSame(moment(), 'day')) {
      $('.js-temp-body').find('input').prop('disabled', true);
      $('.js-temp-actions').hide();
      $('.js-temp-sub-nav').hide();
    }
    rollerTimeStampTab(timedata.times[0].category_time_id);
  }, function(err) {
    console.error(err);
  });
});
//console.log(category_time_id);s
function rollerTimeStampTab(category_time_id) {

  stateObject.category_time_id = category_time_id;
  $('.js-temp-roller-sub-nav').find('li').removeClass('active');
  $('#liTimeData_' + category_time_id).addClass('active');
  console.log(stateObject.category_time_id);
  $('.js-alert-success').hide();
  $('.js-temp-sub-nav').hide();
  if ($.cookie('user').role == 'Admin') {
    var storeid = $('#js-select-store').val();
    if (moment($('#js-today-date-admin-tmp').val(), 'MMM Do YYYY').format('YYYY-MM-DD') != "Invalid date") {
      var reporteddate = moment($('#js-today-date-admin-tmp').val(), 'MMM Do YYYY').format('YYYY-MM-DD');
    } else {
      var reporteddate = moment().format("YYYY-MM-DD");
    }
  } else {
    var storeid = $.cookie('user').storeid;
    if (moment($('#js-today-date-tmp').val(), 'MMM Do YYYY').format('YYYY-MM-DD') != "Invalid date") {
      var reporteddate = moment($('#js-today-date-tmp').val(), 'MMM Do YYYY').format('YYYY-MM-DD');
    } else {
      var reporteddate = moment().format("YYYY-MM-DD");
    }
  }
  var category_name = $('.js-temp-roller-sub-nav li.active').attr("data-category_name");
  var defered1 = $.ajax({
    type: "GET",
    url: apiURL + "/temp/rollerGrillProducts",
    data: {
      "available_category_times": category_time_id,
      "waste_reported_date": reporteddate,
      "store_id": storeid,
      "category_name": category_name,
      "product_type": 'Roller Grill Finished Goods'
    },
    contentType: "application/json; charset=utf-8"
  });

  $.when(defered1).then(function(v1) {
    var productdata = {
      products: v1.response
    };

    //console.log(productdata);
    var productsHtml = tempProdTemplate(productdata);

    $('.temperature .dots-loader').remove();
    $('.js-temp-actions').show();
    $('.js-temp-body').html(productsHtml);
    $('.js-temp-sub-nav').hide();
    var i = 1;
    $('.js-temp-body tr').each(function(index, el) {
      var inputList = $(this).find('td input');
      for (var j = 0; j < inputList.length; j++) {
        $(inputList[j]).attr('tabindex', i++);
      }
    });
    if (moment($('#js-today-date-tmp').val(), 'MMM Do YYYY').isSame(moment(), 'day')) {
      $('.js-product-temp-save').show();
      $('.js-product-temp-complete').show();
    } else {
      if ($('#js-today-date-tmp').val() == moment().add(-1, 'days').format('MMM Do YYYY')) {
        if (moment(moment(moment(), 'day').format("YYYY-MM-DD HH:mm:ss")).unix() <= moment(moment().add('day').format("YYYY-MM-DD " + $.cookie('user').lockTime)).unix()) {
          $('.js-product-temp-save').show();
          $('.js-product-temp-complete').show();
        } else {
          $('.js-temp-body').find('input').prop('disabled', true);
          $('.js-temp-actions').hide();
        }
      } else {
        $('.js-temp-body').find('input').prop('disabled', true);
        $('.js-temp-actions').hide();
      }
    }
  }, function(err) {
    console.error(err);
  });
}


function loadTempFreshProductsTimeSlots() {
  $.ajax({
    type: "GET",
    url: apiURL + "/products/time_categories",
    data: {
      "category_name": 'perishableTemp'
    },
    contentType: "application/json; charset=utf-8",
    success: function(response){
     if(response.response){
       html = '';
       for (var i=0; i< response.response.length;i++){
         html += '<li data-category_time_id='+ response.response[i].category_time_id+'><a href="javascript:void(0)">'+response.response[i].time_range +'</a></li>'
         //stateObject.category_time_id = response.response[0].category_time_id;
       }
       $('.js-temp-perishable-sub-nav').html(html);

       if (stateObject.pershible_category_time_id) {
         $('.js-temp-perishable-sub-nav').find('li[data-category_time_id="'+ stateObject.pershible_category_time_id +'"]').addClass('active');
       } else {
         stateObject.pershible_category_time_id = response.response[0].category_time_id;
         $($('.js-temp-perishable-sub-nav li')[0]).addClass("active");
       }

       if ($('.js-temp-main-nav li.active a').attr('data-value') == "Perishable Goods") {
         loadTempFreshProducts();
       }
     }
    }
  });
}

function loadTempFreshProducts() {
  if ($.cookie('user').role == 'Admin') {
    var storeid = $('#js-select-store').val();
    if (moment($('#js-today-date-admin-tmp').val(), 'MMM Do YYYY').format('YYYY-MM-DD') != "Invalid date") {
      var reporteddate = moment($('#js-today-date-admin-tmp').val(), 'MMM Do YYYY').format('YYYY-MM-DD');
    } else {
      var reporteddate = moment().format("YYYY-MM-DD");
    }
  } else {
    var storeid = $.cookie('user').storeid;
    if (moment($('#js-today-date-tmp').val(), 'MMM Do YYYY').format('YYYY-MM-DD') != "Invalid date") {
      var reporteddate = moment($('#js-today-date-tmp').val(), 'MMM Do YYYY').format('YYYY-MM-DD');
    } else {
      var reporteddate = moment().format("YYYY-MM-DD");
    }
  }
  // if (stateObject && stateObject.pershible_category_time_id) {
  //   var available_category_times =  stateObject.pershible_category_time_id;
  // } else {
  //   var available_category_times = $('.js-temp-perishable-sub-nav li.active').attr('data-category_time_id');
  // }
  var available_category_times =  stateObject.pershible_category_time_id;
  var category_name = 'perishableTemp';
  var product_type = 'Perishable Goods';
  var defered1 = $.ajax({
    type: "GET",
    url: apiURL + "/temp/rollerGrillProducts",
    data: {
      "category_name": category_name,
      "waste_reported_date": reporteddate,
      "store_id": storeid,
      "available_category_times":available_category_times,
      "product_type": product_type
    },
    contentType: "application/json; charset=utf-8"
  });

  $.when(defered1).then(function(v1) {
    var productdata = {
      products: v1.response
    };
    //console.log(productdata);
    var productsHtml = tempProdTemplate(productdata);
    //console.log(productsHtml);
    $('.temperature .dots-loader').remove();
    $('.js-temp-actions').show();
    $('.js-temp-body').html(productsHtml);
    $('.js-temp-sub-nav').hide();
    $('.js-temp-roller-sub-nav').hide();
    var i = 1;
    $('.js-temp-body tr').each(function(index, el) {
      var inputList = $(this).find('td input');
      for (var j = 0; j < inputList.length; j++) {
        $(inputList[j]).attr('tabindex', i++);
      }
    });
    if (moment($('#js-today-date-tmp').val(), 'MMM Do YYYY').isSame(moment(), 'day')) {
      $('.js-product-temp-save').show();
      $('.js-product-temp-complete').show();
    } else {
      if ($('#js-today-date-tmp').val() == moment().add(-1, 'days').format('MMM Do YYYY')) {
        if (moment(moment(moment(), 'day').format("YYYY-MM-DD HH:mm:ss")).unix() <= moment(moment().add('day').format("YYYY-MM-DD " + $.cookie('user').lockTime)).unix()) {
          $('.js-product-temp-save').show();
          $('.js-product-temp-complete').show();
        } else {
          $('.js-temp-body').find('input').prop('disabled', true);
          $('.js-temp-actions').hide();
        }
      } else {
        $('.js-temp-body').find('input').prop('disabled', true);
        $('.js-temp-actions').hide();
      }
    }
  }, function(err) {
    console.error(err);
  });
}
