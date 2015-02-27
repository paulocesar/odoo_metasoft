fs = require('fs')

class Context
    constructor: (@db) ->

    @injectModels = () ->
        requireDirs = [ 'models' ]
        excludeFiles = [ ]

        for d in requireDirs
            fs.readdirSync("#{__dirname}/../#{d}").forEach((file) ->

                f = file.replace('.coffee','')
                if (excludeFiles.indexOf(f) == -1)
                    require("#{__dirname}/../#{d}/" + f)
            )

module.exports = Context
