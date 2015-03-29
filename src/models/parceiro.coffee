{ Model, _, A, Context, moment, V } = require('../core/requires')


class Parceiro extends Model
    search: (data, callback) ->
        query = data.query
        limit = data.limit || 4

        q = @db('parceiro').select('id', 'nome').limit(limit)

        unless query
            return q.exec(callback)

        V.demandGoodString(query, 'query')

        q.where('nome', 'like', "%#{query}%").exec(callback)


module.exports = Parceiro
Context::parceiro = () -> new Parceiro(@)
