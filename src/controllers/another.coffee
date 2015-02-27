{ C, _ } = require('../core/requires')

module.exports = C('another')

.get "index", () ->
    @ms.sample().sampleSelect((err, data) =>
        @renderIndex('Another Sample', data)
    )

.get "another", () -> @renderIndex('Another Another')

.helpers {
    renderIndex: (title, samples = []) ->
        @res.render('metasoft/index', { title, samples })
}

.done()
