import("./filters.js");

$(".container-add-your-company").hide();

$(".btn-prev-signup").click(function(event) {
  $(".container-signup").show();
  $(".container-add-your-company").hide();
});

/* Expand the search bar */
$(".btn-search").click(function(event) {
  $(this).parents(".container-menu").find('nav').hide();
  $(this).parents(".container-menu").find('.container-search').show();
});

$(".bar-search").click(function(event) {
  $(this).parents(".container-menu").find('nav').hide();
  $(this).parents(".container-menu").find('.container-search').show();
});

$(".btn-close-search").click(function(event) {
  $(this).parents(".container-menu").find('nav').show();
  $(this).parents(".container-menu").find('.container-search').hide();
});

/* Opens signin popup */
$(".btn-signup").click(function(event) {
  $(this).parents("ul").find('.popup-involved').removeClass('opened');
  $(this).parents("ul").find('.popup-login').toggleClass('open-popup');
  $(this).parents("li").find('img').toggleClass('rotate-arrow');
  return false;
});

/* Disable sigin popup when clicks outside */
$(document).click(function(event) {
  $target = $(event.target);
  $popup = $('.popup-login');

  if(!$target.parents('.popup-login').length && $popup.is(':visible')) {
    $popup.removeClass('open-popup');
  }
});

/* Opens involved popup */
$(".btn-involved").click(function(event) {
  $(this).parents("ul").find('.popup-login').removeClass('open-popup');
  $(this).parents("ul").find('.popup-involved').toggleClass('opened');
  $(this).parents("li").find('img').toggleClass('rotate-arrow');
  return false;
});

/* Disable involved popup when clicks outside */
$(document).click(function(event) {
  $target = $(event.target);
  $popup = $('.popup-involved');

  if(!$target.parents('.popup-involved').length && $popup.is(':visible')) {
    $popup.removeClass('opened');
  }
});

$(".btn-login-responsive").click(function(event) {
  $(this).parents(".btns-menu").find('.popup-login').toggleClass('open-popup');
});

var peop = $(".all-peoples .line-people").size();
max = 2;
$('.all-peoples .line-people:lt(' + max + ')').show();

$('.btn-show-more').click(function() {
  max = (max + 1 <= peop) ? max + 1 : peop;
  $('.all-peoples .line-people:lt(' + max + ')').fadeIn();
  //mudar quantidade maxima de exibiÃ§Ã£o
  if (max >= peop) {
    $(this).hide();
  }

  return false;
});


const menu = () => {
  const menuButton = document.getElementById('js-open-menu');

  menuButton.addEventListener('click', (e) => {
    e.preventDefault();
    document.documentElement.classList.toggle('menu-opened');
  });
};

menu();

$("#js-open-menu").click(function() {
  $(this).parents(".btns-menu").find('.menu-colapsado').slideToggle();
})

$(".btn-operator").click(function(event) {
  $(this).parents(".tag-operator").find('.container-operator').fadeToggle();
  $(".inputOccupation").val("");
});


$(".container-operator ul li").click(function(event) {
  $(".container-operator").hide();

  var inputTag = '<div class="tag"><span>' + $(this).text() + '</span><button type="button" class="btn-excluir-tag"><img src="assets/img/icone-remove-tag.svg" alt=""></button></div> ';

  $(".all-tags").show();

  $(".all-tags").append(inputTag);
});

$(".btn-add-occupation").click(function(event) {
  var inputTag = '<div class="tag"><span>' + $(".inputOccupation").val() + '</span><button type="button" class="btn-excluir-tag"><img src="assets/img/icone-remove-tag.svg" alt=""></button></div> ';

  if ($(".inputOccupation").val() != "") {
    $(".container-operator").hide();
    $(".all-tags").show();
    $(".all-tags").append(inputTag);
  } else {
    alert("Please do not leave the field empty!");
  }

});

$(document).on("click", ".btn-excluir-tag", function() {
  $(this).parents(".tag").remove();

  if ($(".tag").length == 0) {
    $(".all-tags").hide();
  }
});

$(".inputOccupation").keypress(function(e) {
  if (e.which == 13) {
    var inputTag = '<div class="tag"><span>' + $(".inputOccupation").val() + '</span><button type="button" class="btn-excluir-tag"><img src="assets/img/icone-remove-tag.svg" alt=""></button></div> ';

    if ($(".inputOccupation").val() != "") {
      $(".container-operator").hide();
      $(".all-tags").show();
      $(".all-tags").append(inputTag);
    } else {
      alert("Please do not leave the field empty!");
    }
  }
});

$('#formCreatePeople').on('keyup keypress', function(e) {
  var keyCode = e.keyCode || e.which;
  if (keyCode === 13) {
    e.preventDefault();
    return false;
  }
});


$(".btn-idioma").click(function(event) {
  $(".change-language").toggleClass('opened');
  $(".arrow-down").toggleClass('rotate');
});


$(".all-questions .item").click(function(event) {
  $(this).toggleClass('opened-answers');
});

$(function() {
  $(".datepicker").datepicker({
    dateFormat: 'dd/mm/yy',
    changeMonth: true,
    changeYear: true,
  });
});
