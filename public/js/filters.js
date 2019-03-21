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
                     'data-subcategory="' + subcategory + '" data-type="' + type + '" />';
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

function reloadMasks() {
  $('input[data-subcategory="amount"').inputmask({
    alias: 'numeric',
    enforceDigitsOnBlur: true,
    groupSeparator: '.',
    groupSize: 3,
    autoGroup: true,
    digits: 2,
    unmaskAsNumber: true,
    removeMaskOnSubmit: true,
  });
}

export function loadAutoComplete() {
  reloadMasks();

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

              /* Takes the closest option if we have closer ones */
              let result = values.filter((el) => el.toLowerCase() === request.term.toLowerCase());

              if (result.length < 1) {
                result = values.filter((el) => el.toLowerCase().includes(request.term.toLowerCase()));
              }

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
      },
      select: (event) => autocompleteFocus($(event.target)),
    });
  }

  function autocompleteFocus(givenInput) {
    const subcategory = givenInput ? '' : $(".last-sub-category ul li.active a").data().subcategory;
    const input = givenInput ? givenInput : $('input[data-subcategory="' + subcategory + '"]');

    input.focus(function() {
      autoComplete(input);
      input.keydown();
    });

    autoComplete(input);
    input.keydown();
  }

  /* Autocomplete on input focus, instead of new filters */
  $(".last-nivel-filter input").click(function() { autocompleteFocus($(this)); });

  /* Adds the filter and autocomplete other filters */
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

      autocompleteFocus();
      reloadMasks();
    }

    return true;
  });
}
