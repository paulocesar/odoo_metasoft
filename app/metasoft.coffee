jsRoot = @

{ $, _ } = jsRoot


Metasoft = {
    VERSION: '0.0.1'

    tpls: {}

    displays: {}

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
                alert(raw.data)
                return callback(res)

            callback(res)

    evalResponse: (response) -> ( new Function("return #{response}") )()
}


Metasoft.utils = {
    firstToLower: (str) -> str.charAt(0).toLowerCase() + str.slice(1)
}

jsRoot.Metasoft = Metasoft
