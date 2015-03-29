{ Model, _, A, Context, moment } = require('../core/requires')
dict = require('../shared/dictionary')

today = () -> moment().format('YYYY-MM-DD')

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
                'centroCusto.nome as centroCustoNome'
                'contaBancaria.banco as banco'
                'contaBancaria.agencia as agencia'
                'contaBancaria.conta as contaBanco'
                'metodoPagamento.nome as metodoPagamentoNome'
                'centroCustoId'
                'contaBancariaId'
                'metodoPagamentoId'
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

        q = @applyDateFilter(q, data) if data
        q = @applyQueryFilter(q, query) if query


        status ?= ''
        status = status.toLowerCase()

        f = filters[status]

        return f(q) if f?
        return q

    applyQueryFilter: (q, query) ->
        query = query.trim().replace('"', '')
        return q unless query

        queries = query.split(" ")
        words = []

        for word in queries when word
            words.push(word)

        return q if _.isEmpty(words)

        for w in words
            expression = ("#{f} like \"%#{w}%\"" for f in queryFields)
            expression = "(#{expression.join(' OR ')})"
            q = q.whereRaw(expression)

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
