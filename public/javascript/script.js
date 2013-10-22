$(document).ready(function(){
  var c0 = $('#c0');
  var c1 = $('#c1');
  c0.on('scroll', function () {
    c1.scrollTop($(this).scrollTop());
    c1.scrollLeft($(this).scrollLeft());
  });
  c1.on('scroll', function () {
    c0.scrollTop($(this).scrollTop());
    c0.scrollLeft($(this).scrollLeft());
  });
});