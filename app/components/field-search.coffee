jsRoot = @

{ _, $, Metasoft, V } = jsRoot
{ F } = Metasoft

Metasoft.fieldSearch = (args...) -> new FieldSearch(args...)

class FieldSearch extends Backbone.View
    constructor: (opts) ->
        _.extend(@, opts)
        V.demandGoodString(@model, 'model')
        V.demandGoodString(@action, 'action')

        @lastQuery = ''

        @events = {
            'keyup input.query': 'doLazySearch'
            'change input.query': 'doLazySearch'
        }

        super

        @options = {}
        @lazySearch = _.debounce(@doSearch, 1000)

    setOptions: (opts) -> _.extend(@options, opts)

    doLazySearch: () ->
        data = @getData()

        if @lastQuery == data.query
            return

        Metasoft.showLoading()
        @lazySearch()

    doSearch: () ->
        formData = _.extend(@getData(), @options)
        @lastQuery =  formData.query
        data = { @model, @action, data: formData }

        Metasoft.post('crud/model', data, @onSearchResult)

    onSearchResult: (@items) => @trigger('search:done', @items)

    getData: () ->
        _.defaults(F.getValues(@$el), { query: @$('.query').val() })
