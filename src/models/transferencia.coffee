{ Model, _, A, Context, moment, V } = require('../core/requires')

class Transferencia extends Model
    create: (transf, callback) ->
        V.demandGoodNumber(transf.loginId, 'loginId')
        V.demandGoodNumber(transf.valor, 'valor')

        tasks = []

        A.parallel({
            origin: (cb) =>
                unless transf.contaBancariaOrigemId
                    return cb()

                @db('contaBancaria')
                    .where({ id: transf.contaBancariaOrigemId })
                    .exec(cb)

            destiny: (cb) =>
                unless transf.contaBancariaDestinoId
                    return cb()

                @db('contaBancaria')
                    .where({ id: transf.contaBancariaDestinoId })
                    .exec(cb)
        }, (err, accounts) =>
            return err if err?
            @makeTransaction(transf, accounts.origin[0], accounts.destiny[0], callback)
        )

    makeTransaction: (data, orig, dest, callback) ->
        A.parallel({
            transference: (cb) =>
                return @db('transferencia').insert(data).exec(cb)

            orig: (cb) =>
                unless orig
                    return cb()

                @db.raw(
                    'UPDATE contaBancaria SET saldo = saldo - ? WHERE id = ?'
                    [data.valor, orig.id]
                )
                .exec(cb)

            dest: (cb) =>
                unless dest
                    return cb()

                @db.raw(
                    'UPDATE contaBancaria SET saldo = saldo + ? WHERE id = ?'
                    [data.valor, dest.id]
                )
                .exec(cb)
        }, callback)

module.exports = Transferencia
Context::transferencia = () -> new Transferencia(@)
