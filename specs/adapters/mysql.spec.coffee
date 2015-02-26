Mysql = require('../../src/adapters/mysql')

config = require('../config.coffee')

mysql = new Mysql(config.mysql)

q = "show databases"

describe('Mysql', () ->

    it("should connect to DB", (done) ->
        mysql.connect(done)
    )

    it("should run a query", (done) ->
        mysql.query(q, (err, data) ->
            return done(err) if (err?)

            data.should.be.array

            done()
        )
    )

    it("should close connection", () ->
        mysql.close()
    )

    it("shouldn't run a query", (done) ->
        mysql.query(q, (err, data) ->
            return done() if (err?)
            done(new Error("execute query is working"))
        )
    )

    it("should execute SQL", (done) ->
        mysql.execute(q, (err, data) ->
            return done(err) if (err?)

            data.should.be.array
            done()
        )
    )
)
