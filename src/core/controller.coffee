express = require('express')
_ = require('underscore')
Context = require('./context')
config = require('../../config')

helpers = {
    json: () -> JSON.parse(req.body.data)
    sendData: (data) -> @res.json({ success: true, data: JSON.stringify(data) })
    sendError: (err) -> @res.send({ status: false, data: JSON.stringify(err) })

    sendErrorOrData: (err, data) ->
        return @sendError(err) if err?
        @sendData(data)

    onSuccess: (cb) ->
        return (err, data) ->
            return @sendError(err) if err?
            cb(data)
}

class Controller

    constructor: (@name) ->
        @router = express.Router()
        @extra = {}

    done: () -> return @router

    helpers: (@extra) -> @

    requireLogin: (roles) ->
        ###
        router.use((req, res, next) ->
          # login stuff
          next()
        })
        ###
        return @

    get: (action, cb) -> @_addEndpoint('get', action, cb)
    post: (action, cb) -> @_addEndpoint('post', action, cb)

    _addEndpoint: (method, action, cb) ->
        path = "/#{@name}/#{action}"

        @router[method.toLowerCase()](path, (req, res) =>
            db = require('knex')(config.database)

            data = { req, res, db, ms: new Context(db) }

            _.bind(cb, _.extend(data, helpers, @extra))()
        )

        console.log("#{method.toUpperCase()} #{path}")
        return @

module.exports = (name) -> new Controller(name)
