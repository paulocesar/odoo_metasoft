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

    addCss: (files) ->
        @addFile({
            files
            appendElement: document.getElementsByTagName( "head" )[0]
            type: 'link'
            extension: 'css'
            urlField: 'href'
            data: {
                type: "text/css"
                rel: "stylesheet"
                media: "screen,print"
            }
        })

    addJs: (files) ->
        @addFile({
            files
            appendElement: document.getElementsByTagName( "body" )[0]
            type: 'script'
            extension: 'js'
            urlField: 'src'
            data: {
                type: "text/javascript"
            }
        })

    addFile: (options) ->
        { files, type, extension, data, appendElement, urlField } = options
        files = [].concat(files)

        for file in files
            link = document.createElement(type)
            link[urlField] = "/#{extension}/#{file}.#{extension}"

            _.extend(link, data)

            appendElement.appendChild(link)
}

jsRoot.Metasoft = Metasoft
