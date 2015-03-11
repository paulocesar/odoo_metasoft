jsRoot = @

identifiers = {}

if module.exports
    _ = require('underscore')
    module.exports = identifiers
else
    { _ } = jsRoot
    jsRoot.identifiers = identifiers

_.extend(identifiers, {})
