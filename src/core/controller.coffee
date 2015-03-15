express = require('express')
_ = require('underscore')
Context = require('./context')
config = require('../../config')

rgxHttpMethod = /^(get|post)_[a-zA-Z]+/

class Controller

    constructor: (@name, @content) ->
        @router = express.Router()

        for name, func of @content when rgxHttpMethod.test(name)
            httpMethod = name.split('_')
            @_addEndpoint(httpMethod[0], httpMethod[1], func)

        return @router

    done: () -> return @router

    requireLogin: (roles) ->
        ###
        router.use((req, res, next) ->
          # login stuff
          next()
        })
        ###
        return @

    _addEndpoint: (method, action, cb) ->
        path = "/#{@name}/#{action}"

        @router[method.toLowerCase()](path, (req, res) =>
            db = require('knex')(config.database)

            data = {
                req
                res
                db
                ms: new Context(db)

                json: () -> JSON.parse(req.body.data)
                sendData: (data) => res.json({ success: true, data: JSON.stringify(data) })
                sendError: (err) => res.send({ status: false, data: JSON.stringify(err) })
                sendErrorOrData: (err, data) =>
                    if err?
                        return res.send({ status: false, data: JSON.stringify(err) })
                    res.json({ success: true, data: JSON.stringify(data) })
            }

            _.bind(cb, _.extend(data, @content))()
        )

        console.log("#{method.toUpperCase()} #{path}")
        return @

module.exports = (name, content) -> new Controller(name, content)
