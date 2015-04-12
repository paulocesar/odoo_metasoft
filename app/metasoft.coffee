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

    refreshStaticData: (cb) ->
        cb ?= () -> null
        @get('metasoft/refreshStaticData', {}, (data) =>
            _.extend(@, data)
            @refreshStaticSelects()
        )

    refreshStaticSelects: () ->
        fields = ['centroCusto', 'produtoCategoria', 'metodoPagamento']
        for field in fields
            items = @["#{field}ById"]
            items =  _.sortBy(_.values(items), (i) -> i.nome)
            @fieldValidator.buildSelect("#{field}Id", items)

        items = _.sortBy(_.values(@contaBancariaById), (i) -> i.banco)
        tpl = "<option value='{%= id %}'>{%= Metasoft.formatContaBancaria(id) %}</option>"
        @fieldValidator.buildSelect("contaBancariaId", items, tpl)
        @fieldValidator.buildSelect("contaBancariaOrigemId", items, tpl)
        @fieldValidator.buildSelect("contaBancariaDestinoId", items, tpl)

        f = $("select[name='contaBancariaOrigemId'], select[name='contaBancariaDestinoId']")
        f.prepend('<option value="">(conta externa)</option>')

    formatContaBancaria: (contaId) ->
        c = @contaBancariaById[contaId]
        return "" unless c
        return "#{c.banco} / #{c.agencia} / #{c.conta}"
}


Metasoft.utils = {
    firstToLower: (str) -> str.charAt(0).toLowerCase() + str.slice(1)
}

_.extend(jsRoot.Metasoft, Metasoft)
