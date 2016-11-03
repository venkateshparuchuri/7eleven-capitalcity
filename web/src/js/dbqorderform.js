$(document).ready(function() {
  dbqOrderTemplate = MyApp.templates.dbqOrderform;
  employeeOrderTemplate = MyApp.templates.employeeOrderform;
  editOrderTemplate = MyApp.templates.editDbqProduct;
  editModelProductTemplate = MyApp.templates.editDbqModelForm;
  // need to call this function for loading items
  // if ($.cookie('user').role === 'DBQ_Admin') {
  //   loadOrderItems();
  // }
});
// this function called from dbqadmin side
function loadOrderItems() {
  $('.js-orderform').show();
  $.ajax({
    type: "GET",
    url: apiURL + "/products/dbqProducts",
    data: {
      "product_type": $('.js-orderform-type').find('li.active').attr('data-value')
    },
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      $('.js-orederAction').attr('disabled', false);
      var productdata = {
        products: response.response
      };
      if ($('.js-orderform-type').find('li.active').attr('data-value') == "Packaging") {
        var productsHtml = dbqOrderTemplate(productdata);
        $('.js-product-packaging').html(productsHtml);
        $('#Packaging').show();
        $('#Supplies').hide();
        $('#Labels').hide();
      } else if ($('.js-orderform-type').find('li.active').attr('data-value') == "Supplies") {
        var productsHtml = dbqOrderTemplate(productdata);
        $('.js-product-supplies').html(productsHtml);
        $('#Supplies').show();
        $('#Packaging').hide();
        $('#Labels').hide();
      } else if ($('.js-orderform-type').find('li.active').attr('data-value') == "Labels") {
        var productsHtml = dbqOrderTemplate(productdata);
        $('.js-product-labels').html(productsHtml);
        $('#Labels').show();
        $('#Packaging').hide();
        $('#Supplies').hide();
      }
    }
  });
}

// this function called from employee side
function loadOrderItemsForEmployee(productName) {
  $.ajax({
    type: "GET",
    url: apiURL + "/products/dbqOrders",
    data: {
      "product_type": productName,
      "store_id": $.cookie('user').storeid,
      "date": moment().format('YYYY-MM-DD')
    },
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      var productdata = {
        products: response.response
      };
      var productsHtml = employeeOrderTemplate(productdata);
      if (productName == "Packaging") {
        if (response.response.length > 0) {
          $('.js-products-packaging').html(productsHtml);
          $('.js-emporder-actions').show();
        } else {
          $('.js-products-packaging').html('<center><h4>Products/Quantity not yet updated</h4></center>');
          $('.js-emporder-actions').hide();
        }
        $('#packaging').show();
        $('#supplies').hide();
        $('#labels').hide();
      } else if (productName == "Supplies") {
        if (response.response.length > 0) {
          $('.js-products-supplies').html(productsHtml);
          $('.js-emporder-actions').show();
        } else {
          $('.js-products-supplies').html('<center><h4>Products/Quantity not yet updated</h4></center>');
          $('.js-emporder-actions').hide();
        }
        $('#packaging').hide();
        $('#supplies').show();
        $('#labels').hide();
      } else if (productName == "Labels") {
        if (response.response.length > 0) {
          $('.js-products-labels').html(productsHtml);
          $('.js-emporder-actions').show();
        } else {
          $('.js-products-labels').html('<center><h4>Products/Quantity not yet updated</h4></center>');
          $('.js-emporder-actions').hide();
        }
        $('#labels').show();
        $('#packaging').hide();
        $('#supplies').hide();
      }
    }
  });
}

$(document).delegate('.checkvalue', 'click', function(ev) {
  ev.preventDefault();
  if ($(ev.target).hasClass('active')) {
    $(ev.target).removeClass('active');
  } else {
    $(ev.target).addClass('active');
  }
});

// after giving the order values to order in dbqadmin this event fires
$(document).delegate('.js-orederAction', 'click', function(ev) {
  ev.preventDefault();
  $('.js-orederAction').button('loading');
  if ($('.js-orderform-type li.active').attr('data-value') == "Packaging") {
    var dataArray = [];
    $('.js-product-packaging tbody tr').each(function() {
      var dataObj = {};
      if ($(this).find('input.js-product-waste-entry').val() != '' && $(this).find('input.js-product-waste-entry').val() != 0) {
        dataObj.product_id = $(this).find('input.js-product-waste-entry').attr('data-product-id');
        dataObj.id = $(this).find('input.js-product-waste-entry').attr('data-dbq_id');
        dataObj.max_quantity = $(this).find('input.js-product-waste-entry').val();
        dataArray.push(dataObj);
      }
    });
  } else if ($('.js-orderform-type li.active').attr('data-value') == "Supplies") {
    var dataArray = [];
    $('.js-product-supplies tbody tr').each(function() {
      var dataObj = {};
      if ($(this).find('input.js-product-waste-entry').val() != '' && $(this).find('input.js-product-waste-entry').val() != 0) {
        dataObj.product_id = $(this).find('input.js-product-waste-entry').attr('data-product-id');
        dataObj.id = $(this).find('input.js-product-waste-entry').attr('data-dbq_id');
        dataObj.max_quantity = $(this).find('input.js-product-waste-entry').val();
        dataArray.push(dataObj);
      }
    });
  } else if ($('.js-orderform-type li.active').attr('data-value') == "Labels") {
    var dataArray = [];
    $('.js-product-labels tbody tr').each(function() {
      var dataObj = {};
      if ($(this).find('input.js-product-waste-entry').val() != '' && $(this).find('input.js-product-waste-entry').val() != 0) {
        dataObj.product_id = $(this).find('input.js-product-waste-entry').attr('data-product-id');
        dataObj.id = $(this).find('input.js-product-waste-entry').attr('data-dbq_id');
        dataObj.max_quantity = $(this).find('input.js-product-waste-entry').val();
        dataArray.push(dataObj);
      }
    });
  }
  if (dataArray.length > 0) {
    $.ajax({
      type: "POST",
      url: apiURL + "/products/dbqProducts",
      data: JSON.stringify(dataArray),
      contentType: "application/json; charset=utf-8",
      success: function(response) {
        $('.js-orederAction').button('reset');
        new PNotify({
          title: 'Success!',
          text: 'Item has been reported successfully.',
          type: 'success',
          styling: 'fontawesome',
          hide: true,
          delay: 2000
        });
      }
    });
  }
});

// $(document).delegate('.js-orderform-type li', 'click', function(ev) {
//   loadOrderItems();
// });

// this is the event for adding products to orderform in dbqadmin
$(document).delegate('#getselected', 'click', function(ev) {
  ev.preventDefault();
  var selectedProducts = [];
  $('#pickListResult').each(function() {
    $(this).find('li').each(function() {
      if ($(this).attr('dbq_id') == "undefined") {
        var obj = {};
        obj.product_id = $(this).attr('data-product_id');
        obj.itemName = $(this).text();
        selectedProducts.push(obj);
      }
    });
    if (selectedProducts.length > 0) {
      var dataObj = {};
      dataObj.data = selectedProducts;
      $.ajax({
        type: "POST",
        url: apiURL + "/products/dbqEditProducts",
        data: JSON.stringify(selectedProducts),
        contentType: "application/json; charset=utf-8",
        success: function(response) {
          $.ajax({
            type: "GET",
            url: apiURL + "/products/dbqProducts",
            data: {
              "product_type": $('.js-orderform-type').find('li.active').attr('data-value')
            },
            contentType: "application/json; charset=utf-8",
            success: function(response) {
              $('#addproducts').modal('hide');
              loadOrderItems();
            }
          });
        }
      });
    } else {
      $('#addproducts').modal('hide');
      if ($('#pickListResult li').length == 0) {
        if ($('.js-orderform-type').find('li.active').attr('data-value') == "Packaging") {
          $('.js-products-packaging').html('');
          $('#js-packagingAction').hide();
        } else if ($('.js-orderform-type').find('li.active').attr('data-value') == "Supplies") {
          $('.js-product-supplies').html('');
          $('#js-suppliesAction').hide();
        } else if ($('.js-orderform-type').find('li.active').attr('data-value') == "Labels") {
          $('.js-product-labels').html('');
          $('#js-labelsAction').hide();
        }
      } else {
        loadOrderItems();
      }
    }
  });
});

function empdbqorder(status) {

  var product_type = $('.js-order-employee li.active').attr('data-value');
  var dataArray = [];
  var allValid = true;
  if (product_type == "Packaging") {
    $('.js-products-packaging tbody tr').each(function() {
      if (!$(this).find('input').is(':disabled') && $(this).find('input').val() > 0) {
        var obj = {};
        obj.product_id = $(this).find('input').attr('data-product-id');
        if ($(this).find('input').attr('data-dbq_id')) {
          obj.id = $(this).find('input').attr('data-dbq_id');
        } else {
          obj.id = 0;
        }
        obj.no_of_units = $(this).find('input').val();
        obj.status = status;
        obj.dbqp_id = $(this).find('input').attr('data-dbqp_id');
        obj.store_id = $.cookie('user').storeid;
        obj.total = $(this).find('td.js-totalOrder p').text();
        obj.date = moment().format('YYYY-MM-DD');
        if ($(this).find('input').val() <= parseInt($(this).find('input').attr('data-max_quantity'))) {
          dataArray.push(obj);
        } else {
          $(this).find('input').addClass('error-whole-number');
          allValid = false;
        }
      } else if ($(this).find('input').val() == 0 && $(this).find('input').val() !='') {
        $(this).find('input').addClass('error-whole-number');
        allValid = false;
      }
    });
    saveEmpDbqOrders(dataArray, allValid, status);
  } else if (product_type == "Supplies") {
    $('.js-products-supplies tbody tr').each(function() {
      if (!$(this).find('input').is(':disabled') && $(this).find('input').val() > 0) {
        var obj = {};
        obj.product_id = $(this).find('input').attr('data-product-id');
        if ($(this).find('input').attr('data-dbq_id')) {
          obj.id = $(this).find('input').attr('data-dbq_id');
        } else {
          obj.id = 0;
        }
        obj.no_of_units = $(this).find('input').val();
        obj.status = status;
        obj.dbqp_id = $(this).find('input').attr('data-dbqp_id');
        obj.store_id = $.cookie('user').storeid;
        obj.total = $(this).find('td.js-totalOrder p').text();
        obj.date = moment().format('YYYY-MM-DD');
        if ($(this).find('input').val() <= parseInt($(this).find('input').attr('data-max_quantity'))) {
          dataArray.push(obj);
        } else {
          $(this).find('input').addClass('error-whole-number');
          allValid = false;
        }
      } else if ($(this).find('input').val() == 0 && $(this).find('input').val() !='') {
        $(this).find('input').addClass('error-whole-number');
        allValid = false;
      }
    });
    saveEmpDbqOrders(dataArray, allValid, status)
  } else {
    $('.js-products-labels tbody tr').each(function() {
      if (!$(this).find('input').is(':disabled') && $(this).find('input').val() > 0) {
        var obj = {};
        obj.product_id = $(this).find('input').attr('data-product-id');
        if ($(this).find('input').attr('data-dbq_id')) {
          obj.id = $(this).find('input').attr('data-dbq_id');
        } else {
          obj.id = 0;
        }
        obj.no_of_units = $(this).find('input').val();
        obj.status = status;
        obj.dbqp_id = $(this).find('input').attr('data-dbqp_id');
        obj.store_id = $.cookie('user').storeid;
        obj.total = $(this).find('td.js-totalOrder p').text();
        obj.date = moment().format('YYYY-MM-DD');
        if ($(this).find('input').val() <= parseInt($(this).find('input').attr('data-max_quantity'))) {
          dataArray.push(obj);
        } else {
          $(this).find('input').addClass('error-whole-number');
          allValid = false;
        }
      } else if ($(this).find('input').val() == 0 && $(this).find('input').val() !='') {
        $(this).find('input').addClass('error-whole-number');
        allValid = false;
      }
    });
    saveEmpDbqOrders(dataArray, allValid, status);
  }
}

$(document).delegate('#js-complete-yes', 'click', function(ev) {
  ev.preventDefault();
  empdbqorder('completed');
  $('#confirmationAction-order-emp').modal('hide');
});
// this is the event for saving and completing the orders from employee side
$(document).delegate('.js-emporder-actions', 'click', function(ev) {
  ev.preventDefault();
  var status = $(ev.target).attr('data-actiontype');
  if ($(ev.target).attr('data-actiontype') === "drafted") {
    $('.js-emporder-actions[data-actiontype="drafted"]').button('loading');
    empdbqorder('drafted');
  } else if ($(ev.target).attr('data-actiontype') === "completed") {
    $('#confirmationAction-order-emp').modal('show');
  }
});


function saveEmpDbqOrders(dataArray, allValid, status) {
  if (allValid) {
    if (dataArray.length > 0) {
      $.ajax({
        type: "POST",
        url: apiURL + "/products/dbqOrders",
        data: JSON.stringify(dataArray),
        contentType: "application/json; charset=utf-8",
        success: function(response) {
          loadOrderItemsForEmployee($('.js-order-employee li.active').attr('data-value'));
          if (status == 'drafted') {
            $('.js-emporder-actions[data-actiontype="drafted"]').button("reset");
            new PNotify({
              title: 'Success!',
              text: 'Order has been saved but not completed.',
              type: 'success',
              styling: 'fontawesome',
              hide: true,
              delay: 2000
            });
          } else if (status == 'completed') {
            new PNotify({
              title: 'Success!',
              text: 'Order has been completed successfully.',
              type: 'success',
              styling: 'fontawesome',
              hide: true,
              delay: 2000
            });
          }
        }
      });
    } else {
      $('.js-emporder-actions[data-actiontype="drafted"]').button('reset');
    }
  } else {
    $('.js-emporder-actions[data-actiontype="drafted"]').button('reset');
    new PNotify({
      title: 'Error',
      text: 'Please fix the order fields highlighted in red.',
      type: 'error',
      styling: 'fontawesome',
      hide: true,
      delay: 2000
    });
  }
}

$(document).delegate('#js-dbqOrderEntry', 'keyup', function(ev) {
  ev.preventDefault();
  if ($(this).data('dbqo_date') != '') {
    if ($(this).val() < $(this).data('maxqty')) {
      $(this).addClass('error-whole-number');
      new PNotify({
        title: 'Error',
        text: 'There are orders for the product by the employee today so,that the minimum value you can enter is "' + $(this).data('maxqty') + '" & its above.',
        type: 'error',
        styling: 'fontawesome',
        hide: true,
        delay: 2000
      });
      $('.js-orederAction').prop('disabled', true);
    } else {
      var validationarray = [];
      $('.js-productbody tr').each(function(ev) {
        if ($(this).find('td.form-group input').hasClass('error-whole-number')) {
          var inputlist = 'true';
          validationarray.push(inputlist);
        }
        if (validationarray.length > 0) {
          $('.js-orederAction').prop('disabled', true);
        } else {
          $('.js-orederAction').prop('disabled', false);
        }
      });
    }
  }
});


$(document).delegate('#js-dbq-addform', 'click', function(ev) {
  ev.preventDefault();
  //$("#dbq-addnewproduct-div").show();
  $('.js-orderform').hide();
  $('#addproductsform').show();
  $('#js-addnewproduct-form').find('p').remove();
  $('#js-addnewproduct-form').find('input').parent().removeClass('has-error');
});

$(document).delegate('#js-dbq-ordermanage', 'click', function(ev) {
  ev.preventDefault();
  $('.js-orderform').show();
  $('#addproductsform').hide();
});


$('#js-addproduct-submit').click(function(ev) {
  ev.preventDefault();
  dbqaddnewproduct();
});

function dbqaddnewproduct() {

  if ($("#js-ProductDescription").val() && $("#js-ProductDescription").val() != '') {
    if ($("#js-ProductDescription").val() <= 0) {
      if ($("#js-ProductDescription").parent().hasClass('has-error')) {} else {
        $("#js-ProductDescription").parent().addClass('has-error');
        $("#js-ProductDescription").parent().append('<p class="help-block">Please enter the valid value.</p>');
        var ProductDescription = '';
      }
    }else{
      var ProductDescription = $("#js-ProductDescription").val();
  }

  } else {
    var ProductDescription = '';
    if ($('#js-ProductDescription').parent().hasClass('has-error')) {} else {
      $('#js-ProductDescription').parent().addClass('has-error');
      $('#js-ProductDescription').parent().append('<p class="help-block">Please fill the ProductDescription.</p>');
    }
  }

  if ($("#js-Size").val() && $("#js-Size").val() != '') {
    if ($("#js-Size").val() <= 0) {
      if ($("#js-Size").parent().hasClass('has-error')) {} else {
        $("#js-Size").parent().addClass('has-error');
        $("#js-Size").parent().append('<p class="help-block">Please enter the valid value.</p>');
        var Size = '';
      }
    }else{
      var Size = $("#js-Size").val();
    }

  } else {
    var Size = '';
    if ($('#js-Size').parent().hasClass('has-error')) {} else {
      $('#js-Size').parent().addClass('has-error');
      $('#js-Size').parent().append('<p class="help-block">Please fill the Size.</p>');
    }
  }
  if ($("#js-Case").val() && $("#js-Case").val() != '') {
    if ($("#js-Case").val() <= 0) {
      if ($("#js-Case").parent().hasClass('has-error')) {} else {
        $("#js-Case").parent().addClass('has-error');
        $("#js-Case").parent().append('<p class="help-block">Please enter the valid value.</p>');
        var Case = '';
      }
    }else{
      var Case = $("#js-Case").val();
    }

  } else {
    var Case = '';
    if ($('#js-Case').parent().hasClass('has-error')) {} else {
      $('#js-Case').parent().addClass('has-error');
      $('#js-Case').parent().append('<p class="help-block">Please fill the Case.</p>');
    }
  }
  var Brand = $("#js-Brand").val();
  var Storage = $("#js-Storage").val();


  if ($("#js-Item").val() && $("#js-Item").val() != '') {
    if ($("#js-Item").val() <= 0) {
      if ($("#js-Item").parent().hasClass('has-error')) {} else {
        $("#js-Item").parent().addClass('has-error');
        $("#js-Item").parent().append('<p class="help-block">Please enter the valid value.</p>');
        var Item = '';
      }
    }else{
      var Item = $("#js-Item").val();
    }

  } else {
    var Item = '';
    if ($('#js-Item').parent().hasClass('has-error')) {} else {
      $('#js-Item').parent().addClass('has-error');
      $('#js-Item').parent().append('<p class="help-block">Please fill the Item.</p>');
    }
  }
  if ($("#js-DBQ").val() && $("#js-DBQ").val() != '') {
    if ($("#js-DBQ").val() <= 0) {
      if ($("#js-DBQ").parent().hasClass('has-error')) {} else {
        $("#js-DBQ").parent().addClass('has-error');
        $("#js-DBQ").parent().append('<p class="help-block">Please enter the valid value.</p>');
        var dbq = '';
      }
    }else{
      var dbq = $("#js-DBQ").val();
    }

  } else {
    var dbq = '';
    if ($('#js-DBQ').parent().hasClass('has-error')) {} else {
      $('#js-DBQ').parent().addClass('has-error');
      $('#js-DBQ').parent().append('<p class="help-block">Please fill the DBQ.</p>');
    }
  }
  if ($('#js-max_quantity').val() && $('#js-max_quantity').val() != '') {
    if ($('#js-max_quantity').val() <= 0) {
      if ($('#js-max_quantity').parent().hasClass('has-error')) {} else {
        $('#js-max_quantity').parent().addClass('has-error');
        $('#js-max_quantity').parent().append('<p class="help-block">Please enter the valid value.</p>');
        var max_quantity = '';
      }
    } else {
      var max_quantity = $("#js-max_quantity").val();
    }
  } else {
    var max_quantity = '';
    if ($('#js-max_quantity').parent().hasClass('has-error')) {} else {
      $('#js-max_quantity').parent().addClass('has-error');
      $('#js-max_quantity').parent().append('<p class="help-block">Please fill the DBQ.</p>');
    }
  }
  if (ProductDescription && Size && Case && Item && dbq && max_quantity) {
    $.ajax({
      type: "POST",
      url: apiURL + "/products/dbqProducts",
      data: JSON.stringify({
        "productdescription": ProductDescription,
        "product_type_id": $('input[name="goods"]:checked').val(),
        "storage": Storage,
        "size": Size,
        "case_qty": Case,
        "brand": Brand,
        "item": Item,
        "dbq": parseInt(dbq),
        "max_quantity": parseInt(max_quantity)
      }),
      contentType: "application/json; charset=utf-8",
      success: function(response) {
        $('#js-addnewproduct-form').find("input[type=text],input[type=number]").val("");
        new PNotify({
          title: 'Success!',
          text: 'DBQ Product Added Successfully',
          type: 'success',
          styling: 'fontawesome',
          hide: true,
          delay: 2000
        });
      },
      error: function(xhr, ajaxOptions, thrownError) {}
    });
  } else {
    new PNotify({
      title: 'Failed!',
      text: 'Please fix the highlighted fields.',
      type: 'error',
      styling: 'fontawesome',
      hide: true,
      delay: 2000
    });
  }
}

function blockSpecialChar(e){
       var k;
       document.all ? k = e.keyCode : k = e.which;
       return ((k > 64 && k < 91) || (k > 96 && k < 123) || k == 8 || k == 32 || (k >= 48 && k <= 57));
       }

$(document).delegate('#js-dbqbtn-reset', 'click', function(ev) {
  $('#js-addnewproduct-form').find('p').remove();
  $('#js-addnewproduct-form').find('input').parent().removeClass('has-error');
});

// $(document).delegate('.js-side-nav li', 'click', function(ev) {
//   ev.preventDefault();
//   $('.js-side-nav li').removeClass('active');
//   $(ev.target.parentElement).addClass('active');
// });


function loadEditProducts() {
  $.ajax({
    type: "GET",
    url: apiURL + "/products/dbqProducts",
    data: {
      "product_type": $('.js-orderform-edit li.active').attr('data-value')
    },
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      var productData = {
        product: response.response
      };
      var editProductHtml = editOrderTemplate(productData);
      $('#editProduct').find('table[data-value=' + $('.js-orderform-edit li.active').attr('data-value') + ']').html(editProductHtml);
      $('#editProduct').show();
      $('#addProduct').hide();
    }
  });
}



// $(document).delegate('.js-orderform-edit li', 'click', function(ev) {
//   ev.preventDefault();
//   loadEditProducts();
// });

// this is the event for edit the dbq product
$(document).delegate('.js-edit-product', 'click', function(ev) {
  ev.preventDefault();
  var produtData = {};
  produtData.brand = $(this).closest('td').attr('data-brand');
  produtData.case_qty = $(this).closest('td').attr('data-case_qty');
  produtData.dbq = $(this).closest('td').attr('data-dbq');
  produtData.dbq_id = $(this).closest('td').attr('data-dbq_id');
  produtData.item = $(this).closest('td').attr('data-item');
  produtData.max_quantity = $(this).closest('td').attr('data-max_quantity');
  produtData.product_description = $(this).closest('td').attr('data-product_description');
  produtData.size = $(this).closest('td').attr('data-size');
  produtData.storage = $(this).closest('td').attr('data-storage');
  produtData.type = $(this).closest('td').attr('data-type');
  var productArray = [];
  productArray.push(produtData);
  var data = {
    productInfo: productArray
  };
  var editProductHtml = editModelProductTemplate(data);
  $('.js-dbq-editProductForm').html(editProductHtml);
  $('#js-saveDbq_product').attr('data-Active_flag', $(this).closest('td').attr('data-Active_flag'));
  $('#js-saveDbq_product').attr('data-dbq_id', $(this).closest('td').attr('data-id'));
  $('#js-saveDbq_product').attr('data-product_type_id', $(this).closest('td').attr('data-product_type_id'));
  var text = $(this).closest('td').attr('data-product_description') + ' - Edit Product';
  $('.js-dbq_product-edit').html(text);
  $('#editDbqProduct').modal('show');
});


// this is the event for deleting the dbqproduct
$(document).delegate('.js-delete-product', 'click', function(ev) {
  ev.preventDefault();
  $('#js-product-deleteModal').modal('show');
  var text = $(this).closest('td').attr('data-product_description') + ' - DeleteProduct';
  $('#myProductModalLabel').html(text);
  $('.js-delete-dbqProduct-text').html('<h4>Are you sure, you want to delete this product form <strong>' + $('.js-orderform-edit li.active').attr('data-value') + '</strong> ?</h4>')
  $('#js-Delete-product-Yes').attr('data-dbq_id', $(this).closest('td').attr('data-id'));
});


$(document).delegate('#js-Delete-product-Yes', 'click', function(ev) {
  ev.preventDefault();
  $.ajax({
    type: "DELETE",
    url: apiURL + "/products/dbqProducts",
    data: JSON.stringify({
      "dbq_id": $('#js-Delete-product-Yes').attr('data-dbq_id')
    }),
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      $('#js-product-deleteModal').modal('hide');
      loadEditProducts();
    }
  });
});


// this is the event for saving the edited dbqproduct info
$(document).delegate('#js-saveDbq_product', 'click', function(ev) {
  ev.preventDefault();

  if ($("#js-edit-ProductDescription").val() && $("#js-edit-ProductDescription").val() != '') {
    if ($("#js-edit-ProductDescription").val() <= 0) {
      if ($("#js-edit-ProductDescription").parent().hasClass('has-error')) {} else {
        $("#js-edit-ProductDescription").parent().addClass('has-error');
        $("#js-edit-ProductDescription").parent().append('<p class="help-block">Please enter the valid value.</p>');
        var editProductDescription = '';
      }
    }else{
      var editProductDescription = $("#js-edit-ProductDescription").val();
  }

  } else {
    var editProductDescription = '';
    if ($('#js-edit-ProductDescription').parent().hasClass('has-error')) {} else {
      $('#js-edit-ProductDescription').parent().addClass('has-error');
      $('#js-edit-ProductDescription').parent().append('<p class="help-block">Please fill the ProductDescription.</p>');
    }
  }

  if ($("#js-edit-Size").val() && $("#js-edit-Size").val() != '') {
    if ($("#js-edit-Size").val() <= 0) {
      if ($("#js-edit-Size").parent().hasClass('has-error')) {} else {
        $("#js-edit-Size").parent().addClass('has-error');
        $("#js-edit-Size").parent().append('<p class="help-block">Please enter the valid value.</p>');
        var editSize = '';
      }
    }else{
      var editSize = $("#js-edit-Size").val();
  }

  } else {
    var editSize = '';
    if ($('#js-edit-Size').parent().hasClass('has-error')) {} else {
      $('#js-edit-Size').parent().addClass('has-error');
      $('#js-edit-Size').parent().append('<p class="help-block">Please fill the Size.</p>');
    }
  }

  if ($("#js-edit-Case").val() && $("#js-edit-Case").val() != '') {
    if ($("#js-edit-Case").val() <= 0) {
      if ($("#js-edit-Case").parent().hasClass('has-error')) {} else {
        $("#js-edit-Case").parent().addClass('has-error');
        $("#js-edit-Case").parent().append('<p class="help-block">Please enter the valid value.</p>');
        var editCase = '';
      }
    }else{
      var editCase = $("#js-edit-Case").val();
  }

  } else {
    var editCase = '';
    if ($('#js-edit-Case').parent().hasClass('has-error')) {} else {
      $('#js-edit-Case').parent().addClass('has-error');
      $('#js-edit-Case').parent().append('<p class="help-block">Please fill the Case.</p>');
    }
  }

  if ($("#js-edit-Item").val() && $("#js-edit-Item").val() != '') {
    if ($("#js-edit-Item").val() <= 0) {
      if ($("#js-edit-Item").parent().hasClass('has-error')) {} else {
        $("#js-edit-Item").parent().addClass('has-error');
        $("#js-edit-Item").parent().append('<p class="help-block">Please enter the valid value.</p>');
        var editItem = '';
      }
    }else{
      var editItem = $("#js-edit-Item").val();
  }

  } else {
    var editItem = '';
    if ($('#js-edit-Item').parent().hasClass('has-error')) {} else {
      $('#js-edit-Item').parent().addClass('has-error');
      $('#js-edit-Item').parent().append('<p class="help-block">Please fill the Item.</p>');
    }
  }

  if ($('#js-edit-DBQ').val() && $('#js-edit-DBQ').val() != '') {
    if ($('#js-edit-DBQ').val() <= 0) {
      if ($('#js-edit-DBQ').parent().hasClass('has-error')) {} else {
        $('#js-edit-DBQ').parent().addClass('has-error');
        $('#js-edit-DBQ').parent().append('<p class="help-block">Please enter the valid value.</p>');
        var editdbq = '';
      }
    } else {
      var editdbq = $("#js-edit-DBQ").val();
    }
  } else {
    var editdbq = '';
    if ($('#js-edit-DBQ').parent().hasClass('has-error')) {} else {
      $('#js-edit-DBQ').parent().addClass('has-error');
      $('#js-edit-DBQ').parent().append('<p class="help-block">Please fill the valid value.</p>');
    }
  }

  if ($('#js-edit-max_quantity').val() && $('#js-edit-max_quantity').val() != '') {
    if ($('#js-edit-max_quantity').val() <= 0) {
      if ($('#js-edit-max_quantity').parent().hasClass('has-error')) {} else {
        $('#js-edit-max_quantity').parent().addClass('has-error');
        $('#js-edit-max_quantity').parent().append('<p class="help-block">Please enter the valid value.</p>');
        var editmax_quantity = '';
      }
    } else {
      var editmax_quantity = $("#js-edit-max_quantity").val();
    }
  } else {
    var editmax_quantity = '';
    if ($('#js-edit-max_quantity').parent().hasClass('has-error')) {} else {
      $('#js-edit-max_quantity').parent().addClass('has-error');
      $('#js-edit-max_quantity').parent().append('<p class="help-block">Please fill the valid value.</p>');
    }
  }

  if (editProductDescription && editSize && editCase && editItem && editdbq && editmax_quantity) {
    $.ajax({
      type: "PUT",
      url: apiURL + "/products/dbqProducts",
      data: JSON.stringify({
        "dbq_id": $('#js-saveDbq_product').attr('data-dbq_id'),
        "product_type_id": $('#js-saveDbq_product').attr('data-product_type_id'),
        "product_description": $('#js-edit-ProductDescription').val(),
        "storage": $('#js-edit-Storage').val(),
        "size": $('#js-edit-Size').val(),
        "case_qty": $('#js-edit-Case').val(),
        "brand": $('#js-edit-Brand').val(),
        "item": $('#js-edit-Item').val(),
        "dbq": parseInt($('#js-edit-DBQ').val()),
        "max_quantity": $('#js-edit-max_quantity').val(),
        "Active_flag": $('#js-saveDbq_product').attr('data-Active_flag')
      }),
      contentType: "application/json; charset=utf-8",
      success: function(response) {
        $('#editDbqProduct').modal('hide');
        loadEditProducts();
        new PNotify({
          title: 'Success!',
          text: 'Product has been Saved successfully.',
          type: 'success',
          styling: 'fontawesome',
          hide: true,
          delay: 2000
        });
      }
    });
  } else {
    new PNotify({
      title: 'Failed!',
      text: 'Please fix the highlighted fields.',
      type: 'error',
      styling: 'fontawesome',
      hide: true,
      delay: 2000
    });
  }
});


$(document).delegate('.js-editProduct-close', 'click', function(ev) {
  ev.preventDefault();
  $('#editDbqProduct').modal('hide');
  loadEditProducts();
});


$(document).delegate('.js-dbqOnOffLabel', 'click', function(ev) {
  ev.preventDefault();
  var dbq_id = $(this).parent().find('input').attr('data-id');
  if ($(this).parent().find('input').prop('checked')) {
    var Active_flag = 'false';
  } else {
    var Active_flag = 'true';
  }
  $.ajax({
    type: "PATCH",
    url: apiURL + "/products/dbqProducts",
    data: JSON.stringify({
      "dbq_id": dbq_id,
      "Active_flag": Active_flag
    }),
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      loadOrderItems();
    }
  });
});


$(document).delegate('.js-product-waste-entry', 'keyup', function(ev) {
  ev.preventDefault();
  if ($(this).val() != '' && $(this).val() > 0) {
    var dataArray = $(this).attr('data-cases').split(' ')
    if (dataArray.length > 1) {
      var total = dataArray[0] * $(this).val() + " " + dataArray[1];
    } else {
      var total = $(this).attr('data-cases') * $(this).val();
    }
    $(this).closest('tr').find('td.js-totalOrder p').html(total);
  } else if ($(this).val() == '') {
    $(this).closest('tr').find('td.js-totalOrder p').html('');
  }
});
