jsRoot = @

{ _, ace, Backbone, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class Display extends Backbone.View
    constructor: (opts) ->
        _.extend(@, opts)
        @el = "#display-#{@name}"
        @template = _.template($("#tpl-display-#{@name}").html())

        super

        @render()
        fieldValidator.apply(@$el)

    render: () -> @$el.html(@template())

    addToGrid: () -> @category? || @subCategory?

    show: () -> @$el.show()

    hide: () -> @$el.hide()

    onShow: () ->

    onHide: () ->

    get: (args...) -> Metasoft.post(args...)
    post: (args...) -> Metasoft.post(args...)

Metasoft.Display = Display
