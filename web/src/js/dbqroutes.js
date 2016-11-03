var stateObject = {};
$(document).ready(function() {

  $.routes.add('/ManageOrder Form items/{name:string}', 'manage', function() {
    $('.dbq-main-nav').removeClass('active');
    $('.dbq-main-nav').find("a[data-type='manage']").parent().addClass('active');
    loadOrderItems();
  });
  $.routes.add('/Add / Edit items/{name:string}', 'addedit', function() {
    $('.dbq-main-nav').removeClass('active');
    $('.dbq-main-nav').find("a[data-type='addedit']").parent().addClass('active');
    addeditProducts();
  });
  $.routes.add('/Add / Edit items/{name:string}/{subname:string}', 'addediitmainroutes', function() {
    if (this.name == 'AddProduct') {
      $('#addProduct').show();
    } else if (this.name == 'EditProduct') {
      if (this.subname == 'Packaging') {
        $('.js-orderform-edit').find('li[data-value="Packaging"]').addClass('active');
      } else if (this.subname == 'Supplies') {
        $('.js-orderform-edit').find('li[data-value="Supplies"]').addClass('active');
      } else if (this.subname == 'Labels') {
        $('.js-orderform-edit').find('li[data-value="Labels"]').addClass('active');
      }
      loadEditProducts();
    }
  });


  if ($.cookie('stateObject') && $.cookie('stateObject').navCategory) {
    // $('.dbq-main-nav').removeClass('active');
    if ($.cookie('stateObject').navCategory == 'manage') {
      $('.dbq-main-nav').removeClass('active');
      $('.dbq-main-nav').find("[data-type='" + $.cookie('stateObject').navCategory + "']").parent().addClass('active');
      orderform();
    } else if ($.cookie('stateObject').navCategory == 'addedit') {
      $('.dbq-main-nav').removeClass('active');
      $('.dbq-main-nav').find("[data-type='" + $.cookie('stateObject').navCategory + "']").parent().addClass('active');
      addeditProducts();
    }
  } else {
    $('.dbq-main-nav').find("[data-type='manage']").parent().addClass('active');
    orderform();
  }

});

window.onbeforeunload = function(event) {
  if ($.cookie('user')) {
    var navCategory = $('li.dbq-main-nav.active').find('a').data('type');
    if (navCategory === "manage") {
      stateObject.navCategory = 'manage';
      stateObject.mainCategory = $('.js-orderform-type li.active a').attr('data-value');
    } else if (navCategory === "addedit") {
      stateObject.navCategory = 'addedit';
      stateObject.mainCategory = $('.js-orderform-mainnav li.active a').attr('data-value');
      stateObject.subCategory = $('.js-orderform-edit li.active').attr('data-value');
    }
    $.cookie('stateObject', stateObject);
  }
}

$('.aside--logo').click(function(ev) {
  ev.preventDefault();
  location.reload();
});

function orderform() {
  $('.js-orderform').show();
  $('#addproductsform').hide();
  if ($.cookie('stateObject') && $.cookie('stateObject').mainCategory) {
    $('.js-orderform-type li').removeClass('active');
    $('.js-orderform-type').find('li[data-value="' + $.cookie('stateObject').mainCategory + '"]').addClass('active');
    loadOrderItems();
    $.cookie('stateObject', null);
  } else {
    $.routes.find('manage').routeTo({
      name: $('.js-orderform-type li.active').attr('data-value')
    });
  }
}

$(document).delegate('.js-orderform-type li', 'click', function(ev) {
  // $('.js-orderform-type li').removeClass('active');
  // $('.js-orderform-type').find('li[data-value="' + $(ev.target).closest('li').attr('data-value') + '"]').addClass('active');
  $.routes.find('manage').routeTo({
    name: $('.js-orderform-type li.active').attr('data-value')
  });
});

$(document).delegate('.js-side-nav li', 'click', function(ev) {
  ev.preventDefault();
  $('.js-side-nav li').removeClass('active');
  $(ev.target.parentElement).addClass('active');
  $(this).closest('li').addClass('active');
  var selectedNav = $(this).find('a');
  if (selectedNav.data('type') === 'manage') {
    orderform();
    // $.routes.find('ManageOrder Form').routeTo({});
  } else if (selectedNav.data('type') === 'addedit') {
    $.routes.find('addedit').routeTo({});
  }
});

function addeditProducts() {
  $('#addproductsform').show();
  $('.js-orderform').hide();
  if ($.cookie('stateObject') && $.cookie('stateObject').mainCategory) {
    $('.js-orderform-mainnav li').removeClass('active');
    $('.js-orderform-mainnav').find('li[data-value="' + $.cookie('stateObject').mainCategory + '"]').addClass('active');
    if ($.cookie('stateObject').mainCategory === 'addProduct') {
      $('#addProduct').show();
      $('#editProduct').hide();
    } else if ($.cookie('stateObject').mainCategory === 'editProduct') {
      $('.js-orderform-mainnav').find('li a[data-value="editproduct"]').parent().addClass('active');
      if ($.cookie('stateObject').subCategory == "Packaging") {
        $('#editPackaging').show();
        $('#editSupplies').hide();
        $('#editLabels').hide();
        $('.js-orderform-edit li').removeClass('active');
        $('.js-orderform-edit').find('li[data-value="Packaging"]').addClass('active');
      } else if ($.cookie('stateObject').subCategory == "Supplies") {
        $('#editPackaging').hide();
        $('#editSupplies').show();
        $('#editLabels').hide();
        $('.js-orderform-edit li').removeClass('active');
        $('.js-orderform-edit').find('li[data-value="Supplies"]').addClass('active');
      } else if ($.cookie('stateObject').subCategory == "Labels") {
        $('#editPackaging').hide();
        $('#editSupplies').hide();
        $('#editLabels').show();
        $('.js-orderform-edit li').removeClass('active');
        $('.js-orderform-edit').find('li[data-value="Labels"]').addClass('active');
      }
      loadEditProducts();
    }
    $.cookie('stateObject', null);
  } else {
    stateObject.mainCategory = $('.js-orderform-mainnav li.active').attr('data-value');
    stateObject.subCategory = $('.js-orderform-edit li.active').attr('data-value');
    if (stateObject.mainCategory === 'addProduct') {
      $.routes.find('addediitmainroutes').routeTo({
        name: 'AddProduct'
      });
    } else if (stateObject.mainCategory === 'editProduct') {
      addediitSubcategoryRouting('EditProduct');
    }

  }
}

function addediitSubcategoryRouting(loadfrom) {
  stateObject.MainCategory = $('.js-orderform-mainnav li.active').data('value');
  stateObject.SubCategory = $('.js-orderform-edit li.active').data('value');
  if (loadfrom == "EditProduct") {
    if ($('.js-orderform-edit li.active').attr('data-value') == "Packaging") {
      $.routes.find('addediitmainroutes').routeTo({
        name: 'EditProduct',
        subname: 'Packaging'
      });
    } else if ($('.js-orderform-edit li.active').attr('data-value') == "Supplies") {
      $.routes.find('addediitmainroutes').routeTo({
        name: 'EditProduct',
        subname: 'Supplies'
      });
    } else if ($('.js-orderform-edit li.active').attr('data-value') == "Labels") {
      $.routes.find('addediitmainroutes').routeTo({
        name: 'EditProduct',
        subname: 'Labels'
      });
    }
  }
}
$(document).delegate('.js-orderform-edit li', 'click', function(ev) {
  ev.preventDefault();
  $(this).closest('li').addClass('active');
  if ($('.js-orderform-edit').find('li.active').attr('data-value') == "Packaging") {
    $('#editPackaging').show();
    $('#editSupplies').hide();
    $('#editLabels').hide();
    addediitSubcategoryRouting('EditProduct');
  } else if ($('.js-orderform-edit').find('li.active').attr('data-value') == "Supplies") {
    $('#editPackaging').hide();
    $('#editSupplies').show();
    $('#editLabels').hide();
    addediitSubcategoryRouting('EditProduct');
  } else if ($('.js-orderform-edit').find('li.active').attr('data-value') == "Labels") {
    $('#editPackaging').hide();
    $('#editSupplies').hide();
    $('#editLabels').show();
    addediitSubcategoryRouting('EditProduct');
  }
  loadEditProducts();
});

$(document).delegate('.js-orderform-mainnav li', 'click', function(ev) {
  ev.preventDefault();
  if ($('.js-orderform-mainnav li.active').attr('data-value') === 'addProduct') {
    $.routes.find('addediitmainroutes').routeTo({
      name: 'AddProduct'
    });
  } else if ($('.js-orderform-mainnav').find('li.active').attr('data-value') == "editProduct") {
    addediitSubcategoryRouting('EditProduct');
  }
});
