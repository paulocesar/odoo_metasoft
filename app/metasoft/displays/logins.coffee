jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class Logins extends Metasoft.CrudDisplay
    constructor: (opts) ->

        @urls = {
            list: 'configs/listaLogins'
            upsert: 'configs/upsertLogin'
            remove: 'configs/removeLogin'
        }

        @tpls = {
            crudList: _.template($('#tpl-display-loginsListItem').html())
        }

        super

Metasoft.displays.Logins = Logins
