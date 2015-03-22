jsRoot = @

{ _, ace, Backbone, moment, Metasoft } = jsRoot

{ fieldValidator, money } = Metasoft

createParcela = (numero = '1', valor = 0) -> {
    id: null
    titulo: "Parcela #{numero}"
    dataVencimento: moment().format('DD/MM/YYYY')
    valor
    status: 'pendente'
}

class ContasModal extends Backbone.View
    constructor: (opts) ->
        _.extend(@, opts)
        @el = "#modalContas"

        @subTpls = {
            parcelas: _.template($('#subtpl-display-contas-parcelaItem').html())
        }

        @events = {
            'show.bs.modal': 'onShow'
            'hide.bs.modal': 'onHide'
            'change .valorBruto': 'onChangeValorBruto'
            'change .valorLiquido': 'onChangeValorLiquido'
            'change .quantParcelas': 'onChangeParcelas'
            'change .desconto': 'onChangeDesconto'
        }

        super

        fieldValidator.apply(@$el)

        @$formTop = @$el.find('.form-conta-top')
        @$formBottom = @$el.find('.form-conta-bottom')
        @$parcelas = @$el.find('table .parcelas')

    onChangeValorBruto: () ->
        data = @getFormData()
        data.valorLiquido = data.valorBruto
        @$el.find(".valorLiquido").maskMoney('mask', data.valorBruto)

        @updateDesconto(data)
        @buildParcelas()

    onChangeValorLiquido: () ->
        data = @getFormData()
        if data.valorBruto < data.valorLiquido
            data.valorBruto = data.valorLiquido
            @$el.find(".valorBruto").maskMoney('mask', data.valorLiquido)

        @updateDesconto(data)
        @buildParcelas()

    onChangeDesconto: () ->
        data = @getFormData()

        if data.valorBruto < data.desconto
            data.valorBruto = 0 - data.desconto
            @$el.find(".valorBruto").maskMoney('mask', data.valorBruto)

        data.valorLiquido = data.valorBruto + data.desconto
        @$el.find(".valorLiquido").maskMoney('mask', data.valorLiquido)

        @updateDesconto(data)
        @buildParcelas()

    onChangeParcelas: () ->
        parcelas = _.filter(@parcelas, (p) -> !p.impostoNotaFiscalId?)
        data = @getFormData()
        quant = parseInt(data.quantParcelas)

        if !quant || parcelas.length == quant
            @$el.find('.quantParcelas').val(parcelas.length) if !quant
            return

        @buildParcelas()

    updateDesconto: (data) ->
        desconto = 0 - money.round(data.valorBruto - data.valorLiquido)
        @$el.find('.desconto').maskMoney('mask', desconto)

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

    onShow: (ev) ->
        @resetFormData()

        $btn = $(ev.relatedTarget)
        contaType = $btn.data('contatipo')
        contaId = $btn.data('contaid')
        @parcelas = []

        title = 'Conta a Receber'
        @$el.find('.modal-dialog').removeClass('invert-money-color')

        if contaType == 'pagar'
            title = 'Conta a Pagar'
            @$el.find('.modal-dialog').addClass('invert-money-color')

        unless contaId
            title = "Nova #{title}"
            @parcelas.push(createParcela())

        @$el.find('.modal-title').html(title)

        @renderModalParcelas()

    resetFormData: () ->
        fieldValidator.reset(@$formTop)
        # fieldValidator.reset(@$formBottom)

    getFormData: () ->
        data = fieldValidator.getValues(@$formTop)
        _.defaults(data, fieldValidator.getValues(@$formBottom))

        data.parcelas = []

        @$parcelas.find('tr').each(() ->
            data.parcelas.push(fieldValidator.getValues($(@)))
        )

        return data

    onHide: (ev) -> @$el.find('.modal-dialog').removeClass('invert-money-color')

    get: (args...) -> Metasoft.get(args...)
    post: (args...) -> Metasoft.post(args...)

Metasoft.modals.Contas = ContasModal
