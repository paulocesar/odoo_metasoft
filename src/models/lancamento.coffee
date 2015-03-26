{ Model, _, A, Context, moment } = require('../core/requires')

class Lancamento extends Model
    save: (conta, parcelas, callback) ->
        conta.empresaId = @empresaId
        conta.loginId = @login.id
        conta.criadoEm = @datetimeNow()
        conta = @formatRow('conta', conta)

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


module.exports = Lancamento
Context::lancamento = () -> new Lancamento(@)
