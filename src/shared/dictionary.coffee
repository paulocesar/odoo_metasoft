jsRoot = @

dictionary = {}

if module?.exports?
    _ = require('underscore')
    module.exports = dictionary
else
    { _ } = jsRoot
    jsRoot.dictionary = dictionary

_.extend(dictionary, {
    bank: {
        "001": "001 - Banco do Brasil"
        "002": "002 - Bradesco"
    }
})
