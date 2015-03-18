{ C, _, A } = require('../core/requires')

module.exports = C('financeiro', {
    post_listaContaBancaria: () ->
        data = @json()

        @_listaContas(data.empresaId, @sendErrorOrData)

    post_upsertContaBancaria: () ->
        data = @json()
        q = @db('contaBancaria')
        conta = _.omit(data, 'id')
        tasks = []

        if data.id
            tasks.push((cb) ->
                q.where('id', data.id)
                    .update(conta)
                    .exec(cb)
            )
        else
            tasks.push((cb) -> q.insert(conta).exec(cb))

        tasks.push((rows, cb) => @_listaContas(data.empresaId, cb))

        A.waterfall(tasks, @sendErrorOrData)

    _listaContas: (empresaId, cb) ->
        @db.select('*')
            .from('contaBancaria')
            .where('empresaId', empresaId)
            .exec(cb)

})
