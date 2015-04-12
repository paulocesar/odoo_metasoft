jsRoot = @

{ _, Metasoft, moment } = jsRoot

{ fieldValidator, fieldSearch, DateNavigator } = Metasoft

class TransferenciaModal extends Metasoft.DisplayModal
    constructor: (opts) ->
        @el = '#modalTransferencia'

        @events = {
            'click .save': 'onClickSave'
        }

        super

        @tplTransfModal = _.template($('#tpl-transferencia-crud').html())
        @render()

    onClickSave: () -> alert('funcionalidade em desenvolvimento')

    render: () ->
        contas = Metasoft.contaBancariaById
        @$('.modal-body').html(@tplTransfModal({ contas }))
        fieldValidator.apply(@$el)

class Transferencias extends Metasoft.Display
    constructor: (opts) ->
        @model = 'transferencia'

        @events = {
            'click tr.conta': 'onClickConta'
            'change #transfereciaSearchForm .periodo': 'onChangePeriodo'
        }

        super

        @tplAcctounts = _.template($('#tpl-transferencia-contas').html())
        @tplTransf = _.template($('#tpl-transferencia-listItem').html())

        @search = fieldSearch({ el: '#transfereciaSearchForm', @model, action: 'list' })
        @search.on('search:done', @renderTransferencias)

        @dateNavigator = new DateNavigator({
            el: '#transfereciaSearchForm .date-navigator'
            period: 'dia'
        })
        @dateNavigator.on('date:change', @doSearch)

        @transferenciaModal = new TransferenciaModal()

        @reset()

    onChangePeriodo: () ->
        $periodField = @$('#transfereciaSearchForm .periodo')
        period = $periodField.val()

        if period != @dateNavigator.period
            @dateNavigator.setPeriod(period)
            @doSearch()

    doSearch: () => @search.doSearch()

    onShow: () =>
        data = { table: 'contaBancaria',  withEmpresa: true }
        @post('crud/list', data, (contas) =>
            @renderAccounts(contas)
            @setSelectedAccount(contas[0].id)
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
        id = @contaBancariaId
        @$(".list-transferencia-contas tr").removeClass('active')
        @$(".list-transferencia-contas tr[data-rowid='#{id}']").addClass('active')

        @search.setOptions({ @contaBancariaId })
        @search.doSearch()

Metasoft.displays.Transferencias = Transferencias
