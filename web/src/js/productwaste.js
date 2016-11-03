var stateObject = {};
var styleLoader = '<div class="col-lg-offset-5 dots-loader spinner-div-style">Loading…</div>';
$(document).ready(function() {
  $('#js-recordWaste-today-day').text(moment().format('dddd'));
  freshProductsTemplate = MyApp.templates.freshproducts;
  pulloverTornodoesTemplate = MyApp.templates.pulloveremployee;
  pulloverTimeTemplate = MyApp.templates.pullovertimeslots;
  pulloverHotdogsTemplate = MyApp.templates.pulloveradmin;
  productsTemplate = MyApp.templates.finishedgoods;
  ingredientsTemplate = MyApp.templates.ingredients;
  //freezeTableCreationTemplate = MyApp.templates.freezeTableCreation;
  timeTemplate = MyApp.templates.times_template;
  $('#js-user-name').text($.cookie('user').username + '-' + $.cookie('user').role);
  $('#js-user-role').text($.cookie('user').role);
  $('#js-today-date-waste').val(moment().format("MMM Do YYYY"));
  $('#js-today-date-waste').datetimepicker({
    minDate: moment().subtract(1, 'month').format('MM DD YYYY'),
    ignoreReadonly: true,
    format: 'MMM Do YYYY',
    maxDate: moment()
  });
  $(document).delegate('.fa-calendar', 'click', function(ev) {
    //Trigger the event on the next element.
    $(this).next().trigger('select');
  });


  $('#js-today-date-waste').on('dp.change', function(ev) {
    //alert($(this).val());
    //Now we get the Date and Need to Reload the Screen with Previous Values.
    $('#js-recordWaste-today-day').text(moment($('#js-today-date-waste').val(), 'MMM Do YYYY').format('dddd'));
    if (stateObject.mainCategory === 'Ingredients') {

      loadIngredients();
      $('.waste-table').append(styleLoader);
    } else if (stateObject.mainCategory === 'Finished Goods') {
      loadProductWaste();
      $('.waste-table').append(styleLoader);
    } else if (stateObject.mainCategory === 'Roller Grill Finished Goods') {
      rollerGrillProducts();
      $('.waste-table').append(styleLoader);
    } else if (stateObject.mainCategory === 'Roller Grill Ingredients') {
      rollerGrillIngredients();
      $('.waste-table').append(styleLoader);
    } else if (stateObject.mainCategory === 'Perishable Goods') {
      loadFreshProducts();
      $('.waste-table').append(styleLoader);
    }
    $('.js-product-waste-complete').hide();
    $('.js-product-waste-save').hide();
    $('.js-product-ingredient-waste-save').hide();
    $('.js-product-ingredient-waste-complete').hide();
  });
  $('.js-wastage-sub-nav-times li').addClass('hide');
  stateObject.mainCategory = $('.js-wastage-main-nav li.active a').data('value');
  stateObject.subCategory = $('.js-wastage-sub-nav li.active').data('value');
  // if (!$.cookie('user').capitalCity) {
  //   stateObject.mainCategory = 'Roller Grill Finished Goods';
  // }
  if (stateObject.mainCategory === 'Ingredients') {

    loadIngredients();
    $('.waste-table').append(styleLoader);
  } else if (stateObject.mainCategory === 'Finished Goods') {
    loadProductWaste();
    $('.waste-table').append(styleLoader);
  } else if (stateObject.mainCategory === 'Roller Grill Finished Goods') {
    rollerGrillProducts();
    $('.waste-table').append(styleLoader);
  } else if (stateObject.mainCategory === 'Roller Grill Ingredients') {
    rollerGrillIngredients();
    $('.waste-table').append(styleLoader);
  } else if (stateObject.mainCategory === 'Perishable Goods') {
    loadFreshProducts();
    $('.waste-table').append(styleLoader);
  }
  // $('.js-wastage-main-nav li').click(function(ev) {
  //   ev.preventDefault();
  //   $('.js-wastage-main-nav li').removeClass('active');
  //   $(ev.target).closest('li').addClass('active');
  //   stateObject.mainCategory = $(ev.target).closest('li').find('a').data('value');
  //   if (stateObject.mainCategory === 'Ingredients') {
  //     loadIngredients();
  //     $('.js-wastage-sub-nav').show();
  //   } else if (stateObject.mainCategory === 'Finished Goods') {
  //     loadProductWaste();
  //     $('.js-wastage-sub-nav').show();
  //   }
  //
  //   $('.waste-table .dots-loader').remove();
  //   $('.js-waste-actions').hide();
  //   $('.waste-table .js-products-head').html('');
  //   $('.waste-table .js-products-body').html('');
  //   $('.waste-table').append(styleLoader);
  //   $($('.js-wastage-sub-nav-times li')).addClass('hide');
  // });

  // $('.js-wastage-sub-nav li').click(function(ev) {
  //   ev.preventDefault();
  //   $('.js-wastage-sub-nav li').removeClass('active');
  //   $(ev.target).closest('li').addClass('active');
  //   stateObject.subCategory = $(ev.target).closest('li').data('value');
  //   if (stateObject.mainCategory === 'Ingredients') {
  //     $('.js-wastage-sub-nav-times li').addClass('hide');
  //     var targetIndex = $('.js-wastage-sub-nav').find('li ').index($(ev.target).closest('li'));
  //     $($('.js-wastage-sub-nav-times li')[targetIndex]).removeClass('hide');
  //     loadIngredients();
  //   } else {
  //     loadProductWaste();
  //   }
  //   $('.waste-table .dots-loader').remove();
  //   $('.js-waste-actions').hide();
  //   $('.waste-table .js-products-head').html('');
  //   $('.waste-table .js-products-body').html('');
  //   $('.waste-table').append(styleLoader);
  // });
  $('#js-wastage-div').delegate('.js-product-waste-entry', 'blur', function(ev) {
    ev.preventDefault();
    if ($(ev.target).data('unit-type') === 'oz') {
      var noofozs = $(ev.target).val();
      if (noofozs > 16) {
        $(ev.target).val(noofozs % 16);
        var $poundsEl = $(ev.target).parent().prev().find('.js-product-waste-entry-pounds');
        $poundsEl.val(parseInt(noofozs / 16));
      }
    }


  });
  $('#js-wastage-div').delegate('.js-product-waste-entry-pounds', 'blur', function(ev) {
    ev.preventDefault();
    if ($(ev.target).data('unit-type') === 'pounds') {
      var poundsCount = $(ev.target).val();
      if (poundsCount > 0 && poundsCount % 1 !== 0) {
        var totalOz = poundsCount * 16;
        $(this).val(parseInt(totalOz / 16));
        var $ozEl = $(ev.target).parent().next().find('.js-product-waste-entry');
        $ozEl.val(new Number(totalOz % 16).toFixed(4));
      }
    }


  });

  $('.js-product-waste-complete').on('click', function(ev) {
    ev.preventDefault();
    $('#confirmationAction').modal('show');
    $('#js-success-complete').data('loadfrom', 'finishedGoods');
  });

  $('#js-success-complete').on('click', function(ev) {
    ev.preventDefault();
    if ($(this).data('loadfrom') == "finishedGoods") {
      saveProductWaste('complete');
    } else if ($(this).data('loadfrom') == "ingredients") {
      saveProductIngredientWaste('complete');
    }

  });
  $('#js-wastage-div').delegate('.js-product-waste-entry', 'keyup', function(ev) {
    if ($(this).hasClass('error-whole-number')) {
      $(this).removeClass('error-whole-number');
      $(this).parent().closest('tr').find('.form-control').each(function(i, el) {
        if (!$(el).val()) {
          $(el).removeClass('error-whole-number');
        }
      });
    }
  });
  $('.js-product-waste-save').on('click', function(ev) {
    ev.preventDefault();
    $('.js-product-waste-save').button('loading');
    saveProductWaste('draft');
  });


  $('.js-product-ingredient-waste-complete').on('click', function(ev) {
    ev.preventDefault();
    $('#confirmationAction').modal('show');
    $('#js-success-complete').data('loadfrom', 'ingredients');
    //saveProductIngredientWastea('complete');
  });
  $('.js-product-ingredient-waste-save').on('click', function(ev) {
    ev.preventDefault();
    $('.js-product-ingredient-waste-save').button('loading');
    saveProductIngredientWaste('draft');
  });
});

function saveProductWaste(status) {
  $('#confirmationAction').modal('hide');
  var productWasteArray = [];
  var allValid = true;
  $('.js-products-body').find('input.js-product-waste-entry:filled:enabled').each(function(index, el) {
    var thisElement = $(el);
    var productWaste = pushProductWaste(thisElement, status);
    if (thisElement.val() <= 0 || thisElement.val() % 1 !== 0 || thisElement.val().length > 7) {
      allValid = false;
      thisElement.addClass('error-whole-number');
    } else {

    }
    if (parseInt(productWaste.no_of_units) > 0) {
      productWasteArray.push(productWaste);
    }


  });

  $('.js-products-body input.js-product-waste-entry').filter(function() {
    return $(this).attr("data-waste-id") > 0;
  }).each(function(i, el) {
    if (!$(el).val()) {

      var thisElement = $(el);
      var productWaste = pushProductWaste(thisElement);
      productWaste.no_of_units = 0;
      productWasteArray.push(productWaste);
    }
  });

  if (allValid && productWasteArray.length > 0) {

    $.ajax({
      type: "POST",
      url: apiURL + "/products/finishedgoods",
      data: JSON.stringify(productWasteArray),
      contentType: "application/json; charset=utf-8",
      success: function(response) {
        if (status == "draft") {
          var test = "Saved but not completed."
        } else {
          var test = "Product Waste has been completed successfully."
          $('.js-product-waste-save').button("reset");
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
        $('.js-product-waste-save').button("reset");
        if ($('.js-wastage-main-nav li.active a').attr('data-value') === 'Ingredients') {

          loadIngredients();
          $('.waste-table').append(styleLoader);
        } else if ($('.js-wastage-main-nav li.active a').attr('data-value') === 'Finished Goods') {
          loadProductWaste();
          $('.waste-table').append(styleLoader);
        } else if ($('.js-wastage-main-nav li.active a').attr('data-value') === 'Roller Grill Finished Goods') {
          rollerGrillProducts();
          $('.waste-table').append(styleLoader);
        } else if ($('.js-wastage-main-nav li.active a').attr('data-value') === 'Roller Grill Ingredients') {
          rollerGrillIngredients();
          $('.waste-table').append(styleLoader);
        } else if ($('.js-wastage-main-nav li.active a').attr('data-value') === 'Perishable Goods') {
          loadFreshProducts();
          $('.waste-table').append(styleLoader);
        } else {
          loadIngredients();
          $('.waste-table').append(styleLoader);
        }
      },
      error: function(xhr, err, status) {
        // $('.js-product-waste-save').button("reset");
        new PNotify({
          title: 'Error',
          text: 'Save not successful',
          type: 'error',
          styling: 'fontawesome',
          hide: true,
          delay: 2000
        });
        $('.js-product-waste-save').button("reset");
      }
    });
  } else if (!allValid) {
    $('.js-product-waste-save').button("reset");
    if ($('.ui-pnotify').length <= 1) {
      new PNotify({
        title: 'Error',
        text: 'Please fix the data fields highlighted in red.',
        type: 'error',
        styling: 'fontawesome',
        hide: true,
        delay: 2000
      });
    }
  } else {
    $('.js-product-waste-save').button("reset");
  }
}

function pushProductWaste(element, status) {
  var productWaste = {};
  productWaste.product_id = element.closest('tr').attr('data-id');
  productWaste.store_id = $.cookie('user').storeid;
  if (element.data('waste-id') > 0) {
    productWaste.id = element.data('waste-id');
  } else {
    productWaste.id = 0;
  }
  productWaste.no_of_units = element.val();
  productWaste.unit_type = 'each'
  productWaste.product_availability_id = element.data('category-id');
  if (stateObject.mainCategory === 'Ingredients') {
    //Do not need Avaialable Category ID
    productWaste.available_category_id = null;
  } else {
    productWaste.available_category_id = element.data('category-time-id');
  }
  productWaste.status = status;
  productWaste.waste_reported_date = moment($('#js-today-date-waste').val(), 'MMM Do YYYY').format('YYYY-MM-DD');

  return productWaste;
}

function saveProductIngredientWaste(status) {
  $('#confirmationAction').modal('hide');
  var productWasteArray = [];
  var allValid = true;
  $('.js-products-body').find('tr').each(function(index, el) {
    var productWaste = {};
    if ($(el).find('td input:disabled').length == 0) {
      productWaste.product_id = $(el).data('product-id');
      productWaste.store_id = $.cookie('user').storeid;
      if ($(el).data('waste-id') > 0) {
        productWaste.id = $(el).data('waste-id');
      } else {
        productWaste.id = 0;
      }
      //Calculate this Based on Unit Type
      var unitType = $(el).data('unit-type');
      if (unitType === 'each') {
        productWaste.no_of_units = $(el).find('td input.js-product-waste-entry').val();
        if (productWaste.no_of_units && (productWaste.no_of_units <= 0 || productWaste.no_of_units % 1 !== 0 || $(el).find('td input.js-product-waste-entry').val().length > 7)) {
          allValid = false;
          $(el).find('td input').addClass('error-whole-number');
        } else if (productWaste.id > 0 && !productWaste.no_of_units) {
          productWaste.no_of_units = 0 + '';
        }
      } else {
        var pounds = $(el).find('td input.js-product-waste-entry-pounds').val();
        var oz = $(el).find('td input.js-product-waste-entry').val();
        if (pounds || oz) {
          productWaste.no_of_units = ((pounds > 0) ? parseInt(parseInt(pounds) * 16) : 0) + ((oz > 0) ? parseFloat(oz) : 0);
          if (productWaste.no_of_units <= 0) {
            allValid = false;
            $(el).find('td input').addClass('error-whole-number');
          }
          if ($(el).find('td input.js-product-waste-entry-pounds').val().length > 7) {
            allValid = false;
            $(el).find('td input.js-product-waste-entry-pounds').addClass('error-whole-number');
          }
        }
        if ((pounds && (pounds < 0)) || (oz && (oz < 0)) || productWaste.no_of_units < 0) {
          allValid = false;
          $(el).find('td input').addClass('error-whole-number');
        } else {
          productWaste.no_of_units = (((pounds > 0) ? parseInt(parseInt(pounds) * 16) : 0) + ((oz > 0) ? parseFloat(oz) : 0)).toString();
        }
        if (productWaste.id > 0 && !pounds && !oz) {
          productWaste.no_of_units = 0 + '';
        }
      }
      productWaste.unit_type = $(el).data('unit-type');
      productWaste.product_availability_id = $(el).data('category-id');
      productWaste.status = status;
      productWaste.available_category_id = null;
      productWaste.waste_reported_date = moment($('#js-today-date-waste').val(), 'MMM Do YYYY').format('YYYY-MM-DD');

      if (allValid && (parseFloat(productWaste.no_of_units) > 0 || productWaste.id > 0)) {
        productWasteArray.push(productWaste);
      }
    }
  });
  if (allValid && productWasteArray.length > 0) {
    $.ajax({
      type: "POST",
      url: apiURL + "/products/finishedgoods",
      data: JSON.stringify(productWasteArray),
      contentType: "application/json; charset=utf-8",
      success: function(response) {
        if (status == "draft") {
          var test = "Saved but not completed."
        } else {
          var test = "Product Waste has been completed successfully."
          $('.js-product-ingredient-waste-save').button('reset');
        }
        console.log(response);
        // $('.js-product-ingredient-waste-save').button('reset');
        new PNotify({
          title: 'Success!',
          text: test,
          type: 'success',
          styling: 'fontawesome',
          hide: true,
          delay: 2000
        });
        $('.js-product-ingredient-waste-save').button('reset');
        if ($('.js-wastage-main-nav li.active a').attr('data-value') === 'Ingredients') {
          loadIngredients();
          $('.waste-table').append(styleLoader);
        } else if ($('.js-wastage-main-nav li.active a').attr('data-value') === 'Finished Goods') {
          loadProductWaste();
          $('.waste-table').append(styleLoader);
        } else if ($('.js-wastage-main-nav li.active a').attr('data-value') === 'Roller Grill Finished Goods') {
          rollerGrillProducts();
          $('.waste-table').append(styleLoader);
        } else if ($('.js-wastage-main-nav li.active a').attr('data-value') === 'Roller Grill Ingredients') {
          rollerGrillIngredients();
          $('.waste-table').append(styleLoader);
        } else if ($('.js-wastage-main-nav li.active a').attr('data-value') === 'Perishable Goods') {
          loadFreshProducts();
          $('.waste-table').append(styleLoader);
        } else {
          loadIngredients();
          $('.waste-table').append(styleLoader);
        }

      },
      error: function(err) {
        $('.js-product-ingredient-waste-save').button('reset');
        new PNotify({
          title: 'Error',
          text: 'Save not successful',
          type: 'error',
          styling: 'fontawesome',
          hide: true,
          delay: 2000
        });
        $('.js-product-ingredient-waste-save').button('reset');
      }
    });
  } else if (!allValid) {
    new PNotify({
      title: 'Error',
      text: 'Please fix the data fields highlighted in red.',
      type: 'error',
      styling: 'fontawesome',
      hide: true,
      delay: 2000
    });
    $('.js-product-ingredient-waste-save').button('reset');
  } else {
    $('.js-product-ingredient-waste-save').button('reset');
  }
}

function pushIngredientsWaste(element, status) {
  var productWaste = {};
  if (element.find('td input:disabled').length == 0) {
    productWaste.product_id = element.data('product-id');
    productWaste.store_id = $.cookie('user').storeid;
    productWaste.isValid = true;
    if (element.data('waste-id') > 0) {
      productWaste.id = element.data('waste-id');
    } else {
      productWaste.id = 0;
    }
    //Calculate this Based on Unit Type
    productWaste.unit_type = element.data('unit-type');
    productWaste.product_availability_id = element.data('category-id');
    productWaste.status = status;
    productWaste.available_category_id = null;
    productWaste.waste_reported_date = moment($('#js-today-date-waste').val(), 'MMM Do YYYY').format('YYYY-MM-DD');
    var el = element;
    var unitType = $(el).data('unit-type');
    if (unitType === 'each') {
      productWaste.no_of_units = $(el).find('td input.js-product-waste-entry').val();
      if (productWaste.no_of_units && (productWaste.no_of_units <= 0 || productWaste.no_of_units % 1 !== 0)) {
        productWaste.isValid = false;
        $(el).find('td input').addClass('error-whole-number');
      }
    } else {
      var pounds = $(el).find('td input.js-product-waste-entry-pounds').val();
      var oz = $(el).find('td input.js-product-waste-entry').val();
      if (pounds || oz) {
        productWaste.no_of_units = ((pounds > 0) ? parseInt(parseInt(pounds) * 16) : 0) + ((oz > 0) ? parseFloat(oz) : 0);
        if (productWaste.no_of_units <= 0) {
          productWaste.isValid = false;
          $(el).find('td input').addClass('error-whole-number');
        }
      }
      if ((pounds && (pounds < 0)) || (oz && (oz < 0)) || productWaste.no_of_units < 0) {
        productWaste.isValid = false;
        $(el).find('td input').addClass('error-whole-number');
      } else {
        productWaste.no_of_units = (((pounds > 0) ? parseInt(parseInt(pounds) * 16) : 0) + ((oz > 0) ? parseFloat(oz) : 0)).toString();
      }
    }
  }
  return productWaste;
}

function loadProductWaste() {
  $('.js-alert-success').hide();
  if (moment($('#js-today-date-waste').val(), 'MMM Do YYYY').format('YYYY-MM-DD')) {
    var report_date = moment($('#js-today-date-waste').val(), 'MMM Do YYYY').format('YYYY-MM-DD');
  } else {
    var report_date = moment().format('YYYY-MM-DD');
  }
  var defered1 = $.ajax({
    type: "GET",
    url: apiURL + "/products/finishedgoods",
    data: {
      "category_name": $('.js-wastage-sub-nav li.active').data('value'),
      "product_type": $('.js-wastage-main-nav li.active a').attr('data-value'),
      "storeid": $.cookie('user').storeid,
      "waste_reported_date": report_date
    },
    contentType: "application/json; charset=utf-8"
  });
  var defered2 = $.ajax({
    type: "GET",
    url: apiURL + "/products/time_categories",
    data: {
      "category_name": $('.js-wastage-sub-nav li.active').data('value')
    },
    contentType: "application/json; charset=utf-8"
  });

  $.when(defered1, defered2).then(function(v1, v2) {
    var timedata = {
      times: v2[0].response
    };
    var productdata = {
      products: v1[0].response,
      times: v2[0].response
    };
    var timeHeaderHtml = timeTemplate(timedata);
    var productsHtml = productsTemplate(productdata);
    $('.waste-table .dots-loader').remove();
    $('.js-waste-actions').show();
    $('.js-products-head').html(timeHeaderHtml);
    $('.js-products-body').html(productsHtml);
    var columnCount = 0;
    $('.js-products-body tr').each(function() {
      columnCount = Math.max(columnCount, $(this).children('td').length);
    });

    var cellCounter = 1;
    for (var columnIndex = 0; columnIndex < columnCount; ++columnIndex) {
      $('.js-products-body tr').each(function() {
        var cell = $(this).children('td').eq(columnIndex).find('input');
        if (cell != null) {
          cell.attr('tabindex', cellCounter++);
        }
      });
    }
    if (moment($('#js-today-date-waste').val(), 'MMM Do YYYY').isSame(moment(), 'day')) {
      $('.js-product-waste-complete').show();
      $('.js-product-waste-save').show();
      $('.js-product-ingredient-waste-save').hide();
      $('.js-product-ingredient-waste-complete').hide();
    } else {
      if ($('#js-today-date-waste').val() == moment().add(-1, 'days').format('MMM Do YYYY')) {
        if (moment(moment(moment(), 'day').format("YYYY-MM-DD HH:mm:ss")).unix() <= moment(moment().add('day').format("YYYY-MM-DD " + $.cookie('user').lockTime)).unix()) {
          $('.js-product-waste-complete').show();
          $('.js-product-waste-save').show();
          $('.js-product-ingredient-waste-save').hide();
          $('.js-product-ingredient-waste-complete').hide();
        } else {
          $('.js-products-body').find('input').prop('disabled', true);
        }
      } else {
        $('.js-products-body').find('input').prop('disabled', true);
      }
    }
  }, function(err) {
    console.error(err);
  });

}

function loadIngredients() {
  $('.js-alert-success').hide();
  var defered1 = $.ajax({
    type: "GET",
    url: apiURL + "/products/ingredients",
    data: {
      "category_name": $('.js-wastage-sub-nav li.active').data('value'),
      "product_type": $('.js-wastage-main-nav').find('li.active a').attr('data-value'),
      "storeid": $.cookie('user').storeid,
      "waste_reported_date": moment($('#js-today-date-waste').val(), 'MMM Do YYYY').format('YYYY-MM-DD')
    },
    contentType: "application/json; charset=utf-8"
  });


  $.when(defered1).then(function(v1) {
    var productdata = {
      products: v1.response
    };
    var productsHtml = ingredientsTemplate(productdata);
    $('.waste-table .dots-loader').remove();
    $('.js-products-head').html("<th>Item Name<br/></th><th>Waste</th><th></th>");
    $('.js-products-body').html(productsHtml);
    $('.js-waste-actions').hide();
    $('.js-ingredient-waste-actions').show();
    if (moment($('#js-today-date-waste').val(), 'MMM Do YYYY').isSame(moment(), 'day')) {
      $('.js-product-ingredient-waste-save').show();
      $('.js-product-ingredient-waste-complete').show();
      $('.js-product-waste-complete').hide();
      $('.js-product-waste-save').hide();
    } else {
      if ($('#js-today-date-waste').val() == moment().add(-1, 'days').format('MMM Do YYYY')) {
        if (moment(moment(moment(), 'day').format("YYYY-MM-DD HH:mm:ss")).unix() <= moment(moment().add('day').format("YYYY-MM-DD " + $.cookie('user').lockTime)).unix()) {
          $('.js-product-ingredient-waste-save').show();
          $('.js-product-ingredient-waste-complete').show();
          $('.js-product-waste-complete').hide();
          $('.js-product-waste-save').hide();
        } else {
          $('.js-products-body').find('input').prop('disabled', true);
        }
      } else {
        $('.js-products-body').find('input').prop('disabled', true);
      }
    }
    if ($('.js-wastage-sub-nav li.active').data('value') === 'Breakfast') {
      //console.log($('.js-wastage-sub-nav-times li').first());
      $('.js-wastage-sub-nav-times li').first().removeClass('hide');
    } else if ($('.js-wastage-sub-nav li.active').data('value') === 'Lunch') {
      $($('.js-wastage-sub-nav-times li')[1]).removeClass('hide');
    } else {
      $('.js-wastage-sub-nav-times li').last().removeClass('hide');
    }

  }, function(err) {
    console.error(err);
  });

}


$(document).delegate('#js-roller_select-level', 'change', function(ev) {
  ev.preventDefault();
  $('#js-roller-levels').show();
  var defered1 = $.ajax({
    type: "GET",
    url: apiURL + "/products/rollergrills",
    data: {
      "category_name": "Roller",
      "product_type": "Roller Grill Finished Goods",
      "storeid": $.cookie('user').storeid,
      "waste_reported_date": moment($('#js-today-date-waste').val(), 'MMM Do YYYY').format('YYYY-MM-DD'),
      "level_name": $('#js-roller_select-level option:selected').val()
    },
    contentType: "application/json; charset=utf-8"
  });
  var defered2 = $.ajax({
    type: "GET",
    url: apiURL + "/roller/time_categories",
    data: {
      "category_name": "Roller",
      "level_name": $('#js-roller_select-level option:selected').val()
    },
    contentType: "application/json; charset=utf-8"
  });
  // var defered3 = $.ajax({
  //     type: "GET",
  //     url: apiURL + "/roller/levels",
  //     contentType: "application/json; charset=utf-8"
  // });

  $.when(defered1, defered2).then(function(v1, v2) {
    //console.log(v1[0].response);
    var timedata = {
      times: v2[0].response
    };
    var productdata = {
      products: v1[0].response,
      times: v2[0].response
    };

    //console.log(leveldata);


    var timeHeaderHtml = timeTemplate(timedata);
    var productsHtml = productsTemplate(productdata);

    $('.waste-table .dots-loader').remove();
    $('.js-waste-actions').show();
    $('.js-ingredient-waste-actions').hide();
    $('.js-products-head').html(timeHeaderHtml);
    $('.js-products-body').html(productsHtml);

    var columnCount = 0;
    $('.js-products-body tr').each(function() {
      columnCount = Math.max(columnCount, $(this).children('td').length);
    });

    var cellCounter = 1;
    for (var columnIndex = 0; columnIndex < columnCount; ++columnIndex) {
      $('.js-products-body tr').each(function() {
        var cell = $(this).children('td').eq(columnIndex).find('input');
        if (cell != null) {
          cell.attr('tabindex', cellCounter++);
        }
      });
    }
    $('.js-wastage-sub-nav').hide();
    //$(".main-content-rollerGrills").html(freezeTableCreationTemplate(tableList));
    if (!moment($('#js-today-date-waste').val(), 'MMM Do YYYY').isSame(moment(), 'day')) {
      $('.js-products-body').find('input').prop('disabled', true);
    } else {
      $('.js-product-waste-save').show();
      $('.js-product-waste-complete').show();
      $('.js-product-ingredient-waste-save').hide();
      $('.js-product-ingredient-waste-complete').hide();
    }
    $('.js-product-rollerProducts-save').on('click', function(ev) {
      ev.preventDefault();
      // console.log('drafted');
      saveProductWaste('draft');
    });
    $('.js-product-rollerProducts-complete').on('click', function(ev) {
      ev.preventDefault();
      //console.log('complete');
      saveProductWaste('complete');
    });
  }, function(err) {
    console.error(err);
  });
});



function rollerGrillProducts() {
  $.ajax({
    type: "GET",
    url: apiURL + "/products/LevelId",
    data: {
      "store_id": $.cookie('user').storeid
    },
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      var level_id = response.response[0].level_id;
      var defered1 = $.ajax({
        type: "GET",
        url: apiURL + "/products/rollergrills",
        data: {
          "category_name": "Roller",
          "product_type": "Roller Grill Finished Goods",
          "storeid": $.cookie('user').storeid,
          "waste_reported_date": moment($('#js-today-date-waste').val(), 'MMM Do YYYY').format('YYYY-MM-DD'),
          "level_id": level_id
        },
        contentType: "application/json; charset=utf-8"
      });
      var defered2 = $.ajax({
        type: "GET",
        url: apiURL + "/roller/time_categories",
        data: {
          "category_name": "Roller",
          "level_id": level_id
        },
        contentType: "application/json; charset=utf-8"
      });
      $.when(defered1, defered2).then(function(v1, v2) {
        //console.log(v1[0].response);
        var timedata = {
          times: v2[0].response
        };
        var productdata = {
          products: v1[0].response,
          times: v2[0].response
        };

        //console.log(leveldata);


        var timeHeaderHtml = timeTemplate(timedata);
        var productsHtml = productsTemplate(productdata);

        $('.waste-table .dots-loader').remove();
        $('.js-waste-actions').show();
        $('.js-ingredient-waste-actions').hide();
        $('.js-products-head').html(timeHeaderHtml);
        $('.js-products-body').html(productsHtml);

        var columnCount = 0;
        $('.js-products-body tr').each(function() {
          columnCount = Math.max(columnCount, $(this).children('td').length);
        });

        var cellCounter = 1;
        for (var columnIndex = 0; columnIndex < columnCount; ++columnIndex) {
          $('.js-products-body tr').each(function() {
            var cell = $(this).children('td').eq(columnIndex).find('input');
            if (cell != null) {
              cell.attr('tabindex', cellCounter++);
            }
          });
        }
        $('.js-wastage-sub-nav').hide();
        //$(".main-content-rollerGrills").html(freezeTableCreationTemplate(tableList));
        if (moment($('#js-today-date-waste').val(), 'MMM Do YYYY').isSame(moment(), 'day')) {
          $('.js-product-waste-save').show();
          $('.js-product-waste-complete').show();
          $('.js-product-ingredient-waste-save').hide();
          $('.js-product-ingredient-waste-complete').hide();
        } else {
          if ($('#js-today-date-waste').val() == moment().add(-1, 'days').format('MMM Do YYYY')) {
            if (moment(moment(moment(), 'day').format("YYYY-MM-DD HH:mm:ss")).unix() <= moment(moment().add('day').format("YYYY-MM-DD " + $.cookie('user').lockTime)).unix()) {
              $('.js-product-waste-save').show();
              $('.js-product-waste-complete').show();
              $('.js-product-ingredient-waste-save').hide();
              $('.js-product-ingredient-waste-complete').hide();
            } else {
              $('.js-products-body').find('input').prop('disabled', true);
            }
          } else {
            $('.js-products-body').find('input').prop('disabled', true);
          }
        }
        $('.js-product-rollerProducts-save').on('click', function(ev) {
          ev.preventDefault();
          // console.log('drafted');
          saveProductWaste('draft');
        });
        $('.js-product-rollerProducts-complete').on('click', function(ev) {
          ev.preventDefault();
          //console.log('complete');
          saveProductWaste('complete');
        });
      }, function(err) {
        console.error(err);
      });
    }
  });
}

function rollerGrillIngredients() {

  //  console.log("rollerGrillProducts called");

  //$(".main--content").hide();
  //$(".main-content-rollerGrills").show();
  $('#js-roller-levels').hide();
  $('.js-alert-success').hide();

  var defered1 = $.ajax({
    type: "GET",
    url: apiURL + "/products/ingredients",
    data: {
      "category_name": "Roller",
      "product_type": "Roller Grill Ingredients",
      "storeid": $.cookie('user').storeid,
      "waste_reported_date": moment($('#js-today-date-waste').val(), 'MMM Do YYYY').format('YYYY-MM-DD')
    },
    contentType: "application/json; charset=utf-8"
  });


  $.when(defered1).then(function(v1) {
    var productdata = {
      products: v1.response
    };
    var productsHtml = ingredientsTemplate(productdata);
    $('.waste-table .dots-loader').remove();
    $('.js-products-head').html("<th>Item Name<br/></th><th>Waste</th><th></th>");
    $('.js-products-body').html(productsHtml);
    $('.js-waste-actions').hide();
    $('.js-ingredient-waste-actions').show();
    $('#js-productWaste-roller-finished-li').removeClass('active');
    $('.js-wastage-sub-nav').hide();
    if (moment($('#js-today-date-waste').val(), 'MMM Do YYYY').isSame(moment(), 'day')) {
      $('.js-product-ingredient-waste-save').show();
      $('.js-product-ingredient-waste-complete').show();
      $('.js-product-waste-save').hide();
      $('.js-product-waste-complete').hide();
    } else {
      if ($('#js-today-date-waste').val() == moment().add(-1, 'days').format('MMM Do YYYY')) {
        if (moment(moment(moment(), 'day').format("YYYY-MM-DD HH:mm:ss")).unix() <= moment(moment().add('day').format("YYYY-MM-DD " + $.cookie('user').lockTime)).unix()) {
          $('.js-product-ingredient-waste-save').show();
          $('.js-product-ingredient-waste-complete').show();
          $('.js-product-waste-save').hide();
          $('.js-product-waste-complete').hide();
        } else {
          $('.js-products-body').find('input').prop('disabled', true);
        }
      } else {
        $('.js-products-body').find('input').prop('disabled', true);
      }
    }
    //console.log(tableList);

    //$(".main-content-rollerGrills").html(freezeTableCreationTemplate(tableList));
  }, function(err) {
    console.error(err);
  });

}


function loadFreshProducts() {
  if (moment($('#js-today-date-waste').val(), 'MMM Do YYYY').format('YYYY-MM-DD')!="Invalid date") {
    var report_date = moment($('#js-today-date-waste').val(), 'MMM Do YYYY').format('YYYY-MM-DD');
  } else {
    var report_date = moment().format('YYYY-MM-DD');
  }
  var defered1 = $.ajax({
    type: "GET",
    url: apiURL + "/waste/perishableGoodsWaste",
    data: {
      "category_name": "perishableGoods",
      "product_type": "Perishable Goods",
      "storeid": $.cookie('user').storeid,
      "waste_reported_date": report_date,
      "vendor_name": $('.js-perishable-waste-nav li.active').attr('data-value')
    },
    contentType: "application/json; charset=utf-8"
  });
  var defered2 = $.ajax({
    type: "GET",
    url: apiURL + "/products/time_categories",
    data: {
      "category_name": "perishableGoods"
    },
    contentType: "application/json; charset=utf-8"
  });

  $.when(defered1, defered2).then(function(v1, v2) {
    var timedata = {
      times: v2[0].response
    };
    var productdata = {
      products: v1[0].response,
      times: v2[0].response
    };
    var timeHeaderHtml = timeTemplate(timedata);
    var productsHtml = productsTemplate(productdata);
    $('.waste-table .dots-loader').remove();
    $('.js-waste-actions').show();
    $('.js-products-head').html(timeHeaderHtml);
    $('.js-products-body').html(productsHtml);
    var columnCount = 0;
    $('.js-products-body tr').each(function() {
      columnCount = Math.max(columnCount, $(this).children('td').length);
    });

    var cellCounter = 1;
    for (var columnIndex = 0; columnIndex < columnCount; ++columnIndex) {
      $('.js-products-body tr').each(function() {
        var cell = $(this).children('td').eq(columnIndex).find('input');
        if (cell != null) {
          cell.attr('tabindex', cellCounter++);
        }
      });
    }
    if (moment($('#js-today-date-waste').val(), 'MMM Do YYYY').isSame(moment(), 'day')) {
      $('.js-product-waste-complete').show();
      $('.js-product-waste-save').show();
      $('.js-product-ingredient-waste-save').hide();
      $('.js-product-ingredient-waste-complete').hide();
    } else {
      if ($('#js-today-date-waste').val() == moment().add(-1, 'days').format('MMM Do YYYY')) {
        if (moment(moment(moment(), 'day').format("YYYY-MM-DD HH:mm:ss")).unix() <= moment(moment().add('day').format("YYYY-MM-DD " + $.cookie('user').lockTime)).unix()) {
          $('.js-product-waste-complete').show();
          $('.js-product-waste-save').show();
          $('.js-product-ingredient-waste-save').hide();
          $('.js-product-ingredient-waste-complete').hide();
        } else {
          $('.js-products-body').find('input').prop('disabled', true);
        }
      } else {
        $('.js-products-body').find('input').prop('disabled', true);
      }
    }
  }, function(err) {
    console.error(err);
  });

}
