jsRoot = @

{ _, $, Metasoft } = jsRoot
{ F } = Metasoft

jsRoot.fieldSearch = (args...) -> new FieldSearch(args...)

class FieldSearch extends Backbone.View
    constructor: (opts) ->
        V.demandGoodString(opts.url, 'opts.url')
        @events = {

        }

        super

        @$input = @$('input.search')

    doSearch: () ->
        Metasoft.post()

    getData: () -> F.getValues(@$el)
