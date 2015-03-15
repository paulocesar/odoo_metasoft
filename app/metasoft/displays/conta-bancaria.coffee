jsRoot = @

{ _, Metasoft } = jsRoot

{ fieldValidator } = Metasoft

class ContaBancaria extends Metasoft.Display
    constructor: (opts) ->
        @events = {
            'click .conta-banco-list tr': 'showBankAccount'
            'click .save': 'onClickSave'
            'click .new': 'onClickReset'
            'keyup .conta-banco-busca': 'filterTerms'
        }

        @tpls = {
            bankList: _.template($('#tpl-display-contaBancaria-itemConta').html())
        }

        @accounts = []

        super

        @post('financeiro/listaContaBancaria', { empresaId: 1 }, @renderAccounts)

    onClickReset: () ->
        fieldValidator.reset(@$el)
        @id = null

        @updateButtonsDom()

    onClickSave: () ->
        data = fieldValidator.getValues(@$el)
        data.id = @id if @id?
        data.empresaId = 1
        @post('financeiro/upsertContaBancaria', data, @renderAccounts)

    renderAccounts: (@accounts) =>
        @$el.find('.conta-banco-list').html(@tpls.bankList({ contas: @accounts }))
        @filterTerms()

    filterTerms: () =>
        query = @$el.find('.conta-banco-busca').val()
        Metasoft.filter(@$el.find('.conta-banco-list'), query)

    showBankAccount: (ev) ->
        @id = $(ev.currentTarget).data('rowid')
        account = _.findWhere(@accounts, { @id })
        fieldValidator.fill(@$el, account)

        @updateButtonsDom()

    updateButtonsDom: () ->
        @$el.find('.new').toggleClass('hidden', !@id?)
        @$el.find('.remove').show('hidden', @id?)

Metasoft.displays.ContaBancaria = ContaBancaria
