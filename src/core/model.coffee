class Model
    constructor: (@context) ->
        @db = @context.db
        @empresaId = @context.empresaId
        @login = @context.login

module.exports = Model
