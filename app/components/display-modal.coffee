jsRoot = @

{ _, Backbone, moment, Metasoft } = jsRoot

{ fieldValidator, money, DropdownSearch } = Metasoft

class DisplayModal extends Backbone.View
    constructor: (opts) ->
        _.extend(@, opts)

        _.defaults(@events, {
            'show.bs.modal': 'onShow'
            'hide.bs.modal': 'onHide'
        })

        super

        @$el.modal({
            backdrop: 'static'
            keyboard: false
            show: false
        })

    isOpen: () -> @$el.attr('aria-hidden') == 'false'

    show: () ->
        @$el.modal('show')
        $('.modal-backdrop').click(@onClickBackdrop)

    hide: () -> @$el.modal('hide')

    $f: (name) -> @$("[name='#{name}']")

    onShow: () ->
    onHide: () ->
    onClickBackdrop: () -> alert('backdrop')

    get: (args...) -> Metasoft.get(args...)
    post: (args...) -> Metasoft.post(args...)
    postModel: (args...) -> Metasoft.postModel(args...)

Metasoft.DisplayModal = DisplayModal
