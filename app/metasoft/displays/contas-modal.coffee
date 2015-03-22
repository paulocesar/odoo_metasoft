jsRoot = @

{ _, ace, Backbone, moment, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

defaultParcela = () -> {
    id: null
    titulo: 'Parcela 1'
    dataVencimento: moment().format('DD/MM/YYYY')
    valor: 'R$ 0,00'
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
        }

        super

        fieldValidator.apply(@$el)
        @$parcelas = @$el.find('table .parcelas')

    renderModalParcelas: (parcelas) ->
        parcelas = [].concat(parcelas)
        @$parcelas.html(@subTpls.parcelas({ parcelas }))
        fieldValidator.apply(@$parcelas)

    onShow: (ev) ->
        $btn = $(ev.relatedTarget)
        contaType = $btn.data('conta')
        contaId = $btn.data('contaid')

        title = 'Conta a Receber'
        if contaType == 'pagar'
            title = 'Conta a Pagar'

        unless contaId
            title = "Nova #{title}"
            @renderModalParcelas(defaultParcela())

        @$el.find('.modal-title').html(title)

    onHide: (ev) ->

    get: (args...) -> Metasoft.get(args...)
    post: (args...) -> Metasoft.post(args...)

Metasoft.modals.Contas = ContasModal
