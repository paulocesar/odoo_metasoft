jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class CrudDisplay extends Metasoft.Display
    constructor: (opts) ->
        @tpls ?= {}
        @events ?= {}

        @withEmpresa ?= true

        _.defaults(@events, {
            'click .crud-list tr': 'onClickItemList'
            'click .save': 'onClickSave'
            'click .new': 'onClickReset'
            'click .remove': 'onClickRemove'
            'keyup .crud-busca': 'filterTerms'
        })

        @crudItems = []

        super

        _.defaults(@tpls, {
            crudList: _.template($("#tpl-display-#{@name}ListItem").html())
        })

        @form = @$('.form-crud')

    onShow: () -> @refreshList()

    refreshList: () =>
        @post('crud/list', { @table, @withEmpresa }, @renderItemlist)

    isValid: () -> true

    onClickReset: () -> @resetForm()

    resetForm: () ->
        fieldValidator.reset(@form)
        @id = null
        @updateButtonsDom()

    onClickSave: () =>
        valid = fieldValidator.isValidAndUnique(@form, @crudItems, @id, true)
        unless valid && @isValid()
            return

        data = fieldValidator.getValues(@form)
        data.id = @id if @id?
        @post('crud/upsert', { @table, @withEmpresa, data }, @refreshList)

    onClickRemove: () =>
        @post('crud/remove', { @table, data: { @id } }, @refreshList)

    renderItemlist: (@crudItems) =>
        @$('.crud-list').html(@tpls.crudList({ items: @crudItems }))
        @filterTerms()
        @resetForm()

    filterTerms: () =>
        query = @$('.crud-busca').val()
        Metasoft.filter(@$('.crud-list'), query)

    onClickItemList: (ev) ->
        id = $(ev.currentTarget).data('rowid')
        @showItemInForm(id)

    showItemInForm: (@id) ->
        account = _.findWhere(@crudItems, { @id })
        fieldValidator.fill(@form, account)
        @updateButtonsDom()

    updateButtonsDom: () ->
        @$('.new').toggleClass('hidden', !@id?)
        @$('.remove').toggleClass('hidden', !@id?)

Metasoft.CrudDisplay = CrudDisplay
