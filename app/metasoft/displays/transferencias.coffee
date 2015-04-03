jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class Transferencias extends Metasoft.Display
    constructor: (opts) ->
        @table = 'transferencia'
        super

Metasoft.displays.Transferencias = Transferencias
