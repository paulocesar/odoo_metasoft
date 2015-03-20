jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class Logins extends Metasoft.CrudDisplay
    constructor: (opts) ->

        @urls = {
            list: 'configs/listaLogin'
            upsert: 'configs/upsertLogin'
            remove: 'configs/removeLogin'
        }

        super

Metasoft.displays.Logins = Logins
