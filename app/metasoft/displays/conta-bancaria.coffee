jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class ContaBancaria extends Metasoft.CrudDisplay
    constructor: (opts) ->
        @table = 'contaBancaria'
        super

Metasoft.displays.ContaBancaria = ContaBancaria
