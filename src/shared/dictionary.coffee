jsRoot = @

identifiers = {}

if module.exports
    _ = require('underscore')
    module.exports = identifiers
else
    { _ } = jsRoot
    jsRoot.identifiers = identifiers

_.extend(identifiers, {
    bank {
        1: "001 - Banco do Brasil"
        2: "002 - Bradesco"
    }
})
