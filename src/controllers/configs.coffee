{ C, _, A } = require('../core/requires')

module.exports = C('configs', {
    post_listaLogins: () ->
        data = @json()

        @_listaLogins(data.empresaId, @sendErrorOrData)

    post_upsertLogins: () ->
        data = @json()
        q = @db('login')
        login = _.omit(data, 'id')
        tasks = []

        if data.id
            tasks.push((cb) ->
                q.where('id', data.id)
                    .update(login)
                    .exec(cb)
            )
        else
            tasks.push((cb) -> q.insert(login).exec(cb))

        tasks.push((rows, cb) => @_listaLogins(data.empresaId, cb))

        A.waterfall(tasks, @sendErrorOrData)

    _listaLogins: (empresaId, cb) ->
        @db.select('*')
            .from('login')
            .where('empresaId', empresaId)
            .exec(cb)

})
