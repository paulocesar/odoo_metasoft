fs = require('fs')
_ = require('underscore')
config = require('../../config')

schema = {}

class Context
    constructor: (@db, config) ->
        _.extend(@, config)
        @schema = schema

    @injectModels: () ->
        requireDirs = [ 'models' ]
        excludeFiles = [ ]

        for d in requireDirs
            fs.readdirSync("#{__dirname}/../#{d}").forEach((file) ->

                f = file.replace('.coffee','')
                if (excludeFiles.indexOf(f) == -1)
                    require("#{__dirname}/../#{d}/" + f)
            )

    @init: (db, callback) ->
        Context.injectModels()

        db('information_schema.columns')
            .select('table_name', 'column_name')
            .where('table_schema', config.database.connection.database)
            .exec((err, data) ->
                return callback(err) if err?
                return Context.buildSchema(data, callback)
            )

    @buildSchema: (data, callback) ->
        for row in data
            schema[row.table_name] ?= []
            schema[row.table_name].push(row.column_name)

        callback(null, schema)

module.exports = Context
