jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class Imposto extends Metasoft.CrudDisplay
    constructor: (opts) ->

        @urls = {
            list: 'configs/listaImposto'
            upsert: 'configs/upsertImposto'
            remove: 'configs/removeImposto'
        }

        super

Metasoft.displays.Imposto = Imposto
