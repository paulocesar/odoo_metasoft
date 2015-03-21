jsRoot = @

{ _, Metasoft } = jsRoot

class Contas extends Metasoft.Display
    constructor: (opts) ->
        @subTpls = {
            form: _.template($('#subtpl-display-contas-form').html())
            parcela: _.template($('#subtpl-display-contas-parcelaItem').html())
        }

        super

Metasoft.displays.Contas = Contas
