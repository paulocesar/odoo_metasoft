jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator, fieldSearch } = Metasoft


loadMoreHtml = () ->
    return """
        <tr style="border: 0px;"><td style='background-color: white; border: 0px;'>
            <button class='load-more btn btn-default'>Carregar Mais</button>
        </td></tr>
    """

class CrudDisplay extends Metasoft.Display
    constructor: (opts) ->
        @tpls ?= {}
        @events ?= {}

        @withEmpresa ?= true
        @uniqueWithEmpresa ?= @withEmpresa
        @limit ?= 100

        _.defaults(@events, {
            'click .crud-list tr': 'onClickItemList'
            'click .save': 'onClickSave'
            'click .new': 'onClickReset'
            'click .remove': 'onClickRemove'
            'click .load-more': 'loadMore'
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
        @search.setOptions({ @table, @withEmpresa, @limit })
        @search.on('search:done', @renderItemlist)

        @form = @$('.form-crud')

    doSearch: () =>
        @search.setOptions({ @offset })
        @search.doSearch()

    loadMore: () =>
        @offset += @limit
        @doSearch()

    onShow: () -> @refreshList()

    refreshList: () =>
        @$('.query').val('')
        @offset = 0
        @doSearch()

    isValid: () -> true

    onClickReset: () -> @resetForm()

    resetForm: () ->
        fieldValidator.reset(@form)
        @id = null
        @updateButtonsDom()

    onClickSave: () =>
        valid = fieldValidator.isValid(@form, true)
        unless valid && @isValid()
            return

        data = {
            @table
            @id
            withEmpresa: @uniqueWithEmpresa
            data: fieldValidator.getUniqueValues(@form)
        }

        @lockButtons()

        @post('crud/duplicatedFields', data, (duplicatedFields) =>
            unless _.isEmpty(duplicatedFields)
                @unlockButtons()
                return @highlightDuplicatedFields(duplicatedFields)

            data = fieldValidator.getValues(@form)
            data.id = @id if @id?
            @post('crud/upsert', { @table, @withEmpresa, data }, () =>
                @refreshList()
                Metasoft.refreshStaticData() if @refreshStaticData
                @unlockButtons()
            )
        )

    highlightDuplicatedFields: (fields) ->
        for f in fields
            fieldValidator.addError(@$f(f), 'Valor já existe')
        return

    onClickRemove: () =>
        @post('crud/remove', { @table, data: { @id } }, (res) =>
            if res.related
                alert('Este item não pode ser removido pois está sendo usado')
            else
                field = "#{@table}ById"

            @refreshList()
            Metasoft.refreshStaticData() if @refreshStaticData
        )

    renderItemlist: (list) =>
        @crudItems = [] unless @offset
        hasMore = false

        if list
            @crudItems = @crudItems.concat(list)
            hasMore = list.length >= @limit

        $l = @$('.crud-list')
        $l.html(@tpls.crudList({ items: @crudItems }))
        $l.append(loadMoreHtml()) if hasMore

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
