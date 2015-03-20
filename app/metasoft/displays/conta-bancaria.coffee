jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class ContaBancaria extends Metasoft.CrudDisplay
    constructor: (opts) ->

        @urls = {
            list: 'financeiro/listaContaBancaria'
            upsert: 'financeiro/upsertContaBancaria'
            remove: 'financeiro/removeContaBancaria'
        }

        super

Metasoft.displays.ContaBancaria = ContaBancaria
