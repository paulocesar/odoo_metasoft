jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class CentroCusto extends Metasoft.CrudDisplay
    constructor: (opts) ->
        @table = 'centroCusto'
        super

Metasoft.displays.CentroCusto = CentroCusto
