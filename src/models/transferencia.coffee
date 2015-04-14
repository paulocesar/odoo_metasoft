{ Model, _, A, Context, moment, V } = require('../core/requires')

class Transferencia extends Model
    list: (data, callback) ->
        { contaBancariaId, query, data, periodo } = data
        V.demandGoodNumber(contaBancariaId, 'contaBancariaId')

        q = @db('transferencia')
            .select(
                'contaBancariaOrigemId'
                'contaBancariaDestinoId'
                'cancelado'
                'transferencia.data as data'
                'transferencia.loginId as loginId'
                'transferencia.valor as valor'
                'conta.descricao as contaDescricao'
                'parcela.descricao as parcelaDescricao'
            )
            .where(() ->
                @where('contaBancariaOrigemId', contaBancariaId)
                    .orWhere('contaBancariaDestinoId', contaBancariaId)
            )
            .leftJoin('parcela', 'parcela.id', 'transferencia.parcelaId')
            .leftJoin('conta', 'conta.id', 'parcela.contaId')

        if data
            q = @applyDateFilter(q, data, 'data')

        q.exec(callback)

    createSeparate: (data, callback) ->
        data.loginId = @login.id
        for k, v of data when !v
            data[k] = null

        data.data = @formatDate(data.data)
        @create(data, callback)

    create: (t, callback) ->
        V.demandGoodNumber(t.loginId, 'loginId')
        V.demandGoodNumber(t.valor, 'valor')
        V.demandGoodString(t.data, 'data')
        V.demandFunction(callback, 'callback')

        tasks = []

        @getAccounts(t, (err, accs) =>
            return err if err?

            A.parallel({
                transference: (cb) => @db('transferencia').insert(t).exec(cb)
                accounts: (cb) =>
                    @updateAccountBalance(t.valor, accs.origin, accs.destiny, cb)
            }, (err, raw) ->
                return callback(err) if err?
                t.id =  raw.transference?[0]
                callback(null, t)
            )
        )

    cancel: (id, callback) ->
        V.demandGoodNumber(id, 'id')
        V.demandFunction(callback, 'callback')

        @db('transferencia').where({ id }).exec((err, data) =>
            return callback(err) if err?
            t = data[0]

            return callback(null, null) unless t

            A.waterfall([
                (cb) => @getAccounts(t, cb)

                (accs, cb) =>
                    @updateAccountBalance(t.valor, accs.destiny, accs.origin, cb)

                (res, cb) =>
                    @db('transferencia').update({ cancelado: '1' })
                        .where({ id })
                        .exec(cb)

            ], (err) ->
                return callback(err) if err?

                t.cancelado = '1'
                callback(null, t)
            )
        )

    getAccounts: (transf, callback) ->
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
        }, (err, raw) ->
            return callback(err) if err?
            callback(null, { origin: raw.origin?[0], destiny: raw.destiny?[0] })
        )

    updateAccountBalance: (value, orig, dest, callback) ->
        A.parallel({
            orig: (cb) =>
                unless orig
                    return cb()

                @db.raw(
                    'UPDATE contaBancaria SET saldo = saldo - ? WHERE id = ?'
                    [value, orig.id]
                )
                .exec(cb)

            dest: (cb) =>
                unless dest
                    return cb()

                @db.raw(
                    'UPDATE contaBancaria SET saldo = saldo + ? WHERE id = ?'
                    [value, dest.id]
                )
                .exec(cb)
        }, callback)

module.exports = Transferencia
Context::transferencia = () -> new Transferencia(@)
