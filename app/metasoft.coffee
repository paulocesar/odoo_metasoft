jsRoot = @

{ $, _ } = jsRoot


Metasoft = {
    VERSION: '0.0.1'

    tpls: {}

    displays: {}

    modals: {}

    components: {}

    init: (appName) ->
        @appName = appName
        $('body').append("<div id='#{appName}'></div>")
        @container = $("##{appName}")

        $('.tpl').each(() ->
            $el = $(@)
            name = $el.attr('id').replace 'tpl-', ''
            Metasoft.tpls[name] = _.template($el.html())
        )

        @$loader = $('.loader')

    render: (name, data = {}) ->
        data = @tpls[name](data)

        unless data?
            throw new Error("Cannot find '#{name}' template screen")

        @container.html(data)

    showLoading: () -> @$loader.show()
    hideLoading: () -> @$loader.hide()

    get: (action, data, cb) -> @ajax('get', action, data, cb)
    post: (action, data, cb) -> @ajax('post', action, data, cb)

    postModel: (model, action, data, cb) ->
        @post('crud/model', { model, action, data }, cb)

    ajax: (method, action, data, callback) ->
        callback ?= () ->
        @showLoading()

        $[method]("/#{action}/#{@empresaId}", {data: JSON.stringify(data)}, (raw) =>
            @hideLoading()
            res = @evalResponse(raw.data)

            unless raw.success
                alert(raw.data)
                return callback(res)

            callback(res)
        ).fail((err) ->
            alert('Ocorreu um erro no sistema. Entre em contato com a administrção.')
            location.reload()
        )

    evalResponse: (response) -> ( new Function("return #{response}") )()
}


Metasoft.utils = {
    firstToLower: (str) -> str.charAt(0).toLowerCase() + str.slice(1)
}

_.extend(jsRoot.Metasoft, Metasoft)
