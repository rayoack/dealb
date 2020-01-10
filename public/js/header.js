/* Expand the search bar */
$(".btn-search").click(function(event) {
  $(this).parents(".container-menu").find('nav').hide();
  $(this).parents(".container-menu").find('.container-search').show();
  $(this).parents(".container-menu").find('.container-search').find('input[type="text"]')[0].focus();
});

$(".bar-search").click(function(event) {
  $(this).parents(".container-menu").find('nav').hide();
  $(this).parents(".container-menu").find('.container-search').show();
  $(this).parents(".container-menu").find('.container-search').find('input[type="text"]')[0].focus();
});

$(".btn-close-search").click(function(event) {
  $(this).parents(".container-menu").find('nav').show();
  $(this).parents(".container-menu").find('.container-search').hide();
});

/* Opens signin popup */
$(".btn-signup").click(function(event) {
  $(this).parents("ul").find('.popup-involved').removeClass('opened');
  $(this).parents("ul").find('.popup-investors').removeClass('opened');
  $(this).parents("ul").find('.popup-login').toggleClass('open-popup');
  $(this).parents("li").find('img').toggleClass('rotate-arrow');
  return false;
});

/* Disable sigin popup when clicks outside */
$(document).click(function(event) {
  var $target = $(event.target);
  var $popup = $('.popup-login');

  if(!$target.parents('.popup-login').length && $popup.is(':visible')) {
    $popup.removeClass('open-popup');
  }
});

/* Opens involved popup */
$(".btn-involved").click(function(event) {
  $(this).parents("ul").find('.popup-login').removeClass('open-popup');
  $(this).parents("ul").find('.popup-investors').removeClass('opened');
  $(this).parents("ul").find('.popup-involved').toggleClass('opened');
  $(this).parents("li").find('img').toggleClass('rotate-arrow');
  return false;
});

/* Opens investors popup */
$(".btn-investors").click(function(event) {
  $(this).parents("ul").find('.popup-login').removeClass('open-popup');
  $(this).parents("ul").find('.popup-involved').removeClass('opened');
  $(this).parents("ul").find('.popup-investors').toggleClass('opened');
  $(this).parents("li").find('img').toggleClass('rotate-arrow');
  return false;
});

/* Disable popups when clicks outside */
$(document).click(function(event) {
  var $target = $(event.target);
  var $involvedPopup = $('.popup-involved');
  var $investorsPopup = $('.popup-investors');

  if(!$target.parents('.popup-involved').length && $involvedPopup.is(':visible')) {
    $involvedPopup.removeClass('opened');
  }

  if(!$target.parents('.popup-investors').length && $investorsPopup.is(':visible')) {
    $investorsPopup.removeClass('opened');
  }
});
