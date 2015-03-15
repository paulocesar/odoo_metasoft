{ C, _ } = require('../core/requires')

module.exports = C('financeiro', {
    post_listaContaBancaria: () ->
        data = @json()

        @db.select('*')
            .from('contaBancaria')
            .where('empresaId', data.empresaId)
            .exec(@sendErrorOrData)
})
