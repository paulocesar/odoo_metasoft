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

        @ms.lancamento().save(conta, parcelas, @sendDataOrError)

    post_listaLancamentos: () ->
        @db('parcela')
            .select(
                'dataVencimento'
                'valor'
                'pago'
                'contaId'
                'impostoNotaFiscalId'

                'tipoConta'
                'descricao'
                'parceiro.nome as parceiroNome'
                'centroCustoId'
                'contaBancariaId'
                'metodoPagamentoId'
                'status'
            )
            .innerJoin('conta', 'conta.id', 'parcela.contaId')
            .leftJoin('parceiro', 'parceiro.id', 'conta.parceiroId')
            .orderBy('dataVencimento', 'asc')
            .exec(@sendDataOrError)
})
