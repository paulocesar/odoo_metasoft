jsRoot = @

{ Metasoft } = jsRoot
tpls = Metasoft.tpls

Metasoft.init("metasoft")
Metasoft.render("layout", { title: 'Metasoft' })

displayHtml = (name) -> "<div id='display-#{name}' class='display'></div>"
menuHtml = (display) ->
    { name, category, subCategory } = display
    "<a href='#page/#{name}' class='list-group-item page-#{name}'>#{subCategory}</a>"

class Application
    constructor: () ->
        @displaysById = {}

        @displaysContainer = Metasoft.container.find('#displayContainer')

        _.each(Metasoft.displays, (method, name) =>
            name = Metasoft.utils.firstToLower(name)
            @displaysContainer.append(displayHtml(name))

            display = new method({ name })
            @displaysById[name] = display
        )

app = window.app = new Application()


MetasoftRouter = Backbone.Router.extend({
    routes: {
        "page/:name": "goToPage"
    }

    goToPage: (name) ->
        @previousPage ?= ''

        app.displaysById[@previousPage]?.onHide()


        $('.display').hide()
        $("#display-#{name}").show()

        @previousPage = name
        app.displaysById[name]?.onShow()
})


metasoftRouter = new MetasoftRouter()
app.metasoftRouter = metasoftRouter

Backbone.history.start()
metasoftRouter.navigate('page/contas')
metasoftRouter.goToPage('contas')

Metasoft.fieldValidator.apply($('body'))
