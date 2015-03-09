jsRoot = @

identifiers = {}

if module.exports
    _ = require('underscore')
    module.exports = identifiers
else
    { _ } = jsRoot
    jsRoot.identifiers = identifiers

_.extend(identifiers, {
    paymentMethods: {
        1: 'Cartão'
        3: 'Crédito'
        5: 'Débito'
        7: 'Espécie'
    }
})
