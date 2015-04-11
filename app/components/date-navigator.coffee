jsRoot = @

{ Backbone, Metasoft } = jsRoot

todayDate = () -> moment().format('DD/MM/YYYY')
todayMonth = () -> moment().format('MM/YYYY')

class DateNavigator extends Backbone.View
    constructor: (opts) ->
        _.extend(@, opts)

        @period ?= 'qualquer'

        @events = {
            'click .increment, .decrement': 'onClickMoveDate'
        }

        super

        @setPeriod(@period)
        @$('.data').on('dp.change', () => @trigger('date:change'))

    setPeriod: (@period) ->
        unless @period in [ 'dia', 'mes' ]
            @period = 'qualquer'

        $dateField = @$('.data')
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

    onClickMoveDate: (ev) ->
        return if @period == 'qualquer'

        $el = $(ev.currentTarget)
        mustDecrement = $el.hasClass('decrement')
        $date = @$('.data')
        date = $date.val()
        type = 'days'
        format = 'DD/MM/YYYY'

        if @period == 'mes'
            type = 'months'
            format = 'MM/YYYY'

        increment = 1
        increment = -1 if mustDecrement

        d = $date.data("DateTimePicker")
        d.date(moment(date, format).add(increment, type).format(format))

        @trigger('date:change')

Metasoft.DateNavigator = DateNavigator
