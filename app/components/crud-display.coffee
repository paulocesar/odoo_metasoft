jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class CrudDisplay extends Metasoft.Display
    constructor: (opts) ->
        @urls ?= {}
        @tpls ?= {}
        @events ?= {}

        _.defaults(@events, {
            'click .crud-list tr': 'showItemInForm'
            'click .save': 'onClickSave'
            'click .new': 'onClickReset'
            'keyup .crud-busca': 'filterTerms'
        })

        @crudItems = []

        super

    onShow: () ->
        #TODO: remove empresaId from here
        @post(@urls.list, { empresaId: 1 }, @renderItemlist)

    onClickReset: () ->
        fieldValidator.reset(@$el.find('.form-crud'))
        @id = null

        @updateButtonsDom()

    onClickSave: () =>
        form = @$el.find('.form-crud')
        unless fieldValidator.isValidAndUnique(form, @crudItems, @id, true)
            return

        data = fieldValidator.getValues(form)
        data.id = @id if @id?
        data.empresaId = 1
        @post(@urls.upsert, data, @renderItemlist)

    renderItemlist: (@crudItems) =>
        @$el.find('.crud-list').html(@tpls.crudList({ items: @crudItems }))
        @filterTerms()

    filterTerms: () =>
        query = @$el.find('.crud-busca').val()
        Metasoft.filter(@$el.find('.crud-list'), query)

    showItemInForm: (ev) ->
        @id = $(ev.currentTarget).data('rowid')
        account = _.findWhere(@crudItems, { @id })

        form = @$el.find('.form-crud')
        fieldValidator.fill(form, account)

        @updateButtonsDom()

    updateButtonsDom: () ->
        @$el.find('.new').toggleClass('hidden', !@id?)
        @$el.find('.remove').toggleClass('hidden', !@id?)

Metasoft.CrudDisplay = CrudDisplay
