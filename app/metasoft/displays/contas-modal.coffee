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
        }

        super

        fieldValidator.apply(@$el)

        @$formTop = @$el.find('.form-conta-top')
        @$formBottom = @$el.find('.form-conta-bottom')
        @$parcelas = @$el.find('table .parcelas')

    onChangeValorBruto: () ->
        data = @getFormData()
        @$el.find(".valorLiquido").maskMoney('mask', data.valorBruto)
        @buildParcelas()

    onChangeValorLiquido: () ->
        data = @getFormData()
        if data.valorBruto < data.valorLiquido
            @$el.find(".valorBruto").maskMoney('mask', data.valorLiquido)

        @buildParcelas()

    onChangeParcelas: () ->
        parcelas = _.filter(@parcelas, (p) -> !p.impostoNotaFiscalId?)
        data = @getFormData()
        quant = parseInt(data.quantParcelas)

        if !quant || parcelas.length == quant
            @$el.find('.quantParcelas').val(parcelas.length) if !quant
            return

        @buildParcelas()

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
        $btn = $(ev.relatedTarget)
        contaType = $btn.data('conta')
        contaId = $btn.data('contaid')
        @parcelas = []

        title = 'Conta a Receber'
        if contaType == 'pagar'
            title = 'Conta a Pagar'

        unless contaId
            title = "Nova #{title}"
            @parcelas.push(createParcela())

        @$el.find('.modal-title').html(title)

        @renderModalParcelas()

    getFormData: () ->
        data = fieldValidator.getValues(@$formTop)
        _.defaults(data, fieldValidator.getValues(@$formBottom))

        data.parcelas = []

        @$parcelas.find('tr').each(() ->
            data.parcelas.push(fieldValidator.getValues($(@)))
        )

        return data

    onHide: (ev) ->

    get: (args...) -> Metasoft.get(args...)
    post: (args...) -> Metasoft.post(args...)

Metasoft.modals.Contas = ContasModal
