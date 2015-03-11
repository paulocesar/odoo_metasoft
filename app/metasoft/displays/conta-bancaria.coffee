jsRoot = @

{ _, Metasoft } = jsRoot


class ContaBancaria extends Metasoft.components.Display
    constructor: (opts) ->
        @name = 'contaBancaria'
        @category = 'Financeiro'
        @subCategory = 'Conta Bancaria'

        super

Metasoft.displays.ContaBancaria = ContaBancaria
