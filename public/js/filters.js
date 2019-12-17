/* Filter card, show modal */
$('#filterModal').on('show.bs.modal', function (event) {
  var button = $(event.relatedTarget) // Button that triggered the modal
  var title = button.data('modal-title') // Extract info from data-* attributes
  var subcategory = button.data('subcategory')
  var type = button.data('type')
  var data = button.data('autocomplete-data')
  var index = $('.filter-pill').length
  // control not supress index
  if (index > 0) {
    var last = $('.filter-pill').last().find('input[type="hidden"]').last().attr("name")
    console.log("last " + last)
    index = parseInt( last.split('[')[1].replace(']', '') ) + 1
  }
  console.log( $('.filter-pill'))
  console.group('SHOW MODAL')
  console.log(subcategory)
  console.log(type)
  console.log(data)
  console.log(index)

  var form = $('#filterModalForm')
  if(data && Object.keys(data).length > 5) {
    form.css("column-count", "2");
  } else {
    form.css("column-count", "1");
  }
  // form.find('input[type="hidden"]').remove()
  form.empty()
  
  if (data && (type == 'radio' || type == 'select')) {
    Object.keys(data).forEach(function(key) {
      if (type == 'radio') {
        $('<div class="radio"><label><input type="radio" name="' + subcategory + '" value="' + key + '"><span class="cr"><i class="fa fa-circle"></i></span>' + data[key] + '</label></div>').appendTo(form);
      }
      if (type == 'select') {
        $('<div class="checkbox"><label><input type="checkbox" name="' + subcategory + '" value="' + key + '"><span class="cr"><i class="fas fa-check"></i></span>' + data[key] + '</label></div>').appendTo(form);
      }
    })
  } else {
    if (type == 'text') {
      $('<div class="form-group"><label for="' + subcategory + '">' + title + '</label><input type="text" class="form-control" id="' + subcategory + '" name="' + subcategory + '" placeholder="' + title + '"></div>')
        .keypress(function (event) {
          var key = event.which;
          if(key == 13) { // the enter key code
            event.preventDefault()
            $('#filterModalApplyButton').click();
            return false 
          }
        })
        .appendTo(form)
        .focus()
    }

    if (type == 'range') {
      $('<input>').attr({
        type: 'hidden',
        id: 'min',
        name: 'min'
      }).appendTo(form);
      $('<input>').attr({
        type: 'hidden',
        id: 'max',
        name: 'max'
      }).appendTo(form);
      $('<p><input type="text" id="amount" readonly style="border:0; color:#00DACE; font-weight:bold; width: 100%;"></p>').appendTo(form)
      $('<div id="slider-range"></div>').appendTo(form)
      $( "#slider-range" ).slider({
        range: true,
        step: 5,
        min: 0,
        max: 1000,
        values: [ 0, 500 ],
        slide: function( event, ui ) {
          var min = ui.values[0]
          var max = ui.values[1]
          $('#min').val(min)
          $('#max').val(max)
          if (max == 1000) {
            max = 'infinity'
          }
          $( "#amount" ).val( min + " - " + max );
        }
      });
      $( "#amount" ).val( $( "#slider-range" ).slider( "values", 0 ) + " - " + $( "#slider-range" ).slider( "values", 1 ) );
      $('#min').val($( "#slider-range" ).slider( "values", 0 ))
      $('#max').val($( "#slider-range" ).slider( "values", 1 ))
    }

    if (type == 'range_amount') {
      $('<input>').attr({
        type: 'hidden',
        id: 'min',
        name: 'min'
      }).appendTo(form);
      $('<input>').attr({
        type: 'hidden',
        id: 'max',
        name: 'max'
      }).appendTo(form);
      $('<p><input type="text" id="amount" readonly style="border:0; color:#00DACE; font-weight:bold; width: 100%;"></p>').appendTo(form)
      $('<div id="slider-range"></div>').appendTo(form)
      $( "#slider-range" ).slider({
        range: true,
        step: 5,
        min: 0,
        max: 1000,
        values: [ 0, 500 ],
        slide: function( event, ui ) {
          var min = ui.values[0]
          var max = ui.values[1]
          $('#min').val(min)
          $('#max').val(max)
          if (max == 1000) {
            max = 'infinity'
          }
          var tail = max != 'infinity' ? 'mi' : ''
          $( "#amount" ).val( "$" + min + "mi - $" + max + tail);
        }
      });
      $( "#amount" ).val( "$" + $( "#slider-range" ).slider( "values", 0 ) + "mi - $" + $( "#slider-range" ).slider( "values", 1 ) + "mi");
      $('#min').val($( "#slider-range" ).slider( "values", 0 ))
      $('#max').val($( "#slider-range" ).slider( "values", 1 ))
    }
  }

  var url = new URL(window.location.href)

  var modal = $(this)
  modal.find('.modal-title').text(title)
  console.log(modal.find('#filterModalApplyButton'))
  modal.find('#filterModalApplyButton').unbind()
  modal.find('#filterModalApplyButton').click(function(event) {
    var formData = $('#filterModalForm').serializeArray()
    console.log(formData)
    if (type == 'range') {
      if (formData[0].value != 0) {
        url.searchParams.append('filter['+index+'][type]', subcategory)
        url.searchParams.append('filter['+index+'][operator]', 'greater_than')
        url.searchParams.append('filter['+index+'][value]', formData[0].value)
        index++
      }
      if (formData[1].value != 1000) {
        url.searchParams.append('filter['+index+'][type]', subcategory)
        url.searchParams.append('filter['+index+'][operator]', 'less_than')
        url.searchParams.append('filter['+index+'][value]', formData[1].value)
      }
    } else if (type == 'range_amount') {
      if (formData[0].value != 0) {
        url.searchParams.append('filter['+index+'][type]', subcategory)
        url.searchParams.append('filter['+index+'][operator]', 'greater_than')
        url.searchParams.append('filter['+index+'][value]', formData[0].value * 1000000)
        index++
      }
      if (formData[1].value != 1000) {
        url.searchParams.append('filter['+index+'][type]', subcategory)
        url.searchParams.append('filter['+index+'][operator]', 'less_than')
        url.searchParams.append('filter['+index+'][value]', formData[1].value * 1000000)
      }
    } else if (type == 'text') {
      formData.forEach(function(i) {
        url.searchParams.append('filter['+index+'][type]', subcategory)
        url.searchParams.append('filter['+index+'][operator]', 'contains')
        url.searchParams.append('filter['+index+'][value]', i.value)
        index++
      })
    } else {
      formData.forEach(function(i) {
        url.searchParams.append('filter['+index+'][type]', subcategory)
        url.searchParams.append('filter['+index+'][operator]', 'equal')
        url.searchParams.append('filter['+index+'][value]', i.value)
        console.log(i)
        index++
      })
    }
    console.log(url)
    window.location = url;
    $('#filterModal').modal('hide')
  });
})
// remove filter pill
$(document).on('click', '.filter-pill', function(event) {
  console.log(event)
  console.log(this)
  console.log($(this))
  $(this).remove()
  $('#filter-pills-form').submit()
});
// clear filters
$(document).on('click', '.filter-clear', function(event) {
  $('.pills').empty()
  $('#filter-pills-form').submit()
})
// END NEW

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
    $(".controls .arrow-left").removeClass('disabled');
  }

  renderLastLevelFilters($(this));
});

$(".add-new-filter").click(function(event) {
  $(".bread li span").empty();
  $(".control-breadcrumbs .controls .arrow-left").addClass('disabled');
  $(".level-filter ul li").removeClass('active');
  $(".main-category ul li:first-child").addClass('active');

});

$(".btn-add-filter-modal").click(function(event) {
  $(".bread li span").empty();
  $(".control-breadcrumbs .controls .arrow-left").addClass('disabled');
  $(".level-filter ul li").removeClass('active');
  $(".main-category ul li:first-child").addClass('active');
});

$(document).on("click", ".btn-remove-filter", function() {
  $(this).parents(".item-filter").remove();
});

function reloadMasks() {
  const inputMaskParams = {
    alias: 'numeric',
    enforceDigitsOnBlur: true,
    groupSeparator: '.',
    groupSize: 3,
    autoGroup: true,
    digits: 2,
    unmaskAsNumber: true,
    removeMaskOnSubmit: true,
  };

  $('input[data-subcategory="total_funds_invested"').inputmask(inputMaskParams);
  $('input[data-subcategory="amount"').inputmask(inputMaskParams);
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
