var stateObject = {};
$(document).ready(function() {
    $('#getStoreid').val($.cookie('user').storeid);

    $.get('/src/js/views/inspectionQuestions.hbs', function (data) {
        inspectQuestTemplate = Handlebars.compile(data);
    });

    $('.js-inspect-main-nav li').removeClass('active');
    $('.js-inspect-main-nav li a[data-step=1]').parent('li').addClass('active');
    stateObject.inspectionCategory = $('.js-inspect-main-nav li.active a').data('value');

    $('#startInspection').on('click', function(ev) {
        ev.preventDefault();
        var inspection = {};
        var allValid=true;
        inspection.store_id = $.cookie('user').storeid;
        $('.js-inspect-main-nav li').removeClass('active');
        $('.js-inspect-main-nav li a[data-step=1]').parent('li').addClass('active');
        stateObject.inspectionCategory = $('.js-inspect-main-nav li.active a').data('value');
        inspection.manager_name = $('#getManagername').val();
        if(!inspection.manager_name){
          $('#getManagername').addClass('error-whole-number');
          allValid=false;
        }
        inspection.inspector_name = $('#getInspectorName').val();
        if(!inspection.inspector_name){
          $('#getInspectorName').addClass('error-whole-number');
          allValid=false;
        }
        inspection.status = 'drafted'
        inspection.inspection_id = 0
        if(allValid){
          $.ajax({
              type: "POST",
              url: apiURL + "/inspection/start",
              data: JSON.stringify(inspection),
              contentType: "application/json; charset=utf-8",
              success: function(msg) {
                  //$.cookie('inspection', msg.response);
                  stateObject.inspectionResultId=msg.response;
                  stateObject.inspectionResult=inspection;
                  //$.cookie('user').inspection_id = msg.result;
                  //document.location.href="inspection_form-1.html"
                  $('.inspection-list').hide();
                  $('.inspection-div').hide();
                  $('.start-inspection-div').show();
                  $('.js-btn-back').hide();
                  $('.js-inspect-body').html('<div class="col-lg-offset-5 dots-loader spinner-div-style">Loading…</div>');
                  Questions();
              }
          });
        }else{
          new PNotify({
              title: 'Error',
              text: 'Please fix the data fields highlighted in red.',
              type: 'error',
              styling: 'fontawesome',
              hide:true,
              delay: 2000
          });
        }
    });

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
            //console.log(v1.score[0].score);
            stateObject.score = 0;
            $('#totalscore').text(stateObject.score);
            console.log(stateObject.score);
            var productsHtml = inspectQuestTemplate(productdata);
            //console.log(productsHtml);
            $('.js-inspect-body').html(productsHtml);
        }, function(err) {
            console.error(err);
        });
    }

    $('#js-inspection-run-report').click(function(ev) {
        ev.preventDefault();
        $('.inspection-list').hide();
        $('.inspection-div').show();
        $('.start-inspection-div').hide();
    });
});
