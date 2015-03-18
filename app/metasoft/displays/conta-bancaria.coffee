jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class ContaBancaria extends Metasoft.CrudDisplay
    constructor: (opts) ->

        @urls = {
            list: 'financeiro/listaContaBancaria'
            upsert: 'financeiro/upsertContaBancaria'
        }

        @tpls = {
            crudList: _.template($('#tpl-display-contaBancariaListItem').html())
        }

        super

Metasoft.displays.ContaBancaria = ContaBancaria
