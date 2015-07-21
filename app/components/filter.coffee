jsRoot = @

{ _, $, Metasoft } = jsRoot

rgxWhitespace = /[\s]+/g
rgxTag = /\<[^>]*\>/g
rgxUnwatedChars = /[,.$-]/g

sanitizeString = (str) ->
    return $.trim(str)
        .replace(rgxWhitespace, ' ')
        .replace(rgxTag, '')
        .replace(rgxUnwatedChars, '')

Metasoft.filter = (el, query = '') ->
    terms = sanitizeString(query).toLowerCase().split(' ')
    terms = _.filter(terms, (t) -> t != '')

    if _.isEmpty(terms)
        $(el).find('tr').removeClass('hidden')
        return

    $(el).find('tr').each(() ->
        hasTerm = true
        $tr = $(@)

        content = ''
        $tr.find('td').each(() ->
            content += ' '
            content += ($(@).html() || '').toLowerCase()
        )

        content = sanitizeString(content)

        for term in terms when content.indexOf(term) == -1
            hasTerm = false

        $tr.toggleClass('hidden', !hasTerm)
    )
