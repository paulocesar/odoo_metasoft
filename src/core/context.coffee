fs = require('fs')
_ = require('underscore')

class Context
    constructor: (@db, config) ->
        _.extend(@, config)

    @injectModels: () ->
        requireDirs = [ 'models' ]
        excludeFiles = [ ]

        for d in requireDirs
            fs.readdirSync("#{__dirname}/../#{d}").forEach((file) ->

                f = file.replace('.coffee','')
                if (excludeFiles.indexOf(f) == -1)
                    require("#{__dirname}/../#{d}/" + f)
            )

module.exports = Context
