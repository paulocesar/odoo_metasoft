util = require('util')
express = require('express')
_ = require('underscore')
Context = require('./context')

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
        router.use((req, res, next) ->
            if !req.user || req.user.role not in roles
                return res.redirect("/")
        )

        return @

    _addEndpoint: (method, action, cb) ->
        path = "/#{@name}/#{action}/:empresaId"

        @router[method.toLowerCase()](path, (req, res) =>
            empresaId = req.params.empresaId

            data = {
                empresaId
                req
                res
                db: req.db
                ms: new Context(req.db, empresaId)

                json: () -> JSON.parse(req.body.data)
                sendData: (data) => res.json({ success: true, data: JSON.stringify(data) })
                sendError: (err) => res.send({ status: false, data: JSON.stringify(err) })
                sendDataOrError: (err, data) =>
                    if err?
                        console.log(util.inspect(err, false, null))
                        return res.send({ status: false, data: JSON.stringify(err) })
                    res.json({ success: true, data: JSON.stringify(data) })
            }

            _.bind(cb, _.extend(data, @content))()
        )

        console.log("#{method.toUpperCase()} #{path}")
        return @

module.exports = (name, content) -> new Controller(name, content)
