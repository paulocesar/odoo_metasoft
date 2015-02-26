jsRoot = @

{ $, _ } = jsRoot


Metasoft = {
    VERSION: '0.0.1'

    tpls: {}

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

    render: (name, data = {}) ->
        data = @tpls[name](data)

        unless data?
            throw new Error("Cannot find '#{name}' template screen")

        @container.html(data)

    post: (action, data, callback) ->
        $.post "/#{action}", {data: JSON.stringify(data)}, (raw) =>
            res = @evalResponse(raw.data)

            unless raw.success
                return callback(res)

            callback(null, res)

    evalResponse: (response) -> ( new Function("return #{response}") )()
}

jsRoot.Metasoft = Metasoft
