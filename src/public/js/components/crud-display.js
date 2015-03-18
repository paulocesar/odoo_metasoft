// Generated by CoffeeScript 1.9.0
(function() {
  var CrudDisplay, Metasoft, fieldValidator, jsRoot, _,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __hasProp = {}.hasOwnProperty;

  jsRoot = this;

  _ = jsRoot._, Metasoft = jsRoot.Metasoft;

  fieldValidator = Metasoft.fieldValidator;

  CrudDisplay = (function(_super) {
    __extends(CrudDisplay, _super);

    function CrudDisplay(opts) {
      this.filterTerms = __bind(this.filterTerms, this);
      this.renderItemlist = __bind(this.renderItemlist, this);
      this.onClickSave = __bind(this.onClickSave, this);
      if (this.urls == null) {
        this.urls = {};
      }
      if (this.tpls == null) {
        this.tpls = {};
      }
      if (this.events == null) {
        this.events = {};
      }
      _.defaults(this.events, {
        'click .crud-list tr': 'showItemInForm',
        'click .save': 'onClickSave',
        'click .new': 'onClickReset',
        'keyup .crud-busca': 'filterTerms'
      });
      this.crudItems = [];
      CrudDisplay.__super__.constructor.apply(this, arguments);
    }

    CrudDisplay.prototype.onShow = function() {
      return this.post(this.urls.list, {
        empresaId: 1
      }, this.renderItemlist);
    };

    CrudDisplay.prototype.isValid = function() {};

    CrudDisplay.prototype.onClickReset = function() {
      fieldValidator.reset(this.$el.find('.form-crud'));
      this.id = null;
      return this.updateButtonsDom();
    };

    CrudDisplay.prototype.onClickSave = function() {
      var data, form, valid;
      form = this.$el.find('.form-crud');
      valid = fieldValidator.isValidAndUnique(form, this.crudItems, this.id, true);
      if (!(valid && this.isValid())) {
        return;
      }
      data = fieldValidator.getValues(form);
      if (this.id != null) {
        data.id = this.id;
      }
      data.empresaId = 1;
      return this.post(this.urls.upsert, data, this.renderItemlist);
    };

    CrudDisplay.prototype.renderItemlist = function(_at_crudItems) {
      this.crudItems = _at_crudItems;
      this.$el.find('.crud-list').html(this.tpls.crudList({
        items: this.crudItems
      }));
      return this.filterTerms();
    };

    CrudDisplay.prototype.filterTerms = function() {
      var query;
      query = this.$el.find('.crud-busca').val();
      return Metasoft.filter(this.$el.find('.crud-list'), query);
    };

    CrudDisplay.prototype.showItemInForm = function(ev) {
      var account, form;
      this.id = $(ev.currentTarget).data('rowid');
      account = _.findWhere(this.crudItems, {
        id: this.id
      });
      form = this.$el.find('.form-crud');
      fieldValidator.fill(form, account);
      return this.updateButtonsDom();
    };

    CrudDisplay.prototype.updateButtonsDom = function() {
      this.$el.find('.new').toggleClass('hidden', this.id == null);
      return this.$el.find('.remove').toggleClass('hidden', this.id == null);
    };

    return CrudDisplay;

  })(Metasoft.Display);

  Metasoft.CrudDisplay = CrudDisplay;

}).call(this);