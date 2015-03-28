jsRoot = @

{ _, $, Metasoft, V } = jsRoot
{ F } = Metasoft

Metasoft.fieldSearch = (args...) -> new FieldSearch(args...)

class FieldSearch extends Backbone.View
    constructor: (opts) ->
        _.extend(@, opts)
        V.demandGoodString(@model, 'model')
        V.demandGoodString(@action, 'action')

        @events = {
            'keyup input.query': 'doLazySearch'
            'change input.query': 'doLazySearch'
        }

        super

        @options = {}
        @lazySearch = _.debounce(@doSearch, 1000)

    setOptions: (@options) ->

    doLazySearch: () ->
        Metasoft.showLoading()
        @lazySearch()

    doSearch: () ->
        data = { @model, @action, data: _.extend(@getData(), @options) }
        Metasoft.post('crud/model', data, @onSearchResult)

    onSearchResult: (@items) => @trigger('search:done', @items)

    getData: () -> F.getValues(@$el)