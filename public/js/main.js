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

function hideLastLevelFilters() { $('.last-level-filter li a').hide(); }
function showLastLevelFilters() { $('.last-level-filter li a').show(); }

function renderLastLevelFilters(clickedElement) {
  const type = clickedElement.data().type;

  if (type === 'select') {
    /* Shows only the equals option */
    hideLastLevelFilters();
    $('.last-level-filter li a[data-type="equal"]').show();
  } else if (['text', 'text-completion'].includes(type)) {
    /* Shows only equals & contains options */
    hideLastLevelFilters();
    $('.last-level-filter li a[data-type="equal"]').show();
    $('.last-level-filter li a[data-type="contains"]').show();
  } else if (['number'].includes(type)) {
    /* Hide only contains option */
    showLastLevelFilters();
    $('.last-level-filter li a[data-type="contains"]').hide();
  }
}

function renderFilterInputs(index, subcategory, subcategoryType, type, category) {
  let inputs = '';

  inputs += '<input type="hidden" name="filter[' + index + '][type]" value="' + subcategory + '" />';
  inputs += '<input type="hidden" name="filter[' + index + '][operator]" value="' + type + '" />';

  if (['text', 'number'].includes(subcategoryType)) {
    /* Allow free texting */
    inputs += '<input type="text" name="filter[' + index + '][value]" data-category="' + category + '" ' +
                     'data-subcategory="' + subcategory + '_input" data-type="' + type + '" />';
  } else {
    /* Adds i18n to it */
    inputs += '<input type="hidden" name="filter[' + index + '][value]" data-category="' + category + '" ' +
                     'data-subcategory="' + subcategory + '_input" data-type="' + type + '" />';
    inputs += '<input type="text" data-category="' + category + '" data-subcategory="' + subcategory + '" ' +
                     'data-type="' + type + '"/>';
  }

  return inputs;
}

$(".last-sub-category li a").click(function(event) {
  showLastLevelFilters();

  if ($(this).find("i").length > 0) {
    $(".filter-geral").css({
      transform: 'translateX(-199px) translateY(0px)',
      transition: '.3s all'
    });
    $(".controls .arrow-left").removeClass('disabled');
  }

  renderLastLevelFilters($(this));
});

$(document).ready(function() {
  function autoComplete(input) {
    var subcategory = input.data()['subcategory'];
    var cache = {};

    input.autocomplete({
      minLength: 0,
      source: function(request, response) {
        if (request.term in cache) {
          response(cache[request.term])
        } else {
          var origin = $('a[data-subcategory="' + subcategory + '"]');

          if (origin) {
            var data = origin.data() || {};

            if(data['autocompleteData']) {
              const autocompleteData = data['autocompleteData'];
              const values = Object.values(autocompleteData);

              const result = values.filter((el, i) => {
                return el.toLowerCase().includes(request.term.toLowerCase());
              });
              const key = Object.keys(autocompleteData)
                                .find(k => autocompleteData[k] === result[0]);

              /* Add autocomplete value to hidden input */
              $('input[data-subcategory="' + subcategory + '_input"]').val(key);
              response(result);
            } else if(data['autocompleteSource']) {
              $.ajax({
                dataType: "json",
                url: data['autocompleteSource'],
                data: {
                  term: request.term
                },
                success: function(result) {
                  cache[request.term] = result;

                  $('input[data-subcategory="' + subcategory + '_input"]').val(result);
                  response(result);
                },
                error: function(_, status, error) {
                  console.log(status, error)
                }
              });
            }
          }
        }
      }
    });
  }

  $(".last-level-filter li a").click(function(event) {
    const category = $(".sub-category ul li.active a").text().trim();
    const subcategory = $(".last-sub-category ul li.active a").data().subcategory;
    const subcategoryLabel = $(".last-sub-category ul li.active a").text().trim();
    const subcategoryType = $(".last-sub-category ul li.active a").data().type;
    const type = $(".last-level-filter ul li.active a").data().type;
    const typeLabel = $(".last-level-filter ul li.active a").text().trim();
    const index = $('.item-filter').length;

    const inputs = renderFilterInputs(index, subcategory, subcategoryType, type, category);
    const item_filter = '<div class="item-filter"><ul><li class="primary-nivel-filter-secondary"><button>' + subcategoryLabel + '</button></li><li class="second-nivel-filter"><button>' + typeLabel + '</button></li><li class="last-nivel-filter">'+inputs+'</li></ul><div class="button btn-remove-filter"><img src="/img/img-close-filter.png" alt=""></div></div>';

    if ($(this).find("i").length == 0) {
      $("#modalFilter").modal("hide");
      $(".filter-result").show();
      $(".filter-complete").append(item_filter);
      $('.selectpicker').selectpicker();

      var input = $('input[data-subcategory="' + subcategory + '"]');

      input.focus(function(_e) {
        autoComplete(input);
        input.keydown();
      });

      autoComplete(input);
      input.keydown();
    }

    return true;
  });
})

$(document).on("click", ".btn-remove-filter", function() {
  $(this).parents(".item-filter").remove();
});

$(".add-new-filter").click(function(event) {
  $(".filter-geral").css({
    transform: 'translateX(0px) translateY(0px)',
    transition: '.3s all'
  });
  $(".bread li span").empty();
  $(".control-breadcrumbs .controls .arrow-left").addClass('disabled');
  $(".level-filter ul li").removeClass('active');
  $(".main-category ul li:first-child").addClass('active');

});

$(".btn-add-filter-modal").click(function(event) {
  $(".filter-geral").css({
    transform: 'translateX(0px) translateY(0px)',
    transition: '.3s all'
  });
  $(".bread li span").empty();
  $(".control-breadcrumbs .controls .arrow-left").addClass('disabled');
  $(".level-filter ul li").removeClass('active');
  $(".main-category ul li:first-child").addClass('active');
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
