var stateObject = {};
$(document).ready(function() {
  surveyTabsTemplate = MyApp.templates.emp_surveyTabs;
  updateSurveyTableTemplate = MyApp.templates.inspectionTable;
  adminSurveyTableTemplate = MyApp.templates.adminSurveyTable;
  surveyCategoryTabsTemplate = MyApp.templates.surveyCategory;
  surveyQuestionsTemplate = MyApp.templates.inspectionQuestions;
  completedViewTemplate = MyApp.templates.inspectionCompleteExpand;
  $(document).delegate('#js-pcustom-start-date', 'click', function(ev) {
    $('.picker-switch').css('pointer-events', 'none');
  });
  $(document).delegate('#js-pcustom-end-date', 'click', function(ev) {
    $('.picker-switch').css('pointer-events', 'none');
  });
  if ($.cookie('user').storeid && $.cookie('user').role === "Employee" || $.cookie('user').role === "Manager") {
    getSurveyTabs();
  }
  $("#js-dropdown-button1").change(function() {
    var type = $('#js-dropdown-button1').val();
    if (type == 'Weekly') {
      var start_date = moment().startOf('week').format("LL");
      var end_date = moment().format("LL");
      $('.js-search-report-text').html('Reports from ' + start_date + ' To ' + end_date);

    } else if (type == 'Monthly') {
      var start_date = moment().startOf('month').format("LL");
      var end_date = moment().format("LL");
      $('.js-search-report-text').html('Reports from ' + start_date + ' To ' + end_date);

    } else if (type == 'Daily') {
      var start_date = moment().format("LL");
      $('.js-search-report-text').html('Reports for ' + start_date);

    } else if (type == 'All') {
      $('.js-search-report-text').html('');

    } else if (type == 'Custom') {
      $('.js-search-report-text').html('From: <input type="text" id="js-pcustom-start-date" style="height:35px" readonly="readonly"/> To: <input type="text" id="js-pcustom-end-date" style="height:35px" readonly="readonly"/>');
      var start_date = moment().startOf('custom').format("LL");
      var end_date = moment().format("LL");
      $('#js-pcustom-start-date').datetimepicker({
        format: 'MMM Do YYYY',
        ignoreReadonly: true,
        maxDate: moment()
      });
      $('#js-pcustom-end-date').datetimepicker({
        format: 'MMM Do YYYY',
        ignoreReadonly: true,
        useCurrent: false,
        maxDate: moment()
      });
    }
  });
  $(document).delegate("#js-pcustom-start-date", "dp.change", function(e) {
    $('#js-pcustom-end-date').data("DateTimePicker").minDate(e.date);
  });
  $(document).delegate("#js-pcustom-end-date", "dp.change", function(e) {
    $('#js-pcustom-start-date').data("DateTimePicker").maxDate(e.date);
  });

  $('.js-get-searchreport-by-date').on('click', function(ev) {
    ev.preventDefault();
    $('#table_id').find('tr:hidden').show();
    $('.js-get-searchreport-by-date').button('loading');
    loadReports();
  });
});


function loadReports() {
  var selection = $('#js-dropdown-button1').val();
  if (selection === 'Weekly') {
    var start_date = new Date(moment().startOf('week').format("YYYY-MM-DD"));
    var end_date = new Date(moment().format("YYYY-MM-DD"));
  } else if (selection === 'Monthly') {
    var start_date = new Date(moment().startOf('month').format("YYYY-MM-DD"));
    var end_date = new Date(moment().format("YYYY-MM-DD"));
  } else if (selection === 'Daily') {
    var start_date = new Date(moment().format("YYYY-MM-DD"));
    var end_date = new Date(moment().endOf('day'));
  } else if (selection === 'Custom') {
    var end_date = new Date(moment($('#js-pcustom-end-date').val(), 'MMM Do YYYY').format("YYYY-MM-DD"));
    var start_date = new Date(moment($('#js-pcustom-start-date').val(), 'MMM Do YYYY').format("YYYY-MM-DD"));
  }
  var surveyList_array = [];
  for (var i = 0; i < window.surveysList.length; i++) {
    var surveyDate = window.surveysList[i].survey_date
    compareDate = new Date(moment(surveyDate).format("YYYY-MM-DD"));
    var range = moment.range(start_date, end_date);
    if (range.contains(compareDate)) {
      surveyList_array.push(window.surveysList[i]);
    }
  }

  var surveyData = {};
  surveyData.surveysList = surveyList_array;
  var surveyHtml = "";
  if ($.cookie('user').role == "Admin") {
    surveyHtml = adminSurveyTableTemplate(surveyData);
  } else {
    surveyHtml = updateSurveyTableTemplate(surveyData);
  }
  $('.main--tabs').show();
  $('#survey-tabs-main').show();
  $('.inspection-div').hide();
  $('#totalScoreDiv').hide();
  $('.categories-content-div').html('');
  $('.categories-content-div').hide();
  $('#js-inspection-results-body-id').html(surveyHtml);
  $('.js-get-searchreport-by-date').button('reset');
}


$('#js-inspection-run-report').on('click mousedown touchtarget', function() {
  //console.log($(this).attr('id')+"|"+$(this).attr('surveyid'));
  stateObject.startSurveyid = $(this).attr('surveyid');
  $('#getStoreid').val($.cookie('user').storeid);
  $('.inspection-div').show();
  $('.main--tabs').hide();
});
$('#startInspection').on('click', function(e) {
  e.preventDefault();
  // console.log(stateObject.startSurveyid+"|"+
  //  $('#getManagername').val()+'|'+$('#getInspectorName').val());
  createNewSurvey();
});

function createNewSurvey() {
  var createSurveyData = {};
  createSurveyData.survey_id = parseInt(stateObject.startSurveyid);
  createSurveyData.store_id = parseInt($.cookie('user').storeid);
  createSurveyData.manager_name = $('#getManagername').val();
  createSurveyData.inspector_name = $('#getInspectorName').val();
  if (createSurveyData.manager_name.length > 0 && createSurveyData.inspector_name.length > 0) {
    $.ajax({
      type: "POST",
      url: apiURL + "/survey/createNewSurvey",
      data: JSON.stringify(createSurveyData),
      contentType: "application/json; charset=utf-8",
      success: function(response) {
        $('.inspection-div').hide();
        surveyCategoriesTabs(response.response, 'drafted');
      }
    });
  } else {
    new PNotify({
      title: 'Failed!',
      text: 'Please fill Manager and Inspector Name.',
      type: 'error',
      styling: 'fontawesome',
      hide: true,
      delay: 2000
    });
  }
  // $('#getManagername').val("");
  // $('#getInspectorName').val("");
}

function getSurveyTabs() {
  var storeid;
  if ($.cookie('user').role == 'Admin') {
    storeid = $('#js-select-store').val();
  } else {
    storeid = $.cookie('user').storeid;
  }

  var defered1 = $.ajax({
    type: "GET",
    url: apiURL + "/survey/surveyNames",
    data: {
      "store_id": storeid
    },
    contentType: "application/json; charset=utf-8"
  });

  $.when(defered1).then(function(v1) {
    //console.log(v1.response);
    var surveysData = {
      surveyList: v1.response
    };
    var surveysHtml = surveyTabsTemplate(surveysData);
    //console.log(surveysHtml);
    $('#survey-tabs-main').html(surveysHtml);

    for (var i = 0; i < surveysData.surveyList.length; i++) {
      //console.log(surveysData.surveyList[i].surveyId);
      $('#tabId_' + surveysData.surveyList[i].surveyId).parent().removeClass('active');
      if (surveysData.surveyList[i].surveyName === 'Inspection') {
        $('#js-survey-title').text("Health Inspection: Think food safety");
      }
    }
    if (stateObject.currentSurveyId) {
      $('#tabId_' + stateObject.currentSurveyId).parent().addClass('active');

      updateSurvey(stateObject.currentSurveyId, stateObject.currentSurveyName);
    } else {
      $('#tabId_' + surveysData.surveyList[0].surveyId).parent().addClass('active');

      updateSurvey(surveysData.surveyList[0].surveyId, surveysData.surveyList[0].surveyName);
    }


  }, function(err) {
    console.error(err);
  });

}

function updateSurvey(surveyid, surveyName) {
  $('.js-search-report-text').html('');
  $('#js-dropdown-button1').val('Monthly');
  stateObject.currentSurveyId = surveyid;
  stateObject.currentSurveyName = surveyName;
  //	console.log(surveyid+"|"+surveyName);
  var storeid;
  if ($.cookie('user').role == 'Admin') {
    storeid = $('#js-select-store').val();
  } else {
    storeid = $.cookie('user').storeid;
  }

  var defered1 = $.ajax({
    type: "GET",
    url: apiURL + "/survey/getSurveyTable",
    contentType: "application/json; charset=utf-8",
    data: {
      'survey_id': surveyid,
      'store_id': storeid
    }
  });
  //Check this logic once
  if (surveyName === 'Inspection') {
    $('#js-survey-title').text("Health Inspection: Think food safety");
    $('#js-survey-title').show();
  } else {
    $('#js-survey-title').hide();
  }

  $.when(defered1).then(function(v1) {
    //console.log(v1);
    window.surveysList = v1.response;
    // need to maintain monthly as default
    var surveyList_array = [];
    if ($.cookie('user').role == 'Admin') {
      var start_date = new Date(moment().startOf('month').format("YYYY-MM-DD"));
      var end_date = new Date(moment().format("YYYY-MM-DD"));
      for (var i = 0; i < window.surveysList.length; i++) {
        var surveyDate = window.surveysList[i].survey_date
        compareDate = new Date(moment(surveyDate).format("YYYY-MM-DD"));
        var range = moment.range(start_date, end_date);
        if (range.contains(compareDate)) {
          surveyList_array.push(window.surveysList[i]);
        }
      }
    } else {
      for (var i = 0; i < window.surveysList.length; i++) {
        surveyList_array.push(window.surveysList[i]);
      }
    }
    var surveyHtml = "";
    var surveyData = {};
    surveyData.surveysList = surveyList_array;
    if ($.cookie('user').role == "Admin") {
      surveyHtml = adminSurveyTableTemplate(surveyData);
    } else {
      surveyHtml = updateSurveyTableTemplate(surveyData);
    }
    $('.main--tabs').show();
    $('#survey-tabs-main').show();
    $('.inspection-div').hide();
    $('#totalScoreDiv').hide();
    $('.categories-content-div').html('');
    $('.categories-content-div').hide();
    $('#js-inspection-results-body-id').html(surveyHtml);
    $('#js-inspection-run-report').attr('surveyid', surveyid);
    $('#js-inspection-run-report').html("Start New " + surveyName);
    //window.performanceRows = $("#table_id tr");
    $('#getManagername').val("");
    $('#getInspectorName').val("");

  }, function(err) {
    console.error(err);
  });

}

function surveyCategoriesTabs(survey_result_id, status, total_score) {
  //console.log(status);
  stateObject.survey_result_id = survey_result_id;
  if (status == "drafted") {
    var defered1 = $.ajax({
      type: "GET",
      url: apiURL + "/survey/getCategories",
      contentType: "application/json; charset=utf-8",
      data: {
        'survey_result_id': stateObject.survey_result_id
      }
    });


    $.when(defered1).then(function(v1) {
      //console.log(v1.response);
      var categoryData = {
        tabsData: v1.response
      };
      stateObject.categoryIds = [];
      for (var i = 0; i < v1.response.length; i++) {
        stateObject.categoryIds.push(v1.response[i].category_id);
      }

      //console.log(stateObject.categoryIds);
      var categoryHtml = surveyCategoryTabsTemplate(categoryData);
      //console.log(categoryHtml);
      //console.log(categoryData.tabsData);

      $('.main--tabs').hide();
      //$('#survey-tabs-main').hide();
      //$('#backtoSurveys').show();
      $('#totalScoreDiv').show();
      $('.categories-content-div').show();
      $('.categories-content-div').html(categoryHtml);
      $('#survey-category-tabs').scrollTabs({
        left_arrow_size: 45,
        right_arrow_size: 45
      });
      $("#totalScoreDiv").html('<p>Total Score :  <span id="js-survey-totalScore"></span>/<span id="js-survey-TotalSurveyScore"></p>');
      updateCategoryQuestions(categoryData.tabsData[0].category_id, survey_result_id);
      stateObject.currentCategoryId = 0;

    }, function(err) {
      console.error(err);
    });
  } else {
    var defered1 = $.ajax({
      type: "GET",
      url: apiURL + "/survey/getCompletedQuestions",
      contentType: "application/json; charset=utf-8",
      data: {
        'survey_result_id': stateObject.survey_result_id
      }
    });


    $.when(defered1).then(function(v1) {
      var categoryData = {
        questionsData: v1.response
      };
      var categoryHtml = completedViewTemplate(categoryData);
      //console.log(categoryHtml);
      $('.main--tabs').hide();
      $('#survey-tabs-main').hide();
      $('#backtoSurveys').show();
      $('.js-inspect-table-list').hide();
      $('.categories-content-div').show();
      var htm = "";
      //console.log(categoryData.questionsData[0].questions[0].overallComments);
      htm += "<h4> Overall Comments : " + categoryData.questionsData[0].questions[0].overallComments + "</h4></br>";
      htm += "<h4> Total Score : " + categoryData.questionsData[0].questions[0].total_score + "</h4>";
      if (htm == "") {
        $('.categories-content-div').html(categoryHtml);
      } else {
        $('.categories-content-div').html(htm + categoryHtml);
      }

      $('#backtoSurveys').show();
    }, function(err) {
      console.error(err);
    });
  }
}

function updateCategoryQuestions(category_id, survey_result_id) {
  // if (stateObject.isLastIsComments) {
  //   //Coming from Tab which is Commnets.
  //   var overallComments = $('#js-inspection-text-area-comments').val();
  //   $.ajax({
  //     type: "POST",
  //     url: apiURL + "/survey/completedSurvey",
  //     data: JSON.stringify({
  //       "status": 'drafted',
  //       "survey_overall_comments": overallComments,
  //       "survey_result_id": stateObject.survey_result_id
  //     }),
  //     contentType: "application/json; charset=utf-8",
  //     success: function(response) {}
  //   });
  // }
  // stateObject.isLastIsComments = false;
  saveSurveyAnswers(function() {
    var defered1 = $.ajax({
      type: "GET",
      url: apiURL + "/survey/getQuestions",
      contentType: "application/json; charset=utf-8",
      data: {
        'category_id': category_id,
        'survey_result_id': stateObject.survey_result_id
      }
    });

    $.when(defered1).then(function(v1) {
      var categoryData = {
        categoryQuestions: v1.response
      };

      if (!v1.surveyScore[0].total_score) {
        var totalScore = 0;
      } else {
        var totalScore = v1.surveyScore[0].total_score;
      }

      if (!v1.surveyScore[0].TotalSurveyScore) {
        var TotalSurveyScore = 0;
      } else {
        var TotalSurveyScore = v1.surveyScore[0].TotalSurveyScore;
      }
      $('#js-survey-totalScore').text(totalScore);
      $('#js-survey-TotalSurveyScore').text(TotalSurveyScore);
      $('#survey-category-content').show();
      $('#survey-comments-content').hide();
      $('#survey-category-content').html(surveyQuestionsTemplate(categoryData));
      stateObject.currentCategoryId = category_id;

      for (var i = 0; i < stateObject.categoryIds.length; i++) {
        $('#ctabId_' + stateObject.categoryIds[i]).parent().removeClass('active').removeClass('tab_selected');
      }
      $('#tabId_commentsTab').parent().removeClass('active').removeClass('tab_selected');
      $('#ctabId_' + category_id).parent().addClass('active').addClass('tab_selected');
      if (stateObject.currentCategoryId == stateObject.categoryIds[0]) {
        $('.js-btn-back-cQuestions').hide();
      } else {
        $('.js-btn-back-cQuestions').show();
      }
      addBtnEvents();
      $('.js-inspect-row').delegate('.js-inspection-text-area-comments', 'blur', function(ev) {
        console.log('.js-inspect-row called');
        if ($(this).val().length > 0) {
          $(this).parent().parent().prev().find('.qcard--notes').find('button').addClass('btn-success').removeClass('btn-default');
          $('.js-inspect-body .collapse').removeClass('in');
        } else {
          $(this).parent().parent().prev().find('.qcard--notes').find('button').removeClass('btn-success').addClass('btn-default');
          $('.js-inspect-body .collapse').removeClass('in');
        }
      });
      $(document).delegate('.js-inspect-row', 'click', function(ev) {
        if (!$(ev.target).is('textarea') && !$(ev.target).is('button')) {
          $('.js-inspect-row .collapse').removeClass('in');
        }
      });

      $('.js-inspect-row').delegate('.js-switch-box', 'click', function(ev) {

        if ($(ev.target).prop('checked')) {
          var newScore = parseInt($('#js-survey-totalScore').text()) + $(ev.target).data('question-score');
          $(this).parent().next().text($(ev.target).data('question-score'))
        } else {

          var newScore = parseInt($('#js-survey-totalScore').text()) - $(ev.target).data('question-score');
          $(this).parent().next().text('');
        }
        $('#js-survey-totalScore').text(newScore);
      });

    }, function(err) {
      console.error(err);
    });

  });

}

function addBtnEvents() {
  $('.js-btn-next-cQuestions').on('click', function() {
    //console.log(stateObject.categoryIds.indexOf(stateObject.currentCategoryId)<stateObject.categoryIds.length);
    //saveSurveyAnswers();
    if (stateObject.categoryIds.indexOf(stateObject.currentCategoryId) < stateObject.categoryIds.length - 1) {
      var nextCatId = stateObject.categoryIds.indexOf(stateObject.currentCategoryId);
      nextCatId++;
      updateCategoryQuestions(stateObject.categoryIds[nextCatId], stateObject.survey_result_id);
      if (nextCatId > 1) {
        $('.scroll_tab_right_button').trigger('mousedown');
        $('.scroll_tab_right_button').trigger('mouseup');
      }
    } else {
      commentsTab();
    }


  });
  $('.js-btn-back-cQuestions').on('click', function() {
    if (stateObject.categoryIds.indexOf(stateObject.currentCategoryId) > 0 && stateObject.categoryIds.indexOf(stateObject.currentCategoryId) < stateObject.categoryIds.length) {
      var prevCatId = stateObject.categoryIds.indexOf(stateObject.currentCategoryId);
      prevCatId--;
      updateCategoryQuestions(stateObject.categoryIds[prevCatId], stateObject.survey_result_id);
      $('.scroll_tab_left_button').trigger('mousedown');
      $('.scroll_tab_left_button').trigger('mouseup');

    }
  });

}

function commentsTab() {
  stateObject.isLastIsComments = true;
  saveSurveyAnswers(function() {
    $('#survey-category-content').hide();
    $('#survey-comments-content').show();

    var htm = "";
    htm += '<div class="collapse in" id="commentsText" aria-expanded="true" style="">';
    htm += '  <div class="well">';
    htm += '    <textarea class="form-control " id="js-inspection-text-area-comments" rows="4" placeholder="comment here"></textarea>';
    htm += '  </div>';
    htm += '</div>';
    htm += '<div class="row">';
    htm += '    <div class="col-md-2 col-md-offset-6">';
    htm += '      <button class="btn btn--reports btn-block js-btn-back-commentTab">Back</button>';
    htm += '     </div>';
    htm += '    <div class="col-md-2 ">';
    htm += '    <button class="btn btn--action btn-block js-btn-save-commentTab">Save</button>';
    htm += '    </div>';
    htm += '    <div class="col-md-2 ">';
    htm += '    <button class="btn btn--action btn-block js-btn-complete-commentTab">Complete</button>';
    htm += '    </div>';
    htm += '</div>';
    $('#survey-comments-content').html(htm);
    $.ajax({
      type: "GET",
      url: apiURL + "/survey/getOverallComments",
      data: {
        "survey_result_id": stateObject.survey_result_id
      },
      contentType: "application/json; charset=utf-8",
      success: function(response) {
        $('#js-inspection-text-area-comments').val(response.response[0].survey_overall_comments);

      }
    });


    for (var i = 0; i < stateObject.categoryIds.length; i++) {
      $('#ctabId_' + stateObject.categoryIds[i]).parent().removeClass('active').removeClass('tab_selected');
    }
    $('#tabId_commentsTab').parent().addClass('active').addClass('tab_selected');
    $(".js-btn-back-commentTab").on('click', function() {
      //console.log("commentsTab back clicked");
      //stateObject.categoryIds[stateObject.categoryIds.length-1]
      //stateObject.currentCategoryId
      var overallComments = $('#js-inspection-text-area-comments').val();
      console.log("commentsTab back clicked" + overallComments);
      $.ajax({
        type: "POST",
        url: apiURL + "/survey/completedSurvey",
        data: JSON.stringify({
          "status": 'drafted',
          "survey_overall_comments": overallComments,
          "survey_result_id": stateObject.survey_result_id
        }),
        contentType: "application/json; charset=utf-8",
        success: function(response) {
          console.log("saveSurveyAnswers success");
        }
      });
      updateCategoryQuestions(stateObject.categoryIds[stateObject.categoryIds.length - 1], stateObject.survey_result_id);
    });
    $(".js-btn-save-commentTab").on('click', function() {
      $('.js-btn-save-commentTab').button('loading');
      var overallComments = $('#js-inspection-text-area-comments').val();
      console.log("commentsTab back clicked" + overallComments);
      $.ajax({
        type: "POST",
        url: apiURL + "/survey/completedSurvey",
        data: JSON.stringify({
          "status": 'drafted',
          "survey_overall_comments": overallComments,
          "survey_result_id": stateObject.survey_result_id
        }),
        contentType: "application/json; charset=utf-8",
        success: function(response) {
          console.log("saveSurveyAnswers success");
          new PNotify({
            title: 'Success!',
            text: 'Survey saved but not completed.',
            type: 'success',
            styling: 'fontawesome',
            hide: true,
            delay: 2000
          });
        }
      });
      getSurveyTabs();
      $('#totalScoreDiv').hide();
    });

    $(".js-btn-complete-commentTab").on('click', function() {
      //console.log("commentsTab back clicked");
      $('#survey-comment').modal('show');
    });

    $('#js-complete-surveyComment').unbind().click(function(ev) {
      ev.preventDefault();
      var overallComments = $("#js-inspection-text-area-comments").val();
      $.ajax({
        type: "POST",
        url: apiURL + "/survey/completedSurvey",
        data: JSON.stringify({
          "status": 'completed',
          "survey_overall_comments": overallComments,
          "survey_result_id": stateObject.survey_result_id
        }),
        contentType: "application/json; charset=utf-8",
        success: function(response) {
          console.log("saveSurveyAnswers success");
          new PNotify({
            title: 'Success!',
            text: 'Survey has been completed successfully.',
            type: 'success',
            styling: 'fontawesome',
            hide: true,
            delay: 2000
          });
          $('#survey-comment').modal('hide');
        }
      });
      getSurveyTabs();
      $('#totalScoreDiv').hide();
    });
  });
}

function saveSurveyAnswers(callback) {
  var questions = [];

  $('.qcard').each(function(index) {
    var questionsData = {};
    questionsData.survey_question_id = parseInt($(this).find('.qcard--q').attr('data-question-id'));
    questionsData.question_answer_comments = $(this).find('.js-inspection-text-area-comments').val();
    questionsData.survey_result_id = stateObject.survey_result_id;

    if ($(this).find('.js-switch-box').is(':checked'))
      questionsData.question_answer_score = parseInt($(this).find('.js-switch-box').attr('data-question-score'));
    else
      questionsData.question_answer_score = 0;

    if ($(this).find('.js-switch-box').attr('data-question-answer-id') == "")
      questionsData.question_answer_id = 0;
    else
      questionsData.question_answer_id = parseInt($(this).find('.js-switch-box').attr('data-question-answer-id'));
    if ($(this).find('.js-question-extra-info').length > 0) {
      questionsData.question_extra_info = $(this).find('.js-question-extra-info').val();
    } else {
      questionsData.question_extra_info = '';
    }
    questionsData.total_survey_score = parseInt($('#js-survey-totalScore').text());
    questions.push(questionsData);

  });
  // var overallComments = $("#js-inspection-text-area-comments").val();
  // if(overallComments && stateObject.survey_result_id){
  //   $.ajax({
  //     type: "POST",
  //     url: apiURL + "/survey/completedSurvey",
  //     data: JSON.stringify({
  //       "status": 'drafted',
  //       "survey_overall_comments": overallComments,
  //       "survey_result_id": stateObject.survey_result_id
  //     }),
  //     contentType: "application/json; charset=utf-8",
  //     success: function(response) {
  //       console.log("saveSurveyAnswers success");
  //       $('#survey-comment').modal('hide');
  //     }
  //   });
  // }
  //console.log(questions);
  $.ajax({
    type: "POST",
    url: apiURL + "/survey/saveSurveyAnswers",
    data: JSON.stringify(questions),
    contentType: "application/json; charset=utf-8",
    success: function(response) {
      callback();
    },
    error: function() {
      callback();
    }
  });


}

function backtoSurveys() {
  $('.main--tabs').show();
  $('.js-inspect-table-list').show();
  $('.categories-content-div').hide();
  $('#backtoSurveys').hide();
  $('#survey-tabs-main').show();
}
