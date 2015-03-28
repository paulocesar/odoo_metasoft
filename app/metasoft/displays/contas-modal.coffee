jsRoot = @

{ _, ace, Backbone, moment, Metasoft } = jsRoot

{ fieldValidator, money } = Metasoft

createParcela = (numero = 1, valor = 0) -> {
    id: null
    numero
    valor
    dataVencimento: moment().add(numero-1, 'month').format('DD/MM/YYYY')
}

class ContasModal extends Backbone.View
    constructor: (opts) ->
        _.extend(@, opts)
        @el = "#modalContas"

        @subTpls = {
            parcelas: _.template($('#subtpl-display-contas-parcelaItemModal').html())
        }

        @events = {
            'show.bs.modal': 'onShow'
            'hide.bs.modal': 'onHide'
            'change .valorBruto': 'onChangeValorBruto'
            'change .valorLiquido': 'onChangeValorLiquido'
            'change .quantParcelas': 'onChangeParcelas'
            'change .desconto': 'onChangeDesconto'
            'click .save': 'onClickSave'
        }

        super


        @$formTop = @$('.form-conta-top')
        @$formBottom = @$('.form-conta-bottom')
        @$parcelas = @$('table .parcelas')

        fieldValidator.apply(@$el)

        @$parcelas.on('change', 'input[name="valor"]', @onChangeValorParcelas)

    onChangeValorBruto: () ->
        data = @getFormData()
        data.valorLiquido = data.valorBruto
        money.setValue(@$(".valorLiquido"), data.valorBruto)

        @updateDesconto(data)
        @buildParcelas()

    onChangeValorLiquido: () ->
        data = @getFormData()
        if data.valorBruto < data.valorLiquido
            data.valorBruto = data.valorLiquido
            money.setValue(@$(".valorBruto"), data.valorLiquido)

        @updateDesconto(data)
        @buildParcelas()

    onChangeDesconto: () ->
        data = @getFormData()

        if data.valorBruto < data.desconto
            data.valorBruto = 0 - data.desconto
            money.setValue(@$(".valorBruto"), data.valorBruto)

        data.valorLiquido = data.valorBruto + data.desconto
        money.setValue(@$(".valorLiquido"), data.valorLiquido)

        @updateDesconto(data)
        @buildParcelas()

    onChangeParcelas: () ->
        parcelas = _.filter(@parcelas, (p) -> !p.impostoNotaFiscalId?)
        data = @getFormData()
        quant = parseInt(data.quantParcelas)

        if !quant || parcelas.length == quant
            @$('.quantParcelas').val(parcelas.length) if !quant
            return

        @buildParcelas()

    onChangeValorParcelas: () =>
        if @parcelas.length <= 1
            return

        @parcelas = @getFormData().parcelas

        liquido = @getFormData().valorLiquido
        last = _.last(@parcelas)
        totalPrimeiras = 0

        for p in @parcelas when p.numero != last.numero
            totalPrimeiras += p.valor

        lastValor = liquido - totalPrimeiras

        if lastValor < 0
            return

        last.valor = money.round(lastValor)

        @renderModalParcelas()

    updateDesconto: (data) ->
        desconto = 0 - money.round(data.valorBruto - data.valorLiquido)
        @$('.desconto').maskMoney('mask', desconto)

    buildParcelas: () ->
        data = @getFormData()
        quant = parseInt(data.quantParcelas)
        valor = money.round(parseFloat(data.valorLiquido) / quant)
        @parcelas = []

        for i in [1..quant]
            @parcelas.push(createParcela(i, valor))

        @renderModalParcelas()

    renderModalParcelas: () ->
        @$parcelas.html(@subTpls.parcelas({ @parcelas }))
        @$parcelas.find('tr').each(() -> fieldValidator.apply($(@)))

        @$parcelas.find('.mask-date-day')
            .data("DateTimePicker")
            .minDate(moment())

    onShow: (ev) ->
        @resetFormData()

        $btn = $(ev.relatedTarget)
        @tipoConta = $btn.data('contatipo')
        contaId = $btn.data('contaid')
        @parcelas = []

        title = 'Conta a Receber'
        @$('.modal-dialog').removeClass('invert-money-color')

        if @tipoConta == 'pagar'
            title = 'Conta a Pagar'
            @$('.modal-dialog').addClass('invert-money-color')

        unless contaId
            title = "Nova #{title}"
            @parcelas.push(createParcela())

        @$('.modal-title').html(title)

        @renderModalParcelas()

    resetFormData: () ->
        fieldValidator.reset(@$formTop)
        fieldValidator.reset(@$formBottom)
        @$formTop.find('.quantParcelas').val('1')

    getFormData: () ->
        data = fieldValidator.getValues(@$formTop)
        _.defaults(data, fieldValidator.getValues(@$formBottom))

        data.parcelas = []

        @$parcelas.find('tr').each(() ->
            data.parcelas.push(fieldValidator.getValues($(@)))
        )

        data.tipoConta = if @tipoConta == 'pagar' then '1' else '0'

        return data

    onHide: (ev) -> @$('.modal-dialog').removeClass('invert-money-color')

    isParcelasSumMatches: (data) ->
        sum = 0
        ps = data.parcelas

        for p in ps
            sum += p.valor

        if money.round(sum) == money.round(data.valorLiquido)
            return true

        alert('A soma das parcelas está diferente do valor líquido!')
        return false

    onClickSave: () ->
        data = @getFormData()
        isValid = fieldValidator.isValid(@$formTop, true) &&
            fieldValidator.isValid(@$formBottom,true) &&
            @isParcelasSumMatches(data)

        unless isValid
            return

        @$('.save').attr('disabled', 'disabled')

        d = {
            model: 'lancamento'
            action: 'save'
            data
        }

        @post('crud/model', d, (conta) =>
            @$('.save').removeAttr('disabled')
            @$el.modal('hide')
            @trigger('parcela:save')
        )

    get: (args...) -> Metasoft.get(args...)
    post: (args...) -> Metasoft.post(args...)

Metasoft.modals.Contas = ContasModal
