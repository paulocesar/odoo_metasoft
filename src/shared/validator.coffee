
validator = {}

if module?.exports?
    _ = require('underscore')
    module.exports = validator
else
    jsRoot = @
    { _ } = jsRoot
    jsRoot.validator = jsRoot.V = validator

argumentError = (demand, argName, customMsg) ->
    s = [
        "Argument "
        if argName? then "'#{argName}' " else ""
        "must "
        customMsg ? demand
    ].join('')

    throw new Error(s)

rgxNonWhitespace = /\S/

_.extend(validator, {
    demandNotNil: (a, argName, customMsg) ->
        return true if a?
        argumentError("not be null or undefined", argName, customMsg)

    demandNonEmpty: (a, argName, customMsg) ->
        return validator.isGoodArray(a) if _.isArray(a)

    demandArray: (a, argName, customMsg) ->
        return true if _.isArray(a)
        argumentError("be an array", argName, customMsg)

    demandNonEmptyArray: (a, argName, customMsg) ->
        return true if _.isArray(a) && !_.isEmpty(a)
        argumentError("be a non-empty array", argName, customMsg)

    demandGoodArray: (a, argName, customMsg) ->
        return true if validator.isGoodArray(a)
        argumentError("be a non-empty array free of nil elements", argName, customMsg)

    demandArrayOfStrings: (a, argName, customMsg) ->
        return true if validator.isArrayOfStrings(a)
        argumentError("be an array of strings", argName, customMsg)

    demandArrayOfGoodStrings: (a, argName, customMsg) ->
        return true if validator.isArrayOfGoodStrings(a)
        argumentError("be an array of non-empty, non-all-whitespace strings", argName, customMsg)

    demandArrayOfGoodNumbers: (a, argName, customMsg) ->
        return true if validator.isArrayOfGoodNumbers(a)
        argumentError("be an array of non-infinity, non-NaN numbers", argName, customMsg)

    demandObject: (o, argName, customMsg) ->
        return true if _.isObject(o)
        argumentError("be an object", argName, customMsg)

    demandGoodObject: (o, argName, customMsg) ->
        return true if validator.isGoodObject(o)
        argumentError("be a defined, non-empty object", argName, customMsg)

    demandType: (o, t, argName, customMsg) ->
        return true if validator.isOfType(o, t)
        argumentError("be an object of type '#{t.name || t}'", argName, customMsg)

    demandKeys: (o, keys, argName, customMsg) ->
        return true if validator.hasKeys(o, keys)
        expectedKeys = keys.join(", ")
        argumentError("be a defined object containing [#{expectedKeys}] key(s)", argName, customMsg)

    demandHash: (o, argName, customMsg) ->
        return true if validator.isHash(o)
        argumentError("be a non-empty, non-array object (ie, a hash)", argName, customMsg)

    demandFunction: (f, argName, customMsg) ->
        return true if _.isFunction(f)
        argumentError("be a function", argName, customMsg)

    demandString: (s, argName, customMsg) ->
        return true if _.isString(s)
        argumentError("be a string", argName, customMsg)

    demandGoodString: (s, argName, customMsg) ->
        return true if validator.isGoodString(s)
        argumentError("be a non-empty, non-all-whitespace string", argName, customMsg)

    demandNumber: (n, argName, customMsg) ->
        return true if _.isNumber(n)
        argumentError("be a number", argName, customMsg)

    demandGoodNumber: (n, argName, customMsg) ->
        return true if validator.isGoodNumber(n)
        argumentError("be a number", argName, customMsg)

    demandBoolean: (b, argName, customMsg) ->
        return true if _.isBoolean(b)
        argumentError("be a boolean value", argName, customMsg)

    # See I've already waited too long
    # And all my hope is gone
    demandDate: (d, argName, customMsg) ->
        return true if _.isDate(d)
        argumentError("be a Date", argName, customMsg)

    isHash: (h) -> _.isObject(h) && !_.isEmpty(h) && !_.isArray(h)

    isGoodObject: (o) -> _.isObject(o) && !_.isEmpty(o)

    hasKeys: (o, keys) ->
        validator.demandArrayOfGoodStrings(keys,"keys")
        return false unless validator.isGoodObject(o)
        return _.every(keys, (k) -> k of o)

    isGoodArray: (a) ->
        return false unless _.isArray(a) && !_.isEmpty(a)

        for e in a
            return false unless e?

        return true

    isGoodString: (s) ->
        return false unless _.isString(s) && s.length > 0
        return rgxNonWhitespace.test(s)

    isGoodNumber: (n) ->
        return _.isNumber(n) && _.isFinite(n) && !isNaN(n)

    isArrayOfStrings: (a) ->
        return false unless _.isArray(a)
        for s in a
            return false unless _.isString(s)
        return true

    isArrayOfGoodStrings: (a) ->
        return false unless _.isArray(a)
        for s in a
            return false unless validator.isGoodString(s)
        return true

    isArrayOfGoodNumbers: (a) ->
        return false unless _.isArray(a)
        for n in a
            return false unless validator.isGoodNumber(n)
        return true

    isOfType: (o, t) ->
        validator.demandFunction(t, "t")
        return (o instanceof t)
})

validator.demandNonEmptyObject = validator.demandGoodObject
