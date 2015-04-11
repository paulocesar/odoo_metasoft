jsRoot = @

{ _, Metasoft, moment } = jsRoot

{ fieldValidator, fieldSearch } = Metasoft

class Transferencias extends Metasoft.Display
    constructor: (opts) ->
        @model = 'transferencia'

        @events = {
            'click tr.conta': 'onClickConta'
        }

        super

        @tplAcctounts = _.template($('#tpl-transferencia-contas').html())
        @tplTransf = _.template($('#tpl-transferencia-listItem').html())

        @search = fieldSearch({ el: '#transfereciaSearchForm', @model, action: 'list' })
        @search.on('search:done', @renderTransferencias)

        @reset()

    doSearch: () => @search.doSearch()

    onShow: () =>
        data = { table: 'contaBancaria',  withEmpresa: true }
        @post('crud/list', data, (contas) =>
            @renderAccounts(contas)
            @setSelectedAccount(contas[0].id)
            @doSearch()
        )

    onClickConta: (ev) ->
        contaBancariaId = $(ev.currentTarget).data('rowid')
        @setSelectedAccount(contaBancariaId)

    doSearch: () => @search.doSearch()

    renderTransferencias: (transferencias) =>
        @$('.list-transferencias').html(@tplTransf({ @contaBancariaId, transferencias }))

    renderAccounts: (contas) =>
        @$('.list-transferencia-contas').html(@tplAcctounts({ contas }))

    reset: () ->
        fieldValidator.fill(@$('#transfereciaSearchForm'), {
            query: ''
            periodo: 'dia'
            data: moment().format('YYYY-MM-DD 00:00:00')
        })

    setSelectedAccount: (@contaBancariaId) ->
        @search.setOptions({ @contaBancariaId })

Metasoft.displays.Transferencias = Transferencias
