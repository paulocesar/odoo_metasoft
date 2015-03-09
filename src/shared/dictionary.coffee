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
        1: 'Cheque'
        3: 'Crédito'
        5: 'Débito'
        7: 'Espécie'
        9: 'Transferência'
    }
})
