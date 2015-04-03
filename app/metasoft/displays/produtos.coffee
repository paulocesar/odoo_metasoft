jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class Produtos extends Metasoft.CrudDisplay
    constructor: (opts) ->
        @table = 'produto'
        super

Metasoft.displays.Produtos = Produtos


class ProdutoCategoria extends Metasoft.CrudDisplay
    constructor: (opts) ->
        @table = 'produtoCategoria'
        super

Metasoft.displays.ProdutoCategoria = ProdutoCategoria
