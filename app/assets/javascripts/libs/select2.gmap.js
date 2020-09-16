$ = window.$;

$.fn.select2.amd.define('select2/data/googleAutocompleteAdapter', ['select2/data/array', 'select2/utils'],
    function (ArrayAdapter, Utils) {
        function GoogleAutocompleteDataAdapter($element, options) {
            GoogleAutocompleteDataAdapter.__super__.constructor.call(this, $element, options);
        }

        Utils.Extend(GoogleAutocompleteDataAdapter, ArrayAdapter);

        GoogleAutocompleteDataAdapter.prototype.query = function (params, callback) {
            var returnSuggestions = function (predictions, status) {
                var data = { results: [] };
                if (status != google.maps.places.PlacesServiceStatus.OK) {
                    callback(data);
                }
                for (var i = 0; i < predictions.length; i++) {
                    data.results.push({ id: JSON.stringify(predictions[i]), text: predictions[i].description });
                }
                data.results.push({ id: ' ', text: 'Powered by Google', disabled: true });
                callback(data);
            };

            if (params.term && params.term != '') {
                var service = new google.maps.places.AutocompleteService({
                    types: ['(cities)']
                });
                service.getPlacePredictions({
                    input: params.term,
                    types: ['(cities)'], 
                    componentRestrictions:{  }
                }, returnSuggestions)
            }
            else {
                var data = { results: [] };
                data.results.push({ id: ' ', text: 'Powered by Google', disabled: true });
                callback(data);
            }
        };
        return GoogleAutocompleteDataAdapter;
    }
);
function formatRepo(repo) {
    if (repo.loading) {
        return repo.text;
    }

    var markup = "<div class='select2-result-repository clearfix'>" +
        "<div class='select2-result-title'>" + repo.text + "</div>";
    return markup;
}

function formatRepoSelection(repo) {
    return repo.text;
}

var googleAutocompleteAdapter = $.fn.select2.amd.require('select2/data/googleAutocompleteAdapter');

var autocompleteAddress = ( fieldSelector ) => {
    $( fieldSelector ?? '.address-autocomplete').select2({
        width: '100%',
        dataAdapter: googleAutocompleteAdapter,
        placeholder: 'Search Adress',
        escapeMarkup: function (markup) { return markup; },
        minimumInputLength: 2,
        templateResult: formatRepo,
        templateSelection: formatRepoSelection
    });
}

window.autocompleteAddress = autocompleteAddress;
$(() => {
    autocompleteAddress('.address-autocomplete');
})
