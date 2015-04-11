jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator, fieldSearch } = Metasoft

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
        })

        @crudItems = []

        super

        _.defaults(@tpls, {
            crudList: _.template($("#tpl-display-#{@name}ListItem").html())
        })

        @search = fieldSearch({
            el: "#display-#{@name} .crud-search"
            model: 'crud'
            action: 'search'
        })
        @search.setOptions({ @table, @withEmpresa })
        @search.on('search:done', @renderItemlist)

        @form = @$('.form-crud')

    onShow: () -> @refreshList()

    refreshList: () =>
        @$('.query').val('')
        @search.doSearch()

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
        @post('crud/remove', { @table, data: { @id } }, (res) =>
            if res.related
                alert('Este item não pode ser removido pois está sendo usado')

            @refreshList()
        )

    renderItemlist: (list) =>
        @crudItems = list if list
        @$('.crud-list').html(@tpls.crudList({ items: @crudItems }))
        @resetForm()

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
