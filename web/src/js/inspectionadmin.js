var stateObject = {};
$(document).ready(function() {

    $.get('/src/js/views/inspectionTable.hbs', function (data) {
        inspectionsTemplate = Handlebars.compile(data);
    });

    $.get('/src/js/views/inspectionCompleteExpand.hbs', function (data) {
        inspectionsTemplateDetails = Handlebars.compile(data);
    });



    $('#js-user-name').text($.cookie('user').username);
    $('#js-user-role').text($.cookie('user').role);
    $('.js-inspect-table-list .dots-loader').remove();
    $('.js-inspect-table-list').append('<div class="col-lg-offset-5 dots-loader spinner-div-style">Loading…</div>');

    $('.js-inspection-details-div,#js-inspection-div').delegate('#js-back-to-inspects', 'click', function(ev) {
        ev.preventDefault();
        ev.stopPropagation();
        $('#js-inspection-div').show();
        $('.inspection-list').show();
        $('.start-inspection-div').hide();
        $('.inspection-div').hide();
        $('.inspection-list').show();
        $('.js-inspection-details-div').hide();
        $('.js-inspect-table-list').show();
    });

    $('#js-inspection-div,.js-admin-inspection-div').delegate('.js-inspection-details', 'click', function(ev) {
        ev.preventDefault();
        ev.stopPropagation();
        var inspectionId = $(ev.target).closest('tr').data('inspectionid');
        var status = $(ev.target).closest('tr').data('status');
        var comments = $(ev.target).closest('tr').data('inspectioncomments');
        var inspection={};
        inspection.id=inspectionId;
        inspection.status=status;
        inspection.inspection_overall_comments=comments;
        if(status==='completed'){
        var defered2 = $.ajax({
            type: "GET",
            url: apiURL + "/inspection/expandinspection",
            data: {
                "inspection_id": inspectionId
            },
            contentType: "application/json; charset=utf-8"
        });
        $.when(defered2).then(function(v1) {
            //inspections = [];
            var inspectionArray = _.groupBy(v1.response, function(num) {
                return num.category;
            });
            var inspections = [];
            for (var key in inspectionArray) {
                var inspection = {};
                inspection.category_name = key;
                inspection.questions = inspectionArray[key];
                inspections.push(inspection);
            }
            var lastCommentsSection = {};
            lastCommentsSection.category_name = 'Inspection Comments';
            lastCommentsSection.overallcomments = v1.response[0].inspection_overall_comments;
            inspections.push(lastCommentsSection);
            var productdata = {
                inspectionresult: v1.response[0],
                inspections: inspections
            };
            $('.js-inspect-table-list').hide();
            $('.inspection-list').hide();
            $('.inspection-div').hide();
            $('.start-inspection-div').hide();
            $('.js-inspection-details-div').show();
            var productsHtml = inspectionsTemplateDetails(productdata);
            $('.js-inspection-details-body').html(productsHtml);
            $('.js-inspection-manager').text(productdata.inspectionresult.manager_name);
            $('.js-inspection-result-score').text(productdata.inspectionresult.score);
        }, function(err) {
            console.error(err);
        });
      }else{
        //Load the Same Inspection Here Instead of the Inspection Details.
        stateObject.inspectionResultId=inspectionId;
        stateObject.inspectionResult=inspection;
        stateObject.inspectionCategory='Team Member Standards';
        Questions();
        $('.inspection-div').hide();
        $('.start-inspection-div').show();
        $('.inspection-list').hide();
        $('.js-inspection-details-div').hide();
      }
    });
});


function loadResults() {
    if ($.cookie('user').role == 'Admin' && $('#js-select-store').val() != 0) {
        var defered1 = $.ajax({
            type: "GET",
            url: apiURL + "/inspection/results",
            data: {
                "storeid": $('#js-select-store').val(),
                "from": "admin"
            },
            contentType: "application/json; charset=utf-8"
        });
    } else if ($.cookie('user').role == 'Employee') {
        var defered1 = $.ajax({
            type: "GET",
            url: apiURL + "/inspection/results",
            data: {
                "storeid": $.cookie('user').storeid,
                "from": "user"
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
            $('.js-inspect-table-list .dots-loader').remove();
            $('.js-inspection-results-body').html(productsHtml);
            if ($.cookie('user').role == 'Admin') {
                $('#js-inspection-run-report').hide();
            }
            $('.js-inspection-details-div').hide();
            $('.js-inspect-table-list').show();
        }
    }, function(err) {
        console.error(err);
    });

}
