{ C, _ } = require('../core/requires')

module.exports = C('sample', {
    get_index: () ->
        @ms.sample().sampleSelect((err, data) =>
            @renderIndex('Sample', data)
        )

    renderIndex: (title, samples = []) ->
        @res.render('metasoft/index', { title, samples })
})
