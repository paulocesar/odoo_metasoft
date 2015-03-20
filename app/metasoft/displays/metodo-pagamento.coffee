jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class MetodoPagamento extends Metasoft.CrudDisplay
    constructor: (opts) ->

        @urls = {
            list: 'configs/listaMetodoPagamento'
            upsert: 'configs/upsertMetodoPagamento'
            remove: 'configs/removeMetodoPagamento'
        }

        super

Metasoft.displays.MetodoPagamento = MetodoPagamento
