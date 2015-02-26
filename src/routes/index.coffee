_ = require('underscore')
express = require('express')
router = express.Router()

router.get '/', (req, res) ->
    db = req.db

    res.render('metasoft/index', { title: 'Sample' })

module.exports = router
