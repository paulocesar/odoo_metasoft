jsRoot = @

{ _, Backbone, moment, Metasoft } = jsRoot

{ fieldValidator, money, DisplayModal, DropdownSearch } = Metasoft

class ParcelaModal extends DisplayModal
    constructor: (opts) ->
        _.extend(@, opts)
        @el = "#modalParcela"

        @events = {
            'click .save': 'onClickSave'
        }

        super

        @$formTop = @$('.form-crud')

        fieldValidator.apply(@$el)

        @$('.dropdownSearchParceiro').html(DropdownSearch.html('parceiroId'))
        @dropdownSearch = new DropdownSearch({
            el: "##{@$el.attr('id')} .dropdownSearchParceiro",
            name: 'parceiro',
            model: 'parceiro',
            action: 'search'
        })

    onShow: () ->
        @setMoneyColorCls()
        @parcela.dataPagamento ?= Metasoft.now()
        fieldValidator.fill(@$el, @parcela)

    onClickSave: () ->
        if @parcela.pago == 1
            return

        data = { parcela: fieldValidator.getValues(@$el) }
        @postModel('lancamento', 'pay', data, () =>
            @trigger('lancamento:pay', @parcela.id)
            @hide()
        )

    setParcela: (@parcela, @action) ->

    setMoneyColorCls: () ->
        cls = 'invert-money-color'

        @$el.removeClass(cls)

        if @parcela.tipoConta == dictionary.tipoConta.pagar
            @$el.addClass(cls)

Metasoft.modals.Parcela = ParcelaModal
