_ = require('underscore')
moment = require('moment')

rgxEndsWithId = /[\w_\d]+Id$/

class Model
    constructor: (@context) ->
        @ms = @context
        @db = @context.db
        @empresaId = @context.empresaId
        @login = @context.login
        @schema = @context.schema

    datetimeNow: () -> moment().format('YYYY-MM-DD HH:mm:ss')
    dateNow: () -> moment().format('YYYY-MM-DD')
    formatDate: (d) -> moment(d, 'DD/MM/YYYY').format('YYYY-MM-DD 00:00:00')
    formatDateLastMinute: (d) ->
        return moment(d, 'DD/MM/YYYY').format('YYYY-MM-DD 23:59:59')

    formatRow: (tableName, obj) -> _.pick(obj, @schema[tableName])

    getParentTables: (tableName) ->
        _.chain(@schema[tableName])
            .filter((c) -> rgxEndsWithId.test(c))
            .map((c) -> c.substring(0, c.length - 2))
            .value()

    getChildTables: (tableName) ->
        field = "#{tableName}Id"
        name for name, cols of @schema when field in cols

    applyQueryFilter: (q, query, fieldsOrTable) ->
        query = query.trim().replace('"', '')
        return q unless query

        queries = query.split(" ")
        words = []

        for word in queries when word
            words.push(word)

        return q if _.isEmpty(words)


        fields = fieldsOrTable

        if _.isString(fieldsOrTable)
            fields = []
            for f in (@schema[fieldsOrTable] || [])
                fields.push("#{fieldsOrTable}.#{f}")

            q = @innerJoinParents(q, fieldsOrTable, fields)

        for w in words
            expression = ("#{f} like \"%#{w}%\"" for f in fields)
            expression = "(#{expression.join(' OR ')})"
            q = q.whereRaw(expression)

        return q

    innerJoinParents: (q, table, fields) ->
        searchFields = _.filter(@schema[table], (f) -> !rgxEndsWithId.test(f))
        parents = @getParentTables(table)

        for p in _.omit(parents, 'empresa')
            q = q.innerJoin("#{p}", "#{p}.id", "#{table}.#{p}Id")
            fields.push("#{p}.#{f}") for f in @schema[p]

        return q

    applyDateFilter: (q, date, field) ->
        date = date.split('/')

        year = _.last(date)
        month = _.last(_.initial(date))

        q = q.whereRaw("YEAR(#{field}) = ?", [year])
                .whereRaw("MONTH(#{field}) = ?", [month])

        if date.length == 3
            q = q.whereRaw("DAY(#{field}) = ?", [date[0]])

        return q

module.exports = Model
