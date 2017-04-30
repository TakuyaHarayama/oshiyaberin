// ローディングと高さと幅取得
$(document).ready(function () {
  $('#loader-bg').delay(900).fadeOut(800);
  $('#loader').delay(600).fadeOut(300);
  $('.wrap').css('display', 'block');

  var hsize = $(window).height();
  $(".wrap").css("height", hsize + "px");
  var wsize = $(window).outerWidth();
  $(".wrap").css("width", wsize + "px");
  $("#message .dis_ta").css("width", wsize + "px");
});

$(window).resize(function () {
  var hsize = $(window).height();
  $(".wrap").css("height", hsize + "px");
  var wsize = $(window).outerWidth();
  $(".wrap").css("width", wsize + "px");
  $("#message .dis_ta").css("width", wsize + "px");
});


// 三角点滅
$(function(){
  setInterval(function(){
    $('img.sankaku').fadeOut(500,function(){$(this).fadeIn(500);});
  },1000);
});


// admin時.adminをクリックしたら
$(function(){
  $('.admin').on('click',function(){
    $('#first').css('background-image', "url('/assets/chara_02.png')");
    $('.admin').css('display', 'none');
    $('.user').css('display', 'block');
  });
});

// タイプライター風
$(window).bind('load',function(){
// ここで文字を<span></span>で囲む
$('.tgt').children().andSelf().contents().each(function() {
if (this.nodeType == 3) {
$(this).replaceWith($(this).text().replace(/(\S)/g, '<span>$1</span>'));
}
});
// 一文字ずつフェードインさせる
$('.tgt').css({'opacity':1});
for (var i = 0; i <= $('.tgt').children().size(); i++) {
$('.tgt').children('span:eq('+i+')').delay(50*i).animate({'opacity':1},50);
};
});
