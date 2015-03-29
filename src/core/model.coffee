_ = require('underscore')
moment = require('moment')

class Model
    constructor: (@context) ->
        @ms = @context
        @db = @context.db
        @empresaId = @context.empresaId
        @login = @context.login
        @schema = @context.schema

    datetimeNow: () -> moment().format('YYYY-MM-DD HH:mm:ss')
    dateNow: () -> moment().format('YYYY-MM-DD')
    formatDateLastMinute: (d) ->
        return moment(d, 'DD/MM/YYYY').format('YYYY-MM-DD 23:59:59')

    formatRow: (tableName, obj) -> _.pick(obj, @schema[tableName])


module.exports = Model
