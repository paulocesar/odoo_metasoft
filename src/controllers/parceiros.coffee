{ C, _, A } = require('../core/requires')

module.exports = C('parceiros', {
    post_lista: () ->
        @ms.crud().listWithEmpresa('parceiro', @sendDataOrError)

    post_upsert: () ->
        data = _.extend({ @empresaId }, @json())
        @ms.crud().upsertWithEmpresa('parceiro', data, @sendDataOrError)

    post_remove: () ->
        @ms.crud().remove('parceiro', @json(), @sendDataOrError)
})
