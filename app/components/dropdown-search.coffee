jsRoot = @

{ Backbone, Metasoft, V } = jsRoot
{ F, fieldSearch } = Metasoft

class DropdownSearch extends Backbone.View
    @html: (name) ->
        return """
            <div class="dropdown dropdown-search" data-searchname="#{name}">
                <button class="btn btn-default dropdown-toggle form-control" type="button" data-toggle="dropdown" aria-expanded="true">
                    <span class='button-title' style="float:left;">(Nenhum)</span>
                    <span class="caret" style="float:right;margin-top: 9px;"></span>
                </button>
                <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                    <li role="presentation">
                        <input type="text" class='query form-control' name='query' />
                    </li>
                    <li role="presentation">
                        <a role="menuitem" tabindex="-1" href="#" class="none">
                            (Nenhum)
                        </a>
                    </li>
                </ul>
            </div>
        """

    itemHtml: (item) ->
        return """
            <li role="presentation .item">
                <a role="menuitem" tabindex="-1" href="#" class="item" data-rowid="#{item.id}">
                    #{item.nome}
                </a>
            </li>
        """

    itemsHtml: () ->
        html = ''

        for item in @items
            html += @itemHtml(item)

        return html

    constructor: (opts) ->
        _.extend(@, opts)

        V.demandGoodString(@name, 'name')
        V.demandGoodString(@model, 'model')
        V.demandGoodString(@action, 'action')

        @events = {
            'click .dropdown-toggle': 'onClickDropdown'
            'click .query': 'noAction'
            'click .item': 'selectItem'
            'click .none': 'reset'
        }

        super

        @search = fieldSearch({ @el, @model, @action })
        @search.setOptions({limit: 5})
        @search.on('search:done', @listItems)

    value: () -> @$('.dropdown').data('itemid')

    reset: () =>
        @$('.button-title').html("(Nenhum)")
        @$('.dropdown').data('itemid', '')

    onClickDropdown: () ->
        @$('.query').val('')
        @search.doSearch()

    noAction: (ev) -> ev.stopPropagation()

    listItems: (@items) =>
        @$(".dropdown-menu .item").remove()
        @$(".dropdown-menu").append(@itemsHtml())

    selectItem: (ev) ->
        ev.preventDefault()
        $item = $(ev.currentTarget)
        id = $item.data('rowid')

        @$('.dropdown').data('itemid', id)

        item = _.findWhere(@items, { id })
        @$('.button-title').html(item.nome)

Metasoft.DropdownSearch = DropdownSearch
