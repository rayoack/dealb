import { loadAutoComplete } from './filters.js';
import('./header.js');
import('./swiper.js');
import('./countries.js');
import('./investors.js');

$(".container-add-your-company").hide();

$(".btn-prev-signup").click(function(event) {
  $(".container-signup").show();
  $(".container-add-your-company").hide();
});

var peop = $(".all-peoples .line-people").size();
var max = 2;
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

$(".level-filter ul li a").click(function(event) {
  $(this).parents("li").siblings().removeClass('active').end().addClass('active');
  return false;
});

$(".main-category ul li a").click(function(event) {
  $(".control-breadcrumbs .bread .one-category").empty();
  var itemBread = '<span>' + $(this).text() + '</span>';
  $(".control-breadcrumbs .bread .one-category").append(itemBread);
});

$(".sub-category ul li a").click(function(event) {
  $(".control-breadcrumbs .bread .two-category").empty();
  var itemBread = '<span>' + $(this).text() + '</span>';
  $(".control-breadcrumbs .bread .two-category").append(itemBread);
});

$(".last-sub-category ul li a").click(function(event) {
  $(".control-breadcrumbs .bread .three-category").empty();
  var itemBread = '<span>' + $(this).text() + '</span>';
  $(".control-breadcrumbs .bread .three-category").append(itemBread);
});

$(".last-level-filter ul li a").click(function(event) {
  $(".control-breadcrumbs .bread .last-category").empty();
  var itemBread = '<span>' + $(this).text() + '</span>';
  $(".control-breadcrumbs .bread .last-category").append(itemBread);
});

$(".sub-category li a").click(function(event) {
  var item_filter = '<div class="item-filter"><ul><li class="primary-nivel-filter"><button>' + $(this).text() + '</button></li><li class="second-nivel-filter"><select class="selectpicker"><option>input option 01</option><option>input option 02</option><option>input option 03</option></select></li><li class="last-nivel-filter"><input type="text" placeholder="Value"></li></ul><div class="button btn-remove-filter"><img src="/img/img-close-filter.png" alt=""></div></div>';
  if ($(this).find("i").length == 0) {
    $("#modalFilter").modal("hide");
    $(".filter-result").show();
    $(".filter-complete").append(item_filter);
    $('.selectpicker').selectpicker();
  }
  return false;
});

$(".arrow-left").click(function(event) {
  $(".filter-geral").css({
    transform: 'translateX(0px) translateY(0px)',
    transition: '.3s all'
  });
});

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


$(document).ready(function() {
  loadAutoComplete();
})

$(document).on("click", ".btn-remove-filter", function() {
  $(this).parents(".item-filter").remove();
});
