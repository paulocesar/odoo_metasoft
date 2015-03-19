{ C, _, A } = require('../core/requires')

module.exports = C('configs', {
    post_listaLogins: () ->
        data = @json()

        @_listaLogins(data.empresaId, @sendDataOrError)

    post_upsertLogin: () ->
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

        A.waterfall(tasks, @sendDataOrError)

    post_removeLogin: () ->
        data = @json()
        @db('login').where('id', data.id).del().exec(@sendDataOrError)

    _listaLogins: (empresaId, cb) ->
        @db.select('*')
            .from('login')
            .where('empresaId', empresaId)
            .exec(cb)

})
