jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator, fieldSearch } = Metasoft

class Transferencias extends Metasoft.Display
    constructor: (opts) ->
        @model = 'transferencia'

        @events = {
            'click tr.conta': 'onClickConta'
        }

        super

        @tplAcctounts = _.template($('#tpl-transferencia-contas').html())


        @search = fieldSearch({ el: '#transfereciaSearchForm', @model, action: 'list' })
        @search.on('search:done', @renderTransferencias)

    onShow: () =>
        data = { table: 'contaBancaria',  withEmpresa: true }
        @post('crud/list', data, @renderAccounts)

    onClickConta: (ev) ->
        contaId = $(ev.currentTarget).data('rowid')

    doSearch: () => @search.doSearch()

    renderTransferencias: (data) => console.log(data)

    renderAccounts: (contas) =>
        @$('.list-transferencia-contas').html(@tplAcctounts({ contas }))


Metasoft.displays.Transferencias = Transferencias
