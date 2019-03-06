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

$(".last-sub-category li a").click(function(event) {
  if ($(this).find("i").length > 0) {
    $(".filter-geral").css({
      transform: 'translateX(-199px) translateY(0px)',
      transition: '.3s all'
    });
    $(".controls .arrow-left").removeClass('disabled');
  }

  $('.last-level-filter ul').show();

  var item_filter = '<div class="item-filter"><ul><li class="primary-nivel-filter"><button>' + $(this).text() + '</button></li><li class="second-nivel-filter"><select class="selectpicker"><option>input option 01</option><option>input option 02</option><option>input option 03</option></select></li><li class="last-nivel-filter"><input type="text" placeholder="Value"></li></ul><div class="button btn-remove-filter"><img src="/img/img-close-filter.png" alt=""></div></div>';
  if ($(this).find("i").length == 0) {
    $("#modalFilter").modal("hide");
    $(".filter-result").show();
    $(".filter-complete").append(item_filter);
    $('.selectpicker').selectpicker();
  }
  return false;
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

$(document).on("click", ".btn-remove-filter", function() {
  $(this).parents(".item-filter").remove();
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
          var origin = $('[data-autocomplete-category="' + subcategory + '"]');

          if (origin) {
            var data = origin.data() || {};

            if(data['autocompleteData']) {
              var result = data['autocompleteData'].filter(function(el, i) {
                return el.includes(request.term);
              });

              response(result)
            } else if(data['autocompleteSource']) {
              $.ajax({
                dataType: "json",
                url: data['autocompleteSource'],
                data: {
                  term: request.term
                },
                success: function(result) {
                  cache[request.term] = result;
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
    var category = $(".sub-category ul li.active a").text().trim();
    var subcategory = $(".last-sub-category ul li.active a").attr('id');
    var subcategory_name = $(".last-sub-category ul li.active a").text().trim();
    var type = $(".last-level-filter ul li.active a").attr('id');
    var type_name = $(".last-level-filter ul li.active a").text().trim();
    var index = $('.item-filter').length;
    var value_placeholder = $('.filter-value-placeholder').text();
    var field_input = '<input type="hidden" name="filter['+index+'][type]" value="'+subcategory+'" />';
    var operator_input = '<input type="hidden" name="filter['+index+'][operator]" value="'+type+'" />';
    var value_input = '<input type="text" name="filter['+index+'][value]" data-category="'+category+'" data-subcategory="'+subcategory+'" data-type="'+type+'" placeholder=' + value_placeholder + '>'
    var inputs = field_input + operator_input + value_input;
    var item_filter = '<div class="item-filter"><ul>' +
                        '<li class="primary-nivel-filter-secondary">' +
                          '<button>' + subcategory_name + '</button>' +
                        '</li>' +
                        '<li class="second-nivel-filter">' + 
                          '<button>' + type_name + '</button>' + 
                        '</li>' + 
                        '<li class="last-nivel-filter">' + inputs + '</li>' + 
                        '</ul>' + 
                        '<div class="button btn-remove-filter">' + 
                          '<img src="/img/img-close-filter.png" alt="">' + 
                        '</div></div>';

    if ($(this).find("i").length == 0) {
      $("#modalFilter").modal("hide");
      $('.last-level-filter ul').hide();
      $(".filter-result").show();
      $(".filter-complete").append(item_filter);
      $('.selectpicker').selectpicker();

      var input = $('input[data-subcategory="' + subcategory + '"]');

      autoComplete(input);
      input.focus().keydown();
    }

    return false;
  });

  $('input[data-type="equal"]').on('focus', function(e) {
    var input = $(e.target);

    autoComplete(input);
    input.keydown();
  })
})
