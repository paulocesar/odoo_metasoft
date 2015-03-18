jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class Logins extends Metasoft.CrudDisplay
    constructor: (opts) ->

        @urls = {
            list: 'configs/listaLogins'
            upsert: 'configs/upsertLogins'
        }

        @tpls = {
            crudList: _.template($('#tpl-display-loginsListItem').html())
        }

        super

    isValid: () ->

Metasoft.displays.Logins = Logins
