jsRoot = @

{ _, Metasoft, moment } = jsRoot

{ fieldValidator, fieldSearch, DateNavigator } = Metasoft

class TransferenciaModal extends Metasoft.DisplayModal
    constructor: (opts) ->
        @el = '#modalTransferencia'

        @events = {
            'click .save': 'onClickSave'
            'change select': 'onSelectChange'
        }

        super

        @tplTransfModal = _.template($('#tpl-transferencia-crud').html())
        @render()

    onShow: () ->
        fieldValidator.reset(@$el)
        @$f('data').val(moment().format('DD/MM/YYYY'))

    onSelectChange: () ->
        fieldValidator.removeError(@$f('contaBancariaDestinoId'))

    onClickSave: () ->
        data = fieldValidator.getValues(@$el)
        if data.contaBancariaOrigemId == data.contaBancariaDestinoId
            return fieldValidator.addError(
                @$f('contaBancariaDestinoId')
                "Não pode ser igual à conta origem."
            )

        unless fieldValidator.isValid(@$el, true)
            return

        btns = @$('button')
        btns.attr('disabled','disabled')
        @postModel('transferencia', 'createSeparate', data, () =>
            btns.removeAttr('disabled')
            @hide()
            @trigger('save')
        )

    render: () ->
        contas = Metasoft.contaBancariaById
        @$('.modal-body').html(@tplTransfModal({ contas }))
        fieldValidator.apply(@$el)

class Transferencias extends Metasoft.Display
    constructor: (opts) ->
        @model = 'transferencia'

        @events = {
            'click tr.conta': 'onClickConta'
            'click tr.transferencia': 'onClickTransferencia'
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
        @transferenciaModal.on('save', () =>
            @refreshContaBancaria()
            @doSearch()
        )

        @reset()

    onChangePeriodo: () ->
        $periodField = @$('#transfereciaSearchForm .periodo')
        period = $periodField.val()

        if period != @dateNavigator.period
            @dateNavigator.setPeriod(period)
            @doSearch()

    doSearch: () => @search.doSearch()

    onShow: () => @refreshContaBancaria()

    refreshContaBancaria: () =>
        data = { table: 'contaBancaria',  withEmpresa: true }
        @post('crud/list', data, (contas) =>
            @renderAccounts(contas)
            @setSelectedAccount(contas[0].id)
        )

    onClickConta: (ev) ->
        contaBancariaId = $(ev.currentTarget).data('rowid')
        @setSelectedAccount(contaBancariaId)

    onClickTransferencia: (ev) ->
        ev.preventDefault()

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
