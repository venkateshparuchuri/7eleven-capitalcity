var stateObject = {};
$(document).ready(function() {
    
    $.get('/src/js/views/inspectionQuestions.hbs', function (data) {
        inspectQuestTemplate = Handlebars.compile(data);
    });

    stateObject.score = 0;
    //GetInspectionScore();
    stateObject.inspectionCategory = $('.js-inspect-main-nav li.active a').data('value');
    $('.js-inspect-body').delegate('.js-switch-box', 'click', function(ev) {
        if ($(ev.target).prop('checked')) {
            stateObject.score = stateObject.score + $(ev.target).data('question-score');
            $(this).parent().next().text($(ev.target).data('question-score'));
        } else {
            stateObject.score = stateObject.score - $(ev.target).data('question-score');
            $(this).parent().next().text('');
        }
        $('#totalscore').text(stateObject.score);
    });

    $('.js-inspect-main-nav li').click(function(ev) {
        ev.preventDefault();
        $('.js-inspect-main-nav li').removeClass('active');
        $(ev.target).closest('li').addClass('active');
        stateObject.inspectionCategory = $(ev.target).closest('li').find('a').data('value');
        $('.js-inspect-body').html('<div class="col-lg-offset-5 dots-loader spinner-div-style">Loading…</div>');
        if ($('.js-inspect-main-nav li.active').find('a').data('step') == 1) {
            $('.js-btn-back').hide();
            $('.js-btn-next').text("Next");
            $('.js-btn-next').removeClass('js-complete-inspection');
        } else if ($('.js-inspect-main-nav li.active').find('a').data('step') == 10) {
            $('.js-btn-save').show();
        } else {
            $('.js-btn-save').hide();
            $('.js-btn-next').text("Next");
            $('.js-btn-next').removeClass('js-complete-inspection');
            $('.js-btn-back').show();
        }
        if (stateObject.inspectionCategory === 'Inspection-Comments') {
            var comments=(stateObject.inspectionResult.inspection_overall_comments)?stateObject.inspectionResult.inspection_overall_comments:'';
            $('.js-inspect-body').html("<div class='well col-md-7' rows='8'><textarea class='form-control' rows='8' id='inspectionfinish' placeholder='Enter the overall Inspection Comments here.'>" + comments + "</textarea></div>");
            $('.js-btn-next').text("Complete");
            $('.js-btn-next').addClass('js-complete-inspection');
        } else {
            Questions();
        }
    });
    $('.js-btn-save').click(function(ev) {
        ev.preventDefault();
        saveInspectionResult('drafted', true);
        $('.js-btn-save').hide();
        $('.js-btn-next').text("Next");
        $('.js-btn-back').show();
    });
    $('.js-btn-next').click(function(ev) {
        ev.preventDefault();
        console.log($('.js-inspect-main-nav li.active').index());
        var nextElement = $('.js-inspect-main-nav li.active').next();
        $('.js-inspect-main-nav li.active').removeClass('active');
        nextElement.addClass('active');
        if ($('.js-inspect-main-nav li.active').find('a').data('step') == 1) {
            $('.js-btn-back').hide();
        } else if ($('.js-inspect-main-nav li.active').find('a').data('step') == 10) {
            $('.js-btn-save').show();
        } else {
            $('.js-btn-next').text("Next");
            $('.js-btn-next').removeClass('js-complete-inspection');
            $('.js-btn-back').show();
        }
        stateObject.inspectionCategory = $('.js-inspect-main-nav li.active a').data('value');
        if (stateObject.inspectionCategory === 'Inspection-Comments') {
            saveAnswers();
            if (stateObject.inspectionResult.inspection_overall_comments) {
                $('.js-inspect-body').html("<div class='well col-md-7' rows='8'><textarea class='form-control' rows='8' id='inspectionfinish' placeholder='Enter the overall Inspection Comments here.'>" + stateObject.inspectionResult.inspection_overall_comments + "</textarea></div>");
            } else {
                $('.js-inspect-body').html("<div class='well col-md-7' rows='8'><textarea class='form-control' rows='8' id='inspectionfinish' placeholder='Enter the overall Inspection Comments here.'></textarea></div>");
            }
            $('.js-btn-next').text("Complete");
            $('.js-btn-next').addClass('js-complete-inspection');
        } else if ($(ev.target).hasClass('js-complete-inspection') || $('.js-inspect-main-nav li.active').length === 0) {
            saveInspectionResult('completed', true);
        } else {
            saveAnswers();
            saveInspectionResult('drafted', false);
            $('.js-inspect-body').html('<div class="col-lg-offset-5 dots-loader spinner-div-style">Loading…</div>');
            Questions();
        }
    });

    $('.js-btn-back').click(function(ev) {
        ev.preventDefault();
        var currentIndex = $('.js-inspect-main-nav li.active').index();
        if (currentIndex == 0) {
            var prevIndex = currentIndex;
        } else {
            var prevIndex = (currentIndex - 1);
        }
        liElementsList = $('.js-inspect-main-nav li');
        var prevElement = liElementsList[prevIndex];
        console.log(prevElement);
        $('.js-inspect-main-nav li.active').removeClass('active');
        $(prevElement).addClass('active');
        if ($(prevElement).find('a').data('step') === 1) {
            $('.js-btn-back').hide();
        } else if ($('.js-inspect-main-nav li.active').find('a').data('step') == 7) {
            $('.js-btn-save').show();
        } else {
            $('.js-btn-save').hide();
            $('.js-btn-next').text("Next");
            $('.js-btn-back').show();
        }
        stateObject.inspectionCategory = $('.js-inspect-main-nav li.active a').data('value');
        $('.js-inspect-body').html('<div class="col-lg-offset-5 dots-loader spinner-div-style">Loading…</div>');
        Questions();
    });

    $(document).delegate('.js-inspect-body','click',function(ev){
        if(!$(ev.target).is('textarea') && !$(ev.target).is('button')){
          $('.js-inspect-body .collapse').removeClass('in');
        }
    });

    $('.js-inspect-body').delegate('.js-inspection-text-area-comments','blur',function(ev){
      if($(this).val().length>0){
        $(this).parent().parent().prev().find('.qcard--notes').find('button').addClass('btn-success').removeClass('btn-default');
        $('.js-inspect-body .collapse').removeClass('in');
      }else{
        $(this).parent().parent().prev().find('.qcard--notes').find('button').removeClass('btn-success').addClass('btn-default');
        $('.js-inspect-body .collapse').removeClass('in');
      }
    })

});

function loadResults() {
    var defered1 = $.ajax({
        type: "GET",
        url: apiURL + "/inspection/results",
        data: {
            "storeid": $.cookie('user').storeid
        },
        contentType: "application/json; charset=utf-8"
    });


    $.when(defered1).then(function(v1) {
        var productdata = {
            inspections: v1.response
        };
        var productsHtml = inspectionsTemplate(productdata);
        $('.js-inspection-results-body').html(productsHtml);
        $('.dots-loader').remove();
    }, function(err) {
        console.error(err);
    });

}

function Questions() {
    var defered1 = $.ajax({
        type: "GET",
        url: apiURL + "/inspection/questions",
        data: {
            "category_name": stateObject.inspectionCategory,
            "Inspection_result_id": stateObject.inspectionResultId
        },
        contentType: "application/json; charset=utf-8"
    });

    $.when(defered1).then(function(v1) {
        var productdata = {
            products: v1.response
        };
        stateObject.score = v1.score[0].score;
        $('#totalscore').text(stateObject.score);
        var productsHtml = inspectQuestTemplate(productdata);
        //console.log(productsHtml);
        $('.js-inspect-body').html(productsHtml);
        if(stateObject.inspectionCategory === 'Team Member Standards'){
            $('.js-btn-save').hide();
            $('.js-btn-next').text("Next");
            $('.js-btn-back').hide();
        }
        $('.js-inspect-main-nav li').removeClass('active');
        $('.js-inspect-main-nav li').find('a[data-value="' + stateObject.inspectionCategory + '"]').parent('li').addClass('active');
    }, function(err) {
        console.error(err);
    });
}

function saveAnswers() {
    var inspectionAnswers = [];
    $('.js-inspect-body').find('.js-inspect-row').each(function(index, el) {
        var inspect = {};
        inspect.Inspection_result_id = stateObject.inspectionResultId;
        inspect.question_id = $(el).find('.qcard--q').data('question-id');
        inspect.comments = $(el).find('textarea').val();
        //if ($(el).find('input').prop('checked') || $(el).find('input').data('question-answer-id')>0) {
            if($(el).find('input').prop('checked')){
              inspect.result_score = $(el).find('input').data('question-score');
            }else{
              inspect.result_score = 0;
            }
            var answerId = $(el).find('input').data('question-answer-id');
            if (answerId) {
                inspect.question_answer_id = answerId;
            } else {
                inspect.question_answer_id = 0;
            }
            inspect.total_score = stateObject.score;
        //} else {
          //  inspect.question_answer_id = 0;
        //}
        inspectionAnswers.push(inspect);
    });
    $.ajax({
        type: "POST",
        url: apiURL + "/inspection/saveanswers",
        data: JSON.stringify(inspectionAnswers),
        contentType: "application/json; charset=utf-8",
        success: function(response) {

        }
    });
}


function saveInspectionResult(value, loadResultsFlag) {
    var comments_inspection = $('#inspectionfinish').val();
    var sendobj = {}
    sendobj.inspection_id = stateObject.inspectionResultId;
    sendobj.score = stateObject.score;
    sendobj.comments = comments_inspection ? comments_inspection : '';
    sendobj.status = value;
    $.ajax({
        type: "POST",
        url: apiURL + "/inspection/start",
        data: JSON.stringify(sendobj),
        contentType: "application/json; charset=utf-8",
        success: function(response) {
            if (loadResultsFlag) {
                $('.inspection-list').show();
                $('.js-inspection-results-body').html('<div class="col-lg-offset-5 dots-loader spinner-div-style">Loading…</div>');
                $('.inspection-div').hide();
                $('.start-inspection-div').hide();
                new PNotify({
                    title: 'Success!',
                    text: 'Inspection has been reported successfully.',
                    type: 'success',
                    styling: 'fontawesome',
                    hide:true,
                    delay: 2000
                });
                loadResults();
            }
        }
    });
}
