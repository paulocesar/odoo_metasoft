{ C, _ } = require('../core/requires')

module.exports = C('sample')

.get "index", () ->
    @ms.sample().sampleSelect((err, data) =>
        @renderIndex('Sample', data)
    )

.helpers {
    renderIndex: (title, samples = []) ->
        @res.render('metasoft/index', { title, samples })
}

.done()
