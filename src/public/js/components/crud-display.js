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
      this.onClickRemove = __bind(this.onClickRemove, this);
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
        'click .crud-list tr': 'onClickItemList',
        'click .save': 'onClickSave',
        'click .new': 'onClickReset',
        'click .remove': 'onClickRemove',
        'keyup .crud-busca': 'filterTerms'
      });
      this.crudItems = [];
      CrudDisplay.__super__.constructor.apply(this, arguments);
      _.defaults(this.tpls, {
        crudList: _.template($("#tpl-display-" + this.name + "ListItem").html())
      });
      this.form = this.$el.find('.form-crud');
    }

    CrudDisplay.prototype.onShow = function() {
      return this.refreshList();
    };

    CrudDisplay.prototype.refreshList = function() {
      return this.post(this.urls.list, {}, this.renderItemlist);
    };

    CrudDisplay.prototype.isValid = function() {
      return true;
    };

    CrudDisplay.prototype.onClickReset = function() {
      return this.resetForm();
    };

    CrudDisplay.prototype.resetForm = function() {
      fieldValidator.reset(this.form);
      this.id = null;
      return this.updateButtonsDom();
    };

    CrudDisplay.prototype.onClickSave = function() {
      var data, valid;
      valid = fieldValidator.isValidAndUnique(this.form, this.crudItems, this.id, true);
      if (!(valid && this.isValid())) {
        return;
      }
      data = fieldValidator.getValues(this.form);
      if (this.id != null) {
        data.id = this.id;
      }
      return this.post(this.urls.upsert, data, this.renderItemlist);
    };

    CrudDisplay.prototype.onClickRemove = function() {
      return this.post(this.urls.remove, {
        id: this.id
      }, (function(_this) {
        return function(res) {
          return _this.refreshList();
        };
      })(this));
    };

    CrudDisplay.prototype.renderItemlist = function(_at_crudItems) {
      this.crudItems = _at_crudItems;
      this.$el.find('.crud-list').html(this.tpls.crudList({
        items: this.crudItems
      }));
      this.filterTerms();
      return this.resetForm();
    };

    CrudDisplay.prototype.filterTerms = function() {
      var query;
      query = this.$el.find('.crud-busca').val();
      return Metasoft.filter(this.$el.find('.crud-list'), query);
    };

    CrudDisplay.prototype.onClickItemList = function(ev) {
      var id;
      id = $(ev.currentTarget).data('rowid');
      return this.showItemInForm(id);
    };

    CrudDisplay.prototype.showItemInForm = function(_at_id) {
      var account;
      this.id = _at_id;
      account = _.findWhere(this.crudItems, {
        id: this.id
      });
      fieldValidator.fill(this.form, account);
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
