jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class MetodoPagamento extends Metasoft.CrudDisplay
    constructor: (opts) ->
        @table = 'metodoPagamento'

        super

Metasoft.displays.MetodoPagamento = MetodoPagamento
