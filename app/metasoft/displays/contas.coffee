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

Metasoft.displays.Contas = Contas
