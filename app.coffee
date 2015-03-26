module.exports = require('./src/core/application')((err, app) ->
    app.set('port', process.env.PORT || 3535)

    server = app.listen(app.get('port'), () ->
      console.log('Express server listening on port ' + server.address().port)
    )
)
