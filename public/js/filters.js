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

function subcategoryCard(name) {
  return (
    '<li class="primary-nivel-filter-secondary">' +
      '<button>' + name + '</button>' +
    '</li>'
  );
}

function operatorCard(name) {
  return (
    '<li class="second-nivel-filter">' +
      '<button>' + name + '</button>' +
    '</li>'
  );
}

function inputCard(options) {
  if (options.type === 'select') {
    let content = '<select name="" id="" class="last-nivel.filter">' +
                    '<option value="nada" disabled selected>Number of employees</option>' +
                    '<option value="nadad">Option01</option>' +
                    '<option value="nadadd">Option02</option>' +
                    '<option value="nadadds">Option03</option>' +
                  '</select>';
    return content;
  } else {
    return '<li class="last-nivel-filter">' + options.inputs + '</li>';
  }
}

function finalSelection(event, params) {
    const category = $(".sub-category ul li.active a").text().trim();
    const subcategory = $(".last-sub-category ul li.active a").attr('id');
    const subcategory_name = $(".last-sub-category ul li.active a").text().trim();
    const type = params.operator.value || $(".last-level-filter ul li.active a").attr('id');
    const type_name = params.operator.name || $(".last-level-filter ul li.active a").text().trim();
    const index = $('.item-filter').length;
    const value_placeholder = $('.filter-value-placeholder').text();
    const field_input = '<input type="hidden" name="filter['+index+'][type]" value="'+subcategory+'" />';
    const operator_input = '<input type="hidden" name="filter['+index+'][operator]" value="'+type+'" />';
    const value_input = '<input type="text" name="filter['+index+'][value]" data-category="' +
                            category + '" data-subcategory="' +
                            subcategory +'" data-type="' +
                            type + '" placeholder=' + value_placeholder + '>'
    const inputs = field_input + operator_input + value_input;
    const item_filter = '<div class="item-filter">' +
                          '<ul>' +
                            subcategoryCard(subcategory_name) +
                            operatorCard(type_name) +
                            inputCard({ inputs: inputs, ...params}) +
                          '</ul>' +
                          '<div class="button btn-remove-filter">' +
                            '<img src="/img/img-close-filter.png" alt="">' +
                          '</div>' +
                        '</div>';

    if ($(this).find("i").length == 0) {
      $("#modalFilter").modal("hide");
      $('.last-level-filter ul').hide();
      $(".filter-result").show();
      $(".filter-complete").append(item_filter);
      $('.selectpicker').selectpicker();

      const input = $('input[data-subcategory="' + subcategory + '"]');

      autoComplete(input);
      input.focus().keydown();
    }

    return false;
}

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

  /* Text options */
  // TODO

  /* Numeric options */
  // TODO

  /* Select options */
  if ($(this).attr('data-autocomplete-data')) {
    return finalSelection(event, {
      type: 'select',
      inputs: $(this).attr('data-autocomplete-data'),
      operator: {
        value: 'equal',
        name: $('#equal').text().trim(),
      }
    });
  };

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

  $(".last-level-filter li a").click(finalSelection);

  $('input[data-type="equal"]').on('focus', function(e) {
    var input = $(e.target);

    autoComplete(input);
    input.keydown();
  })
})
