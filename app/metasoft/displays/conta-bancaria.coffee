jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class ContaBancaria extends Metasoft.Display
    constructor: (opts) ->
        @events = {
            'click .conta-banco-list tr': 'showBankAccount'
        }

        @tpls = {
            bankList: _.template($('#tpl-display-contaBancaria-itemConta').html())
        }

        super

        @post('financeiro/listaContaBancaria', { empresaId: 1 }, @renderAccounts)

    renderAccounts: (@accounts) =>
        @$el.find('.conta-banco-list').html(@tpls.bankList({ contas: @accounts }))

    showBankAccount: (ev) ->
        id = $(ev.currentTarget).data('rowid')
        account = _.findWhere(@accounts, { id })
        fieldValidator.fill(@$el, account)

Metasoft.displays.ContaBancaria = ContaBancaria
