jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class CentroCusto extends Metasoft.CrudDisplay
    constructor: (opts) ->

        @urls = {
            list: 'configs/listaCentroCusto'
            upsert: 'configs/upsertCentroCusto'
            remove: 'configs/removeCentroCusto'
        }

        super

Metasoft.displays.CentroCusto = CentroCusto
