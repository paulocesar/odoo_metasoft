jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class Imposto extends Metasoft.CrudDisplay
    constructor: (opts) ->
        @table = 'impostoNotaFiscal'

        super

Metasoft.displays.Imposto = Imposto
