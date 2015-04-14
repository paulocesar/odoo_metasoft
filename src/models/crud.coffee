{ Model, _, A, V, Context } = require('../core/requires')

class Crud extends Model
    get: (table, id, callback) ->
        @db(table).where({ id }).exec((err, d) -> callback(err, d?[0]))

    list: (table, withEmpresa, callback) ->
        q = @db(table).select('*')

        if withEmpresa
            q = q.where('empresaId', @empresaId)

        q.exec(callback)

    duplicatedFields: (raw, callback) ->
        { table, withEmpresa, data, id } = raw
        V.demandGoodString(table, 'table')
        V.demandHash(data, 'data')

        q = @db(table)

        if withEmpresa
            q.where('empresaId', @empresaId)

        if id
            q.where('id', '<>', id)

        q.where(() ->
            me = this
            for field, value of data
                me = me.orWhere(field, value)
        )

        q.exec((err, rows) ->
            return callback(err) if err?

            duplicatedFields = []

            for field, value of data

                for r in rows
                    v1 = "#{r[field]}".toLowerCase()
                    v2 = "#{value}".toLowerCase()
                    if v1 == v2
                        duplicatedFields.push(field)
                        break

            callback(null, duplicatedFields)
        )

    upsert: (table, data, callback) ->
        content = @formatRow(table, _.omit(data, 'id'))
        q = @db(table)
        tasks = []

        if data.id
            tasks.push((cb) ->
                q.where('id', data.id)
                    .update(content)
                    .exec(cb)
            )
        else
            tasks.push((cb) -> q.insert(content).exec(cb))

        A.waterfall(tasks, callback)

    remove: (table, data, callback) ->
        V.demandGoodString(table, 'table')
        V.demandFunction(callback, 'callback')
        V.demandGoodNumber(data.id, 'id')

        @db(table).where('id', data.id).del().exec((err, data) =>
            if err?
                return callback(null, { related: true })
            return callback(null, { related: false })
        )

    # Não deve ser usada frequentemente pois pode gerar joins desnecessarios
    # ou conflito no nome das colunas (apesar de realizar uma busca efetiva)
    search: (data, callback) ->
        V.demandFunction(callback, 'callback')
        { table, withEmpresa, limit, offset, query } = data

        limit ?= 100
        offset ?= 0

        V.demandGoodString(table, 'table')

        q = @db(table).select('*')
        q.where('empresaId', @empresaId) if withEmpresa
        @applyQueryFilter(q, query, table) if query

        q.limit(limit).offset(offset).exec(callback)

module.exports = Crud
Context::crud = () -> new Crud(@)
