jsRoot = @

{ _, Metasoft } = jsRoot

class ContaBancaria extends Metasoft.Display
    constructor: (opts) ->
        @events = {
            'click .conta-banco-list tr': 'showBankAccount'
        }

        @tpls = {
            bankList: _.template($('#tpl-display-contaBancaria-itemConta').html())
        }

        super

        @renderAccounts()


    renderAccounts: (accounts) ->
        accounts = []
        for id in [1..100]
            accounts.push({ id, agencia: '1234-x', conta: '12345-6', banco: '123 - Bradesco', saldo: 100 })

        @$el.find('.conta-banco-list').html(@tpls.bankList({ contas: accounts }))

    showBankAccount: (ev) ->
        console.log($(ev.currentTarget).data('rowid'))

Metasoft.displays.ContaBancaria = ContaBancaria
