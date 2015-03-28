{ Model, _, A, Context, moment } = require('../core/requires')
dict = require('../shared/dictionary')

today = () -> moment().utc().format('YYYY-MM-DD')

filters = {
    apagar: (q) ->
        q.andWhere({ tipoConta: dict.tipoConta.pagar, pago: '0' })
            .andWhere('dataVencimento', '>=', today())

    areceber: (q) ->
        q.andWhere({ tipoConta: dict.tipoConta.receber, pago: '0' })
            .andWhere('dataVencimento', '>=', today())

    vencido: (q) ->
        q.andWhere('pago', '0')
            .andWhere('dataVencimento', '<', today())

    pago: (q) -> q.andWhere({ tipoConta: dict.tipoConta.pagar, pago: '1' })

    recebido: (q) -> q.andWhere({ tipoConta: dict.tipoConta.receber, pago: '1' })

    todos: (q) -> q
}

class Lancamento extends Model
    save: (data, callback) ->
        parcelas = data.parcelas
        conta = @formatRow('conta', data)

        conta.empresaId = @empresaId
        conta.loginId = @login.id
        conta.criadoEm = @datetimeNow()

        @db('conta').insert(conta).exec((err, ids) =>
            return callback(err) if err?

            id = ids[0]

            ps = []

            for p in parcelas
                p.contaId = id
                p.empresaId = @empresaId
                p.dataVencimento = @formatDateLastMinute(p.dataVencimento)
                ps.push(@formatRow('parcela', p))

            @db('parcela').insert(ps).exec(callback)
        )

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
            .innerJoin('conta', 'conta.id', 'parcela.contaId')

        parcelas = @applyFilter(parcelas, data)
        pages = @applyFilter(pages, data)


        A.parallel({
            parcelas: (cb) -> parcelas.exec(cb)
            pages: (cb) -> pages.exec(cb)
        }, (err, raw) =>
            return callback(err) if err?
            callback(null, {
                parcelas: raw.parcelas
                pages: Math.floor(raw.pages[0].pages / limit)
            })
        )

    applyFilter: (q, filter) ->
        { query, status, period, date } = filter

        q.where('parcela.empresaId', @empresaId)

        status ?= ''
        status = status.toLowerCase()

        f = filters[status]

        return f(q) if f?
        return q

module.exports = Lancamento
Context::lancamento = () -> new Lancamento(@)
