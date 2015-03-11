jsRoot = @

{ _, ace, Backbone, Metasoft } = jsRoot

class Display extends Backbone.View
    constructor: (opts) ->
        _.extend(@, opts)
        @el = "#display-#{@name}"
        @template = _.template($("#tpl-display-#{@name}").html())

        super

        @render()

    render: () -> @$el.html(@template())

    addToGrid: () -> @category? || @subCategory?

    show: () -> @$el.show()

    hide: () -> @$el.hide()

Metasoft.components.Display = Display
