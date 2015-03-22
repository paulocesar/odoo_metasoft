{ C, A, _ } = require('../core/requires')

toDictionary = (content, field = 'id') ->
    contentByField = {}

    for c in content
        contentByField[c[field]] = c

    return contentByField

module.exports = C('metasoft', {
    get_index: () ->
        # Centro de Custo / Forma de Pagamento / Conta Financeira

        @getBasicItems((err, data) =>
            return @sendError(err) if err?

            renderContent = {
                title: 'Metasoft'
                jsData: JSON.stringify(_.extend({ @empresaId }, data))
            }


            @res.render('metasoft/index', renderContent)
        )

    getBasicItems: (callback) ->
        A.parallel({
            centroCustos: (cb) =>
                @db.select('id', 'nome')
                    .from('centroCusto')
                    .where('empresaId', @empresaId)
                    .orderBy('nome', 'asc')
                    .exec(cb)

            metodoPagamentos: (cb) =>
                @db.select('id', 'nome')
                    .from('metodoPagamento')
                    .where('empresaId', @empresaId)
                    .orderBy('nome', 'asc')
                    .exec(cb)

            contaBancarias: (cb) =>
                @db.select('id', 'banco', 'agencia', 'conta')
                    .from('contaBancaria')
                    .where('empresaId', @empresaId)
                    .orderBy('saldo', 'desc')
                    .exec(cb)

        }, (err, raw) ->
            callback(err) if err?

            data = {
                centroCustoById: toDictionary(raw.centroCustos)
                metodoPagamentoById: toDictionary(raw.metodoPagamentos)
                contaBancariaById: toDictionary(raw.contaBancarias)
            }

            callback(null, data)
        )

})
