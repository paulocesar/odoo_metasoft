{ Model, _, A, Context, moment } = require('../core/requires')
dict = require('../shared/dictionary')

today = () -> moment().format('YYYY-MM-DD')
formatDateLastMinute = (d) -> moment(d, 'DD/MM/YYYY').format('YYYY-MM-DD 23:59:59')

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
                p.dataVencimento = formatDateLastMinute(p.dataVencimento)
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
        { query, status, period, data } = filter

        q.where('parcela.empresaId', @empresaId)

        q = @applyDateFilter(q, data) if data

        status ?= ''
        status = status.toLowerCase()

        f = filters[status]

        return f(q) if f?
        return q

    applyDateFilter: (q, date) ->
        date = date.split('/')


        year = _.last(date)
        month = _.last(_.initial(date))

        q = q.whereRaw('YEAR(dataVencimento) = ?', [year])
                .whereRaw('MONTH(dataVencimento) = ?', [month])

        if date.length == 3
            q = q.whereRaw('DAY(dataVencimento) = ?', [date[0]])

        return q

module.exports = Lancamento
Context::lancamento = () -> new Lancamento(@)
