// Generated by CoffeeScript 1.9.0
(function() {
  var Backbone, ContasModal, Metasoft, ace, createParcela, fieldValidator, jsRoot, moment, money, _,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __hasProp = {}.hasOwnProperty,
    __slice = [].slice;

  jsRoot = this;

  _ = jsRoot._, ace = jsRoot.ace, Backbone = jsRoot.Backbone, moment = jsRoot.moment, Metasoft = jsRoot.Metasoft;

  fieldValidator = Metasoft.fieldValidator, money = Metasoft.money;

  createParcela = function(numero, valor) {
    if (numero == null) {
      numero = '1';
    }
    if (valor == null) {
      valor = 0;
    }
    return {
      id: null,
      titulo: "Parcela " + numero,
      dataVencimento: moment().format('DD/MM/YYYY'),
      valor: valor,
      status: 'pendente'
    };
  };

  ContasModal = (function(_super) {
    __extends(ContasModal, _super);

    function ContasModal(opts) {
      _.extend(this, opts);
      this.el = "#modalContas";
      this.subTpls = {
        parcelas: _.template($('#subtpl-display-contas-parcelaItem').html())
      };
      this.events = {
        'show.bs.modal': 'onShow',
        'hide.bs.modal': 'onHide',
        'change .valorBruto': 'onChangeValorBruto',
        'change .valorLiquido': 'onChangeValorLiquido',
        'change .quantParcelas': 'onChangeParcelas',
        'change .desconto': 'onChangeDesconto'
      };
      ContasModal.__super__.constructor.apply(this, arguments);
      fieldValidator.apply(this.$el);
      this.$formTop = this.$el.find('.form-conta-top');
      this.$formBottom = this.$el.find('.form-conta-bottom');
      this.$parcelas = this.$el.find('table .parcelas');
    }

    ContasModal.prototype.onChangeValorBruto = function() {
      var data;
      data = this.getFormData();
      data.valorLiquido = data.valorBruto;
      this.$el.find(".valorLiquido").maskMoney('mask', data.valorBruto);
      this.updateDesconto(data);
      return this.buildParcelas();
    };

    ContasModal.prototype.onChangeValorLiquido = function() {
      var data;
      data = this.getFormData();
      if (data.valorBruto < data.valorLiquido) {
        data.valorBruto = data.valorLiquido;
        this.$el.find(".valorBruto").maskMoney('mask', data.valorLiquido);
      }
      this.updateDesconto(data);
      return this.buildParcelas();
    };

    ContasModal.prototype.onChangeDesconto = function() {
      var data;
      data = this.getFormData();
      if (data.valorBruto < data.desconto) {
        data.valorBruto = 0 - data.desconto;
        this.$el.find(".valorBruto").maskMoney('mask', data.valorBruto);
      }
      data.valorLiquido = data.valorBruto + data.desconto;
      this.$el.find(".valorLiquido").maskMoney('mask', data.valorLiquido);
      this.updateDesconto(data);
      return this.buildParcelas();
    };

    ContasModal.prototype.onChangeParcelas = function() {
      var data, parcelas, quant;
      parcelas = _.filter(this.parcelas, function(p) {
        return p.impostoNotaFiscalId == null;
      });
      data = this.getFormData();
      quant = parseInt(data.quantParcelas);
      if (!quant || parcelas.length === quant) {
        if (!quant) {
          this.$el.find('.quantParcelas').val(parcelas.length);
        }
        return;
      }
      return this.buildParcelas();
    };

    ContasModal.prototype.updateDesconto = function(data) {
      var desconto;
      desconto = 0 - money.round(data.valorBruto - data.valorLiquido);
      return this.$el.find('.desconto').maskMoney('mask', desconto);
    };

    ContasModal.prototype.buildParcelas = function() {
      var data, i, quant, valor, _i;
      data = this.getFormData();
      quant = parseInt(data.quantParcelas);
      valor = money.round(parseFloat(data.valorLiquido) / quant);
      this.parcelas = [];
      for (i = _i = 1; 1 <= quant ? _i <= quant : _i >= quant; i = 1 <= quant ? ++_i : --_i) {
        this.parcelas.push(createParcela(i, valor));
      }
      return this.renderModalParcelas();
    };

    ContasModal.prototype.renderModalParcelas = function() {
      this.$parcelas.html(this.subTpls.parcelas({
        parcelas: this.parcelas
      }));
      return this.$parcelas.find('tr').each(function() {
        return fieldValidator.apply($(this));
      });
    };

    ContasModal.prototype.onShow = function(ev) {
      var $btn, contaId, contaType, title;
      this.resetFormData();
      $btn = $(ev.relatedTarget);
      contaType = $btn.data('contatipo');
      contaId = $btn.data('contaid');
      this.parcelas = [];
      title = 'Conta a Receber';
      this.$el.find('.modal-dialog').removeClass('invert-money-color');
      if (contaType === 'pagar') {
        title = 'Conta a Pagar';
        this.$el.find('.modal-dialog').addClass('invert-money-color');
      }
      if (!contaId) {
        title = "Nova " + title;
        this.parcelas.push(createParcela());
      }
      this.$el.find('.modal-title').html(title);
      return this.renderModalParcelas();
    };

    ContasModal.prototype.resetFormData = function() {
      return fieldValidator.reset(this.$formTop);
    };

    ContasModal.prototype.getFormData = function() {
      var data;
      data = fieldValidator.getValues(this.$formTop);
      _.defaults(data, fieldValidator.getValues(this.$formBottom));
      data.parcelas = [];
      this.$parcelas.find('tr').each(function() {
        return data.parcelas.push(fieldValidator.getValues($(this)));
      });
      return data;
    };

    ContasModal.prototype.onHide = function(ev) {
      return this.$el.find('.modal-dialog').removeClass('invert-money-color');
    };

    ContasModal.prototype.get = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return Metasoft.get.apply(Metasoft, args);
    };

    ContasModal.prototype.post = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return Metasoft.post.apply(Metasoft, args);
    };

    return ContasModal;

  })(Backbone.View);

  Metasoft.modals.Contas = ContasModal;

}).call(this);
