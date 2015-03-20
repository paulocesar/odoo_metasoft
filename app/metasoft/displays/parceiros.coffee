jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class Parceiros extends Metasoft.CrudDisplay
    constructor: (opts) ->

        @urls = {
            list: 'parceiros/lista'
            upsert: 'parceiros/upsert'
            remove: 'parceiros/remove'
        }

        super

Metasoft.displays.Parceiros = Parceiros
