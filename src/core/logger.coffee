util = require('util')
_ = require('underscore')

timestamp = () ->
    d = (new Date()).toISOString()
    return "[#{d}] - "

ensureString = (message) ->
    return if _.isString(message) then message else util.inspect(message)

isTTYout = Boolean(process.stdout.isTTY)
isTTYerr = Boolean(process.stderr.isTTY)

LABEL_INFO = if (isTTYout) then "\x1b[36m[info]\x1b[0m" else ''
LABEL_ERROR = if (isTTYerr) then "\x1b[31m[error]\x1b[0m" else ''

logger = {

    logAll: (message) ->
        message =  ensureString(message)
        message = LABEL_INFO + timestamp() + message

        process.stdout.write("#{message}\n")
        process.stderr.write("#{message}\n")


    logInfo: (info, context) ->
        params = [
            LABEL_INFO + timestamp() + ensureString(info)
        ]

        if context?
            params.push(util.inspect(context))

        params.push('')

        process.stdout.write(params.join('\n'))


    logError: (error, context) ->
        params = []

        message = LABEL_ERROR + timestamp()
        if (error instanceof Error)
            message += error.message
            stack = error.stack
        else
            message += ensureString(error)
            stack = (new Error()).stack

        params = [message, stack]

        if context?
            params.push(util.inspect(context))

        params.push('')

        process.stderr.write(params.join('\n'))

}


module.exports = logger
