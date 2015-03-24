{ C, A, _ } = require('../core/requires')

toDictionary = (content, field = 'id') ->
    contentByField = {}

    for c in content
        contentByField[c[field]] = c

    return contentByField

configs = { roles: ['admin'] }

module.exports = C('metasoft', configs, {
    get_index: () ->

        @getBasicItems((err, data) =>
            return @sendError(err) if err?

            renderContent = {
                @login
                jsData: JSON.stringify(_.extend({ @empresaId, @login }, data))
            }

            @res.render('metasoft/index', renderContent)
        )

    getBasicItems: (callback) ->
        A.parallel({
            empresa: (cb) =>
                @db.select('id', 'nome')
                    .from('empresa')
                    .where('id', @empresaId)
                    .exec(cb)

            centroCustos: (cb) =>
                @db.select('id', 'nome')
                    .from('centroCusto')
                    .where('empresaId', @empresaId)
                    .orderBy('nome', 'asc')
                    .exec(cb)

            produtoCategoria: (cb) =>
                @db.select('id', 'nome')
                    .from('produtoCategoria')
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
                produtoCategoriaById: toDictionary(raw.produtoCategoria)
                empresa: raw.empresa[0]
            }

            callback(null, data)
        )
})
