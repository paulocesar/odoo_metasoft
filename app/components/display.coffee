jsRoot = @

{ _, ace, Backbone, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class Display extends Backbone.View
    constructor: (opts) ->
        _.extend(@, opts)
        @el = "#display-#{@name}"
        @template = _.template($("#tpl-display-#{@name}").html())

        @subTpls ?= {}

        super

        @render()
        fieldValidator.apply(@$el)

    $f: (name) -> @$("[name='#{name}']")

    render: () -> @$el.html(@template({ @subTpls }))

    addToGrid: () -> @category? || @subCategory?

    show: () -> @$el.show()

    hide: () -> @$el.hide()

    onShow: () ->

    onHide: () ->

    lockButtons: () -> @$('button').attr('disabled', 'disabled')
    unlockButtons: () -> @$('button').removeAttr('disabled')

    get: (args...) -> Metasoft.get(args...)
    post: (args...) -> Metasoft.post(args...)
    postModel: (args...) -> Metasoft.postModel(args...)

Metasoft.Display = Display
