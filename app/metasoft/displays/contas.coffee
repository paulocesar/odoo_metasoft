jsRoot = @

{ _, Metasoft, moment } = jsRoot

{ F, modals, fieldSearch } = Metasoft

todayDate = () -> moment().format('DD/MM/YYYY')
todayMonth = () -> moment().format('MM/YYYY')

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
        }

        super

        @limit = 100

        @modal = new modals.Contas()
        @modal.on('parcela:save', @doSearch)

        @parcelaModal = new modals.Parcela()
        @parcelaModal.on('lancamento:pay', @onLancamentoPay)

        @search = fieldSearch({ el: '#contasSearchForm', @model, action: 'list' })
        @search.on('search:done', @renderLancamentos)

        @$('#contasSearchForm .data').on('dp.change', @doSearch)
        @$('#contasSearchForm .data').data("DateTimePicker").disable()
        @period = 'qualquer'

    doSearch: () =>
        @offset = 0
        @search.setOptions({ @offset, @limit })
        @search.doSearch()

    loadMore: () =>
        @offset += @limit
        @search.setOptions({ @offset })
        @search.doSearch()

    onShow: () -> @doSearch()

    renderLancamentos: (data) =>
        { parcelas } = data
        $l = @$('.list-lancamentos')

        showLoadMore = parcelas.length >= @limit

        if @offset == 0
            @parcelas = parcelas
        else
            @parcelas = @parcelas.concat(parcelas)

        $l.html(@subTpls.parcelas({ @parcelas }))


        $l.append(loadMoreHtml()) if showLoadMore

    onChangePeriodo: () ->
        $periodField = @$('#contasSearchForm .periodo')
        @period = $periodField.val()

        $dateField = @$('#contasSearchForm .data')
        d = $dateField.data("DateTimePicker")

        if @period == 'qualquer'
            d.disable()
            $dateField.val('')

        if @period == 'mes'
            d.enable()
            d.viewMode('months')
            d.format('MM/YYYY')
            d.date(todayMonth())

        if @period == 'dia'
            d.enable()
            d.viewMode('days')
            d.format('DD/MM/YYYY')
            d.date(todayDate())

        @doSearch()

    onClickMoveDate: (ev) ->
        return if @period == 'qualquer'

        $el = $(ev.currentTarget)
        mustDecrement = $el.hasClass('decrement')
        $date = @$('#contasSearchForm .data')
        date = $date.val()
        type = 'days'
        format = 'DD/MM/YYYY'

        if @period == 'mes'
            type = 'months'
            format = 'MM/YYYY'

        increment = 1
        increment = -1 if mustDecrement

        $date.val(moment(date, format).add(increment, type).format(format))

        @doSearch()

    onChangeDate: () ->
        alert('changed')

    onClickPago: (ev) ->
        ev.preventDefault()

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
            @postModel('lancamento', 'cancel', { parcelaId: id }, () => @doSearch)

    onLancamentoPay: (id) ->
        $(".list-lancamentos tr[data-rowid='#{id}'] input[name='pago']")
            .prop('checked', true)

Metasoft.displays.Contas = Contas
