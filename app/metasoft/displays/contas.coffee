jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator, modals } = Metasoft


class Contas extends Metasoft.Display
    constructor: (opts) ->
        @model = 'lancamento'

        @subTpls = {
            form: _.template($('#subtpl-display-contas-form').html())
            parcelas: _.template($('#subtpl-display-contas-parcelaItem').html())
        }

        super

        @modal = new modals.Contas()

    onShow: () ->
        data = { @model, action: 'list' }
        @post('crud/model', data, @renderLancamentos)

    renderLancamentos: (data) =>
        { @parcelas, @pages } = data
        $l = @$('.list-lancamentos')
        $l.html(@subTpls.parcelas({ @parcelas }))


Metasoft.displays.Contas = Contas
