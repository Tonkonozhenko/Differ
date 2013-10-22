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

  var map0 = $('#map0');
  var map1 = $('#map1');
  map0.on('scroll', function () {
    map1.scrollTop($(this).scrollTop());
    map1.scrollLeft($(this).scrollLeft());
  });
  map1.on('scroll', function () {
    map0.scrollTop($(this).scrollTop());
    map0.scrollLeft($(this).scrollLeft());
  });

  $('a').on('click', function() {
    $('tr').removeClass('selected');
    var id = $(this).attr('href');
    $(id).addClass('selected');
  })
});