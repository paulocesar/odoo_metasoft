jsRoot = @

{ _, Metasoft } = jsRoot
{ money } = Metasoft

rgxNotBankDigit = /[^\dx]/g
rgxNotDigit = /[^\d]/g

inputBackgroundColor = '#FFF9F4'

errorLabel = {
    apply: (f, msg) ->
        if f.next().hasClass('error-message')
            return

        f.css('background-color', inputBackgroundColor)

        if msg
            f.after("""
                <div class='error-message'>
                    <span class='glyphicon glyphicon-warning-sign'></span>
                    #{msg}
                </div>
            """)

    remove: (f) ->
        errEl = f.next()

        unless errEl.hasClass('error-message')
            return

        f.css('background-color', 'white')
        errEl.remove()

    check: (f, isValid, message) ->
}

validators = {
    'not-empty': {
        test: (v) -> $.trim(v) != ''
        message: 'Não pode ser vazio'
    }

    'not-zero': {
        test: (v) -> $.trim(v) not in [ '', 0, '0', 'R$ 0,00' ]
        message: 'Não pode ser zero'
    }
}

masks = {
    'mask-money': ($el) -> money.applyMask($el)
    'mask-money-positive': ($el) -> money.applyMask($el, { allowNegative: false })
    'mask-money-negative': ($el) ->
        money.applyMask($el, { allowNegative: true })

        func = () ->
            val = $el.maskMoney('unmasked')[0]
            if val > 0
                val = 0 - val
                $el.maskMoney('mask', val)

        $el.on('keyup', func).on('change', func)

    'mask-number-bank': ($el) ->
        func = () ->
            f = $(@)
            val = "#{f.val()}"

            val = val.replace(rgxNotBankDigit, '')

            if val.length > 3
                l = val.length - 1
                val = val.slice(0, -1) + "-" + val.slice(l, l+1)

            f.val(val)

        $el.on('keyup', func).on('change', func).on('focusout', func)

    'mask-only-number': ($el) ->
        func = () ->
            f = $(@)
            f.val("#{f.val()}".replace(rgxNotDigit, ''))

        $el.on('keyup', func).on('change', func).on('focusout', func)

    'mask-date-day': ($el) ->
        $el.datetimepicker({
            viewMode: 'days'
            format: 'DD/MM/YYYY'
        })

    'mask-date-month': ($el) ->
        $el.datetimepicker({
            viewMode: 'months'
            format: 'MM/YYYY'
        })
}

buildValidatorFunc = (v) ->
    return () ->
        f = $(@)

        if v.test(f.val())
            errorLabel.remove(f)
            return

        errorLabel.apply(f, v.message)

hasClasses = (el, arr) ->
    arr = [].concat(arr)

    for cls in arr
        return true if $(el).hasClass(cls)

    return false

hasMoneyClass = (el) ->
    hasClasses(el, ['mask-money',  'mask-money-positive',  'mask-money-negative'])

fieldValidator = {
    apply: (el) ->
        @applyValidators(el, validators)
        @applyMasks(el, masks)

    reset: (el) ->
        $(el).find('input, textarea').css('background-color', 'white')
        $(el).find('.error-message').remove()
        $(el).find('input, textarea').val('')
        $(el).find('input[type="checkbox"]').attr('checked', false)

        $(el).find('select').each(() ->
            s = $(@)
            s.val(s.find("option:first").val())
        )

        m = $(el).find('.mask-money, .mask-money-positive, .mask-money-negative')
        m.val(money.defaultVal)
        money.setColor(m)

    fill: (el, data) ->
        @reset(el)
        $el = $(el)

        for name, value of data
            f = $el.find("[name='#{name}']")

            if f.attr('type') == 'checkbox'
                f.prop('checked', value)
                continue

            if f.hasClass('mask-date-day')
                f.val(moment(value).utc().format('DD/MM/YYYY'))
                continue

            if f.hasClass('mask-date-month')
                f.val(moment(value).utc().format('MM/YYYY'))
                continue

            if hasMoneyClass(f)
                f.addClass(money.getColorCls(value))
                value = money.format(value)

            f.val(value)

        return

    applyValidators: (el, valids) ->
        for cls, data of valids
            func = buildValidatorFunc(data)

            $(el).find(".#{cls}")
                .on('change',func)
                .on('focusout',func)

        return

    applyMasks: (el, mks) ->
        for cls, applyFunc of mks
            applyFunc($(el).find(".#{cls}"))

        return

    isValid: (el, highlightInvalid = false) ->
        $el = $(el)

        isValid = true

        for cls, v of validators
            $el.find(".#{cls}").each(() ->
                f = $(@)

                unless v.test(f.val())
                    isValid = false
                    errorLabel.apply(f, v.message) if highlightInvalid
                    return

                errorLabel.remove(f)
            )

        return isValid

    getUniqueValues: (el) ->
        data = {}

        $(el).find('input.unique').each(() ->
            f = $(@)
            val = if hasMoneyClass(f) then f.maskMoney('unmasked')[0] else f.val()
            val = $.trim(val) if _.isString(val)
            data[f.attr('name')] = val
        )

        return data

    getValues: (el) ->
        data = {}

        $(el).find('input, textarea, select').each(() ->
            f = $(@)
            val = if hasMoneyClass(f) then f.maskMoney('unmasked')[0] else f.val()
            val = $.trim(val) if _.isString(val)
            data[f.attr('name')] = val
        )

        $(el).find('input[type="checkbox"]').each(() ->
            f = $(@)
            data[f.attr('name')] = if f.is(":checked") then '1' else '0'
        )

        $(el).find('.dropdown-search').each(() ->
            f = $(@)
            name = f.data('searchname')
            value = f.data('itemid')
            value = $.trim(value) if _.isString(value)
            data[name] = value
        )

        return data

    removeError: (input) -> errorLabel.remove($(input))
    addError: (input, message) -> errorLabel.apply($(input), message)

    buildSelect: (name, items, template) ->
        template ?= "<option value='{%= id %}'>{%= nome %}</option>"
        tpl = _.template(template)

        unless _.isArray(items)
            items = _.values(items)

        html = ''
        for item in items
            html += tpl(item)

        $("select[name='#{name}']").html(html)
}


Metasoft.fieldValidator = Metasoft.F = fieldValidator
