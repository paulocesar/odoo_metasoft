Mssql = require('../../src/adapters/mssql')

config = require('../config.coffee')

mssql = new Mssql(config.mssql)

q = 'SELECT name FROM master..sysdatabases'

describe('Mssql', () ->
    it('should connect to DB', (done) ->
        mssql.connect((err, data) ->
            return done(err) if (err?)

            done()
        )
    )

    it('should run query', (done) ->
        mssql.query(q, (err, data) ->
            return done(err) if (err?)

            done()
        )
    )

    it('should disconnect from db', (done) ->
        mssql.close()
        mssql.query(q, (err) ->
            return done() if (err?)

            done(new Error('must be an error'))
        )
    )

    it("should execute SQL", (done) ->
        mssql.execute(q, (err, data) ->
            return done(err) if (err?)

            data.should.be.array
            done()
        )
    )
)
