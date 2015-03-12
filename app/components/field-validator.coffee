jsRoot = @

{ _, Metasoft } = jsRoot

errorLabel = {
    apply: (f, msg) ->
        if f.next().hasClass('error-message')
            return

        f.css('background-color', '#FFE8E8')
        f.after("<div class='error-message'>#{msg}</div>")

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
        test: (v) -> v != ''
        message: 'Não pode ser vazio'
    }

    'not-zero': {
        test: (v) -> v not in [ '', 0, '0', 'R$ 0.00' ]
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
        $el = $(el)

        for cls, data of validators
            func = buildValidatorFunc(data)
            $el.find(".#{cls}").on('change',func).on('focusout',func).on('keyup',func)

        for cls, applyFunc of masks
            applyFunc($el.find(".#{cls}"))

    isValid: (el, highlightInvalid = false) ->
        $el = $(el)
        if $el.find('error-message').length > 0
            return true

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
