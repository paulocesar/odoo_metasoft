jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class Logins extends Metasoft.CrudDisplay
    constructor: (opts) ->
        @table = 'login'

        super

Metasoft.displays.Logins = Logins
