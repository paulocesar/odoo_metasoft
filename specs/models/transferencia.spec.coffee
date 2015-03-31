config = require('../config')
Context = require('../../src/core/context')
A = require('async')
assert = require('assert')

db = ms = null
account1Id = account2Id = null

empresaId = 1
login = { id: 1, nome: 'Admin', login: 'admin', papel: 'admin', empresaId }

beforeEach((done) ->
    db = require('knex')(config.database)

    Context.init(db, () ->
        ms = new Context(db, { empresaId, login })

        db('contaBancaria').insert([
            { empresaId, saldo: 100, banco: '000', agencia: '0000', conta: '0001'},
            { empresaId, saldo: 100, banco: '000', agencia: '0000', conta: '0002'}
        ])
        .exec((err, ids) ->
            return done(err) if err?
            account1Id = ids[0]
            account2Id = account1Id + 1
            return done()
        )
    )
)

afterEach((done) ->
    A.series([
        (cb) ->
            db.raw("""
                DELETE t.* FROM transferencia t
                    LEFT JOIN contaBancaria c1 ON t.contaBancariaOrigemId = c1.id
                    LEFT JOIN contaBancaria c2 ON t.contaBancariaDestinoId = c2.id
                WHERE
                    (c1.banco = "000" AND c1.empresaId = #{empresaId})
                    OR (c2.banco = "000" AND c2.empresaId = #{empresaId});
            """).exec(cb)

        (cb) ->
            db('contaBancaria')
                .where({ empresaId, banco: '000' })
                .del()
                .exec(cb)
    ], done)

)

newTransf = (contaBancariaOrigemId, contaBancariaDestinoId, valor) ->
    return {
        contaBancariaOrigemId
        contaBancariaDestinoId
        valor
        loginId: login.id
    }

describe "#create()", () ->
    it 'creates a transaction between accounts and cancel', (done) ->
        t = newTransf(account1Id, account2Id, 100)
        A.waterfall([

            #Make transaction
            (cb) -> ms.transferencia().create(t, cb)
            (res, cb) ->
                t = res
                db('contaBancaria').select('id', 'saldo')
                    .whereIn('id', [account1Id, account2Id])
                    .exec(cb)
            (res, cb) ->
                assert.equal(true, res[0].saldo == 0, "should be 0")
                assert.equal(true, res[1].saldo == 200, "should be 200")
                cb()

            #Cancel transaction
            (cb) -> ms.transferencia().cancel(t.id, cb)
            (res, cb) ->
                db('contaBancaria').select('id', 'saldo')
                    .whereIn('id', [account1Id, account2Id])
                    .exec(cb)
            (res, cb) ->
                assert.equal(true, res[0].saldo == 100, "should be 100")
                assert.equal(true, res[1].saldo == 100, "should be 100")
                cb()

        ], done)

    it 'creates a transaction from 1 account', (done) ->
        t = newTransf(account1Id, null, 100)
        A.waterfall([
            (cb) -> ms.transferencia().create(t, cb)
            (res, cb) ->
                db('contaBancaria').select('id', 'saldo')
                    .whereIn('id', [account1Id, account2Id])
                    .exec(cb)
            (res, cb) ->
                assert.equal(true, res[0].saldo == 0, "should be 0")
                assert.equal(true, res[1].saldo == 100, "should 100")
                cb()
        ], done)

    it 'creates a transaction to 1 account', (done) ->
        t = newTransf(null, account1Id, 100)
        A.waterfall([
            (cb) -> ms.transferencia().create(t, cb)
            (res, cb) ->
                db('contaBancaria').select('id', 'saldo')
                    .whereIn('id', [account1Id, account2Id])
                    .exec(cb)
            (res, cb) ->
                assert.equal(true, res[0].saldo == 200, "should be 200")
                assert.equal(true, res[1].saldo == 100, "should 100")
                cb()
        ], done)
