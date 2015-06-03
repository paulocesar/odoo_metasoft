jsRoot = @

{ _, Metasoft, moment } = jsRoot

{ F, modals, fieldSearch, DateNavigator } = Metasoft

loadMoreHtml = () ->
    return """
        <tr style="border: 0px;"><td style='background-color: white; border: 0px;'>
            <button class='load-more'>Carregar Mais</button>
        </td></tr>
    """

class Contas extends Metasoft.Display
    constructor: (opts) ->
        @model = 'lancamento'

        @subTpls = {
            form: _.template($('#subtpl-display-contas-form').html())
            parcelas: _.template($('#subtpl-display-contas-parcelaItem').html())
        }

        @events = {
            'change #contasSearchForm .status': 'doSearch'
            'change #contasSearchForm .periodo': 'onChangePeriodo'
            'click .increment, .decrement': 'onClickMoveDate'
            'click .load-more': 'loadMore'
            'click .list-lancamentos input[name="pago"]': 'onClickPago'
            'click .parcela.clickable': 'onClickParcela'
        }

        super

        @limit = 100

        @modal = new modals.Contas()
        @modal.on('parcela:save', @doSearch)

        @parcelaModal = new modals.Parcela()
        @parcelaModal.on('lancamento:pay', @doSearch)

        @search = fieldSearch({ el: '#contasSearchForm', @model, action: 'list' })
        @search.on('search:done', @renderLancamentos)

        @dateNavigator = new DateNavigator({
            el: '#contasSearchForm .date-navigator'
            period: 'qualquer'
        })
        @dateNavigator.on('date:change', @doSearch)


    doSearch: () =>
        @offset = 0
        @search.setOptions({ @offset, @limit })
        @search.doSearch()

    loadMore: () =>
        @offset += @limit
        @doSearch()

    onShow: () -> @doSearch()

    renderLancamentos: (data) =>
        { parcelas } = data
        $l = @$('.list-lancamentos')

        showLoadMore = parcelas.length >= @limit

        if @offset == 0
            @parcelas = []

        @parcelas = @parcelas.concat(parcelas)

        $l.html(@subTpls.parcelas({ @parcelas }))


        $l.append(loadMoreHtml()) if showLoadMore

    onChangePeriodo: () ->
        $periodField = @$('#contasSearchForm .periodo')
        period = $periodField.val()

        if period != @dateNavigator.period
            @dateNavigator.setPeriod(period)
            @doSearch()

    onClickPago: (ev) ->
        ev.preventDefault()
        ev.stopPropagation()

        $checkbox = $(ev.currentTarget)
        id = $checkbox.parent('td').parent('tr').data('rowid')
        mustPay = $checkbox.is(':checked')

        if mustPay
            @post('crud/get', { table: 'parcela', id }, (parcela) =>
                @parcelaModal.setParcela(parcela)
                @parcelaModal.show('crud')
            )

            return

        if confirm('Deseja realemente cancelar o pagamento?')
            $checkbox.prop('checked', false)
            @postModel('lancamento', 'cancel', { parcelaId: id }, @doSearch)

    onClickParcela: (ev) ->
        ev.preventDefault()
        debugger

Metasoft.displays.Contas = Contas
