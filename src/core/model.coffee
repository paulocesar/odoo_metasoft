class Model
    constructor: (@context) ->
        @db = @context.db
        @empresaId = @context.empresaId

module.exports = Model
