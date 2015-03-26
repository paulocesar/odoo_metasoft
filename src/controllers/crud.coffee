{ C, _ } = require('../core/requires')

module.exports = C('crud', {
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
        d = @json()
        model = @ms[d.model]
        action = d.action

        unless model? && _.isFunction(model)
            return @sendError("Cannot find model '#{d.model}'")

        m = model()

        unless m[action]?
            return @sendError("Cannot find action '#{action}'")

        m.action(d.data || {}, callback)
})
