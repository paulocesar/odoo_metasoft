{ C, _ } = require('../core/requires')

module.exports = C('metasoft', {
    get_index: () ->
        @res.render('metasoft/index', { title: 'Metasoft' })

})
