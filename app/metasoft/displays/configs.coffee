jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class CentroCusto extends Metasoft.CrudDisplay
    constructor: (opts) ->
        @table = 'centroCusto'
        @refreshStaticData = true
        super

Metasoft.displays.CentroCusto = CentroCusto

class MetodoPagamento extends Metasoft.CrudDisplay
    constructor: (opts) ->
        @table = 'metodoPagamento'
        @refreshStaticData = true
        super

Metasoft.displays.MetodoPagamento = MetodoPagamento

class Imposto extends Metasoft.CrudDisplay
    constructor: (opts) ->
        @table = 'impostoNotaFiscal'

        super

Metasoft.displays.Imposto = Imposto

class Logins extends Metasoft.CrudDisplay
    constructor: (opts) ->
        @table = 'login'
        @uniqueWithEmpresa = false
        super

Metasoft.displays.Logins = Logins

class ContaBancaria extends Metasoft.CrudDisplay
    constructor: (opts) ->
        @table = 'contaBancaria'
        @refreshStaticData = true
        super

Metasoft.displays.ContaBancaria = ContaBancaria
