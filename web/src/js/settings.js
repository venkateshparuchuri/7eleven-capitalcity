var stateObject = {};
var styleLoader = '<div class="col-lg-offset-5 dots-loader spinner-div-style">Loading�</div>';
$(document).ready(function() {
  // need to declare hbs templates here
  unitPriceTemplate = MyApp.templates.unitPrice;
  buildToFactorValuesTemplate = MyApp.templates.buildToFactorValues;
  wastethresholdfactorTemplate = MyApp.templates.wastethresholdfactor;
  buildToFactorSurveyList = MyApp.templates.surveylist;
  rollergrillLevel = MyApp.templates.rollergrilllevels;
  storeTemplate = MyApp.templates.storeProfiles;
  loadStoresWithProfile();
  editCostFormTemplate = MyApp.templates.editcostform;
  addStoreFormTemplate = MyApp.templates.addStore;
  emailConfigTemplate = MyApp.templates.emailConfig;
  reportConfigTemplate = MyApp.templates.reportConfig;
  viewAllStoresTemplate = MyApp.templates.viewAllStores;
  viewAllUsersTemplate = MyApp.templates.viewAllUsers;
  viewThresholdFactorTemplate = MyApp.templates.viewWasteThresholdStores;
  viewBuildToFactorTemplate = MyApp.templates.viewBuildToFactorStores;
  AdmrunreporttabTemplate = MyApp.templates.Admrunreporttab;

  // need to create these variables for view more model in setings
  reportData = '';
  reportUserData = '';
  wasteThresholdData = '';
  buildToStoreData = '';

  $('#js-date-emailconfig').text(moment().format("MMM Do YYYY"));
  $('#js-date-emailconfig').val(moment().format("MMM Do YYYY"));
  $('#js-date-emailconfig').datetimepicker({
    minDate: moment().subtract(1, 'month').format('MM DD YYYY'),
    ignoreReadonly: true,
    format: 'MMM Do YYYY',
    maxDate: moment()
  });
  $('#js-settings-reports-date').text(moment().format("MMM YYYY"));
  $('#js-settings-reports-date').val(moment().format("MMM YYYY"));
  $('#js-settings-reports-date').datetimepicker({
    ignoreReadonly: true,
    format: 'MMM YYYY',
    maxDate: moment()
  });
  //
  // $('#js-settings-reports-date').on('mp.change', function(ev) {
  //
  // });

  $(document).delegate('.fa-calendar', 'click', function(ev) {
    //Trigger the event on the next element.
    $(this).next().trigger('select');
  });

  $('#js-date-emailconfig').on('dp.change', function(ev) {
    if (moment($('#js-date-emailconfig').val(), 'MMM Do YYYY').isSame(moment(), 'day')) {
      $('.js-admin-addEmail-send').attr('disabled', true);
    } else {
      $('.js-admin-addEmail-send').attr('disabled', false);
    }
  });

  $(document).delegate('.js-button-levelInsertRollerCheck-yes', 'click', function(ev) {
    ev.preventDefault();
    var store_id = $('#js-select-levelInsertRollerCheck option:checked').attr('data-store-id');
    if ($('#myonoffswitch' + store_id + 'cc').prop('checked') == true) {
      $('#myonoffswitch' + store_id + 'cc').prop('checked', true);
    } else {
      $('#myonoffswitch' + store_id + 'cc').prop('checked', false);
      $('#alertdiv').hide();
    }
    var elementString = "js-store-profile-switch-box[data-store-id=" + store_id + "][value='cc']";

    $('#js-select-levelRollerModalCheck').modal('hide');
    var jsonObj = {};
    jsonObj.storeId = store_id;
    jsonObj.profile_id = 2;
    jsonObj.storeProfile = 1;
    jsonObj.level_id = $('#js-select-levelInsertRollerCheck option:checked').data('level_id');
    $.ajax({
      type: "PUT",
      url: apiURL + "/settings/stores",
      data: JSON.stringify(jsonObj),
      contentType: "application/json; charset=utf-8",
      success: function(response) {
        loadStoresWithProfile();
      }
    });
  });
  //
  $(document).delegate('#js-level-cancel,#js-modalclosebutton', 'click', function(ev) {
    ev.preventDefault();
    $('#myonoffswitch' + $('#js-level-cancel').attr('data-storeid') + 'rg').attr('checked', false);
  });

  $(document).delegate('.js-store-profile-switch-box', 'change', function(ev) {
    ev.preventDefault();
    if ($(this).hasClass('rg')) {
      if ($(this).prop('checked') == true) {
        $('#js-select-levelRollerModalCheck').modal('show');
        var store_id = $(this).attr('data-store-id');
        $.ajax({
          type: "GET",
          url: apiURL + "/roller/levels",
          contentType: "application/json; charset=utf-8",
          success: function(response) {
            var html = '';
            for (i = 0; i < response.response.length; i++) {
              html += '<option' + " " + 'data-store-id=' + store_id + "  " + 'data-level_id=' + response.response[i].level_id + '>' + " " + response.response[i].level_name + '</option>';
            }
            $('#js-select-levelInsertRollerCheck').html(html);
            $('#js-level-cancel').attr('data-storeid', store_id);
            loadStoresWithProfile();
          }
        });
      } else {
        var checkedStatus = '';
        if ($('#myonoffswitch' + $(this).attr('data-store-id') + 'cc').prop('checked') == true) {
          checkedStatus = true;
        } else if ($('#myonoffswitch' + $(this).attr('data-store-id') + 'pg').prop('checked') == true) {
          checkedStatus = true;
        }
        if (checkedStatus) {
          $(this).parent().prev().find('button').hide();
          var jsonObj = {};
          jsonObj.storeId = $(this).attr('data-store-id');
          jsonObj.profile_id = 2;
          jsonObj.storeProfile = 0;
          jsonObj.level_id = 0;
          $.ajax({
            type: "PUT",
            url: apiURL + "/settings/stores",
            data: JSON.stringify(jsonObj),
            contentType: "application/json; charset=utf-8",
            success: function(response) {
              loadStoresWithProfile();
            }
          });
        } else {
          $('#myonoffswitch' + $(this).attr('data-store-id') + 'rg').prop('checked', true);
          $('#alertdiv').show();
          setTimeout(function() {
            $('#alertdiv').hide();
          }, 1000);
          loadStoresWithProfile();
        }
      }
    } else if ($(this).hasClass('cc')) {
      var jsonObj = {};
      jsonObj.storeId = $(this).data('store-id');
      var profileCode = $(this).val();
      jsonObj.profile_id = 1;
      jsonObj.level_id = 0;
      if ($(this).prop('checked') == true) {
        jsonObj.storeProfile = 1;
      } else {
        var checkedStatus = '';
        if ($('#myonoffswitch' + $(this).attr('data-store-id') + 'rg').prop('checked') == true) {
          checkedStatus = true;
        } else if ($('#myonoffswitch' + $(this).attr('data-store-id') + 'pg').prop('checked') == true) {
          checkedStatus = true;
        }
        if (checkedStatus) {
          jsonObj.storeProfile = 0;
        } else {
          $('#myonoffswitch' + $(this).attr('data-store-id') + 'cc').prop('checked', true);
          $('#alertdiv').show();
          setTimeout(function() {
            $('#alertdiv').hide();
          }, 1000);
        }
      }

      $.ajax({
        type: "PUT",
        url: apiURL + "/settings/stores",
        data: JSON.stringify(jsonObj),
        contentType: "application/json; charset=utf-8",
        success: function(response) {
          loadStoresWithProfile();
        }
      });
    } else if ($(this).hasClass('pg')) {
      var jsonObj = {};
      jsonObj.storeId = $(this).data('store-id');
      var profileCode = $(this).val();
      jsonObj.profile_id = 3;
      jsonObj.level_id = 0;
      if ($(this).prop('checked') == true) {
        jsonObj.storeProfile = 1;
      } else {
        var checkedStatus = '';
        if ($('#myonoffswitch' + $(this).attr('data-store-id') + 'cc').prop('checked') == true) {
          checkedStatus = true;
        } else if ($('#myonoffswitch' + $(this).attr('data-store-id') + 'rg').prop('checked') == true) {
          checkedStatus = true;
        }
        if (checkedStatus) {
          jsonObj.storeProfile = 0;
        } else {
          $('#myonoffswitch' + $(this).attr('data-store-id') + 'pg').prop('checked', true);
          $('#alertdiv').show();
          setTimeout(function() {
            $('#alertdiv').hide();
          }, 1000);
        }
      }
      $.ajax({
        type: "PUT",
        url: apiURL + "/settings/stores",
        data: JSON.stringify(jsonObj),
        contentType: "application/json; charset=utf-8",
        success: function(response) {
          loadStoresWithProfile();
        }
      });
    }

  });
  $(document).delegate('.js-add-new-store', 'click', function(ev) {
    ev.preventDefault();
    var storeHtml = addStoreFormTemplate({
      factor_id: $(this).data('factor-id')
    });
    $('.js-add-store-to-build').html(storeHtml);
    var profile_code = $('#js-setting-buildto-profiles li.active a').attr('profileCode');
    $.ajax({
      type: "GET",
      url: apiURL + "/settings/factor/store/add",
      data: {
        "profile_code": profile_code
      },
      contentType: "application/json; charset=utf-8",
      success: function(response) {
        console.log(response.response);
        if (response.response.length > 0) {
          var html = '';
          for (i = 0; i < response.response.length; i++) {
            html += '<option' + " " + 'store_id=' + response.response[i].store_id + '>' + "STORE" + response.response[i].store_id + '</option>';
            console.log(html);
          }
          $('#addStoreModal').find('select').html(html)
          $('#addStoreModal').modal('show');
        } else {
          new PNotify({
            title: 'Failed!',
            text: 'Sorry. There are no more stores to add',
            type: 'error',
            styling: 'fontawesome',
            hide: true,
            delay: 2000
          });
        }
      }
    });
    //js-build-store-id
    //var $options = $("#js-select-store > option").clone();
    //$('#js-build-store-id').append($options);
    //var elments=$('.js-store-detatch-build_factor');
    //$.each(elments,function(i,val){
    //   var storeId=$(val).data('store-id');
    //   $("#js-build-store-id option[value='"+storeId+"']").remove();
    //});
  });

  $(document).delegate('.js-close-alert', 'click', function(ev) {
    ev.preventDefault();
    $('#alertdiv').hide();
  });


  $(document).delegate('.js-factor-delete', 'click', function(ev) {
    ev.preventDefault();
    $('#js-Delete-factor-Yes').attr('data-factorid', $(ev.target.parentElement).attr("data-factor-id"));
    $('#js-factor-deleteModal').modal('show');
  });
  $('#js-Delete-factor-Yes').click(function(ev) {
    ev.preventDefault();
    //$('#this').text();
    var factor_id = $('#js-Delete-factor-Yes').attr('data-factorid');
    $.ajax({
      type: "POST",
      url: apiURL + "/settings/factor/delete",
      data: JSON.stringify({
        "factor_id": factor_id
      }),
      contentType: "application/json; charset=utf-8",
      success: function(response) {
        $('#js-factor-deleteModal').modal('hide');
        var profile_code = $('#js-setting-buildto-profiles li.active a').attr('profileCode');
        initBuildtoFactorValues(profile_code);

      }
    });
    //$('#js-factor-deleteModal').modal('hide');
  });


  $(document).delegate('.js-add-new-waste-store', 'click', function(ev) {
    ev.preventDefault();
    var storeHtml = addStoreFormTemplate({
      factor_id: $(this).data('factor-id')
    });
    $('.js-add-store-to-build').html(storeHtml);
    var profile_code = $('#js-setting-buildto-profiles li.active a').attr('profileCode');
    $.ajax({
      type: "GET",
      url: apiURL + "/survey/thresholdStores",
      contentType: "application/json; charset=utf-8",
      success: function(response) {
        if (response.response.length > 0) {
          console.log(response.response);
          var html = '';
          for (i = 0; i < response.response.length; i++) {
            html += '<option' + " " + 'store_id=' + response.response[i].store_id + '>' + "STORE" + response.response[i].store_id + '</option>';
            console.log(html);
          }
          $('#js-threshold-select-store_id').html(html);
          $('#addwasteStoreModal').modal('show');
        } else {
          new PNotify({
            title: 'Failed!',
            text: 'Sorry. There are no more stores to add',
            type: 'error',
            styling: 'fontawesome',
            hide: true,
            delay: 2000
          });
        }
      }
    });
  });

  $(document).delegate('#js-waste-add-store', 'click', function(ev) {
    ev.preventDefault();
    var addStoreToBuild = $('#js-add-store-to-build-form').formParams();
    var store_id = $('#js-threshold-select-store_id option:selected').attr('store_id');

    $.ajax({
      type: "POST",
      url: apiURL + "/survey/thresholdStores",
      data: JSON.stringify({
        "threshold_id": parseInt(addStoreToBuild.id),
        "store_id": parseInt(store_id)
      }),
      contentType: "application/json; charset=utf-8",
      success: function(response) {
        $('#addwasteStoreModal').modal('hide');
        initWasteThresoldFactor();
        $('#js-threshold-select-store_id').empty();
      }
    });

  });

  $(document).delegate('.js-factor-waste-delete', 'click', function(ev) {
    ev.preventDefault();
    $('#js-wasteDelete-factor-Yes').attr('data-thresholdid', $(ev.target.parentElement).data('factor-id'));
    $('#js-wastefactor-deleteModal').modal('show');
  });

  $('#js-wasteDelete-factor-Yes').click(function(ev) {
    ev.preventDefault();
    //var threshold_id = $(ev.target.parentElement).attr("data-factor-id");
    var threshold_id = $('#js-wasteDelete-factor-Yes').attr('data-thresholdid')

    $.ajax({
      type: "DELETE",
      url: apiURL + "/survey/ThresholdFactor",
      data: JSON.stringify({
        "threshold_id": threshold_id
      }),
      contentType: "application/json; charset=utf-8",
      success: function(response) {

        $('#js-wastefactor-deleteModal').modal('hide');
        //var threshold_id= $('#js-threshold-select-store_id li.active a').attr('thresholdi-d');
        initWasteThresoldFactor();
      }
    });
    //$('#js-wastefactor-deleteModal').modal('hide');
  });

  $(document).delegate('.js-store-detatch-factor', 'click', function(ev) {
    ev.preventDefault();
    if ($(ev.target).closest('tr').find('a').attr('data-factor-id')) {
      $('#js-wastestoreDelete-factor-Yes').attr('data-factorid', $(ev.target).closest('tr').find('a').attr('data-factor-id'));
    } else {
      $('#js-wastestoreDelete-factor-Yes').attr('data-factorid', $('#WasteThresholdStoresModalLabel').attr('data-thresholdid'));
    }
    $('#js-wastestoreDelete-factor-Yes').attr('data-storeid', $(ev.target).closest('button').attr('data-store-id'));
    $('#js-wastestorefactor-deleteModal').modal('show');
  });

  $('#js-wastestoreDelete-factor-Yes').click(function(ev) {
    ev.preventDefault();
    var threshold_id = $(this).attr("data-factorid");
    $.ajax({
      type: "DELETE",
      url: apiURL + "/survey/thresholdStores",
      data: JSON.stringify({
        "threshold_id": threshold_id,
        "store_id": $(this).attr("data-storeid")
      }),
      contentType: "application/json; charset=utf-8",
      success: function(response) {
        $('#js-wastestorefactor-deleteModal').modal('hide');
        $.ajax({
          type: "GET",
          url: apiURL + "/settings/threshold",
          data: {
            "threshold_id": threshold_id
          },
          contentType: "application/json; charset=utf-8",
          success: function(response) {
            var thresholdData = {
              report: response.response
            };
            wasteThresholdData = thresholdData;
            var thresholdHtml = viewThresholdFactorTemplate(thresholdData);
            $('.js-viewAllWasteThresholdStores').html(thresholdHtml);
            $('.js-viewWasteThreshold-search').val('');
          }
        });
        initWasteThresoldFactor();
      }
    });

  });


  $(document).delegate('.js-button-add-store-to-factor', 'click', function(ev) {
    ev.preventDefault();
    var addStoreToBuild = $('#js-add-store-to-build-form').formParams();
    var store_id = $('#addStoreModal').find('select option:selected').attr('store_id');

    $.ajax({
      type: "POST",
      url: apiURL + "/settings/factor/store/add",
      data: JSON.stringify({
        "factor_id": parseInt(addStoreToBuild.id),
        "store_id": parseInt(store_id)
      }),
      contentType: "application/json; charset=utf-8",
      success: function(response) {
        $('#addStoreModal').modal('hide');
        var profile_code = $('#js-setting-buildto-profiles li.active a').attr('profileCode');
        initBuildtoFactorValues(profile_code);
        $('#addStoreModal').find('select').empty();
      }
    });

  });

  $(document).delegate('.js-store-detatch-build_factor', 'click', function(ev) {
    ev.preventDefault();
    if ($(ev.target).closest('tr').find('a').attr('data-factor-id')) {
      $('#js-storeDelete-factor-Yes').attr('data-factorid', $(ev.target).closest('tr').find('a').attr('data-factor-id'));
    } else {
      $('#js-storeDelete-factor-Yes').attr('data-factorid', $('#buildToStoresModalLabel').attr('data-factorid'));
    }
    $('#js-storeDelete-factor-Yes').attr('data-storeid', $(ev.target).closest('button').attr('data-store-id'));
    $('#js-storefactor-deleteModal').modal('show');
  });
  $('#js-storeDelete-factor-Yes').click(function(ev) {
    ev.preventDefault();
    var factorid = $(this).attr('data-factorid');
    $.ajax({
      type: "POST",
      url: apiURL + "/settings/factor/store/delete",
      data: JSON.stringify({
        id: factorid,
        storeId: $(this).attr('data-storeid')
      }),
      contentType: "application/json; charset=utf-8",
      success: function(response) {
        $('#js-storefactor-deleteModal').modal('hide');
        $.ajax({
          type: "GET",
          url: apiURL + "/settings/buildFactor",
          data: {
            "factor_id": factorid
          },
          contentType: "application/json; charset=utf-8",
          success: function(response) {
            var buildToData = {
              report: response.response
            };
            buildToStoreData = buildToData;
            var buildToHtml = viewBuildToFactorTemplate(buildToData);
            $('.js-viewBuildToStores').html(buildToHtml);
            $('.js-buildTo-search').val('');
          }
        });
        var profile_code = $('#js-setting-buildto-profiles li.active a').attr('profileCode');
        initBuildtoFactorValues(profile_code);
      }
    });
  });




  //$(document).delegate('.js-store-detatch-build_factor', 'click', function(ev) {
  // ev.preventDefault();
  // Factor from Stote - Removing Record from the Build To Stores.

  //$('#js-storefactor-deleteModal').modal('show');
  //ev.preventDefault();
  //$.ajax({
  // type: "POST",
  // url: apiURL + "/settings/factor/store/delete",
  // data: JSON.stringify({
  //  id: $(this).data('factor-id'),
  // storeId: $(this).data('store-id')
  //}),
  // contentType: "application/json; charset=utf-8",
  // success: function(response) {
  // var profile_code = $('#js-setting-buildto-profiles li.active a').attr('profileCode');
  //initBuildtoFactorValues(profile_code);
  //}
  ///});
  //});
  $(document).delegate('.js-factor-', 'click', function(ev) {
    ev.preventDefault();
    // the Factor Value and As Well As Stores From the Factor.
    $.ajax({
      type: "POST",
      url: apiURL + "/settings/factor/",
      data: JSON.stringify({
        id: $(this).data('factor-id')
      }),
      contentType: "application/json; charset=utf-8",
      success: function(response) {
        var profile_code = $('#js-setting-buildto-profiles li.active a').attr('profileCode');
        initBuildtoFactorValues(profile_code);
      }
    });
  });

  $(document).delegate('.js-factor-waste-', 'click', function(ev) {
    ev.preventDefault();
    $.ajax({
      type: "",
      url: apiURL + "/survey/ThresholdFactor",
      data: JSON.stringify({
        threshold_id: $(this).data('factor-id')
      }),
      contentType: "application/json; charset=utf-8",
      success: function(response) {
        initWasteThresoldFactor();
      }
    });
  });

  $(document).delegate('#js-settings-Category', 'click', function(ev) {
    $('#js-edit-Name1_' + surveyId).val($('#p-cat-' + $(ev.target).attr("category-id")).text());
    $('#js-edit-Name1_' + surveyId).attr('category_id', $(ev.target).attr("category-id"));
    $('#editCategory__' + surveyId).modal('show');
    // ev.preventDefault();
    // var category_id = $(ev.target).attr("category-id");
    // $(ev.target.parentElement).remove();
    // Category(category_id);
  });

  $(document).delegate('.js-settings-deleteQuestion', 'click', function(ev) {
    ev.preventDefault();
    var question_id = $(ev.target).attr("question-id");
    //console.log(question_id + "my question_id");
    $('#js-settings-deleteQuestionModal').modal('show');
    $.ajax({
      type: "GET",
      url: apiURL + "/survey/Category",
      data: {
        "idsurvey_questions": question_id
      },
      contentType: "application/json; charset=utf-8",
      success: function(response) {
        console.log(response.response);
        if (response.response.length > 0) {
          var html = '<p>Please complete the following surveys in order to delete this Question.</p>';
          html += '<table class="table table-bordered"><thead><tr><th>StoreID</th><th>SurveyDate</th><th>ManagerName</th></tr></thead>';
          html += '<tbody>'
          for (i = 0; i < response.response.length; i++) {
            html += '<tr>' + '<td class="mytable">' + response.response[i].store_id + '</td>';
            html += '<td class="mytable">' + moment(response.response[i].survey_date).format('MMM Do YYYY') + '</td>' + '<td>' + response.response[i].manager_name + '</td></tr>';
          }
          html += '</tbody></table>'
          console.log(html);
          $('#js-settings-deleteQuestion-tableBody').html(html);
          $('#js-settings-deleteQuestion-yesDelete').hide();
          $('#js-settings-deleteQuestion-noDelete').hide();
        } else {
          $('#js-settings-deleteQuestion-tableBody').html('<p>Are you sure, you want to delete this question?</p>');
          $('#js-settings-deleteQuestion-yesDelete').show();
          $('#js-settings-deleteQuestion-noDelete').show();

        }
      }
    });

    //$(ev.target).closest("tr").remove();
    //Question(question_id);
    $('#js-settings-deleteQuestion-yesDelete').on('click', function(ev) {
      ev.preventDefault();
      $('#js-settings-deleteQuestionModal').modal('hide');
      $('.modal-backdrop').remove();
      $('body').removeClass('modal-open');
      deleteQuestion(question_id);
    });
  });



  $(document).delegate('.js-edit-cost-action', 'click', function(ev) {
    ev.preventDefault();
    ev.stopPropagation();
    var costFormHtml = editCostFormTemplate({
      itemName: $(this).data('product-name'),
      itemId: parseInt($(this).data('product-id'))
    });
    $('.js-edit-cost-form').html(costFormHtml);
    $('#cost').val($(this).parent().parent().find('div.js-product-cost').text());
    $('#editCostModal').modal('show');
    $('#js-cost-update').addClass('js-button-cost-update');
    $('.js-button-cost-update').removeAttr('id');
    $('.js-button-cost-update').attr('data-productid', $(this).attr('data-product-id'));
    $('#effectiveDatePicker').datetimepicker({
      format: 'YYYY-MM-DD',
      ignoreReadonly: true
    });

  });

  $(document).delegate('.js-button-cost-update', 'click', function(ev) {
    ev.preventDefault();
    var productHistory = $('#editCostForm').formParams();
    //var dateArray = [];
    // $("#collapsesausage_" + $(this).data('productid')).find("tbody tr").each(function() {
    //   var object = {};
    //   object.date = $(this).find("td:nth-child(2)").text();
    //   object.cost = $(this).find("td:nth-child(3)").text()
    //   dateArray.push(object);
    // });
    // console.log(dateArray);
    // dateArray.forEach(function(obj) {
    //   if (obj.date == 'productHistory.effectiveDate') {
    //     var reqDate = obj.date;
    //     var reqCost = obj.cost;
    //     $('#editCostModal').modal('hide');
    //     $('#confirmationCostModal').modal('show');
    //   }
    // });
    $.ajax({
      type: "GET",
      url: apiURL + "/settings/unitPrice/verifyDate",
      data: {
        "date": productHistory.effectiveDate,
        "product_id": parseInt(productHistory.itemId)
      },
      contentType: "application/json; charset=utf-8",
      success: function(response) {
        console.log(response);
        if (response.response.length == 0) {
          if (productHistory.cost && productHistory.cost > 0 && productHistory.effectiveDate) {
            $('#editCostModal').modal('hide');
            $.ajax({
              type: "POST",
              url: apiURL + "/settings/savecost",
              data: JSON.stringify({
                "cost": productHistory.cost,
                "effectiveDate": productHistory.effectiveDate,
                "itemId": parseInt(productHistory.itemId),
                "history_id": 0
              }),
              contentType: "application/json; charset=utf-8",
              success: function(response) {
                if ($('.js-unitprice').parent().find('li.active').hasClass('cc')) {
                  loadUnitPrice('cc');
                } else if ($('.js-unitprice').parent().find('li.active').hasClass('rg')) {
                  loadUnitPrice('rg');
                } else if ($('.js-unitprice').parent().find('li.active').hasClass('pg')) {
                  loadUnitPrice('pg');
                }
              }
            });
          } else {
            $('#editCostModal').find('.has-error').removeClass('has-error');
            $('#editCostModal').find('.help-block').remove();
            if (!productHistory.cost || productHistory.cost <= 0) {
              $('#editCostModal #cost').addClass('has-error');
              $('#editCostModal #cost').parent().addClass('has-error');
              $('#editCostModal #cost').parent().append('<p class="help-block">The cost has to have a positive value.</p>');
            } else {
              //As this is a Group Element
              $('#editCostModal #effectiveDate').addClass('has-error');
              $('#editCostModal #effectiveDate').parent().parent().addClass('has-error');
              $('#editCostModal #effectiveDate').parent().parent().append('<p class="help-block">Please provide valid Date.</p>');
            }
          }
        } else {
          $('#confirmationCostModal').modal('show');
          $('.js-button-cost-update').attr('id', 'js-cost-update');
          $('#js-cost-update').removeClass('js-button-cost-update');
          $('#js-cost-update').attr('data-historyid', response.response[0].history_id);
          $('#cost').text(response.response[0].product_cost);
        }
      }
    });
  });

  $(document).delegate('.js-button-yes', 'click', function(ev) {
    ev.preventDefault();
    $('#confirmationCostModal').modal('hide');
  });
  $(document).delegate('#js-button-cancel', 'click', function(ev) {
    ev.preventDefault();
    $('#confirmationCostModal').modal('hide');
    $('#editCostModal').modal('hide');
  });

  $(document).delegate('#js-cost-update', 'click', function(ev) {
    ev.preventDefault();
    $('#confirmationCostModal').modal('hide');
    $('#js-cost-update').addClass('js-button-cost-update');
    $('.js-button-cost-update').removeAttr('id');
    //$('.js-button-cost-update').attr('data-productid', $(this).attr('data-product-id'));
    $('#effectiveDatePicker').datetimepicker({
      format: 'YYYY-MM-DD',
      ignoreReadonly: true
    });
    var productHistory = $('#editCostForm').formParams();
    if (productHistory.cost && productHistory.cost > 0 && productHistory.effectiveDate) {
      $('#editCostModal').modal('hide');
      $.ajax({
        type: "POST",
        url: apiURL + "/settings/savecost",
        data: JSON.stringify({
          "cost": productHistory.cost,
          "effectiveDate": productHistory.effectiveDate,
          "itemId": parseInt(productHistory.itemId),
          "history_id": $('.js-button-cost-update').attr('data-historyid')
        }),
        contentType: "application/json; charset=utf-8",
        success: function(response) {


          if ($('.js-unitprice').parent().find('li.active').hasClass('cc')) {
            loadUnitPrice('cc');
          } else if ($('.js-unitprice').parent().find('li.active').hasClass('rg')) {
            loadUnitPrice('rg');
          } else if ($('.js-unitprice').parent().find('li.active').hasClass('pg')) {
            loadUnitPrice('pg');
          }
        }
      });
    } else {
      $('#editCostModal').find('.has-error').removeClass('has-error');
      $('#editCostModal').find('.help-block').remove();
      if (!productHistory.cost || productHistory.cost <= 0) {
        $('#editCostModal #cost').addClass('has-error');
        $('#editCostModal #cost').parent().addClass('has-error');
        $('#editCostModal #cost').parent().append('<p class="help-block">Cost has to have positive value.</p>');
      } else {
        //As this is a Group Element
        $('#editCostModal #effectiveDate').addClass('has-error');
        $('#editCostModal #effectiveDate').parent().parent().addClass('has-error');
        $('#editCostModal #effectiveDate').parent().parent().append('<p class="help-block">Please provide valid Date.</p>');
      }
    }
  });

  if ($('.tabs-new li').length === 0) {
    $('.tabs-new').hide();
  }
  $('#js-admin-settings').click(function(ev) {
    ev.preventDefault();
    $('#js-admin-settings').removeClass('active');
    $("#js-selectstore-hide").hide();
    $('#js-admin-settings-pop').show();
    $('.js-admin-wastage-div').hide();
    $("#settings-reports").hide();
    $('#js-admin-ccWorkbooks').parent().removeClass('active');
    //$('.js-admin-main-div').hide();
    $(ev.target.parentElement).addClass('active');
    $('#js-ordermanage').parent().removeClass('active');
    $('.js-admin-main-nav').removeClass('active')
    $('.js-admin-order-management-div').hide();
    $('.js-admin-antispated-div').hide();
    $('.js-admin-inspection-div').hide();
    $('.js-admin-temperature-div').hide();
    $('.js-admin-threshold-div').hide();
    $('.js-admin-pullover-div').hide();
  });

  $('.js-admin-settings li').click(function(ev) {
    ev.preventDefault();
    $('#addWasteFactorDiv').hide();
    $('#addWasteFactorDiv').find('div.has-error').removeClass('has-error')
    $('#addFactorDiv').find('div.has-error').removeClass('has-error');
    $('#addFactor-rollerDiv').find('div.has-error').removeClass('has-error');
    $('#addFactor-rollerDiv').find('p').hide();
    $('#addFactorDiv').find('p').hide();
    $('#addWasteFactorDiv').find('p').hide();
    $('#addFactor').val('');
    $('#addWasteFactor').val('');
    $('#addlevelFactor').val('');
    $('#addFactorDiv').hide();
    $('#addFactor-rollerDiv').removeClass('active');
  });
  $('#js-setting-buildto-profiles li').click(function(ev){
    ev.preventDefault();
    $('#addFactorDiv').find('div.has-error').removeClass('has-error');
    $('#addFactorDiv').find('p').hide();
    $('#addFactor').val('');
  });
  $('#js-admin-ccWorkbooks').click(function(ev){
    $("#settings-reports").show();
    $("#js-selectstore-hide").hide();
    $('#js-admin-settings-pop').hide();
    $('.js-admin-wastage-div').hide();
    //$('.js-admin-main-div').hide();
    $(ev.target.parentElement).addClass('active');
    $('#js-ordermanage').parent().removeClass('active');
    $('.js-admin-main-nav').removeClass('active');
   $('#js-admin-settings').parent().removeClass('active');
    $('.js-admin-order-management-div').hide();
    $('.js-admin-antispated-div').hide();
    $('.js-admin-inspection-div').hide();
    $('.js-admin-temperature-div').hide();
    $('.js-admin-threshold-div').hide();
    $('.js-admin-pullover-div').hide();
  });
  $('#js-add-survey').click(function(ev) {

    var profile_id = $('#js-survey-profiles option:selected').attr('profile_id');
    var surveyName = $('#js-survey-name').val();
    $('#js-add-survey').button('loading');
    if (surveyName.length > 0) {
      $.ajax({
        type: "POST",
        url: apiURL + "/settings/survey/create",
        data: JSON.stringify({
          'surveyName': surveyName,
          "profile_id": parseInt(profile_id)
        }),
        contentType: "application/json; charset=utf-8",
        success: function(response) {
          $('#js-add-survey').button("reset");
          //console.log("sucessfully survey created");
          getFactorySurvey();

          $('#addsurvey').modal('hide');
        }
      });

    } else {
      new PNotify({
        title: 'Failed!',
        text: 'Survey Name must not be null',
        type: 'error',
        styling: 'fontawesome',
        hide: true,
        delay: 2000
      });
      $('#js-add-survey').button("reset");
    }
  });

  $('.js-settings-addfactor').click(function(ev) {
    ev.preventDefault();
    $('#addFactorDiv').show();
    $('#addFactorDiv').addClass('active');
    $("#addFactor").val('')
  });
  $('.js-settings-waste-addfactor').click(function(ev) {
    ev.preventDefault();
    $('#addWasteFactorDiv').addClass('active');
    $("#addWasteFactorDiv").show();
    $("#addFactor").val('')
  });

  $('#js-settings-assembleOrder-enterButton').on('click', function(ev) {
    ev.preventDefault();
    if ($('#addFactor').val()) {
      if ($('#addFactor').val() <= 0) {
        if ($('#addFactor').parent().hasClass('has-error')) {} else {
          $('#addFactor').parent().addClass('has-error');
          $('#addFactor').parent().append('<p class="help-block">Please enter the valid value.</p>');
          var addfactor = '';
        }
      } else {
        var addfactor = $("#addFactor").val();
      }
    } else {
      var addfactor = '';
      if ($('#addFactor').parent().hasClass('has-error')) {} else {
        $('#addFactor').parent().addClass('has-error');
        $('#addFactor').parent().append('<p class="help-block">Please fill the valid value.</p>');
      }
    }
    if ($("#addFactor").val() != "") {
      if (addfactor) {
        var newfactor = '<tr id="' + $("#addFactor").val() + '">  <td class="mytable">' + $("#addFactor").val() + ' <i class="fa fa-trash pull-right"></i></td><td class="mytable">' + '  <span class="dropdown"><button class="btn btn-default btn--tag dropdown-toggle" type="button"' + 'id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true"' + 'aria-expanded="true"><i class="fa fa-plus"></i> Add Store </button></span></td></tr>';
        loadBuidtoFactorValues($("#addFactor").val());
        $('#buildtoData').append(newfactor);
        $('#addFactorDiv').removeClass('active');
        //$('#inputCategoryDiv').css('display','none');
        $("#" + $("#addFactor").val()).find('.fa-trash').on('click mousedown', function(eve) {
          eve.preventDefault();
          //console.log($(this).parent().attr('id'));
          $("#" + $(this).parent().parent().attr('id')).remove();
        });
      }
    }
  });




  $('#js-wasteFactor-enterButton').on('click', function(ev) {

    ev.preventDefault();

    if ($('#addWasteFactor').val()) {
      if ($('#addWasteFactor').val() <= 0) {
        if ($('#addWasteFactor').parent().hasClass('has-error')) {} else {
          $('#addWasteFactor').parent().addClass('has-error');
          $('#addWasteFactor').parent().append('<p class="help-block">Please enter the valid value.</p>');
          var addwastefactor = '';
        }
      } else {
        var addwastefactor = $("#addWasteFactor").val();
      }
    } else {
      var addwastefactor = '';
      if ($('#addWasteFactor').parent().hasClass('has-error')) {} else {
        $('#addWasteFactor').parent().addClass('has-error');
        $('#addWasteFactor').parent().append('<p class="help-block">Please fill the valid value.</p>');
      }
    }


    //console.log("done");
    if ($("#addWasteFactor").val() != "") {
      if (addwastefactor) {
        var newfactor = '<tr id="' + $("#addWasteFactor").val() + '">  <td class="mytable">' + $("#addWasteFactor").val() + ' <i class="fa fa-trash pull-right"></i></td><td class="mytable">' + '  <span class="dropdown"><button class="btn btn-default btn--tag dropdown-toggle" type="button"' + 'id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true"' + 'aria-expanded="true"><i class="fa fa-plus"></i> Add Store </button></span></td></tr>';

        $.ajax({
          type: "POST",
          url: apiURL + "/survey/ThresholdFactor",
          data: JSON.stringify({
            "factor_value": parseInt($("#addWasteFactor").val())
          }),
          contentType: "application/json; charset=utf-8",
          success: function(response) {
            initWasteThresoldFactor();
          }
        });

        //$('#buildtoData').append(newfactor);
        $('#addWasteFactor').val('');
        $('#addWasteFactorDiv').removeClass('active');
        //$('#inputCategoryDiv').css('display','none');
        // $("#" + $("#addWasteFactor").val()).find('.fa-trash').on('click mousedown', function(eve) {
        //     ev.preventDefault();
        //     //console.log($(this).parent().attr('id'));
        //     $("#" + $(this).parent().parent().attr('id')).remove();
        // });
      }
    }
  });


  $('#js-addNewUser-submit').click(function(ev) {
    ev.preventDefault();
    signup();
  });

  $('#js-updatePassword-submit').click(function(ev) {
    ev.preventDefault();
    updatePassword();
  });


  $('#js-settings-plan-addcategory').click(function(ev) {
    //console.log("active calling");
    ev.preventDefault();
    $('#inputCategoryDiv').addClass('active');
    //$('#inputCategoryDiv').css('display','block');
    $("#inputCategory").val('')
  });
  $('.fa-times-circle').on('click mousedown', function(eve) {
    eve.preventDefault();
    //console.log($(this).parent().attr('id'));
    $("#" + $(this).parent().attr('id')).remove();
  });
  $('#inputCategory').on('keydown', function(ev) {
    if (ev.keyCode == 13) {
      ev.preventDefault();
      var newcategory = "<button class='btn btn--tag btn-default' id='" + $("#inputCategory").val() + "'>" + $("#inputCategory").val() +
        " <i class='fa fa-times-circle' ></i></button>";
      $('#js-settings-plan-category').append(newcategory);
      $('#inputCategoryDiv').removeClass('active');
      //$('#inputCategoryDiv').css('display','none');
      $("#" + $("#inputCategory").val()).find('.fa-times-circle').on('click mousedown', function(eve) {
        eve.preventDefault();
        //console.log($(this).parent().attr('id'));
        $("#" + $(this).parent().attr('id')).remove();
      });
    }
  });
  //loadUnitPrice();
  if ($('.js-unitprice').parent().find('li.active').hasClass('cc')) {
    loadUnitPrice('cc');
  } else if ($('.js-unitprice').parent().find('li.active').hasClass('rg')) {
    loadUnitPrice('rg');
  } else if ($('.js-unitprice').parent().find('li.active').hasClass('pg')) {
    loadUnitPrice('pg');
  }
  //loadBuidtoFactorValues();

  initBuildtoFactorValues('cc');
  initWasteThresoldFactor();
  getFactorySurvey();
  addNewUser();
  rollergrillLevels();
  getEmailConfigData();
  getReportGroups();
  getReportStores();
  getRunReports();

});

function getFactorySurvey() {
  var defered1 = $.ajax({
    type: "GET",
    url: apiURL + "/settings/getSurveys",
    contentType: "application/json; charset=utf-8"
  });


  $.when(defered1).then(function(v1) {
    //console.log("factory surveys:"+v1);
    var surveysData = {
      surveysList: v1.response
    };
    var surveysHtml = buildToFactorSurveyList(surveysData);
    //console.log(surveysHtml);
    $('#survey-tabs-new').html(surveysHtml);
    $('#tabs-new a:first').tab('show');
    if (window.settingsObj) {
      //$('#tabId_1').parent().removeClass('active');
      $('#tabId_' + window.settingsObj.currentSurveyId).trigger('click');
      if (window.settingsObj.currentTab === 'Question') {
        $('.js-question-li').find('a').trigger('click');
      } else if (window.settingsObj.currentTab === 'Category') {
        $('.js-category-li').find('a').trigger('click');
      }
    }
    if (window.settingsObj && window.settingsObj.edit_question_id) {
      $('#tabId_' + window.settingsObj.questionSurveyId).trigger('click');
    }
  }, function(err) {
    console.error(err);
  });

}



function loadUnitPrice(type) {
  $('.modal-backdrop').remove();
  $('body').removeClass('modal-open');
  var profile_type = type;
  var defered1 = $.ajax({
    type: "GET",
    url: apiURL + "/settings/unitPrice",
    data: {
      "profile_code": type
    },
    contentType: "application/json; charset=utf-8"
  });


  $.when(defered1).then(function(v1) {
    //console.log(v1);
    var productdata = {
      unitPrices: v1.response
    };
    var unitPricehtml = unitPriceTemplate(productdata);
    $('#js-unitprice_profile').html(unitPricehtml);

  }, function(err) {
    console.error(err);
  });

}

function loadStoresWithProfile() {

  var defered1 = $.ajax({
    type: "GET",
    url: apiURL + "/settings/stores",
    contentType: "application/json; charset=utf-8"
  });


  $.when(defered1).then(function(v1) {
    //console.log(v1);
    var storeData = {
      stores: v1.response
    };
    var storeHTML = storeTemplate(storeData);
    $('.js-store-list').html(storeHTML);

  }, function(err) {
    console.error(err);
  });

}

function initBuildtoFactorValues(storeType) {
  $("#ATOF_" + storeType).addClass("active");

  if ($("#ATOF_" + storeType).hasClass("active")) {
    $("#ATOF_" + storeType).addClass("active");
    $('.js-settings-addfactor').show();
    $('#addFactorDiv').hide();
  }
  if (storeType == "cc") {
    $("#ATOF_rg").removeClass("active");
    $("#ATOF_pg").removeClass("active");
  } else if (storeType == "rg") {
    $("#ATOF_cc").removeClass("active");
    $("#ATOF_pg").removeClass("active");
  } else if (storeType == "pg") {
    $("#ATOF_cc").removeClass("active");
    $("#ATOF_rg").removeClass("active");
  }

  var defered1 = $.ajax({
    type: "GET",
    url: apiURL + "/settings/initBuildto",
    data: {
      "profile_code": storeType
    },
    contentType: "application/json; charset=utf-8"
  });
  /*
  var defered2 = $.ajax({
    type: "GET",
    url: apiURL + "/settings/factor/store/add",
    contentType: "application/json; charset=utf-8"
  });
*/
  $.when(defered1).then(function(v1) {
    //console.log(v1);
    var factordata = {
      factorValues: v1.response
    };
    var factorValueshtml = buildToFactorValuesTemplate(factordata);
    $('#buildtoData').html(factorValueshtml);
  }, function(err) {
    console.log(err);
  });
}

function initWasteThresoldFactor() {

  var defered1 = $.ajax({
    type: "GET",
    url: apiURL + "/survey/ThresholdFactor",
    contentType: "application/json; charset=utf-8"
  });
  $.when(defered1).then(function(v1) {
    var factordata = {
      factorValues: v1.response
    };
    var factorValueshtml = wastethresholdfactorTemplate(factordata);

    $('#thresholdData').html(factorValueshtml);
  }, function(err) {
    console.log(err);
  });
}

function loadBuidtoFactorValues(factorValue) {
  var profile_code = $('#js-setting-buildto-profiles li.active a').attr('profileCode');
  if (profile_code == 'cc') {
    var profile_id = 1;
  } else if (profile_code == 'rg') {
    var profile_id = 2;
  } else if (profile_code == 'pg') {
    var profile_id = 3;
  }

  $.ajax({
    type: "POST",
    url: apiURL + "/settings/buildto",
    data: JSON.stringify({
      "factor_value": parseInt(factorValue),
      "profile_id": profile_id
    }),
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      var profile_code = $('#js-setting-buildto-profiles li.active a').attr('profileCode');
      initBuildtoFactorValues(profile_code);
    }
  });

}

// this function s category from the survey
function deleteCategory(category_id) {
  $.ajax({
    type: "DELETE",
    url: apiURL + "/survey/Category",
    data: JSON.stringify({
      "category_id": category_id
    }),
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      //initBuildtoFactorValues();
      window.settingsObj = {
        'currentSurveyId': $('#tabs-new').find('li.active').attr('data-surveyid'),
        'currentTab': 'Category'
      }
      getFactorySurvey();

    }
  });
}

function editQuestion(questionId, question, score) {
  $("#editQuestionModal").modal('show');
  $("#editQuestionModal").find(".modal-content").css('border', '3px solid green');
  $("#editQuestionText").val(question);
  $("#editScoreText").val(score);
  //This Can Be Refactored into Delegate.
  $("#editQuestionDone").click(function(ev) {
    $.ajax({
      type: "PUT",
      url: apiURL + "/survey/Question",
      data: JSON.stringify({
        "question_id": questionId,
        "question": $("#editQuestionText").val(),
        "score": $("#editScoreText").val()
      }),
      contentType: "application/json; charset=utf-8",
      success: function(response) {
        //initBuildtoFactorValues();
        $('#data_' + questionId).html($("#editQuestionText").val());
        $('#datascore_' + questionId).html($("#editScoreText").val());
        $("#editQuestionModal").find(".modal-content").css('border', '3px solid green');
        $("#editQuestionModal").modal('hide');
        //$($(event.currentTarget).closest('tr').children()[0]).text("hellow");
        window.settingsObj = {
          'currentSurveyId': $('#tabs-new').find('li.active').attr('data-surveyid'),
          'currentTab': 'Question'
        }
        $('.modal-backdrop').remove();
        $('body').removeClass('modal-open');
        $("#editQuestionText").val('');
        window.settingsObj = {
          'currentSurveyId': $('#tabs-new').find('li.active').attr('data-surveyid'),
          'currentTab': 'Question'
        }
        getFactorySurvey();

      }
    });
  });

}

function deleteQuestion(Question_id) {
  $.ajax({
    url: apiURL + "/survey/Question",
    type: "DELETE",
    data: JSON.stringify({
      "question_id": Question_id
    }),
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      $('.modal-backdrop').remove();
      $('body').removeClass('modal-open');
      window.settingsObj = {
        'currentSurveyId': $('#tabs-new').find('li.active').attr('data-surveyid'),
        'currentTab': 'Question'
      }
      getFactorySurvey();

    }
  });
}

function addCategory(surveyId, surveyName) {
  $('#addcategory_' + surveyId).modal('show');
  //var optionValue = $($('#tabs-new').find('li.active').children()[0]).attr("data-value");
  $('#select-surveyName_' + surveyId).val(surveyName);
  // var survey_id = $($('#tabs-new').find('li.active').children()[0]).attr("survey_id");


  $("#addCategoryDone_" + surveyId).click(function(ev) {
    ev.preventDefault();
    var category_name = $('#newCategoryName_' + surveyId).val();
    if (category_name.length > 0) {

      $.ajax({
        type: "POST",
        url: apiURL + "/survey/Category",
        data: JSON.stringify({
          "survey_id": surveyId,
          "category_name": category_name
        }),
        contentType: "application/json; charset=utf-8",
        success: function(response) {

          //$('#newCategoryName_' + surveyId).val('');
          $('#addcategory_' + surveyId).modal('hide');
          $('.modal-backdrop').remove();
          $('body').removeClass('modal-open');
          window.settingsObj = {
            'currentSurveyId': $('#tabs-new').find('li.active').attr('data-surveyid'),
            'currentTab': 'Category'
          }
          getFactorySurvey();
        }
      });

    } else {

      new PNotify({
        title: 'Failed!',
        text: 'Please enter category name.',
        type: 'error',
        styling: 'fontawesome',
        hide: true,
        delay: 2000
      });
    }
  });

}


//function editCategory(categoryId, categoryName, surveyId) {
$(document).delegate('.js-edit-surveyCategory', 'click', function(ev) {
  ev.preventDefault();
  var categoryId = $(ev.target).closest('button').attr('data-categoryid');
  var categoryName = $(ev.target).closest('button').attr('data-categoryname');
  var surveyId = $(ev.target).closest('div').attr('data-surveyId');
  $('#js-edit-Name1_' + surveyId).val($('#p-cat-' + categoryId).text());
  $('#js-edit-Name1_' + surveyId).attr('category_id', categoryId);
  $('#editCategory__' + surveyId).modal('show');

  $('#saveSurveyName1_' + surveyId).on('click', function() {

    $.ajax({
      type: "PUT",
      url: apiURL + "/survey/getCategories",
      data: JSON.stringify({
        "surveyid": surveyId,
        "categoryname": $("#js-edit-Name1_" + surveyId).val(),
        "idsurvey_category": categoryId
      }),
      contentType: "application/json; charset=utf-8",
      success: function(response) {
        $('#editCategory__' + surveyId).modal('hide');
        $('#js-edit-Name1_' + surveyId).val($("#js-edit-Name1_" + surveyId).val());
        $('#p-cat-' + categoryId).text($("#js-edit-Name1_" + surveyId).val());
      }
    });
  });

});

function getProfiles() {

  $.ajax({
    type: "GET",
    url: apiURL + "/survey/getProfiles",
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      var html = '';
      for (i = 0; i < response.response.length; i++) {
        html += '<option' + " " + 'profile_id=' + response.response[i].profile_id + '>' + response.response[i].profile_name + '</option>';
        console.log(html);
      }
      $('#js-survey-profiles').html(html);
      $('#js-survey-name').val("");
    }
  });

}



function editSurvey(surveyName, surveyId) {

  $('#js-edit-Name_' + surveyId).val($("#tabId_" + surveyId).attr("data-value"));
  $("#js-edit-Code_" + surveyId).val(surveyId);
  $('#editModal_' + surveyId).modal('show');
  console.log("#tabId_" + surveyId);

  //$(event.currentTarget).parent().find('li.active').find('a').text($('#js-edit-Name').val());
  $('#saveSurveyName_' + surveyId).on('click', function() {
    $('#editModal_' + surveyId).modal('hide');

    console.log($("#js-edit-Name_" + surveyId).val() + "|" + $("#js-edit-Code_" + surveyId).val() + "|" + ("#tabId_" + surveyId));

    $("#tabId_" + surveyId).text($("#js-edit-Name_" + surveyId).val());
    $("#tabId_" + surveyId).attr("data-value", $("#js-edit-Name_" + surveyId).val());

    $.ajax({
      type: "PUT",
      url: apiURL + "/settings/survey/editSurvey",
      data: JSON.stringify({
        "edit_name": $("#js-edit-Name_" + surveyId).val(),
        "edit_code": $("#js-edit-Code_" + surveyId).val()
      }),
      contentType: "application/json; charset=utf-8",
      success: function(response) {
        $('#editModal').modal('hide');
        $("#js-edit-Name").val('');
        $("#js-edit-Code").val('');

      }
    });
  });

  $('#js-settings-deleteSurvey_' + surveyId).on('click', function(ev) {
    $('#js-settings-deleteSurveyModal').modal('show');
    $.ajax({
      type: "GET",
      url: apiURL + "/settings/deleteSurvey",
      data: {
        "survey_id": surveyId
      },
      contentType: "application/json; charset=utf-8",
      success: function(response) {
        console.log(response.response);
        if (response.response.length > 0) {
          var html = '<p>Please complete the following surveys in order to delete this Survey.</p>';
          html += '<table class="table table-bordered"><thead><tr><th>StoreID</th><th>SurveyDate</th><th>ManagerName</th></tr></thead>';
          html += '<tbody>'
          for (i = 0; i < response.response.length; i++) {
            html += '<tr>' + '<td class="mytable">' + response.response[i].store_id + '</td>';
            html += '<td class="mytable">' + moment(response.response[i].survey_date).format('MMM Do YYYY') + '</td>' + '<td class="mytable">' + response.response[i].manager_name + '</td></tr>';
          }
          html += '</tbody></table>'
          console.log(html);
          $('#js-settings-deleteSurvey-tableBody').html(html);
          $('#js-settings-deleteSurvey-yesDelete').hide();
          $('#js-settings-deleteSurvey-noDelete').hide();
        } else {
          $('#js-settings-deleteSurvey-tableBody').html('<p>Are you sure, you want to delete this survey?</p>');
          $('#js-settings-deleteSurvey-yesDelete').show();
          $('#js-settings-deleteSurvey-noDelete').show();
        }
      }
    });
  });

  $('#js-settings-deleteSurvey-yesDelete').on('click', function(ev) {
    $('#js-settings-deleteSurveyModal').modal('hide');
    $('#editModal_' + surveyId).modal('hide');
    $('.modal-backdrop').remove();
    $('body').removeClass('modal-open');
    $.ajax({
      type: "PUT",
      url: apiURL + "/settings/deleteSurvey",
      data: JSON.stringify({
        "survey_id": surveyId
      }),
      contentType: "application/json; charset=utf-8",
      success: function(response) {
        getFactorySurvey();
      }
    });
  });





}




function addquestion(surveyId) {
  $('#addquestion_' + surveyId).modal('show');


  $("#addQuestionDone_" + surveyId).click(function(ev) {
    ev.preventDefault();
    console.log("addQuestion :" + $("#newQuestionName_" + surveyId).val() + "|" + parseInt($("#js-addQuestion-newScore_" + surveyId).val()));
    //$('#addquestion_' + surveyId).modal('show');
    window.settingsObj = {
      'currentSurveyId': $(this).attr('data-surveyid'),
      'currentTab': 'Question'
    }
    var question = $("#newQuestionName_" + surveyId).val()
    var score = $("#js-addQuestion-newScore_" + surveyId).val()
    if (question.length > 0 && score.length > 0) {
      $.ajax({
        type: "POST",
        url: apiURL + "/survey/Question",
        data: JSON.stringify({
          "question": $("#newQuestionName_" + surveyId).val(),
          "score": parseInt($("#js-addQuestion-newScore_" + surveyId).val()),
          "category_id": parseInt($("#js-categories-dropDown_" + surveyId + " " + "option:selected").val())
        }),
        contentType: "application/json; charset=utf-8",
        success: function(response) {
          $('#addquestion_' + surveyId).modal('hide');
          $("#newQuestionName").val('');
          $("#js-addScore").val('');
          window.settingsObj = {
            'currentSurveyId': $('#tabs-new').find('li.active').attr('data-surveyid'),
            'currentTab': 'Question'
          }
          getFactorySurvey();
          $('.modal-backdrop').remove();
          $('body').removeClass('modal-open');
        }
      });
    } else {
      new PNotify({
        title: 'Failed!',
        text: 'Question and Score must be filled.',
        type: 'error',
        styling: 'fontawesome',
        hide: true,
        delay: 2000
      });
    }

  });

}


function deleteCategoryModal() {
  $('#deleteCategoryModal').modal('show');
  var survey_id = $('#survey-tabs-new #tabs-new').find('li.active a').attr('survey_id');
  var category_id = $('#js-edit-Name1_' + survey_id).attr("category_id");
  $.ajax({
    type: "GET",
    url: apiURL + "/settings/savedSurveyList",
    data: {
      "category_id": category_id
    },
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      console.log(response.response);
      if (response.response.length > 0) {
        var html = '<p>Please complete the following surveys in order to delete this Category</p>';
        html += '<table class="table table-bordered"><thead><tr><th>StoreID</th><th>SurveyDate</th><th>ManagerName</th></tr></thead>';
        html += '<tbody>'
        for (i = 0; i < response.response.length; i++) {
          html += '<tr>' + '<td class="mytable">' + response.response[i].store_id + '</td>';
          html += '<td class="mytable">' + moment(response.response[i].survey_date).format('MMM Do YYYY') + '</td>' + '<td class="mytable">' + response.response[i].manager_name + '</td></tr>';
        }
        html += '</tbody></table>'
        console.log(html);
        $('#js-settings-deleteCategory-tableBody').html(html);
        $('#js-settings-deleteCategory-yesDelete').hide();
        $('#js-settings-deleteCategory-noDelete').hide();
      } else {
        $('#js-settings-deleteCategory-tableBody').html('<p>Are you sure, you want to delete this category?</p>');
        $('#js-settings-deleteCategory-yesDelete').show();
        $('#js-settings-deleteCategory-noDelete').show();
      }

      $('#js-settings-deleteCategory-yesDelete').on('click', function(ev) {
        ev.preventDefault();
        deleteCategory(category_id);
        $('#deleteCategoryModal').modal('hide');
        $('#editCategory__' + survey_id).modal('hide');
        $('.modal-backdrop').remove();
        $('body').removeClass('modal-open');
        $('#btn-cat-' + category_id).hide();
      })

    }
  });
}


$('.js-unitprice').click(function(ev) {
  ev.preventDefault();
  $('#js-setting-unit-profiles li').removeClass('active')
  $(this).addClass('active');
  loadUnitPrice($(this).attr('profileCode'));
  $('.js-unitprice').css('cursor', 'pointer');
});

$('.js-close-alert').click(function(ev) {
  ev.preventDefault();
  $('#successmessage').hide();
});

/*function editCategory(categoryId,categoryName,surveyId)
{


 $('#js-edit-Name1_'+surveyId).val(categoryName);
 $('#editCategory__'+surveyId).modal('show');

 $('#saveSurveyName1_'+surveyId).on('click',function(){

  $.ajax({
        type: "PUT",
        url: apiURL + "/survey/getCategories",
        data: JSON.stringify({"surveyid":surveyId, "categoryname":$("#js-edit-Name1_"+surveyId).val(), "idsurvey_category":categoryId}),
        contentType: "application/json; charset=utf-8",
        success: function(response) {
          $('#editCategory__'+surveyId).modal('hide');
          $('#js-edit-Name1_'+surveyId).val('');

         }
      });
  });

}*/
// function myinitials() {
//     var x = $("#js-addUser-Initials");
//     x.value = x.value.toUpperCase();
// }
function signup() {

  if ($("#js-addUser-userId").val() && $("#js-addUser-userId").val() != '') {
    var userId = $("#js-addUser-userId").val();
  } else {
    var userId = '';
    if ($('#js-addUser-userId').parent().hasClass('has-error')) {} else {
      $('#js-addUser-userId').parent().addClass('has-error');
      $('#js-addUser-userId').parent().append('<p class="help-block">Please fill the userid.</p>');
    }
  }


  if ($("#js-addUser-inputName").val() && $("#js-addUser-inputName").val() != "") {
    var Name = $("#js-addUser-inputName").val();
  } else {
    var Name = '';
    if ($('#js-addUser-inputName').parent().hasClass('has-error')) {} else {
      $('#js-addUser-inputName').parent().addClass('has-error');
      $('#js-addUser-inputName').parent().append('<p class="help-block">Please fill the name.</p>');
    }
  }


  if ($("#js-addUser-E-mail").val() && $("#js-addUser-E-mail").val() != "") {
    var Email = $("#js-addUser-E-mail").val();
  } else {
    var Email = '';
    if ($('#js-addUser-E-mail').parent().hasClass('has-error')) {} else {
      $('#js-addUser-E-mail').parent().addClass('has-error');
      $('#js-addUser-E-mail').parent().append('<p class="help-block">Please fill the valid email.</p>');
    }
  }

  if ($("#js-addUser-Password").val() && $("#js-addUser-Password").val() != "") {
    var password = $.sha256($("#js-addUser-Password").val());
  } else {
    if ($('#js-addUser-Password').parent().hasClass('has-error')) {} else {
      $('#js-addUser-Password').parent().addClass('has-error');
      $('#js-addUser-Password').parent().append('<p class="help-block">Please fill the passsword.</p>');
    }
  }

  if ($("#js-addUser-Initials").val() && $("#js-addUser-Initials").val() != "") {
    var Initials = $("#js-addUser-Initials").val();
  } else {
    if ($('#js-addUser-Initials').parent().hasClass('has-error')) {} else {
      $('#js-addUser-Initials').parent().addClass('has-error');
      $('#js-addUser-Initials').parent().append('<p class="help-block">Please fill the initials.</p>');
    }
  }

  var Designation = $("#js-addUser-Designation option:selected").val();

  var Store = $('#js-addUser-stores option:selected').val();
  if (validateEmail($("#js-addUser-E-mail").val())) {
    if (userId && Name && Email && password && Initials) {
      $.ajax({
        type: "POST",
        url: apiURL + "/auth/addUser",
        data: JSON.stringify({
          "name": Name,
          "email": Email,
          "password": password,
          "initials": Initials,
          "user_id": userId,
          "store_id": Store,
          "role_id": Designation
        }),
        contentType: "application/json; charset=utf-8",
        success: function(response) {
          $('#js-signup-form').find("input[type=text], input[type=Name], input[type=password]").val("");
          $('#successmessage').show();
          $("#successmessage").fadeTo(2000, 500).slideUp(500, function() {
            $("#successmessage").hide();
          });
          $('#js-addNewUser-submit').prop("disabled", true);
          $('#js-addUser-Designation').html("");
          $('#js-addUser-Designation').prop("disabled", true);
          $('#js-signup-form').find('input[type=password],[type=Name],[type=email],[type=text]').val('')
          $('#js-addUser-stores').prop('selectedIndex', 0);
          $('#js-signup-form').find('p').remove();
          $('#js-signup-form').find('input').parent().removeClass('has-error');
          addNewUser();
        },
        error: function(xhr, ajaxOptions, thrownError) {
          new PNotify({
            title: 'SignUp Failed!',
            text: 'User has already existed for this store.',
            type: 'error',
            styling: 'fontawesome'
          });
          $('#js-addNewUser-submit').prop("disabled", true);
          $('#js-addUser-Designation').html("");
          $('#js-addUser-Designation').prop("disabled", true);
          $('#js-signup-form').find('input[type=password],[type=Name],[type=email],[type=text]').val('')
          $('#js-addUser-stores').prop('selectedIndex', 0);
          $('#js-signup-form').find('p').remove();
          $('#js-signup-form').find('input').parent().removeClass('has-error');
          addNewUser();
        }
      });
    }
  } else {
    if ($('#js-addUser-E-mail').parent().hasClass('has-error')) {} else {
      $('#js-addUser-E-mail').parent().addClass('has-error');
      $('#js-addUser-E-mail').parent().append('<p class="help-block">Please enter valid email.</p>');
    }
  }
};

$(document).delegate('#js-addUser-Initials', 'blur', function(ev) {
  ev.preventDefault();
  var intialvalue = $("#js-addUser-Initials").val();
  var intial = intialvalue.toUpperCase();
  $("#js-addUser-Initials").val(intial);
});

function validateEmail(sEmail) {
  var filter = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
  if (filter.test(sEmail)) {
    return true;
  } else {
    return false;
  }
}


function addNewUser() {
  $.ajax({
    type: "GET",
    url: apiURL + "/auth/addUserStoresList",
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      var html = "";
      for (var i = 0; i < response.response.length; i++) {
        html += "<option value='" + response.response[i].store_id + "'>Store" + response.response[i].store_id + "</option>";
      }
      $('#js-addUser-stores').append(html);
    }
  });
}



function updatePassword() {

  if ($('#js-updatePassword-user_id').val() && $('#js-updatePassword-user_id').val() != "") {
    var userId = $('#js-updatePassword-user_id').val();
  } else {
    if ($('#js-updatePassword-user_id').parent().hasClass('has-error')) {} else {
      $('#js-updatePassword-user_id').parent().addClass('has-error');
      $('#js-updatePassword-user_id').parent().append('<p class="help-block">You forgot to enter your userId.</p>');
    }
  }

  if ($('#js-updatePassword-email').val() && $('#js-updatePassword-email').val() != "") {
    var email = $('#js-updatePassword-email').val();
  } else {
    if ($('#js-updatePassword-email').parent().hasClass('has-error')) {} else {
      $('#js-updatePassword-email').parent().addClass('has-error');
      $('#js-updatePassword-email').parent().append('<p class="help-block">Please enter valid email.</p>');
    }
  }

  if ($('#js-updatePassword-newPassword').val() && $('#js-updatePassword-newPassword').val() != "") {
    var newPassword = $.sha256($('#js-updatePassword-newPassword').val());
  } else {
    if ($('#js-updatePassword-newPassword').parent().hasClass('has-error')) {} else {
      $('#js-updatePassword-newPassword').parent().addClass('has-error');
      $('#js-updatePassword-newPassword').parent().append('<p class="help-block">You forgot to enter your password.</p>');
    }
  }
  if (validateEmail($('#js-updatePassword-email').val())) {
    if (email && newPassword && userId) {
      $.ajax({
        type: "PUT",
        url: apiURL + "/auth/addUser",
        data: JSON.stringify({
          "email": email,
          "newpass": newPassword,
          "user_id": userId
        }),
        contentType: "application/json; charset=utf-8",
        success: function(response) {
          $('#resetmessage').show();
          $("#resetmessage").fadeTo(2000, 500).slideUp(500, function() {
            $("#resetmessage").hide();
          });
          $('#js-changepassword-form').find("input[type=Name], input[type=password]").val("");
        },
        error: function(xhr, ajaxOptions, thrownError) {
          new PNotify({
            title: 'Updating Failed!',
            text: 'usreId/E-mail entered is invalid.',
            type: 'error',
            styling: 'fontawesome'
          });
        }
      });
    }
  } else {
    if ($('#js-updatePassword-email').parent().hasClass('has-error')) {} else {
      $('#js-updatePassword-email').parent().addClass('has-error');
      $('#js-updatePassword-email').parent().append('<p class="help-block">Please enter valid email.</p>');
    }
  }
}

function rollergrillLevels() {
  $.ajax({
    type: "GET",
    url: apiURL + "/settings/level_timings",
    contentType: "application/json; charset=utf-8",
    success: function(response) {

      var data = response.response;
      var array = data.sort(function(a, b) {
        a.value = parseInt(a.level_name.split(' ')[1]);
        b.value = parseInt(b.level_name.split(' ')[1]);
        if (a.value > b.value) {
          return 1;
        }
        if (a.value < b.value) {
          return -1;
        }
        // a must be equal to b
        return 0;
      });
      //console.log(array);
      var levelData = {
        level: array
      };
      var levelshtml = rollergrillLevel(levelData);

      $('#js-roller-levels').html(levelshtml);
    }
  });
}

$(document).delegate('#js-addlevel-time', 'click', function(ev) {
  ev.preventDefault();
  var level_id = $(this).attr('data-level-id');
  $.ajax({
    type: "GET",
    url: apiURL + "/settings/levels/getTimeSlots",
    data: {
      "level_id": level_id
    },
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      if (response.response.length > 0) {
        var html = '';
        for (i = 0; i < response.response.length; i++) {
          html += '<option' + " " + 'time_id=' + response.response[i].time_id + " " + 'level_id=' + level_id + '>' + response.response[i].time_slot + '</option>';
        }
        $('#js-rollertimeslots').html(html);
        $('#addrollertimeslots').modal('show');
      } else {
        new PNotify({
          title: 'Failed!',
          text: 'Sorry. There are no available time slots.',
          type: 'error',
          styling: 'fontawesome',
          hide: true,
          delay: 2000
        });
      }
    }
  });

});


$(document).delegate('#js-addUser-group', 'click', function(ev) {
  ev.preventDefault();
  $('.js-example-basic-multiple').val('');
  var group_id = $(this).closest('tr').find('a').attr('data-group-id');
  var groupName = $(this).closest('tr').find('a').attr('data-group-name');
  $.ajax({
    type: "GET",
    url: apiURL + "/report/EmailReport",
    data: {
      "group_id": group_id
    },
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      if (response.response.length > 0) {
        $('.js-example-basic-multiple').val('');
        $('#js-add-userToGroup').attr('data-groupid', group_id)
        $('#userDataForGroup').modal('show');
        var data = groupName + " - Add User";
        $('.js-addUserToGroup').text(data);
        $(".js-example-basic-multiple").val({
          placeholder: "Search User"
        });
        var html = '';
        for (i = 0; i < response.response.length; i++) {
          html += '<option' + " " + 'data-user_id=' + response.response[i].user_id + "  " + 'data-id=' + response.response[i].id + ' selected >' + " " + response.response[i].user_id + '</option>';
        }
        $('.js-example-basic-multiple').html('');
        $('.js-example-basic-multiple').append(html);
        $('.js-example-basic-multiple').val('');
        $('.select2').css('width', '500px');
      } else {
        new PNotify({
          title: 'Failed!',
          text: 'Sorry. There are no available users.',
          type: 'error',
          styling: 'fontawesome',
          hide: true,
          delay: 2000
        });
      }
    }
  });

});


$(document).delegate('#js-add-userToGroup', 'click', function(ev) {
  ev.preventDefault();
  var object = {};
  user_id = [];
  var dataArray = $('.js-example-basic-multiple').val();
  for (var i = 0; i < dataArray.length; i++) {
    var userName = dataArray[i];
    user_id.push($('.js-example-basic-multiple').find('option[data-user_id="' + userName + '"]').attr('data-id'))
  }
  object.group_id = $(this).attr('data-groupid');
  $.ajax({
    type: "POST",
    url: apiURL + "/report/EmailReport",
    data: JSON.stringify({
      "user_id": user_id,
      "group_id": $(this).attr('data-groupid')
    }),
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      getReportGroups();
      $('.js-example-basic-multiple').val('');
      $('#userDataForGroup').modal('hide');
    }
  });
});


$(document).delegate('#js-add-time_slots', 'click', function(ev) {
  ev.preventDefault();
  $.ajax({
    type: "POST",
    url: apiURL + "/settings/levels/getTimeSlots",
    data: JSON.stringify({
      "level_id": $('#js-rollertimeslots option:selected').attr('time_id'),
      "times_id": $('#js-rollertimeslots option:selected').attr('level_id')
    }),
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      rollergrillLevels();
      $('#addrollertimeslots').modal('hide');
    }
  });
});

$(document).delegate('.js-level-detatch-time_slot', 'click', function(ev) {
  ev.preventDefault();
  $('#js-level-timeslotconfirmation').modal('show');
  $('#js-delete-timeslot').attr('data-levelid', $(this).data("level-id"));
  $('#js-delete-timeslot').attr('data-timesid', $(this).data("times-id"));
  $('#js-delete-timeslot').attr('data-leveltimeid', $(this).data("level-time-id"));
});

$(document).delegate('.js-user-detatch-group', 'click', function(ev) {
  ev.preventDefault();
  $('#js-user-deleteConfirmation').modal('show');
  var data1 = "<h4><strong>" + $(this).closest('tr').find('a').attr('data-group-name') + "</strong> -Delete User</h4>";
  var data = "<h4>Are you sure, you want to delete <strong>" + $(this).attr('data-user_id') + " </strong> from this group ?</h4>"
  $('.js-deleteUserText').html(data);
  $('.js-deleteUserTextHeader').html(data1);
  $('#js-deleteGroup-user').attr('data-userid', $(this).data("email-id"));
  if ($(this).closest('tr').find('a.js-group-delete').attr('data-group-name')) {
    $('.js-deleteUserTextHeader').attr('data-groupname', $(this).closest('tr').find('a.js-group-delete').attr('data-group-name'));
  } else {
    $('.js-deleteUserTextHeader').attr('data-groupname', $('#viewUsersModalLabel').attr('data-groupname'));
    var data1 = "<h4><strong>" + $('#viewUsersModalLabel').attr('data-groupname') + "</strong> -Delete User</h4>";
    $('.js-deleteUserTextHeader').html(data1);
  }
});


$(document).delegate('#js-deleteGroup-user', 'click', function(ev) {
  ev.preventDefault();
  $.ajax({
    type: "DELETE",
    url: apiURL + "/report/EmailReport",
    data: JSON.stringify({
      "user_id": $('#js-deleteGroup-user').attr('data-userid')
    }),
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      getReportGroups();
      $('#js-user-deleteConfirmation').modal('hide');
      $.ajax({
        type: "GET",
        url: apiURL + "/report/viewUsers",
        data: {
          "group_name": $('#viewUsersModalLabel').attr('data-groupname')
        },
        contentType: "application/json; charset=utf-8",
        success: function(response) {
          var UserData = {
            report: response.response
          };
          reportUserData = UserData;
          var reportsHtml = viewAllUsersTemplate(UserData);
          $('.js-viewUsersModel').html(reportsHtml);
          $('.js-viewUser-search').val('');
        }
      });
    },
    error: function(err) {
      $('#js-user-deleteConfirmation').modal('hide');
    }
  });
});

$(document).delegate('#js-delete-timeslot', 'click', function(ev) {
  ev.preventDefault();
  $.ajax({
    type: "PUT",
    url: apiURL + "/settings/levels/getTimeSlots",
    data: JSON.stringify({
      "level_id": $('#js-delete-timeslot').attr('data-levelid'),
      "times_id": $('#js-delete-timeslot').attr('data-timesid'),
      "level_time_id": $('#js-delete-timeslot').attr('data-leveltimeid')
    }),
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      rollergrillLevels();
      $('#js-level-timeslotconfirmation').modal('hide');
    },
    error: function(err) {
      $('#js-level-timeslotconfirmation').modal('hide');
      new PNotify({
        title: 'Failed!',
        text: 'Minimum one time slot is required.',
        type: 'error',
        styling: 'fontawesome',
        hide: true,
        delay: 2000
      });
    }
  });
});


$(document).delegate('.js-level-delete', 'click', function(ev) {
  ev.preventDefault();
  $('#js-level-deleteconfirmation').modal('show');
  $('#js-delete-level').attr('data-levelid', $(this).data("level-id"));
});

$(document).delegate('.js-group-delete', 'click', function(ev) {
  ev.preventDefault();
  $('#js-group-deleteconfirmation').modal('show');
  var text1 = "<h4><strong>" + $(this).attr('data-group-name') + "</strong> -Delete Group</h4>";
  var text = "<h4>Are you sure, you want to delete <strong>" + $(this).attr('data-group-name') + " </strong> Group ?</h4>"
  $('.js-deleteGroupText').html(text);
  $('.js-deleteGroupTextHeader').html(text1);
  $('#js-delete-group').attr('data-groupid', $(this).data("group-id"));
});

$(document).delegate('#js-delete-level', 'click', function(ev) {
  ev.preventDefault();
  $.ajax({
    type: "PUT",
    url: apiURL + "/settings/level_timings",
    data: JSON.stringify({
      "level_id": $('#js-delete-level').attr('data-levelid')
    }),
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      rollergrillLevels();
      $('#js-level-deleteconfirmation').modal('hide');
    },
    error: function(response) {
      $('#js-level-deleteconfirmation').modal('hide');
      $('#js-leveldeletealert').show();
      $("#js-leveldeletealert").fadeTo(2000, 500).slideUp(500, function() {
        $("#js-leveldeletealert").hide();
      });
    }
  });
});


$(document).delegate('#js-delete-group', 'click', function(ev) {
  ev.preventDefault();
  $.ajax({
    type: "DELETE",
    url: apiURL + "/report/ReportsGetUsers",
    data: JSON.stringify({
      "group_id": $('#js-delete-group').attr('data-groupid')
    }),
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      getReportGroups();
      getEmailConfigData();
      $('#js-group-deleteconfirmation').modal('hide');
    },
    error: function(response) {
      $('#js-group-deleteconfirmation').modal('hide');
      console.log("error");
    }
  });
});

$(document).delegate('.js-settings-roller-addfactor', 'click', function(ev) {
  ev.preventDefault();
  $('#addFactor-rollerDiv').addClass('active');
  $("#addlevelFactor").val('')
});

$(document).delegate('.js-settings-addGroup', 'click', function(ev) {
  ev.preventDefault();
  $('#addFactor-reportDiv').addClass('active');
  $("#addGroupFactor").val('')
});


$(document).delegate('#js-settings-levels-enterButton', 'click', function(ev) {
  ev.preventDefault();

  if ($('#addlevelFactor').val() && $("#addlevelFactor").val() != "") {
    if ($('#addlevelFactor').val() <= 0) {
      if ($('#addlevelFactor').parent().hasClass('has-error')) {} else {
        $('#addlevelFactor').parent().addClass('has-error');
        $('#addlevelFactor').parent().append('<p class="help-block">Please enter the valid Level.</p>');
        var addlevelfactor = '';
      }
    } else {
      var addlevelfactor = $("#addlevelFactor").val();
    }
  } else {
    var addlevelfactor = '';
    if ($('#addlevelFactor').parent().hasClass('has-error')) {} else {
      $('#addlevelFactor').parent().addClass('has-error');
      $('#addlevelFactor').parent().append('<p class="help-block">Please enter the valid Level.</p>');
    }
  }
  if ($("#addlevelFactor").val() != "") {
    if (addlevelfactor) {
      var levelValue = "Level " + $("#addlevelFactor").val();
      var newfactor = '<tr id="' + levelValue + '">  <td class="mytable">' + levelValue + ' <i class="fa fa-trash pull-right"></i></td><td class="mytable">' + '  <span class="dropdown"><button class="btn btn-default btn--tag dropdown-toggle" type="button"' + 'id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true"' + 'aria-expanded="true"><i class="fa fa-plus"></i> Add timeslot </button></span></td></tr>';
      $.ajax({
        type: "POST",
        url: apiURL + "/settings/level_timings",
        data: JSON.stringify({
          "level_name": (levelValue)
        }),
        contentType: "application/json; charset=utf-8",
        success: function(response) {
          rollergrillLevels();
        },
        error: function(err) {
          new PNotify({
            title: 'Failed!',
            text: 'The level name already existed.',
            type: 'error',
            styling: 'fontawesome',
            hide: true,
            delay: 2000
          });
        }

      });
      $('#addlevelFactor').val('');
      $('#addFactor-rollerDiv').removeClass('active');
    }
  }
});

$(document).delegate('.js-level-storeProfile', 'click', function(ev) {
  ev.preventDefault();
  var store_id = $(this).data("store-id");
  var level_name = $(this).children('span').text().trim();
  $.ajax({
    type: "GET",
    url: apiURL + "/roller/levels",
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      console.log(response.response);
      var html = '';
      for (i = 0; i < response.response.length; i++) {
        console.log(response.response[i].level_name.length + "==" + level_name.length);
        if (response.response[i].level_name == level_name) {
          html += '<option' + " " + 'data-store-id=' + store_id + "  " + 'data-level_id=' + response.response[i].level_id + ' selected >' + " " + response.response[i].level_name + '</option>';
        } else {
          html += '<option' + " " + 'data-store-id=' + store_id + "  " + 'data-level_id=' + response.response[i].level_id + ' >' + " " + response.response[i].level_name + '</option>';
        }
      }
      $('#js-select-levelEdit').html(html);
    }
  });
  $('#js-select-levelModal').modal('show');
});



$(document).delegate('.js-button-editLevelRollerProfile-yes', 'click', function(ev) {
  ev.preventDefault();
  var level_id = $('#js-select-levelEdit option:selected').data("level_id");
  var store_id = $('#js-select-levelEdit option:selected').data("store-id");
  $.ajax({
    type: "PUT",
    url: apiURL + "/roller/levels",
    data: JSON.stringify({
      "level_id": level_id,
      "store_id": store_id
    }),
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      loadStoresWithProfile();
      $('#js-select-levelModal').modal('hide');
    }
  });
});

$(document).delegate('#js-addUser-stores', 'change', function(ev) {
  ev.preventDefault();
  if ($('#js-addUser-stores option:selected').val() != 0) {
    $.ajax({
      type: "GET",
      url: "/api/auth/addUser",
      data: {
        'store_id': $('#js-addUser-stores option:selected').val()
      },
      contentType: "application/json; charset=utf-8",
      success: function(response) {
        if (response.response.length > 0) {
          var html = '';
          for (var i = 0; i < response.response.length; i++) {
            html += "<option value='" + response.response[i].id + "'>" + response.response[i].name + "</option>";
          }
          $('#js-addUser-Designation').html(html);
          $('#js-addUser-Designation').prop("disabled", false);
          $('#js-addNewUser-submit').prop("disabled", false);
        } else {
          var html = '';
          new PNotify({
            title: 'Failed!',
            text: 'Sorry. There are no more roles available for the store',
            type: 'error',
            styling: 'fontawesome',
            hide: true,
            delay: 2000
          });
          $('#js-addUser-Designation').html('');
          $('#js-addUser-Designation').prop("disabled", true);
          $('#js-addNewUser-submit').prop("disabled", true);
        }
      }
    });
  }
});

$(document).delegate('#js-button-reset', 'click', function(ev) {
  $('#js-addUser-Designation').html("");
  $('#js-addUser-Designation').prop("disabled", true);
  $('#js-signup-form').find('p').remove();
  $('#js-signup-form').find('input').parent().removeClass('has-error');
});

$(document).delegate('#cost', 'blur', function(ev) {
  var num = parseFloat($(this).val());
  var cleanNum = num.toFixed(3);
  $(this).val(cleanNum);
});


$(document).delegate('#js-cancel-emailconfig', 'click', function(ev) {
  $('#js-inputUser-emailconfig').html("");
  $('.js-admin-addemailform').find('p').remove();
  $('.js-admin-addemailform').find('input').parent().removeClass('has-error');
  $('#js-inputUser-emailconfig').val("");
});

$(document).delegate('.js-adduser-email', 'click', function(ev) {

  ev.preventDefault();
  var group_id = $(this).closest('tr').attr('data-groupid');
  var groupName = $(this).closest('tr').attr('data-groupName');
  $.ajax({
    type: "GET",
    url: apiURL + "/report/getStores",
    data: {
      "group_id": group_id
    },
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      if (response.response.length > 0) {
        var html = '';
        for (i = 0; i < response.response.length; i++) {
          html += '<option' + " " + 'store_id=' + response.response[i].store + '>' + 'store -' + response.response[i].store + '</option>';
        }
        $('#js-userEmailSlots').html(html);
        $('#js-addingUserEmail').attr('data-group_id', group_id);
        $('#addUserEmails').modal('show');
        var text = "<strong>" + groupName + "</strong> - Add Store"
        $('.js-userEmailSlotsHeader').html(text);
      } else {
        new PNotify({
          title: 'Failed!',
          text: 'Sorry. There are no more stores to add.',
          type: 'error',
          styling: 'fontawesome',
          hide: true,
          delay: 2000
        });
      }
    }
  });

});


$(document).delegate('#js-addingUserEmail', 'click', function(ev) {
  ev.preventDefault();
  $.ajax({
    type: "POST",
    url: apiURL + "/report/addStores",
    data: JSON.stringify({
      "group_id": $(this).attr('data-group_id'),
      "store_id": $('#js-userEmailSlots option:selected').attr('store_id')
    }),
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      $('#addUserEmails').modal('hide');
      $('#js-date-emailconfig').val(moment().format("MMM Do YYYY"));
      getEmailConfigData();
    }
  });

});

$(document).delegate('.js-emailconfig_slot', 'click', function(ev) {
  ev.preventDefault();
  $("#js-email-deleteconfirmation").css("z-index", "1055");
  $('#js-email-deleteconfirmation').modal('show');
  var text1 = "<h4><strong>" + $(this).closest('tr').attr('data-groupname') + "</stong> -Delete Store</h4>"
  var text2 = "<h4>Are you sure, you want to delete <strong>Store " + $(this).attr('data-storeid') + "</strong> from this group?</h4>"
  $('.js-StoreDeleteFromGroupHeader').html(text1);
  $('.js-StoreDeleteFromGroup').html(text2);
  $('#js-delete-emailid').attr('data-id', $(this).data("id"));

  if ($(this).closest('tr').attr('data-groupname')) {
    $('.js-deleteUserTextHeader').attr('data-groupname', $(this).closest('tr').attr('data-groupname'));
  } else {
    $('.js-deleteUserTextHeader').attr('data-groupname', $('#viewStoresModalLabel').attr('data-groupname'));
    var text1 = "<h4><strong>" + $('#viewStoresModalLabel').attr('data-groupname') + "</stong> -Delete Store</h4>";
    $('.js-StoreDeleteFromGroupHeader').html(text1);
  }
});

$(document).delegate('#js-delete-emailid', 'click', function(ev) {
  ev.preventDefault();
  $.ajax({
    type: "DELETE",
    url: apiURL + "/report/addStores",
    data: JSON.stringify({
      "id": $(this).attr('data-id')
    }),
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      $('#js-email-deleteconfirmation').modal('hide');
      $.ajax({
        type: "GET",
        url: apiURL + "/report/viewStores",
        data: {
          "group_name": $('#viewStoresModalLabel').attr('data-groupname')
        },
        contentType: "application/json; charset=utf-8",
        success: function(response) {
          var reportStoreData = {
            report: response.response
          };
          reportData = reportStoreData;
          $('.js-store-search').val('');
          var reportsHtml = viewAllStoresTemplate(reportStoreData);
          $('.js-viewStoresModel').html(reportsHtml);
          $('#js-date-emailconfig').val(moment().format("MMM Do YYYY"));
        }
      });
      getEmailConfigData();
    }
  });
});

$(document).delegate('.js-admin-addEmail-send', 'click', function(ev) {
  ev.preventDefault();
  $(this).button('loading');
  $.ajax({
    type: "POST",
    url: apiURL + "/products/waste/SendEmail",
    data: JSON.stringify({
      "date": moment(moment($('#js-date-emailconfig').val(), 'MMM Do YYYY')).format('YYYY-MM-DD'),
      "group_name": $(this).closest('tr').attr('data-groupname')
    }),
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      $('.js-admin-addEmail-send').button('reset');
      new PNotify({
        title: 'Sent',
        text: 'Survey reports have been mailed successfully.',
        type: 'success',
        styling: 'fontawesome',
        hide: true,
        delay: 2000
      });
    }
  });
});


function getReportGroups() {
  $.ajax({
    type: "GET",
    url: apiURL + "/report/ReportsGetUsers",
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      var reportGroupData = {
        report: response.response
      };
      var reportsHtml = reportConfigTemplate(reportGroupData);
      $('.js-reportGroup-tab').html(reportsHtml);
    }
  });
}

$(document).delegate('#js-settings-reports-enterButton', 'click', function(ev) {
  ev.preventDefault();

  if ($("#addGroupFactor").val() != "") {
    var groupValue = $("#addGroupFactor").val();
    var newfactor = '<tr id="' + groupValue + '">  <td class="mytable">' + groupValue + ' <i class="fa fa-trash pull-right"></i></td><td class="mytable">' + '  <span class="dropdown"><button class="btn btn-default btn--tag dropdown-toggle" type="button"' + 'id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true"' + 'aria-expanded="true"><i class="fa fa-plus"></i> Add timeslot </button></span></td></tr>';
    $.ajax({
      type: "POST",
      url: apiURL + "/report/ReportsGetUsers",
      data: JSON.stringify({
        "group_name": (groupValue)
      }),
      contentType: "application/json; charset=utf-8",
      success: function(response) {
        getReportGroups();
        getEmailConfigData();
      },
      error: function(err) {
        new PNotify({
          title: 'Failed!',
          text: 'The group name already existed.',
          type: 'error',
          styling: 'fontawesome',
          hide: true,
          delay: 2000
        });
      }
    });
    $('#addgroupFactor').val('');
    $('#addFactor-reportDiv').removeClass('active');
  }

});


function getEmailConfigData() {
  $.ajax({
    type: "GET",
    url: apiURL + "/report/addStores",
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      var reportEmailData = {
        report: response.response
      };
      var reportsHtml = emailConfigTemplate(reportEmailData);
      $('.js-emailConfig-tab').html(reportsHtml);
    }
  });
}

$(document).delegate('#js-viewMoreStore', 'click', function(ev) {
  ev.preventDefault();
  var text = $(this).closest('tr').attr('data-groupname') + "- All Stores";
  var groupname = $(this).closest('tr').attr('data-groupname');
  $.ajax({
    type: "GET",
    url: apiURL + "/report/viewStores",
    data: {
      "group_name": groupname
    },
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      reportData = {
        report: response.response
      };
      var reportsHtml = viewAllStoresTemplate(reportData);
      $('.js-viewStoresModel').html(reportsHtml);
      $('#viewAllStores').modal('show');
      $('.js-store-search').val('');
      $('#viewStoresModalLabel').html(text);
      $('#viewStoresModalLabel').attr('data-groupname', groupname);
    }
  });
});


$(document).delegate('#js-viewMoreUsers', 'click', function(ev) {
  ev.preventDefault();
  var text = $(this).closest('tr').find('a.js-group-delete').attr('data-group-name') + "- All Users";
  var groupname = $(this).closest('tr').find('a.js-group-delete').attr('data-group-name');
  $.ajax({
    type: "GET",
    url: apiURL + "/report/viewUsers",
    data: {
      "group_name": $(this).closest('tr').find('a.js-group-delete').attr('data-group-name')
    },
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      reportUserData = {
        report: response.response
      };
      var reportsHtml = viewAllUsersTemplate(reportUserData);
      $('.js-viewUsersModel').html(reportsHtml);
      $('#viewAllUsers').modal('show');
      $('.js-viewUser-search').val('');
      $('#viewUsersModalLabel').html(text);
      $('#viewUsersModalLabel').attr('data-groupname', groupname);
    }
  });
});


$(document).delegate('#js-viewMoreWasteStore', 'click', function(ev) {
  ev.preventDefault();
  var thresholdid = $(this).closest('tr').find('a.js-factor-waste-delete').attr('data-factor-id');
  $.ajax({
    type: "GET",
    url: apiURL + "/settings/threshold",
    data: {
      "threshold_id": thresholdid
    },
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      wasteThresholdData = {
        report: response.response
      };
      var thresholdHtml = viewThresholdFactorTemplate(wasteThresholdData);
      $('.js-viewAllWasteThresholdStores').html(thresholdHtml);
      $('#viewAllWasteThresholdStores').modal('show');
      $('.js-viewWasteThreshold-search').val('');
      $('#WasteThresholdStoresModalLabel').attr('data-thresholdid', thresholdid);
    }
  });
});


$(document).delegate('#js-viewMoreBuildToStores', 'click', function(ev) {
  ev.preventDefault();
  var factorid = $(this).closest('tr').find('a.js-factor-delete').attr('data-factor-id');
  $.ajax({
    type: "GET",
    url: apiURL + "/settings/buildFactor",
    data: {
      "factor_id": factorid
    },
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      buildToStoreData = {
        report: response.response
      };
      var buildToHtml = viewBuildToFactorTemplate(buildToStoreData);
      $('.js-viewBuildToStores').html(buildToHtml);
      $('#viewAllBuildToStores').modal('show');
      $('.js-buildTo-search').val('');
      $('#buildToStoresModalLabel').attr('data-factorid', factorid);
    }
  });
});


function firstToUpperCase(str) {
  return str.substr(0, 1).toUpperCase() + str.substr(1);
}

$(document).delegate('.js-store-search', 'keyup', function(ev) {
  ev.preventDefault();
  var searchItem = firstToUpperCase($(this).val());
  var reportsHtml = viewAllStoresTemplate(reportData);
  $('.js-viewStoresModel').html(reportsHtml);
  $('.js-viewStoresModel table tr').each(function(el) {
    var rowItem = $(this).find('td button').text();
    if (rowItem.indexOf(searchItem) >= 0) {
      $(this).show();
    } else {
      $(this).hide();
    }
  });
});


$(document).delegate('.js-viewUser-search', 'keyup', function(ev) {
  ev.preventDefault();
  var searchItem = $(this).val();
  var reportsHtml = viewAllUsersTemplate(reportUserData);
  $('.js-viewUsersModel').html(reportsHtml);
  $('.js-viewUsersModel table tr').each(function(el) {
    var rowItem = $(this).find('td button').text();
    if (rowItem.indexOf(searchItem) >= 0) {
      $(this).show();
    } else {
      $(this).hide();
    }
  });
});


$(document).delegate('.js-viewWasteThreshold-search', 'keyup', function(ev) {
  ev.preventDefault();
  var searchItem = firstToUpperCase($(this).val());
  var reportsHtml = viewThresholdFactorTemplate(wasteThresholdData);
  $('.js-viewAllWasteThresholdStores').html(reportsHtml);
  $('.js-viewAllWasteThresholdStores table tr').each(function(el) {
    var rowItem = $(this).find('td button').text();
    if (rowItem.indexOf(searchItem) >= 0) {
      $(this).show();
    } else {
      $(this).hide();
    }
  });
});


$(document).delegate('.js-buildTo-search', 'keyup', function(ev) {
  ev.preventDefault();
  var searchItem = firstToUpperCase($(this).val());
  var reportsHtml = viewBuildToFactorTemplate(buildToStoreData);
  $('.js-viewBuildToStores').html(reportsHtml);
  $('.js-viewBuildToStores table tr').each(function(el) {
    var rowItem = $(this).find('td button').text();
    if (rowItem.indexOf(searchItem) >= 0) {
      $(this).show();
    } else {
      $(this).hide();
    }
  });
});

$('#js-reports-stores').on('change', function(ev) {
  ev.preventDefault();
  var Store = $('#js-reports-stores option:selected').val();
});

function getReportStores() {
  $.ajax({
    type: "GET",
    url: apiURL + "/report/reportsGetStores",
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      console.log(response.response);
      var html = "";
      for (var i = 0; i < response.response.length; i++) {
        html += "<option value='" + response.response[i].store + "'>Store" + response.response[i].store + "</option>";
      }
      $('#js-reports-stores').append(html);
    }
  });
}

function getRunReports() {
  $.ajax({
    type: "GET",
    url: apiURL + "/admin/excel/getReports",
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      for (var i=0; i< response.response.length; i++) {
        response.response[i].apiURL = apiURL+"/query/"+response.response[i].reports_id;
      }
      var runreportData = {
        runreport: response.response
      };
      var runreportsHtml = AdmrunreporttabTemplate(runreportData);
      $('.js-settings-Admrunreport').html(runreportsHtml);
    }
  });
}


$(document).delegate('#js-adm-settings-runreport', 'click', function(ev) {
  ev.preventDefault();
  var month = '';
  var Store = $('#js-reports-stores option:selected').val();
  var date = $('#js-settings-reports-date').val();
  var monthDate = date.split(' ')[0];
  var year = date.split(' ')[1];
  var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  for (var i = 0; i < months.length; i++) {
    if (months[i] == monthDate) {
      month = i + 1;
    }
  }
  var reportId = '';

  $.ajax({
    type: "POST",
    url: apiURL + "/admin/excel/reportStatus",
    data: JSON.stringify({
      "store_id": Store
    }),
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      reportId = response.response;
      getRunReports();
      $.ajax({
        type: "GET",
        url: apiURL + "/admin/excel/excelsheets",
        data: {
          "month": parseInt(month),
          "year": parseInt(year),
          "store_id": Store,
          "reportId": reportId
        },
        contentType: "application/json; charset=utf-8",
        success: function(response) {
          $.ajax({
            type: "PUT",
            url: apiURL + "/admin/excel/excelsheets",
            data: JSON.stringify({
              "reportId": reportId
            }),
            contentType: "application/json; charset=utf-8"
          });
        }
      });
      status(reportId);
    },
    error: function(xhr, err, status) {
    
      new PNotify({
        title: 'Error',
        text: 'Please Select a Store.',
        type: 'error',
        styling: 'fontawesome',
        hide: true,
        delay: 2000
      });
    }
  });
});

function status(reportId) {
  var report_id = reportId;
  setTimeout(function() {
    $.ajax({
      url: apiURL + "/admin/excel/reportStatus",
      type: "GET",
      dataType: "json",
      data: {
        "reportId": reportId
      },
      success: function(data) {
        if (data.response[0].active_flag == "false") {
          status(reportId);
        } else {
          getRunReports();
          new PNotify({
            title: 'Success!',
            text: 'Report has been generated successfully.',
            type: 'success',
            styling: 'fontawesome',
            hide: true,
            delay: 2000
          });
        }
      }
    });
  }, 8000);
}


$(document).delegate('.js-deleteRunReport', 'click', function(ev) {
  ev.preventDefault();
  var reportId = parseInt($(this).closest('td').attr('data-id'));
  var file_location = $(this).closest('td').attr('data-file_location')
  $('#js-report-detachmodal').modal('show');
  $('#js-delete_confirmation').attr('data-reportId', reportId);
  $('#js-delete_confirmation').attr('data-file_location', file_location);
});

$(document).delegate('#js-delete_confirmation', 'click', function(ev) {
  ev.preventDefault();
  $.ajax({
    url: apiURL + "/excel/deleteReports",
    type: "POST",
    data: JSON.stringify({
      "reportId": $(this).attr('data-reportId'),
      "file_name": $(this).attr('data-file_location')
    }),
    contentType: "application/json; charset=utf-8",
    success: function(data) {
      $('#js-report-detachmodal').modal('hide');
      new PNotify({
        title: 'Success!',
        text: 'Report has been deleted successfully.',
        type: 'success',
        styling: 'fontawesome',
        hide: true,
        delay: 2000
      });
      getRunReports();
    }
  });
});
