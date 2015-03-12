jsRoot = @

{ _, Metasoft } = jsRoot

inputBackgroundColor = '#FFF9F4'
devaultMaskMoneyVal = 'R$ 0,00'

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
        test: (v) -> $.trim(v) not in [ '', 0, '0', 'R$ 0.00' ]
        message: 'Não pode ser zero'
    }
}

masks = {
    'mask-money': ($el) ->
        $el.maskMoney({
            prefix: 'R$ '
            thousands: '.'
            decimals: ','
            allowZero: true
        })

        $el.val(devaultMaskMoneyVal)
}

buildValidatorFunc = (v) ->
    return () ->
        f = $(@)

        if v.test(f.val())
            errorLabel.remove(f)
            return

        errorLabel.apply(f, v.message)

fieldValidator = {
    apply: (el) ->
        @applyValidators(el, validators)
        @applyMasks(el, masks)

    reset: (el) ->
        $(el).find('input, textarea').css('background-color', 'white')
        $(el).find('.error-message').remove()
        $(el).find('.mask-money').val(devaultMaskMoneyVal)
        return

    applyValidators: (el, valids) ->
        for cls, data of valids
            func = buildValidatorFunc(data)
            $(el).find(".#{cls}").on('change',func).on('focusout',func).on('keyup',func)

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
}


Metasoft.components.fieldValidator = fieldValidator
