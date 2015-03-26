{ Model, _, A, Context } = require('../core/requires')

class Crud extends Model
    list: (table, withEmpresa, callback) ->
        q = @db(table).select('*')

        if withEmpresa
            q = q.where('empresaId', @empresaId)

        q.exec(callback)

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

    list: (table, where, callback) ->
        @db.select('*')
            .from(table)
            .exec(callback)

    remove: (table, data, callback) ->
        @db(table).where('id', data.id).del().exec(callback)

module.exports = Crud
Context::crud = () -> new Crud(@)
