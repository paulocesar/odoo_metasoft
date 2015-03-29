express = require('express')
_ = require('underscore')
Context = require('./context')
log = require('./logger')

rgxHttpMethod = /^(get|post)_[a-zA-Z]+/

class Controller
    constructor: (@name, @content, configs) ->
        _.extend(@, configs)

        @router = express.Router()
        @roles ?= []
        @hasEmpresaId ?= true

        unless _.isEmpty(@roles)
            @requireLogin()

        for name, func of @content when rgxHttpMethod.test(name)
            httpMethod = name.split('_')
            @_addEndpoint(httpMethod[0], httpMethod[1], func)

        return @router

    done: () -> return @router

    requireLogin: () ->
        roles = @roles
        @router.use((req, res, next) ->
            if !req.user || (req.user.papel not in roles)
                return res.redirect("/access/index")

            next()
        )

        return @

    _addEndpoint: (method, action, cb) ->
        path = "/#{@name}/#{action}"

        if @hasEmpresaId
            path += "/:empresaId"

        @router[method.toLowerCase()](path, (req, res) =>
            empresaId = req.params.empresaId
            login = req.user

            if login && login.papel != 'admin' && login.empresaId != empresaId
                res.redirect("/metasoft/index/#{login.empresaId}")
                return

            data = {
                empresaId
                login
                req
                res
                db: req.db
                ms: new Context(req.db, { empresaId , login })

                json: () -> JSON.parse(req.body.data)
                sendData: (data) => res.json({ success: true, data: JSON.stringify(data) })
                sendError: (err) => res.send({ status: false, data: JSON.stringify(err) })
                sendDataOrError: (err, data) =>
                    if err?
                        log.logError(err)
                        return res.send({ status: false, data: JSON.stringify(err) })
                    res.json({ success: true, data: JSON.stringify(data) })
            }

            _.bind(cb, _.extend(data, @content))()
        )

        console.log("#{method.toUpperCase()} #{path}")
        return @

module.exports = (name, configs, content) ->
    unless content?
        content = configs
        configs = null

    new Controller(name, content, configs)
