// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require moment
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require turbolinks
//= require select2-full
//= require plupload/js/moxie
//= require plupload/js/plupload.dev
//= require common
//= require bootstrap
//= require admin-lte
//= require bootstrap-datepicker/core
//= require slimScroll
//= require cytoscape
//= require three2
//= require bootstrap-treeview
//= require_tree .


$.fn.datepicker.dates['zh-cn'] = {
    days: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"],
    daysShort: ["日", "一", "二", "三", "四", "五", "六"],
    daysMin: ["日", "一", "二", "三", "四", "五", "六"],
    months: ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
    monthsShort: ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十", "十一", "十二"],
    today: "今天",
    clear: "清除",
    format: "yyyy-mm-dd",
    titleFormat: "yyyy年 MM", /* Leverages same syntax as 'format' */
    weekStart: 0
};

var initPage = function () {
    $(".modal").on("hidden.bs.modal", function() {
        $(this).removeData("bs.modal");
    });
    textToImg();
    $.fn.modal.Constructor.prototype.enforceFocus = function () { };
    $('.datepicker').datepicker({
        autoclose: true,
        language: 'zh-cn'
    });
};


// 在线预览office pdf
function show_file(e){
    var filename = $(e).attr('data-file-name');
    var url = $(e).attr('data-url');
    var ext = filename.split('.').pop().toLowerCase();
    // word ppt xls 使用微软在线编辑
    // pdf 使用
    $('#file-modal-label').text($(e).attr('data-file-name'));
    if(['docx', 'doc', 'ppt', 'pptx', 'xls', 'xlsx'].indexOf(ext) >= 0){
        $('#file-modal-body').html("<iframe src='https://view.officeapps.live.com/op/embed.aspx?src=" + url +"' width='100%' height='100%' frameborder='0'></iframe>");
    }else if(['pdf'].indexOf(ext) >= 0){
        // $('#file-modal-body').html("<iframe src='" + url + "' width='100%' height='100%' frameborder='1'>\n");
        $('#file-modal-body').html("<iframe src='/pdfjs-2.0.943-dist/web/viewer.html?file=" + url + "' width='100%' height='100%' frameborder='0' scrolling='no'></iframe>");
    }else if(['png', 'jpg', 'jepg', 'gif', 'bmp'].indexOf(ext) >= 0){
        $('#file-modal-body').html("<div style='text-align:center;'><image style='max-width:90%' src='"+ url + "'></image></div>");
    }else if(['dwg'].indexOf(ext) >= 0) {
        // $('#file-modal-body').html("<iframe src='" + url + "' width='100%' height='100%' frameborder='1'>\n");
        //window.open("https://sharecad.org/cadframe/load?url=" + url);
        //return;
        $('#file-modal-body').html("<iframe src='//sharecad.org/cadframe/load?url=" + url + "' width='100%' height='100%' frameborder='0' scrolling='no'></iframe>");
    }else{
        ext = url.split('.').pop().toLowerCase();
        if(['stl'].indexOf(ext) >= 0) {
            $('#file-modal-body').html('<iframe id="viewer" align="middle" width="1024" height="620" src="http://mo3d.mohou.com/mo3d/moview.htm?width=1024&amp;height=620&amp;id=102097&amp;file=' + url + '" frameborder="0" scrolling="no" style=""></iframe>');
            $('#share').hide();
        }else{
            alert('该文件格式暂时不支持在线预览，点击确定后直接下载文件。');
            location.href = url;
            return;
        }

    }
    $('#file-modal').modal();
}

function textToImg() {
    var fontSize = 500;
    var fontWeight = 'bold';
    var canvases = document.getElementsByClassName('canvas');
    for (var i = 0; i < canvases.length; i++) {
        var canvas = canvases[i];
        canvas.width = 1000;
        canvas.height = 1000;
        var context = canvas.getContext('2d');
        context.fillStyle = '#F7F7F9';
        context.fillRect(0, 0, canvas.width, canvas.height);
        context.fillStyle = '#605CA8';
        context.font = fontWeight + ' ' + fontSize + 'px sans-serif';
        context.textAlign = 'center';
        context.textBaseline = "middle";
        var name = $(canvas).attr('first_name');
        context.fillText(name, fontSize, fontSize);
        $(canvas).siblings('img').attr('src', canvas.toDataURL("image/png"));
    }

};



$(document).ready(initPage);
$(document).on("turbolinks:load", initPage);



function showSpinner() {
    $("#spinner").addClass("spinner");
}

function hideSpinner() {
    $("#spinner").removeClass("spinner");
}

function show_flash(type, message){
    $(".page_tips").fadeIn(function(){
        setTimeout(function(){
            $(".page_tips").fadeOut();
            $(".page_tips").html('');
        }, 3000);
    });
    $(".page_tips").append(
        '<div class="' + type +'"> <div class="inner">'+ message + '<i class="fa fa-close close-tips"></i> </div> </div>');
}
