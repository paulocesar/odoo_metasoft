jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class CrudDisplay extends Metasoft.Display
    constructor: (opts) ->
        @urls ?= {}
        @tpls ?= {}
        @events ?= {}

        _.defaults(@events, {
            'click .crud-list tr': 'onClickItemList'
            'click .save': 'onClickSave'
            'click .new': 'onClickReset'
            'click .remove': 'onClickRemove'
            'keyup .crud-busca': 'filterTerms'
        })

        @crudItems = []

        super

        @form = @$el.find('.form-crud')

    onShow: () -> @refreshList()

    refreshList: () ->
        #TODO: remove empresaId from here
        @post(@urls.list, { empresaId: 1 }, @renderItemlist)

    isValid: () -> true

    onClickReset: () ->
        fieldValidator.reset(@form)
        @id = null
        @updateButtonsDom()

    onClickSave: () =>
        valid = fieldValidator.isValidAndUnique(@form, @crudItems, @id, true)
        unless valid && @isValid()
            return

        data = fieldValidator.getValues(@form)
        data.id = @id if @id?
        #TODO: remove empresaId from here
        data.empresaId = 1
        @post(@urls.upsert, data, @renderItemlist)

    onClickRemove: () =>
        @post(@urls.remove, { @id }, (res) =>
            @refreshList()
        )

    renderItemlist: (@crudItems) =>
        @$el.find('.crud-list').html(@tpls.crudList({ items: @crudItems }))
        @filterTerms()
        fieldValidator.reset(@form)

    filterTerms: () =>
        query = @$el.find('.crud-busca').val()
        Metasoft.filter(@$el.find('.crud-list'), query)

    onClickItemList: (ev) ->
        id = $(ev.currentTarget).data('rowid')
        @showItemInForm(id)

    showItemInForm: (@id) ->
        account = _.findWhere(@crudItems, { @id })
        fieldValidator.fill(@form, account)
        @updateButtonsDom()

    updateButtonsDom: () ->
        @$el.find('.new').toggleClass('hidden', !@id?)
        @$el.find('.remove').toggleClass('hidden', !@id?)

Metasoft.CrudDisplay = CrudDisplay
