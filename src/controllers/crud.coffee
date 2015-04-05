{ C, _ } = require('../core/requires')

module.exports = C('crud', {
    post_get: () ->
        d = @json()
        @ms.crud().get(d.table, d.id, @sendDataOrError)

    post_list: () ->
        d = @json()
        @ms.crud().list(d.table, d.withEmpresa, @sendDataOrError)

    post_upsert: () ->
        d = @json()
        table = d.table
        data = _.extend({ @empresaId }, d.data)
        @ms.crud().upsert(table, data, @sendDataOrError)

    post_remove: () ->
        d = @json()
        @ms.crud().remove(d.table, d.data, @sendDataOrError)

    post_model: () ->
        { model, action, data } = @json()
        data ?= {}

        unless _.isFunction(@ms[model])
            return @sendError("Cannot find model '#{model}'")

        m = @ms[model]()

        unless _.isFunction(m[action])
            return @sendError("Cannot find action '#{action}'")

        return m[action](data, @sendDataOrError)
})
