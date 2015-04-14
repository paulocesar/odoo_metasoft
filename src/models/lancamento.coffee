{ Model, _, A, Context, moment, V } = require('../core/requires')
dict = require('../shared/dictionary')

today = () -> moment().format('YYYY-MM-DD')

filters = {
    apagar: (q) ->
        q.andWhere({ 'parcela.tipoConta': dict.tipoConta.pagar, pago: '0' })

    areceber: (q) ->
        q.andWhere({ 'parcela.tipoConta': dict.tipoConta.receber, pago: '0' })

    vencido: (q) ->
        q.andWhere('pago', '0')
            .andWhere('dataVencimento', '<', today())

    pago: (q) -> q.andWhere({ 'parcela.tipoConta': dict.tipoConta.pagar, pago: '1' })

    recebido: (q) -> q.andWhere({ 'parcela.tipoConta': dict.tipoConta.receber, pago: '1' })

    todos: (q) -> q
}

queryFields = [
    'dataVencimento',
    'valor',
    'criadoEm',
    'descricao',
    'parceiro.nome',
    'centroCusto.nome',
    'metodoPagamento.nome',
    'contaBancaria.banco',
    'contaBancaria.agencia',
    'contaBancaria.conta'
]

class Lancamento extends Model
    pay: (data, callback) ->
        V.demandGoodObject(data.parcela, 'parcela')
        parcela = @formatRow('parcela', data.parcela)
        parcela.dataVencimento = @formatDate(parcela.dataVencimento)
        parcela.dataPagamento = @formatDateLastMinute(parcela.dataPagamento)
        id = parcela.id
        conta = null

        A.waterfall([
            (cb) => @db('parcela').where({ id, pago: '0' }).exec(cb)

            (parcelas, cb) =>
                V.demandObject(parcelas?[0], 'parcela')
                _.defaults(parcela, parcelas?[0])
                @db('conta').where({ id: parcela.contaId }).exec(cb)

            (contas, cb) =>
                conta = contas?[0]
                V.demandObject(conta, 'conta')

                label = 'contaBancariaOrigemId'
                if conta.tipoConta == 0
                    label = 'contaBancariaDestinoId'

                transf = {}
                transf[label] = conta.contaBancariaId
                transf.valor = parcela.valor
                transf.data = parcela.dataPagamento
                transf.parcelaId = parcela.id
                transf.loginId = @login.id

                @ms.transferencia().create(transf, cb)

            (t, cb) =>
                parcela.pago = '1'

                @db('parcela').update(_.omit(parcela, 'id'))
                    .where({ id }).exec(cb)

        ], (err) =>
            return callback(err) if err?
            callback(null, parcela)
        )

    cancel: (data, callback) ->
        V.demandGoodNumber(data.parcelaId, 'parcelaId')
        id = data.parcelaId

        parcela = null

        A.waterfall([
            (cb) => @db('parcela').where({ id, pago: '1' }).exec(cb)

            (p, cb) =>
                parcela = p?[0]
                V.demandObject(parcela, 'parcela')

                @db('transferencia')
                    .where({ parcelaId: parcela.id, cancelado: '0' })
                    .exec(cb)

        ], (err, t) =>
            return callback(err) if err?

            transferencia = t?[0]
            V.demandObject(transferencia, 'transferencia')

            if !parcela || parcela.pago == '0'
                return callback(null, parcela)

            @ms.transferencia().cancel(transferencia?.id, (err, data) =>
                return callback(err) if err?

                @db('parcela').update({ pago: '0' })
                    .where({ id })
                    .exec(callback)
            )
        )

    save: (data, callback) ->
        parcelas = data.parcelas
        conta = @formatRow('conta', data)

        conta.empresaId = @empresaId
        conta.loginId = @login.id
        conta.criadoEm = @datetimeNow()

        contaId = null

        A.waterfall([
            (cb) => @db('conta').insert(conta).exec(cb)

            (ids, cb) =>
                contaId = ids[0]
                conta.id = contaId

                ps = []

                for p in parcelas
                    p.contaId = contaId
                    p.empresaId = @empresaId
                    p.dataVencimento = @formatDateLastMinute(p.dataVencimento)
                    p.tipoConta = conta.tipoConta
                    p.contaBancariaId = conta.contaBancariaId
                    p.metodoPagamentoId = conta.metodoPagamentoId
                    ps.push(@formatRow('parcela', p))

                @db('parcela').insert(ps).exec(cb)
        ], (err) =>
            return callback(err) if err?
            callback(null, conta)
        )

    createTransactions: (parcelas, callback) ->
        return callback(null, null) if _.isEmpty(parcelas)

        tasks = []
        for p in parcelas
            tasks.push((cb) => @pay({ parcelaId: p.id }, cb))

        A.series(tasks, callback)

    list: (data, callback) ->
        limit = data.limit || 100
        offset = data.offset || 0

        parcelas = @db('parcela').select(
                'parcela.id as id'
                'dataVencimento'
                'criadoEm'
                'valor'
                'pago'
                'contaId'
                'impostoNotaFiscalId'
                'parcela.tipoConta'
                'parcela.descricao'
                'parceiro.nome as parceiroNome'
                'centroCusto.nome as centroCustoNome'
                'contaBancaria.banco as banco'
                'contaBancaria.agencia as agencia'
                'contaBancaria.conta as contaBanco'
                'metodoPagamento.nome as metodoPagamentoNome'
                'centroCustoId'
                'parcela.contaBancariaId'
                'parcela.metodoPagamentoId'
                'status'
            )
            .innerJoin('conta', 'conta.id', 'parcela.contaId')
            .leftJoin('parceiro', 'parceiro.id', 'conta.parceiroId')
            .innerJoin('centroCusto', 'centroCusto.id', 'conta.centroCustoId')
            .innerJoin('contaBancaria', 'contaBancaria.id', 'conta.contaBancariaId')
            .innerJoin('metodoPagamento', 'metodoPagamento.id', 'conta.metodoPagamentoId')
            .orderBy('dataVencimento', 'asc')
            .limit(limit)
            .offset(offset)

        parcelas = @applyFilter(parcelas, data)


        A.parallel({
            parcelas: (cb) -> parcelas.exec(cb)
        }, (err, raw) =>
            return callback(err) if err?
            callback(null, raw)
        )

    applyFilter: (q, filter) ->
        { query, status, period, data } = filter

        q.where('parcela.empresaId', @empresaId)

        q = @applyDateFilter(q, data, 'dataVencimento') if data
        q = @applyQueryFilter(q, query, queryFields) if query

        status ?= ''
        status = status.toLowerCase()

        f = filters[status]

        return f(q) if f?
        return q

module.exports = Lancamento
Context::lancamento = () -> new Lancamento(@)
