jsRoot = @

{ _, Metasoft } = jsRoot

{ F, modals, fieldSearch } = Metasoft


class Contas extends Metasoft.Display
    constructor: (opts) ->
        @model = 'lancamento'

        @subTpls = {
            form: _.template($('#subtpl-display-contas-form').html())
            parcelas: _.template($('#subtpl-display-contas-parcelaItem').html())
        }

        @events = {
            'change #contasSearchForm .status': 'doSearch'
        }

        super

        @modal = new modals.Contas()

        @search = fieldSearch({ el: '#contasSearchForm', @model, action: 'list' })
        @search.on('search:done', @renderLancamentos)

    doSearch: () -> @search.doSearch()

    onShow: () -> @doSearch()

    renderLancamentos: (data) =>
        { @parcelas, @pages } = data
        $l = @$('.list-lancamentos')
        $l.html(@subTpls.parcelas({ @parcelas }))


Metasoft.displays.Contas = Contas
