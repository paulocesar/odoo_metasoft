{ Model, _, A, Context } = require('../core/requires')

class Sample extends Model
    sampleSelect: (callback) ->
        @db.select('*').from('sample').exec(callback)

module.exports = Sample
Context::sample = () -> new Sample(@)
