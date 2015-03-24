jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class Produtos extends Metasoft.CrudDisplay
    constructor: (opts) ->

        @urls = {
            list: 'configs/listaProduto'
            upsert: 'configs/upsertProduto'
            remove: 'configs/removeProduto'
        }

        super

Metasoft.displays.Produtos = Produtos
