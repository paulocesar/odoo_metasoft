jsRoot = @

dictionary = {}

if module?.exports?
    _ = require('underscore')
    module.exports = dictionary
else
    { _ } = jsRoot
    jsRoot.dictionary = dictionary

_.extend(dictionary, {
    banksById: {
        "001": "001 - Banco do Brasil"
        "002": "002 - Bradesco"
    }

    rolesById: {
        financeiro: 'Financeiro'
        contabil: 'Contábil'
        admin: 'Administrador'
    }

    tipoConta: {
        receber: '0'
        pagar: '1'
    }

    getParcelaStatus: (p) ->
        return 'pendente'
})
