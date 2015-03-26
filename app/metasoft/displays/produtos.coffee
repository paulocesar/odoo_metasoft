jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class Produtos extends Metasoft.CrudDisplay
    constructor: (opts) ->
        @table = 'produto'
        super

Metasoft.displays.Produtos = Produtos
