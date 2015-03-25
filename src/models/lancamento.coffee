{ Model, _, A, Context, moment } = require('../core/requires')

formatConta = (c) ->
    _.pick(c, 'id', 'empresaId', 'tipoConta', 'criadoEm', 'descricao',
        'centroCustoId', 'metodoPagamentoId', 'valorBruto', 'valorLiquido',
        'parceiroId', 'contaBancariaId', 'status', 'loginId'
    )

formatParcela = (p) ->
    _.pick(p, 'id', 'dataVencimento', 'valor', 'deducao', 'contaId', 'pago',
        'empresaId', 'impostoNotaFiscalId'
    )

dbNow = () -> moment().format('YYYY-MM-DD HH:mm:ss')

formatDate = (d) ->
    moment(d, 'DD/MM/YYYY').format('YYYY-MM-DD 23:59:59')


class Lancamento extends Model
    save: (conta, parcelas, callback) ->
        conta.empresaId = @empresaId
        conta.loginId = @login.id
        conta.criadoEm = dbNow()
        conta = formatConta(conta)

        @db('conta').insert(conta).exec((err, ids) =>
            return callback(err) if err?

            id = ids[0]

            ps = []

            for p in parcelas
                p.contaId = id
                p.empresaId = @empresaId
                p.dataVencimento = formatDate(p.dataVencimento)
                ps.push(formatParcela(p))

            @db('parcela').insert(ps).exec(callback)
        )


module.exports = Lancamento
Context::lancamento = () -> new Lancamento(@)
