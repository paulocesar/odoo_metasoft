express = require('express')
path = require('path')
favicon = require('serve-favicon')
logger = require('morgan')
bodyParser = require('body-parser')
cookieParser = require('cookie-parser')
session = require('cookie-session')
fs = require('fs')
_ = require('underscore')
A = require('async')

log = require('./logger')

config = require('../../config')
Context = require('./context')
db = require('knex')(config.database)

passport = require('passport')
LocalStrategy = require('passport-local').Strategy

passport.use(new LocalStrategy((username, senha, next) ->

    onDone = (err, logins) ->
        return next(err) if err?

        login = logins[0]

        # TODO: melhorar seguraca
        if login? && senha == login.senha
            return next(null, _.omit(login, 'senha'))

        next(null, false, { message: 'Login ou senha incorretos' })

    db('login')
        .select('id', 'login', 'senha', 'empresaId', 'papel', 'nome')
        .where('login', username)
        .exec(onDone)
))

passport.serializeUser((user, done) ->
  done(null, user)
)

passport.deserializeUser((user, done) ->
  done(null, user)
)

class Application
    constructor: (callback) ->
        Context.init(db, (err) =>
            return callback(err) if err?

            @startExpress()
            @injectControllers()
            @configureErrorHandlers()

            callback(null, @expressApp())
        )

    expressApp: () -> @app

    startExpress: () ->
        @app = express()

        srcPath = path.join(__dirname, '..')

        @app.set('views', path.join(srcPath, 'views'))
        @app.set('view engine', 'ejs')
        # uncomment after placing your favicon in /public
        #@app.use(favicon(__dirname + '/public/favicon.ico'));
        @app.use(logger('dev'))
        @app.use(bodyParser.json())
        @app.use(bodyParser.urlencoded({ extended: false }))
        @app.use(cookieParser())
        @app.use(session({ keys: ['kasbsa9da&gd', 'jnasd8yabyb'] }))
        @app.use(express.static(path.join(srcPath, 'public')))
        @app.use((req, res, next) ->
            req.db = db
            next()
        )

        @app.use(passport.initialize());
        @app.use(passport.session());

    injectControllers: () ->
        requireDirs = [ 'controllers' ]
        excludeFiles = [ ]

        for d in requireDirs
            basePath = path.join(__dirname, '..', d)
            fs.readdirSync(basePath)
                .forEach((file) =>
                    f = file.replace('.coffee','')
                    if (excludeFiles.indexOf(f) == -1)
                        @app.use(require(path.join(basePath, f)))
                )

    configureErrorHandlers: () ->
        @app.use((req, res, next) ->
            err = new Error('Not Found')
            err.status = 404
            next(err)
        )

        if @app.get('env') == 'development'
            @app.use((err, req, res, next) ->
                res.status(err.status || 500)
                res.render('error', {
                    message: err.message
                    error: err
                })
                log.logError(err)
            )

        @app.use((err, req, res, next) ->
            res.status(err.status || 500)
            res.render('error', {
                message: err.message
                error: {}
            })
            log.logError(err)
        )

module.exports = (args...) -> new Application(args...)
