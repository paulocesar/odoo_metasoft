// Generated by CoffeeScript 1.9.0
(function() {
  var Backbone, DropdownSearch, F, Metasoft, V, fieldSearch, jsRoot,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __hasProp = {}.hasOwnProperty;

  jsRoot = this;

  Backbone = jsRoot.Backbone, Metasoft = jsRoot.Metasoft, V = jsRoot.V;

  F = Metasoft.F, fieldSearch = Metasoft.fieldSearch;

  DropdownSearch = (function(_super) {
    __extends(DropdownSearch, _super);

    DropdownSearch.html = function(name) {
      return "<div class=\"dropdown dropdown-search\" data-searchname=\"" + name + "\">\n    <button class=\"btn btn-default dropdown-toggle form-control\" type=\"button\" data-toggle=\"dropdown\" aria-expanded=\"true\">\n        <span class='button-title' style=\"float:left;\">(Nenhum)</span>\n        <span class=\"caret\" style=\"float:right;margin-top: 9px;\"></span>\n    </button>\n    <ul class=\"dropdown-menu\" role=\"menu\" aria-labelledby=\"dropdownMenu1\">\n        <li role=\"presentation\">\n            <input type=\"text\" class='query form-control' name='query' />\n        </li>\n        <li role=\"presentation\">\n            <a role=\"menuitem\" tabindex=\"-1\" href=\"#\" class=\"none\">\n                (Nenhum)\n            </a>\n        </li>\n    </ul>\n</div>";
    };

    DropdownSearch.prototype.itemHtml = function(item) {
      return "<li role=\"presentation .item\">\n    <a role=\"menuitem\" tabindex=\"-1\" href=\"#\" class=\"item\" data-rowid=\"" + item.id + "\">\n        " + item.nome + "\n    </a>\n</li>";
    };

    DropdownSearch.prototype.itemsHtml = function() {
      var html, item, _i, _len, _ref;
      html = '';
      _ref = this.items;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        html += this.itemHtml(item);
      }
      return html;
    };

    function DropdownSearch(opts) {
      this.listItems = __bind(this.listItems, this);
      this.reset = __bind(this.reset, this);
      _.extend(this, opts);
      V.demandGoodString(this.name, 'name');
      V.demandGoodString(this.model, 'model');
      V.demandGoodString(this.action, 'action');
      this.events = {
        'click .dropdown-toggle': 'onClickDropdown',
        'click .query': 'noAction',
        'click .item': 'selectItem',
        'click .none': 'reset'
      };
      DropdownSearch.__super__.constructor.apply(this, arguments);
      this.search = fieldSearch({
        el: this.el,
        model: this.model,
        action: this.action
      });
      this.search.setOptions({
        limit: 5
      });
      this.search.on('search:done', this.listItems);
    }

    DropdownSearch.prototype.value = function() {
      return this.$('.dropdown').data('itemid');
    };

    DropdownSearch.prototype.reset = function() {
      this.$('.button-title').html("(Nenhum)");
      return this.$('.dropdown').data('itemid', '');
    };

    DropdownSearch.prototype.onClickDropdown = function() {
      if (this.$('.dropdown').hasClass('open')) {
        return;
      }
      this.$('.query').val('');
      this.search.doSearch();
      return setTimeout((function(_this) {
        return function() {
          return _this.$('.query').focus();
        };
      })(this), 100);
    };

    DropdownSearch.prototype.noAction = function(ev) {
      return ev.stopPropagation();
    };

    DropdownSearch.prototype.listItems = function(_at_items) {
      this.items = _at_items;
      this.$(".dropdown-menu .item").remove();
      return this.$(".dropdown-menu").append(this.itemsHtml());
    };

    DropdownSearch.prototype.selectItem = function(ev) {
      var $item, id, item;
      ev.preventDefault();
      $item = $(ev.currentTarget);
      id = $item.data('rowid');
      this.$('.dropdown').data('itemid', id);
      item = _.findWhere(this.items, {
        id: id
      });
      return this.$('.button-title').html(item.nome);
    };

    return DropdownSearch;

  })(Backbone.View);

  Metasoft.DropdownSearch = DropdownSearch;

}).call(this);