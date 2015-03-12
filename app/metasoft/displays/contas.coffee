jsRoot = @

{ _, Metasoft } = jsRoot


class Contas extends Metasoft.components.Display
    constructor: (opts) ->
        @category = 'Financeiro'
        @subCategory = 'Início'

        super

Metasoft.displays.Contas = Contas
