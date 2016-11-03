var stateObject = {};
$(document).ready(function() {
  loadPullSheetTabs();
  loadTempFreshProductsTimeSlots();
  $.routes.add('/Ben E. Keith Orders', 'ordermanagement', function() {
    $('.employee-main-nav').removeClass('active');
    $('.employee-main-nav').find("a[data-url='order']").parent().addClass('active');
    orderManagement();
  });
  $.routes.add('/waste', 'wastereport', function() {
    $('.employee-main-nav').removeClass('active');
    $('.employee-main-nav').find("a[data-url='waste']").parent().addClass('active');
    wastereport();
  });
  $.routes.add('/waste/{name:string}/{subname:string}', 'wastemainroutes', function() {
    if (this.name == 'finishedgoods') {
      $('.js-wastage-main-nav').find('li').removeClass('active');
      $('.js-wastage-main-nav').find('li a[data-value="Finished Goods"]').parent().addClass('active');
      if (this.subname == 'breakfast' || this.subname == 'lunch' || this.subname == 'dinner') {
        loadProductWaste();
      }
    } else if (this.name == 'ingredients') {
      $('.js-wastage-main-nav').find('li').removeClass('active');
      $('.js-wastage-main-nav').find('li a[data-value="Ingredients"]').parent().addClass('active');
      if (this.subname == 'breakfast' || this.subname == 'lunch' || this.subname == 'dinner') {
        $('.js-wastage-sub-nav-times li').addClass('hide');
        var targetIndex = $('.js-wastage-sub-nav').find('li ').index($('.js-wastage-sub-nav li.active'));
        $($('.js-wastage-sub-nav-times li')[targetIndex]).removeClass('hide');
        loadIngredients();
      }
    } else if (this.name == 'rollergrillproducts') {
      $('.js-wastage-main-nav').find('li').removeClass('active');
      $('.js-wastage-main-nav').find('li a[data-value="Roller Grill Finished Goods"]').parent().addClass('active');
      rollerGrillProducts();
    } else if (this.name == 'rollergrillingredients') {
      $('.js-wastage-main-nav').find('li').removeClass('active');
      $('.js-wastage-main-nav').find('li a[data-value="Roller Grill Ingredients"]').parent().addClass('active');
      rollerGrillIngredients();
    } else if (this.name == 'perishablegoods') {
      $('.js-wastage-main-nav').find('li').removeClass('active');
      $('.js-wastage-main-nav').find('li a[data-value="Perishable Goods"]').parent().addClass('active');
      loadFreshProducts();
    }
  });
  $.routes.add('/temperature', 'temperature', function() {
    $('.employee-main-nav').removeClass('active');
    $('.employee-main-nav').find("a[data-url='temperature']").parent().addClass('active');
    temperature();
  });
  $.routes.add('/temperature/{name:string}/{subname:string}', 'tempmainroutes', function() {
    if (this.name == 'equipment') {
      $('.js-temp-sub-nav li').removeClass('active');
      if (this.subname == 'open') {
        $('.js-temp-sub-nav').find('li[data-value="Open"]').addClass('active');
      } else if (this.subname == 'peak') {
        $('.js-temp-sub-nav').find('li[data-value="Peak"]').addClass('active');
      } else if (this.subname == 'breakdown') {
        $('.js-temp-sub-nav').find('li[data-value="Breakdown"]').addClass('active');
      }
      loadEquipments();
      $('.temperature').append('<div class="col-lg-offset-5 dots-loader spinner-div-style">Loading…</div>');
    } else if (this.name == 'product') {
      if (this.subname == 'open') {
        $('.js-temp-sub-nav').find('li[data-value="Open"]').addClass('active');
      } else if (this.subname == 'peak') {
        $('.js-temp-sub-nav').find('li[data-value="Peak"]').addClass('active');
      } else if (this.subname == 'breakdown') {
        $('.js-temp-sub-nav').find('li[data-value="Breakdown"]').addClass('active');
      }
      loadProducts();
      $('.temperature').append('<div class="col-lg-offset-5 dots-loader spinner-div-style">Loading…</div>');
    } else if (this.name == 'temprgproducts') {
      $('.js-temp-sub-nav').hide();
      //$('.js-temp-roller-sub-nav li').removeClass('active');
      if ($('.js-temp-roller-sub-nav li.active').attr('data-category-time-id')) {
        rollerTimeStampTab($('.js-temp-roller-sub-nav li.active').attr('data-category-time-id'));
      } else {
        loadRollerTimeSlots();
      }
    } else if (this.name == 'perishablegoods') {
      loadTempFreshProducts();
    }
  });
  $.routes.add('/inspection', 'inspection', function() {
    $('.employee-main-nav').removeClass('active');
    $('.employee-main-nav').find("a[data-url='inspection']").parent().addClass('active');
    inspection();
  });
  $.routes.add('/inspection/{id:int}/{surveyname:string}', 'inspectionmaintab', function() {
    updateSurvey(this.id, this.surveyname);
  });
  $.routes.add('/anticipated/{name:string}/{subname:string}', 'anticipatedmainroutes', function() {
    if (this.name == 'capitalCity') {
      $('.js-antispated-sub-nav li').removeClass('active');
      if (this.subname == 'breakfast') {
        $('.js-antispated-sub-nav').find('li[data-value="Breakfast"]').addClass('active');
      } else if (this.subname == 'lunch') {
        $('.js-antispated-sub-nav').find('li[data-value="Lunch"]').addClass('active');
      } else if (this.subname == 'dinner') {
        $('.js-antispated-sub-nav').find('li[data-value="Dinner"]').addClass('active');
      }
      buildto('2');
    } else if (this.name == 'rollerGrills') {
      buildtoRollerGrill('7');
    } else if (this.name == 'perishablegoods') {
      buildtoFreshproducts('8');
    }
  });
  $.routes.add('/pullsheet/{name:string}/{subname:string}', 'pullsheet', function() {
    $('.employee-main-nav').removeClass('active');
    $('.employee-main-nav').find("a[data-url='pulloversheets']").parent().addClass('active');
    if ($('.js-temp-pullsheet-sub-nav li.active').attr('data-category-time-id')) {
      pulloverfunction($('.js-pullover-employee li.active').attr('data-value'));
    } else {
      loadPulloverTimeSlots();
    }
  });
  $.routes.add('/dbqOrderForm/{name:string}', 'dbqOrderForm', function() {
    $('.employee-main-nav').removeClass('active');
    $('.employee-main-nav').find("a[data-url='orderform']").parent().addClass('active');
    loadOrderItemsForEmployee(this.name);
  });
  if ($.cookie('stateObject') && $.cookie('stateObject').navCategory) {
    $('.employee-main-nav').removeClass('active');
    if ($.cookie('stateObject').navCategory == 'waste') {
      $('.employee-main-nav').find("[data-url='" + $.cookie('stateObject').navCategory + "']").parent().addClass('active');
      wastereport();
    } else if ($.cookie('stateObject').navCategory == 'temperature') {
      $('.employee-main-nav').find("[data-url='" + $.cookie('stateObject').navCategory + "']").parent().addClass('active');
      temperature();
    } else if ($.cookie('stateObject').navCategory == 'inspection') {
      $('.employee-main-nav').find("[data-url='" + $.cookie('stateObject').navCategory + "']").parent().addClass('active');
      inspection();
    } else if ($.cookie('stateObject').navCategory == 'anticipated') {
      $('.employee-main-nav').find("[data-url='" + $.cookie('stateObject').navCategory + "']").parent().addClass('active');
      anticipated();
    } else if ($.cookie('stateObject').navCategory == 'pulloversheets') {
      $('.employee-main-nav').find("[data-url='" + $.cookie('stateObject').navCategory + "']").parent().addClass('active');
      pullsheet();
    } else if ($.cookie('stateObject').navCategory == 'orderform') {
      $('.employee-main-nav').find("[data-url='" + $.cookie('stateObject').navCategory + "']").parent().addClass('active');
      orderform();
    } else if ($.cookie('stateObject').navCategory == 'order') {
      $('.employee-main-nav').find("[data-url='" + $.cookie('stateObject').navCategory + "']").parent().addClass('active');
      orderManagement();
    }
  } else {
    $('.employee-main-nav').find("[data-url='anticipatedsales']").parent().addClass('active');
    anticipated();
  }

});



window.onbeforeunload = function(event) {
  //return alert("Confirm refresh");
  if ($.cookie('user')) {
    var navCategory = $('li.employee-main-nav.active').find('a').data('url');
    if (navCategory === "waste") {
      stateObject.navCategory = 'waste';
      stateObject.mainCategory = $('.js-wastage-main-nav li.active a').data('value');
      if (stateObject.mainCategory == "Finished Goods" || stateObject.mainCategory == "Ingredients") {
        stateObject.subCategory = $('.js-wastage-sub-nav li.active').data('value');
      } else if (stateObject.mainCategory == "Perishable Goods") {
        stateObject.subCategory = $('.js-perishable-waste-nav li.active').attr('data-value');
      }
    } else if (navCategory === "temperature") {
      stateObject.navCategory = 'temperature';
      stateObject.mainCategory = $('.js-temp-main-nav li.active a').data('value');
      if (stateObject.mainCategory == "Perishable Goods") {
        stateObject.subCategory = $('.js-temp-perishable-sub-nav li.active').data('category_time_id');
      } else if (stateObject.mainCategory == "Roller Grill Products") {
        stateObject.subCategory = $('.js-temp-roller-sub-nav li.active').data('category-time-id');
      } else {
        stateObject.subCategory = $('.js-temp-sub-nav li.active').data('value');
      }
    } else if (navCategory === "inspection") {
      stateObject.navCategory = 'inspection';
      stateObject.mainCategory = $('#emp-survey-tabs').find('li.active a').attr('data-surveyname');
      stateObject.surveyId = $('#emp-survey-tabs').find('li.active a').attr('data-surveyid');
    } else if (navCategory === "anticipated") {
      stateObject.navCategory = 'anticipated';
      stateObject.mainCategory = $('.js-store-nav').find('li.active').find('a').attr("data-value");
      if (stateObject.mainCategory === "capitalCity") {
        stateObject.subCategory = $('.js-antispated-sub-nav').find('li.active').attr('data-value');
      } else if (stateObject.mainCategory === "Perishable Goods") {
        stateObject.subCategory = $('.js-perishable-sub-nav').find('li.active').attr('data-value');
      }
    } else if (navCategory === "pulloversheets") {
      stateObject.navCategory = 'pulloversheets';
      stateObject.mainCategory = $('.js-pullover-employee li.active').attr('data-value');
      stateObject.subCategory = $('.js-temp-pullsheet-sub-nav li.active').attr('data-category-time-id');
    } else if (navCategory === "orderform") {
      stateObject.navCategory = 'orderform';
      stateObject.mainCategory = $('.js-order-employee li.active').attr('data-value');
    } else if (navCategory === "order") {
      stateObject.navCategory = 'order';
      stateObject.mainCategory = $('.js-order-employee li.active').attr('data-value');
    }
    $.cookie('stateObject', stateObject);
  }
}
$('.aside--logo').click(function(ev) {
  ev.preventDefault();
  location.reload();
});
$('.employee-main-nav').click(function(ev) {
  ev.preventDefault();
  $('.main--tabs').show();
  $('.employee-main-nav').removeClass('active');
  $(this).closest('li').addClass('active');
  var selectedNav = $(this).find('a');
  $('.js-employee-main-div').hide();
  if (selectedNav.data('url') === 'order') {
    $.routes.find('ordermanagement').routeTo({});
  } else if (selectedNav.data('url') === 'waste') {
    $.routes.find('wastereport').routeTo({});
  } else if (selectedNav.data('url') === 'temperature') {
    $.routes.find('temperature').routeTo({});
  } else if (selectedNav.data('url') === 'inspection') {
    $('#backtoSurveys').hide();
    $.routes.find('inspection').routeTo({});
  } else if (selectedNav.data('url') === 'anticipated') {
    anticipated();
  } else if (selectedNav.data('url') === 'pulloversheets') {
    pullsheet();
  } else if (selectedNav.data('url') === 'orderform') {
    orderform();
  }
});


$('.js-temp-roller-sub-nav').click(function(ev) {
  ev.preventDefault();
  $('.js-temp-roller-sub-nav li').removeClass('active');
  $(ev.target.parentElement).addClass('active');
  tempSubCategoryRouting('rgproducts');
});

$('.js-wastage-main-nav li').click(function(ev) {
  ev.preventDefault();
  $('.js-wastage-main-nav li').removeClass('active');
  $(ev.target.parentElement).addClass('active')
  if ($(ev.target).attr('data-value') == "Finished Goods") {
    $('.js-perishable-waste-nav').hide();
    wasteSubCategoryRouting('finishedgoods');
  } else if ($(ev.target).attr('data-value') == "Ingredients") {
    $('.js-perishable-waste-nav').hide();
    wasteSubCategoryRouting('ingredients');
  } else if ($(ev.target).attr('data-value') == "Roller Grill Finished Goods") {
    $('.js-wastage-sub-nav-times').hide();
    $('.js-perishable-waste-nav').hide();
    stateObject.mainCategory = "Roller Grill Finished Goods";
    $.routes.find('wastemainroutes').routeTo({
      name: 'rollergrillproducts'
    });
  } else if ($(ev.target).attr('data-value') == "Roller Grill Ingredients") {
    $('.js-wastage-sub-nav-times').hide();
    $('.js-perishable-waste-nav').hide();
    stateObject.mainCategory = "Roller Grill Ingredients";
    $.routes.find('wastemainroutes').routeTo({
      name: 'rollergrillingredients'
    });
  } else if ($(ev.target).attr('data-value') == "Perishable Goods") {
    $('.js-wastage-sub-nav-times').hide();
    $('.js-wastage-sub-nav').hide();
    $('.js-perishable-waste-nav').show();
    stateObject.mainCategory = "Perishable Goods";
    wasteSubCategoryRouting('perishablegoods');
  }
});


$('.js-temp-main-nav li').click(function(ev) {
  ev.preventDefault();
  $('.js-temp-main-nav li').removeClass('active');
  $(ev.target.parentElement).addClass('active');
  if ($(ev.target).attr('data-value') == "Product") {
    $('.js-temp-roller-sub-nav').hide();
    $('.js-temp-perishable-sub-nav').hide();
    tempSubCategoryRouting('product');
  } else if ($(ev.target).attr('data-value') == "Equipment") {
    $('.js-temp-roller-sub-nav').hide();
    $('.js-temp-perishable-sub-nav').hide();
    tempSubCategoryRouting('equipment');
  } else if ($(ev.target).attr('data-value') == "Roller Grill Products") {
    $('.js-temp-roller-sub-nav').show();
    $('.js-temp-sub-nav').hide();
    $('.js-temp-perishable-sub-nav').hide();
    tempSubCategoryRouting('rgproducts');
  } else if ($(ev.target).attr('data-value') == "Perishable Goods") {
    $('.js-temp-roller-sub-nav').hide();
    $('.js-temp-perishable-sub-nav').show();
    tempSubCategoryRouting('freshproducts');
  }
});

$('.js-temp-sub-nav li').click(function(ev) {
  ev.preventDefault();
  if ($('.js-temp-sub-nav li.active').attr('data-value') != $(ev.target).closest('li').attr('data-value')) {
    $('.js-temp-sub-nav li').removeClass('active');
    $(ev.target).closest('li').addClass('active');
    if ($('.js-temp-main-nav').find('li.active a').attr('data-value') == "Product") {
      tempSubCategoryRouting('product');
    } else if ($('.js-temp-main-nav').find('li.active a').attr('data-value') == "Equipment") {
      tempSubCategoryRouting('equipment');
    }
    $('.temperature .dots-loader').remove();
    $('.js-temp-actions').hide();
    //$('.temperature .js-temp-head').html('');
    $('.temperature .js-temp-body').html('');
    //$('.temperature').append('<div class="col-lg-offset-5 dots-loader spinner-div-style">Loading…</div>');
  }
});


$('.js-store-nav li').click(function(ev) {
  ev.preventDefault();
  $('.js-store-nav li').removeClass('active');
  $(ev.target.parentElement).addClass('active')
  if (ev.target.dataset.value == 'rollerGrills') {
    $.routes.find('anticipatedmainroutes').routeTo({
      name: 'rollerGrills'
    });
  } else if (ev.target.dataset.value == 'capitalCity') {
    anticipatedSubCategoryRouting();
  } else if (ev.target.dataset.value == 'Perishable Goods') {
    $.routes.find('anticipatedmainroutes').routeTo({
      name: 'perishablegoods',
      subname: $('.js-perishable-sub-nav li.active').attr('data-value')
    });
    if ($('.js-perishable-sub-nav li.active').data('value') =="Core-Mark") {
      buildtoFreshproducts('8');
    }
  }
});
$('.js-antispated-sub-nav').on('click', function(ev) {
  ev.preventDefault();
  stateObject.anticipatedMainCategory = $(ev.target).closest('li').find('a').data('value');
  $('.js-antispated-sub-nav li').removeClass('active');
  $(ev.target).closest('li').addClass('active');
  $('.build-table .dots-loader').remove();
  $('.js-antispected-actions').hide();
  $('.build-table .js-buildto-head').html('');
  $('.build-table .js-buildto-body').html('');
  $('.build-table').append(styleLoader);
  if ($('.js-store-nav').find('li.active').attr("data-value") === 'rollerGrills') {
    buildtoRollerGrill('7');
  } else {
    anticipatedSubCategoryRouting();
  }
});
$(document).delegate('#emp-survey-tabs', 'click', function(ev) {
  ev.preventDefault();
  var surveyId = ev.target.dataset.surveyid;
  var surveyName = ev.target.dataset.surveyname;
  $.routes.find('inspectionmaintab').routeTo({
    id: ev.target.dataset.surveyid,
    surveyname: ev.target.dataset.surveyname
  });
});

function pullsheet() {
  $('.js-employee-pullover-div').show();
  $('#js-wastage-div').hide();
  $('#js-temperature-div').hide();
  $('#js-inspection-div').hide();
  $('.js-inspect-table-list').hide();
  $('.inspection-list').hide();
  $('.js-employee-antispated-div').hide();
  if ($.cookie('stateObject') && $.cookie('stateObject').mainCategory) {
    stateObject.pullover_category_id = $.cookie('stateObject').subCategory;
    $('.js-pullover-employee li').removeClass('active');
    $('.js-pullover-employee').find('li[data-value="' + $.cookie('stateObject').mainCategory + '"]').addClass('active');
    loadPullSheetTabs();
    // if ($('.js-temp-pullsheet-sub-nav li.active').attr('data-category-time-id')) {
    //   pulloverfunction($.cookie('stateObject').mainCategory);
    // } else {
    //   loadPulloverTimeSlots();
    // }
    // here stateObject need to maintain dynamic tabs active class
    //$.cookie('stateObject', null);
  } else {
    stateObject.pullover_category_id = $('.js-temp-pullsheet-sub-nav li.active').attr('data-category-time-id');
    stateObject.category_times = $('.js-temp-pullsheet-sub-nav li.active').attr('data-value');
    $.routes.find('pullsheet').routeTo({
      name: $('.js-pullover-employee li.active').attr('data-value'),
      subname: $('.js-temp-pullsheet-sub-nav li.active').attr('data-category-time-id')
    });
  }
}

function orderform() {
  $('.js-employee-order-div').show();
  $('.js-employee-pullover-div').hide();
  $('#js-wastage-div').hide();
  $('#js-temperature-div').hide();
  $('#js-inspection-div').hide();
  $('.js-inspect-table-list').hide();
  $('.inspection-list').hide();
  if ($.cookie('stateObject') && $.cookie('stateObject').mainCategory) {
    $('.js-order-employee li').removeClass('active');
    $('.js-order-employee').find('li[data-value="' + $.cookie('stateObject').mainCategory + '"]').addClass('active');
    loadOrderItemsForEmployee($.cookie('stateObject').mainCategory);
    $.cookie('stateObject', null);
  } else {
    $.routes.find('dbqOrderForm').routeTo({
      name: $('.js-order-employee li.active').attr('data-value')
    });
  }
}

$(document).delegate('.js-pullover-employee li', 'click', function(ev) {
  ev.preventDefault();
  $('.js-pullover-employee li').removeClass('active');
  $('.js-pullover-employee').find('li[data-value="' + $(ev.target).attr('data-value') + '"]').addClass('active');
  $.routes.find('pullsheet').routeTo({
    name: $('.js-pullover-employee li.active').attr('data-value'),
    subname: $('.js-temp-pullsheet-sub-nav li.active').attr('data-category-time-id')
  });
});

$(document).delegate('.js-order-employee li', 'click', function(ev) {
  ev.preventDefault();
  $('.js-order-employee li').removeClass('active');
  $('.js-order-employee').find('li[data-value="' + $(ev.target).attr('data-value') + '"]').addClass('active');
  $.routes.find('dbqOrderForm').routeTo({
    name: $('.js-order-employee li.active').attr('data-value')
  });
});

function wastereport() {
  $('#js-wastage-div').show();
  $('#js-temperature-div').hide();
  $('#js-inspection-div').hide();
  $('.js-inspect-table-list').hide();
  $('.inspection-list').hide();
  $('.js-employee-antispated-div').hide();
  $('.js-employee-pullover-div').hide();
  $('.js-employee-order-div').hide();
  if ($.cookie('stateObject') && $.cookie('stateObject').mainCategory) {
    stateObject.mainCategory = $.cookie('stateObject').mainCategory;
    stateObject.subCategory = $.cookie('stateObject').subCategory;
    $('.js-wastage-main-nav').find('li').removeClass('active');
    $('.js-wastage-sub-nav').find('li').removeClass('active');
    if ($.cookie('stateObject').mainCategory === 'Finished Goods') {
      $('.js-perishable-waste-nav').hide();
      $('.js-wastage-main-nav').find('li a[data-value="Finished Goods"]').parent().addClass('active');
      if ($.cookie('stateObject').subCategory == "Breakfast") {
        $('.js-wastage-sub-nav').find('li[data-value="Breakfast"]').addClass('active');
      } else if ($.cookie('stateObject').subCategory == "Lunch") {
        $('.js-wastage-sub-nav').find('li[data-value="Lunch"]').addClass('active');
      } else if ($.cookie('stateObject').subCategory == "Dinner") {
        $('.js-wastage-sub-nav').find('li[data-value="Dinner"]').addClass('active');
      }
      loadProductWaste();
    } else if ($.cookie('stateObject').mainCategory === 'Ingredients') {
      $('.js-perishable-waste-nav').hide();
      $('.js-wastage-main-nav').find('li a[data-value="Ingredients"]').parent().addClass('active');
      $('.js-wastage-sub-nav-times li').addClass('hide');
      if ($.cookie('stateObject').subCategory == "Breakfast") {
        $('.js-wastage-sub-nav').find('li[data-value="Breakfast"]').addClass('active');
      } else if ($.cookie('stateObject').subCategory == "Lunch") {
        $('.js-wastage-sub-nav').find('li[data-value="Lunch"]').addClass('active');
      } else if ($.cookie('stateObject').subCategory == "Dinner") {
        $('.js-wastage-sub-nav').find('li[data-value="Dinner"]').addClass('active');
      }
      var targetIndex = $('.js-wastage-sub-nav').find('li ').index($('.js-wastage-sub-nav li.active'));
      $($('.js-wastage-sub-nav-times li')[targetIndex]).removeClass('hide');
      loadIngredients();
    } else if ($.cookie('stateObject').mainCategory === 'Roller Grill Finished Goods') {
      $('.js-perishable-waste-nav').hide();
      $('.js-wastage-main-nav').find('li a[data-value="Roller Grill Finished Goods"]').parent().addClass('active');
      rollerGrillProducts();
    } else if ($.cookie('stateObject').mainCategory === 'Roller Grill Ingredients') {
      $('.js-perishable-waste-nav').hide();
      $('.js-wastage-main-nav').find('li a[data-value="Roller Grill Ingredients"]').parent().addClass('active');
      rollerGrillIngredients();
    } else if ($.cookie('stateObject').mainCategory === 'Perishable Goods') {
      $('.js-wastage-sub-nav').hide();
      $('.js-wastage-main-nav').find('li a[data-value="Perishable Goods"]').parent().addClass('active');
      $('.js-perishable-waste-nav li').removeClass('active');
      if ($.cookie('stateObject').subCategory == "DBQ") {
        $('.js-perishable-waste-nav').find('li[data-value="DBQ"]').addClass('active');
      } else if ($.cookie('stateObject').subCategory == "Core-Mark") {
        $('.js-perishable-waste-nav').find('li[data-value="Core-Mark"]').addClass('active');
      } else if ($.cookie('stateObject').subCategory == "Commissary") {
        $('.js-perishable-waste-nav').find('li[data-value="Commissary"]').addClass('active');
      }
      loadFreshProducts();
    }
    $.cookie('stateObject', null);
  } else {
    stateObject.mainCategory = $('.js-wastage-main-nav li.active a').data('value');
    stateObject.subCategory = $('.js-wastage-sub-nav li.active').data('value');
    if ($.cookie('user').capitalCity && !$.cookie('user').rollerGrills && !$.cookie('user').perishableGoods || $.cookie('user').capitalCity && $.cookie('user').rollerGrills && !$.cookie('user').perishableGoods) {
      $('.js-perishable-waste-nav').hide();
      if (stateObject.mainCategory === 'Finished Goods') {
        wasteSubCategoryRouting('finishedgoods');
      } else if (stateObject.mainCategory === 'Ingredients') {
        wasteSubCategoryRouting('ingredients');
      }
    } else if (!$.cookie('user').capitalCity && $.cookie('user').rollerGrills && !$.cookie('user').perishableGoods || !$.cookie('user').capitalCity && $.cookie('user').rollerGrills && $.cookie('user').perishableGoods) {
      if (stateObject.mainCategory === 'Roller Grill Finished Goods') {
        $('.js-perishable-waste-nav').hide();
        $.routes.find('wastemainroutes').routeTo({
          name: 'rollergrillproducts'
        });
      } else if (stateObject.mainCategory === 'Roller Grill Ingredients') {
        $('.js-perishable-waste-nav').hide();
        $.routes.find('wastemainroutes').routeTo({
          name: 'rollergrillingredients'
        });
      } else if (stateObject.mainCategory === 'Perishable Goods') {
        $('.js-perishable-waste-nav').show();
        wasteSubCategoryRouting('perishablegoods');
      }
    } else if (!$.cookie('user').capitalCity && !$.cookie('user').rollerGrills && $.cookie('user').perishableGoods) {
      wasteSubCategoryRouting('perishablegoods');
    } else if ($.cookie('user').capitalCity && !$.cookie('user').rollerGrills && $.cookie('user').perishableGoods || $.cookie('user').capitalCity && $.cookie('user').rollerGrills && $.cookie('user').perishableGoods) {
      $('.js-perishable-waste-nav').hide();
      if (stateObject.mainCategory === 'Finished Goods') {
        wasteSubCategoryRouting('finishedgoods');
      } else if (stateObject.mainCategory === 'Ingredients') {
        wasteSubCategoryRouting('ingredients');
      } else if (stateObject.mainCategory === 'Roller Grill Finished Goods') {
        $.routes.find('wastemainroutes').routeTo({
          name: 'rollergrillproducts'
        });
      } else if (stateObject.mainCategory === 'Roller Grill Ingredients') {
        $.routes.find('wastemainroutes').routeTo({
          name: 'rollergrillingredients'
        });
      } else if (stateObject.mainCategory === 'Perishable Goods') {
        $('.js-wastage-main-nav').find('li a[data-value="Perishable Goods"]').parent().addClass('active');
        $('.js-wastage-sub-nav').hide();
        $('.js-perishable-waste-nav').show();
        wasteSubCategoryRouting('perishablegoods');
      }
    }
  }
}

function temperature() {
  //loadRollerTimeSlots();
  //loadTempFreshProductsTimeSlots();
  $('#js-roller_select-level').addClass('js-roller_temp_levels');
  $('.js-roller_temp_levels').removeAttr('id');
  $('#js-temperature-div').show();
  $('#js-wastage-div').hide();
  $('#js-inspection-div').hide();
  $('.js-inspect-table-list').hide();
  $('.inspection-list').hide();
  $('.js-employee-antispated-div').hide();
  $('.js-employee-pullover-div').hide();
  $('.js-employee-order-div').hide();
  if ($.cookie('stateObject') && $.cookie('stateObject').mainCategory) {
    stateObject.tempMainCategory = $.cookie('stateObject').mainCategory;

    $('.js-temp-main-nav').find('li').removeClass('active');
    if (stateObject.tempMainCategory == 'Equipment') {
      $('.js-temp-perishable-sub-nav').hide();
      $('.js-temp-main-nav').find('li a[data-value="Equipment"]').parent().addClass('active');
      $('.js-temp-sub-nav li').removeClass('active');
      if ($.cookie('stateObject').subCategory == "Open") {
        $('.js-temp-sub-nav').find('li[data-value="Open"]').addClass('active');
      } else if ($.cookie('stateObject').subCategory == "Peak") {
        $('.js-temp-sub-nav').find('li[data-value="Peak"]').addClass('active');
      } else if ($.cookie('stateObject').subCategory == "Breakdown") {
        $('.js-temp-sub-nav').find('li[data-value="Breakdown"]').addClass('active');
      }
      stateObject.tempSubCategory = $('.js-temp-sub-nav li.active').data('value');
      loadEquipments();
      $('.temperature').append('<div class="col-lg-offset-5 dots-loader spinner-div-style">Loading…</div>');
    } else if (stateObject.tempMainCategory == 'Roller Grill Products') {
      $('.js-temp-perishable-sub-nav').hide();
      $('.js-temp-main-nav').find('li a[data-value="Roller Grill Products"]').parent().addClass('active');
      $('.js-temp-sub-nav').hide();
      $('.js-temp-roller-sub-nav').show();
      stateObject.category_time_id = $.cookie('stateObject').subCategory;
      loadRollerTimeSlots();
    } else if (stateObject.tempMainCategory == 'Product') {
      $('.js-temp-perishable-sub-nav').hide();
      $('.js-temp-main-nav').find('li a[data-value="Product"]').parent().addClass('active');

      $('.js-temp-sub-nav li').removeClass('active');
      if ($.cookie('stateObject').subCategory == "Open") {
        $('.js-temp-sub-nav').find('li[data-value="Open"]').addClass('active');
      } else if ($.cookie('stateObject').subCategory == "Peak") {
        $('.js-temp-sub-nav').find('li[data-value="Peak"]').addClass('active');
      } else if ($.cookie('stateObject').subCategory == "Breakdown") {
        $('.js-temp-sub-nav').find('li[data-value="Breakdown"]').addClass('active');
      }
      loadProducts();
      $('.temperature').append('<div class="col-lg-offset-5 dots-loader spinner-div-style">Loading…</div>');
    } else if (stateObject.tempMainCategory == 'Perishable Goods') {
      $('.js-temp-perishable-sub-nav').show();
      $('.js-temp-main-nav').find('li a[data-value="Perishable Goods"]').parent().addClass('active');
      $('.js-temp-sub-nav').hide();
      $('.js-perishable-waste-nav li').removeClass('active');
      stateObject.pershible_category_time_id = $.cookie('stateObject').subCategory;
      loadTempFreshProductsTimeSlots();
    }
    $.cookie('stateObject', null);
  } else {
    stateObject.tempMainCategory = $('.js-temp-main-nav li.active a').data('value');
    if (stateObject.tempMainCategory == "Roller Grill Products") {
      stateObject.tempSubCategory = $('.js-temp-roller-sub-nav li.active').attr('data-category-time-id');
    } else if (stateObject.tempMainCategory == "Perishable Goods") {
      stateObject.tempSubCategory = $('#js-temp-perishable-sub-nav li.active').attr('data-category_time_id');
    } else {
      stateObject.tempSubCategory = $('.js-temp-sub-nav li.active').attr('data-value');
      stateObject.category_time_id = "";
    }
    if ($.cookie('user').capitalCity && !$.cookie('user').rollerGrills && !$.cookie('user').perishableGoods || $.cookie('user').capitalCity && $.cookie('user').rollerGrills && !$.cookie('user').perishableGoods) {
      $('.js-temp-perishable-sub-nav').hide();
      if (stateObject.tempMainCategory == 'Equipment') {
        tempSubCategoryRouting('equipment');
      } else if (stateObject.tempMainCategory == 'Product') {
        tempSubCategoryRouting('product');
      }
    } else if (!$.cookie('user').capitalCity && $.cookie('user').rollerGrills && !$.cookie('user').perishableGoods || !$.cookie('user').capitalCity && $.cookie('user').rollerGrills && $.cookie('user').perishableGoods) {
      if (stateObject.tempMainCategory == 'Perishable Goods') {
        $('.js-temp-perishable-sub-nav').show();
        $('.js-temp-sub-nav').hide();
        $('.js-temp-main-nav').find('li a[data-value="Perishable Goods"]').parent().addClass('active');
        tempSubCategoryRouting('freshproducts');
      } else {
        $('.js-temp-perishable-sub-nav').hide();
        $('.js-temp-sub-nav').show();
        tempSubCategoryRouting('rgproducts');
      }
    } else if (!$.cookie('user').capitalCity && !$.cookie('user').rollerGrills && $.cookie('user').perishableGoods) {
      $('.js-temp-perishable-sub-nav').show();
      $('.js-temp-sub-nav').hide();
      $('.js-temp-main-nav').find('li a[data-value="Perishable Goods"]').parent().addClass('active');
      tempSubCategoryRouting('freshproducts');
    } else if ($.cookie('user').capitalCity && !$.cookie('user').rollerGrills && $.cookie('user').perishableGoods || $.cookie('user').capitalCity && $.cookie('user').rollerGrills && $.cookie('user').perishableGoods) {
      if (stateObject.tempMainCategory == 'Equipment') {
        $('.js-temp-perishable-sub-nav').hide();
        tempSubCategoryRouting('equipment');
      } else if (stateObject.tempMainCategory == 'Product') {
        $('.js-temp-perishable-sub-nav').hide();
        tempSubCategoryRouting('product');
      } else if (stateObject.tempMainCategory == 'Perishable Goods') {
        $('.js-temp-perishable-sub-nav').show();
        $('.js-temp-sub-nav').hide();
        $('.js-temp-main-nav').find('li a[data-value="Perishable Goods"]').parent().addClass('active');
        tempSubCategoryRouting('freshproducts');
      } else if (stateObject.tempMainCategory == 'Roller Grill Products') {
        $('.js-temp-perishable-sub-nav').hide();
        tempSubCategoryRouting('rgproducts');
      }
    }
  }
}

function inspection() {
  $('#js-inspection-div').show();
  $('.js-inspect-table-list').show();
  $('.inspection-list').show();
  $('#js-temperature-div').hide();
  $('#js-wastage-div').hide();
  $('.js-employee-antispated-div').hide();
  $('.js-employee-pullover-div').hide();
  $('.js-employee-order-div').hide();
  if ($.cookie('stateObject') && $.cookie('stateObject').surveyId) {
    // $.routes.find('inspectionmaintab').routeTo({
    //   id: $.cookie('stateObject').surveyId,
    //   surveyname: $.cookie('stateObject').mainCategory
    // });

    updateSurvey($.cookie('stateObject').surveyId, $.cookie('stateObject').mainCategory);
    $.cookie('stateObject', null);
  } else {
    $.routes.find('inspectionmaintab').routeTo({
      id: $('#emp-survey-tabs li.active a').attr('data-surveyid'),
      surveyname: $('#emp-survey-tabs li.active a').attr('data-surveyname')
    });
    //updateSurvey($('#emp-survey-tabs li.active a').attr('data-surveyid'),$('#emp-survey-tabs li.active a').attr('data-surveyname'));
  }
  /*loadResults();
   $('.start-inspection-div').hide();
   $('.inspection-div').hide();
   $('.js-inspection-details-div').hide();*/
}

function anticipated() {
  $('.js-employee-antispated-div').show();
  $('#js-inspection-div').hide();
  $('.js-inspect-table-list').hide();
  $('.inspection-list').hide();
  $('#js-temperature-div').hide();
  $('#js-wastage-div').hide();
  $('.js-employee-pullover-div').hide();
  $('.js-employee-order-div').hide();
  if ($.cookie('stateObject') && $.cookie('stateObject').mainCategory) {
    $('.js-store-nav').find('li.active').removeClass('active');
    if ($.cookie('stateObject').mainCategory == 'rollerGrills') {
      $('.js-store-nav').find('li[data-value="rollerGrills"]').addClass('active');
      buildtoRollerGrill('7');
    } else if ($.cookie('stateObject').mainCategory == 'Perishable Goods') {
      $('.js-store-nav').find('li[data-value="Perishable Goods"]').addClass('active');
      $('.js-perishable-sub-nav li').removeClass('active');
      $('.js-perishable-sub-nav').find('li[data-value=' + $.cookie('stateObject').subCategory + ']').addClass('active');
      buildtoFreshproducts('8');
    } else {
      $('.js-store-nav').find('li[data-value="capitalCity"]').addClass('active');
      $('.js-antispated-sub-nav li').removeClass('active');
      if ($.cookie('stateObject').subCategory == "Breakfast") {
        $('.js-antispated-sub-nav').find('li[data-value="Breakfast"]').addClass('active');
      } else if ($.cookie('stateObject').subCategory == "Lunch") {
        $('.js-antispated-sub-nav').find('li[data-value="Lunch"]').addClass('active');
      } else if ($.cookie('stateObject').subCategory == "Dinner") {
        $('.js-antispated-sub-nav').find('li[data-value="Dinner"]').addClass('active');
      }
      buildto('2');
    }
    $.cookie('stateObject', null);
  } else {
    $('.js-store-nav').find('li.active').removeClass('active');
    if ($.cookie('user').capitalCity && !$.cookie('user').rollerGrills && !$.cookie('user').perishableGoods || $.cookie('user').capitalCity && !$.cookie('user').rollerGrills && $.cookie('user').perishableGoods) {
      $('.js-store-nav').find('li[data-value="capitalCity"]').addClass('active');
      anticipatedSubCategoryRouting();
    } else if (!$.cookie('user').capitalCity && $.cookie('user').rollerGrills && !$.cookie('user').perishableGoods || !$.cookie('user').capitalCity && $.cookie('user').rollerGrills && $.cookie('user').perishableGoods) {
      $('.js-store-nav').find('li[data-value="rollerGrills"]').addClass('active');
      $.routes.find('anticipatedmainroutes').routeTo({
        name: 'rollerGrills'
      });
    } else if (!$.cookie('user').capitalCity && !$.cookie('user').rollerGrills && $.cookie('user').perishableGoods) {
      $('.js-store-nav').find('li[data-value="Perishable Goods"]').addClass('active');
      $.routes.find('anticipatedmainroutes').routeTo({
        name: 'perishablegoods',
        subname: $('.js-perishable-sub-nav li.active').attr('data-value')
      });
      if ($('.js-perishable-sub-nav li.active').data('value') =="Core-Mark") {
        buildtoFreshproducts('8');
      }
    } else if ($.cookie('user').capitalCity && $.cookie('user').rollerGrills && !$.cookie('user').perishableGoods || $.cookie('user').capitalCity && $.cookie('user').rollerGrills && $.cookie('user').perishableGoods) {
      $('.js-store-nav').find('li[data-value="capitalCity"]').addClass('active');
      anticipatedSubCategoryRouting();
    }
  }
  //stateObject.anticipatedMainCategory = 'Breakfast';
  $('.build-table .dots-loader').remove();
  $('.js-antispected-actions').hide();
  $('.build-table .js-buildto-head').html('');
  $('.build-table .js-buildto-body').html('');
  $('.build-table').append(styleLoader);
}
$('#js-reports-main').on('click', function(ev) {
  ev.preventDefault();
  $('.employee-main-nav').removeClass('active');
  $('.js-side-sub-nav li:first').addClass('active');
  $('#js-wastage-div').show();
});
$('#logout').on('click', function(ev) {
  ev.preventDefault();
  $.cookie('user', null);
  document.location.href = '/';
  $.cookie('stateObject', null);
});

//}); // document.ready function ending here

$('.js-wastage-sub-nav').on('click', function(ev) {
  ev.preventDefault();
  $('.js-wastage-sub-nav li').removeClass('active');
  $(ev.target).closest('li').addClass('active');
  if ($('.js-wastage-main-nav').find('li.active a').attr('data-value') == "Finished Goods") {
    wasteSubCategoryRouting('finishedgoods');
  } else if ($('.js-wastage-main-nav').find('li.active a').attr('data-value') == "Ingredients") {
    wasteSubCategoryRouting('ingredients');
  }
});

function wasteSubCategoryRouting(loadfrom) {
  if (loadfrom == "finishedgoods") {
    stateObject.mainCategory = "Finished Goods";
    $('.js-wastage-sub-nav').show();
    $('.js-wastage-sub-nav-times').hide();
    if ($('.js-wastage-sub-nav li.active').data('value')) {
      if ($('.js-wastage-sub-nav li.active').data('value') == "Breakfast") {
        $.routes.find('wastemainroutes').routeTo({
          name: 'finishedgoods',
          subname: 'breakfast'
        });
      } else if ($('.js-wastage-sub-nav li.active').data('value') == "Lunch") {
        $.routes.find('wastemainroutes').routeTo({
          name: 'finishedgoods',
          subname: 'lunch'
        });
      } else if ($('.js-wastage-sub-nav li.active').data('value') == "Dinner") {
        $.routes.find('wastemainroutes').routeTo({
          name: 'finishedgoods',
          subname: 'dinner'
        });
      }
    } else {
      $('.js-wastage-sub-nav li[data-value="Breakfast"]').addClass('active');
      $.routes.find('wastemainroutes').routeTo({
        name: 'finishedgoods',
        subname: 'breakfast'
      });
    }
  } else if (loadfrom == "ingredients") {
    stateObject.mainCategory = "Ingredients";
    $('.js-wastage-sub-nav').show();
    $('.js-wastage-sub-nav-times').show();
    if ($('.js-wastage-sub-nav li.active').data('value')) {
      if ($('.js-wastage-sub-nav li.active').data('value') == "Breakfast") {
        $.routes.find('wastemainroutes').routeTo({
          name: 'ingredients',
          subname: 'breakfast'
        });
      } else if ($('.js-wastage-sub-nav li.active').data('value') == "Lunch") {
        $.routes.find('wastemainroutes').routeTo({
          name: 'ingredients',
          subname: 'lunch'
        });
      } else if ($('.js-wastage-sub-nav li.active').data('value') == "Dinner") {
        $.routes.find('wastemainroutes').routeTo({
          name: 'ingredients',
          subname: 'dinner'
        });
      }
    } else {
      $('.js-wastage-sub-nav li[data-value="Breakfast"]').addClass('active');
      $.routes.find('wastemainroutes').routeTo({
        name: 'ingredients',
        subname: 'breakfast'
      });
    }
  } else if (loadfrom == "perishablegoods") {
    if ($('.js-perishable-waste-nav li.active').attr('data-value')) {
      $.routes.find('wastemainroutes').routeTo({
        name: 'perishablegoods',
        subname: $('.js-perishable-waste-nav li.active').attr('data-value')
      });
    }
    if ($('.js-perishable-waste-nav li.active').attr('data-value') == "Core-Mark") {
      loadFreshProducts();
    }
  }
}

function tempSubCategoryRouting(loadfrom) {
  stateObject.tempMainCategory = $('.js-temp-main-nav li.active a').data('value');
  stateObject.tempSubCategory = $('.js-temp-sub-nav li.active').data('value');
  if (loadfrom == "product") {
    if ($('.js-temp-sub-nav li.active').attr('data-value') == "Open") {
      $.routes.find('tempmainroutes').routeTo({
        name: 'product',
        subname: 'open'
      });
    } else if ($('.js-temp-sub-nav li.active').attr('data-value') == "Peak") {
      $.routes.find('tempmainroutes').routeTo({
        name: 'product',
        subname: 'peak'
      });
    } else if ($('.js-temp-sub-nav li.active').attr('data-value') == "Breakdown") {
      $.routes.find('tempmainroutes').routeTo({
        name: 'product',
        subname: 'breakdown'
      });
    }
  } else if (loadfrom == "equipment") {
    if ($('.js-temp-sub-nav li.active').attr('data-value') == "Open") {
      $.routes.find('tempmainroutes').routeTo({
        name: 'equipment',
        subname: 'open'
      });
    } else if ($('.js-temp-sub-nav li.active').attr('data-value') == "Peak") {
      $.routes.find('tempmainroutes').routeTo({
        name: 'equipment',
        subname: 'peak'
      });
    } else if ($('.js-temp-sub-nav li.active').attr('data-value') == "Breakdown") {
      $.routes.find('tempmainroutes').routeTo({
        name: 'equipment',
        subname: 'breakdown'
      });
    }
  } else if (loadfrom == "rgproducts") {
    $.routes.find('tempmainroutes').routeTo({
      name: 'temprgproducts',
      subname: $('.js-temp-roller-sub-nav li.active').attr('data-category-time-id')
    });
  } else if (loadfrom == "freshproducts") {
    stateObject.pershible_category_time_id = $('.js-temp-perishable-sub-nav li.active').attr('data-category_time_id');
    $.routes.find('tempmainroutes').routeTo({
      name: 'perishablegoods',
      subname: $('.js-temp-perishable-sub-nav li.active').attr('data-category_time_id')
    });
  }
}

function anticipatedSubCategoryRouting() {
  if ($('.js-antispated-sub-nav li.active').data('value') == "Breakfast") {
    $.routes.find('anticipatedmainroutes').routeTo({
      name: 'capitalCity',
      subname: 'breakfast'
    });
  } else if ($('.js-antispated-sub-nav li.active').data('value') == "Lunch") {
    $.routes.find('anticipatedmainroutes').routeTo({
      name: 'capitalCity',
      subname: 'lunch'
    });
  } else if ($('.js-antispated-sub-nav li.active').data('value') == "Dinner") {
    $.routes.find('anticipatedmainroutes').routeTo({
      name: 'capitalCity',
      subname: 'dinner'
    });
  }
}

function orderManagement() {
  $('#js-ordermanage').show();
  $('#js-order-management-site-div').show();
}

$(document).delegate('.js-temp-perishable-sub-nav li', 'click', function(el, ev) {
  $('.js-temp-perishable-sub-nav li').removeClass('active');
  $(this).addClass('active');
  stateObject.pershible_category_time_id = $('.js-temp-perishable-sub-nav li.active').attr('data-category_time_id');
  tempSubCategoryRouting('freshproducts');
});

$(document).delegate('.js-perishable-waste-nav li', 'click', function(ev) {
  ev.preventDefault();
  $('.js-perishable-waste-nav li.active').removeClass('active');
  $(this).addClass('active');
  wasteSubCategoryRouting('perishablegoods');
});

$(document).delegate('.js-perishable-sub-nav li', 'click', function(ev) {
  ev.preventDefault();
  $('.js-perishable-sub-nav li.active').removeClass('active');
  $(this).addClass('active');
  $.routes.find('anticipatedmainroutes').routeTo({
    name: 'perishablegoods',
    subname: $('.js-perishable-sub-nav li.active').data('value')
  });
  if ($('.js-perishable-sub-nav li.active').data('value') =="Core-Mark") {
    buildtoFreshproducts('8');
  }
});

$(document).delegate('.js-temp-pullsheet-sub-nav li', 'click', function(ev) {
  ev.preventDefault();
  $('.js-temp-pullsheet-sub-nav li').removeClass('active');
  $(this).addClass('active');
  stateObject.pullover_category_id = $('.js-temp-pullsheet-sub-nav li.active').attr('data-category-time-id');
  stateObject.category_times = $('.js-temp-pullsheet-sub-nav li.active').attr('data-value');
  $.routes.find('pullsheet').routeTo({
    name: $('.js-pullover-employee li.active').attr('data-value'),
    subname: $('.js-temp-pullsheet-sub-nav li.active').attr('data-category-time-id')
  });
});
