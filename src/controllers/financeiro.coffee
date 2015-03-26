{ C, _, A } = require('../core/requires')

module.exports = C('financeiro', {
    post_upsertConta: () ->
        data = @json()
        parcelas = data.parcelas
        conta = _.omit(data, 'parcelas', 'desconto', 'quantParcelas')

        @ms.lancamento().save(conta, parcelas, @sendDataOrError)

    post_listaLancamentos: () ->
        data = @json()
        limit = data.limit || 100
        offset = data.offset || 0

        parcelas = @db('parcela').select(
                'parcela.id as id'
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
            .limit(limit)
            .offset(offset)

        pages = @db('parcela').count('parcela.id as pages')

        A.parallel({
            parcelas: (cb) -> parcelas.exec(cb)
            pages: (cb) -> pages.exec(cb)
        }, (err, raw) =>
            return @sendError(err) if err?
            @sendData({
                parcelas: raw.parcelas
                pages: Math.floor(raw.pages[0].pages / limit)
            })
        )
})
