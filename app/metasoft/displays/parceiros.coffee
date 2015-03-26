jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class Parceiros extends Metasoft.CrudDisplay
    constructor: (opts) ->
        @table = 'parceiro'
        super

Metasoft.displays.Parceiros = Parceiros
