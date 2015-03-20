{ Model, _, A, Context } = require('../core/requires')

class Crud extends Model

    listWithEmpresa: (table, callback) ->
        @db.select('*')
            .from(table)
            .where('empresaId', @empresaId)
            .exec(callback)

    upsertWithEmpresa: (table, data, callback) ->
        content = _.omit(data, 'id')
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

        tasks.push((rows, cb) => @listWithEmpresa(table, cb))

        A.waterfall(tasks, callback)

    upsert: (table, data, callback) ->
        content = _.omit(data, 'id')
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

        tasks.push((rows, cb) => @listWithEmpresa(table, cb))

        A.waterfall(tasks, callback)

    list: (table, callback) ->
        @db.select('*')
            .from(table)
            .exec(callback)

    remove: (table, data, callback) ->
        @db(table).where('id', data.id).del().exec(callback)

module.exports = Crud
Context::crud = () -> new Crud(@)
