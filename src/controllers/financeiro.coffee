{ C, _, A } = require('../core/requires')

module.exports = C('financeiro', {
    post_listaContaBancaria: () ->
        @ms.crud().listWithEmpresa('contaBancaria', @sendDataOrError)

    post_upsertContaBancaria: () ->
        data = _.extend({ @empresaId }, @json())
        @ms.crud().upsertWithEmpresa('contaBancaria', data, @sendDataOrError)

    post_removeContaBancaria: () ->
        @ms.crud().remove('contaBancaria', @json(), @sendDataOrError)

    post_upsertConta: () ->
        data = @json()
        parcelas = data.parcelas
        conta = _.omit(data, 'parcelas', 'desconto', 'quantParcelas')

        setTimeout(
            () => @sendData({conta: data})
            3000
        )
})
