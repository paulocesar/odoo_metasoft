{ C, _, A } = require('../core/requires')

module.exports = C('configs', {
    post_listaLogin: () ->
        @ms.crud().listWithEmpresa('login', @sendDataOrError)

    post_upsertLogin: () ->
        data = _.extend({ @empresaId }, @json())
        @ms.crud().upsertWithEmpresa('login', data, @sendDataOrError)

    post_removeLogin: () ->
        @ms.crud().remove('login', @json(), @sendDataOrError)

    post_listaCentroCusto: () ->
        @ms.crud().listWithEmpresa('centroCusto', @sendDataOrError)

    post_upsertCentroCusto: () ->
        data = _.extend({ @empresaId }, @json())
        @ms.crud().upsertWithEmpresa('centroCusto', data, @sendDataOrError)

    post_removeCentroCusto: () ->
        @ms.crud().remove('centroCusto', @json(), @sendDataOrError)

})
