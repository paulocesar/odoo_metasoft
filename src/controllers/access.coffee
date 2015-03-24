{ C, _, A } = require('../core/requires')
passport = require('passport')

configs = { hasEmpresaId: false }

module.exports = C('access', configs , {
    get_index: () -> @res.render('access/index', { info: '' })

    post_login: () ->
        req = @req
        res = @res
        sendError = @sendError

        passport.authenticate('local', (err, user, info) ->
            return sendError(err) if err?

            if !user
                return res.render('access/index', { info })

            req.login(user, (err) ->
                return sendError(err) if err?
                return res.redirect("/metasoft/index/#{user.empresaId}")
            )
        )(req, res)

    get_logout: () ->
        @req.logout()
        @res.redirect('/access/index')
})
