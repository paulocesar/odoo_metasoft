
defaultConfig = {
    prefix: 'R$ '
    thousands: '.'
    decimal: ','
    allowZero: true
    allowNegative: true
    precision: 2
}



money = {
    defaultVal: 'R$ 0,00'

    applyMask: ($el, config = {}) ->
        _.defaults(config, defaultConfig)

        v = parseFloat($el.val()) || 0.00
        color = @getColor(v)
        v = @format(v)

        $el.maskMoney(config)
        $el.val(v).css('color', color)
        $el.on('keyup', () ->
            value = $(@).maskMoney('unmasked')[0]

            $(@).css('color', money.getColor(value))
        )

    getColor: (value) ->
        color = if value > 0 then '#35BA00' else 'black'
        color = 'red' if value < 0
        return color

    round: (num, decimalPlaces = 2) ->
        d = decimalPlaces || 0
        m = Math.pow(10, d)
        n = +(if d then num * m else num).toFixed(8)
        i = Math.floor(n)
        f = n - i
        if (f == 0.5)
            r = if (i % 2 == 0) then i else i + 1
        else
            r = Math.round(n)

        return if d then r / m else r

    html: (num) -> "<font color='#{ @getColor(num) }'>#{ @format(num) }</font>"

    # http://stackoverflow.com/questions/149055/how-can-i-format-numbers-as-money-in-javascript?answertab=votes#tab-top
    format: (num) ->
        num = @round(num)
        c = defaultConfig.precision
        d = defaultConfig.decimal
        t = defaultConfig.thousands
        s = if num < 0 then "-" else ""
        i = parseInt(num = Math.abs(+num || 0).toFixed(c)) + ""
        j = if (j = i.length) > 3 then j % 3 else 0

        return s + defaultConfig.prefix +
            (if j then i.substr(0, j) + t else "") +
            i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) +
            (if c then d + Math.abs(num - i).toFixed(c).slice(2) else "")

}

Metasoft.money = money
