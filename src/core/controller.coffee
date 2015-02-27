express = require('express')
_ = require('underscore')

class Controller

    constructor: (@name) ->
        @router = express.Router()
        @extra = {}

    done: () -> return @router

    get: (action, cb) -> @_addEndpoint('get', action, cb)

    post: (action, cb) -> @_addEndpoint('post', action, cb)

    helpers: (@extra) -> @

    _addEndpoint: (method, action, cb) ->
        path = "/#{@name}/#{action}"

        @router[method.toLowerCase()](path, (req, res) =>
            data = { db: req.db, ms: req.ms, req, res }
            _.bind(cb, _.extend(data, @extra))()
        )

        console.log("#{method.toUpperCase()} #{path}")
        return @

    requireLogin: (roles) ->
        ###
        router.use((req, res, next) ->
          # login stuff
          next()
        })
        ###
        return @

module.exports = (name) -> new Controller(name)
