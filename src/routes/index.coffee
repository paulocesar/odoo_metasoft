_ = require('underscore')
express = require('express')
router = express.Router()

###
router.use((req, res, next) ->
  # login stuff
  next()
})
###

router.get '/', (req, res) ->
    req.ms.sample().sampleSelect((err, data) ->
        res.render('metasoft/index', { title: 'Sample', samples: data })
    )


module.exports = router
