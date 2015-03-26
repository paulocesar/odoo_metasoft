jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator, modals } = Metasoft


class Contas extends Metasoft.Display
    constructor: (opts) ->
        @subTpls = {
            form: _.template($('#subtpl-display-contas-form').html())
            parcelas: _.template($('#subtpl-display-contas-parcelaItem').html())
        }

        super

        @modal = new modals.Contas()

    onShow: () ->
        @post('financeiro/listaLancamentos', { }, @renderLancamentos)

    renderLancamentos: (data) =>
        { @parcelas, @pages } = data
        $l = @$el.find('.list-lancamentos')
        $l.html(@subTpls.parcelas({ @parcelas }))


Metasoft.displays.Contas = Contas
