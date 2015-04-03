// Generated by CoffeeScript 1.9.0
(function() {
  var Backbone, Display, Metasoft, ace, fieldValidator, jsRoot, _,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __hasProp = {}.hasOwnProperty,
    __slice = [].slice;

  jsRoot = this;

  _ = jsRoot._, ace = jsRoot.ace, Backbone = jsRoot.Backbone, Metasoft = jsRoot.Metasoft;

  fieldValidator = Metasoft.fieldValidator;

  Display = (function(_super) {
    __extends(Display, _super);

    function Display(opts) {
      _.extend(this, opts);
      this.el = "#display-" + this.name;
      this.template = _.template($("#tpl-display-" + this.name).html());
      if (this.subTpls == null) {
        this.subTpls = {};
      }
      Display.__super__.constructor.apply(this, arguments);
      this.render();
      fieldValidator.apply(this.$el);
    }

    Display.prototype.render = function() {
      return this.$el.html(this.template({
        subTpls: this.subTpls
      }));
    };

    Display.prototype.addToGrid = function() {
      return (this.category != null) || (this.subCategory != null);
    };

    Display.prototype.show = function() {
      return this.$el.show();
    };

    Display.prototype.hide = function() {
      return this.$el.hide();
    };

    Display.prototype.onShow = function() {};

    Display.prototype.onHide = function() {};

    Display.prototype.get = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return Metasoft.get.apply(Metasoft, args);
    };

    Display.prototype.post = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return Metasoft.post.apply(Metasoft, args);
    };

    Display.prototype.postModel = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return Metasoft.postModel.apply(Metasoft, args);
    };

    return Display;

  })(Backbone.View);

  Metasoft.Display = Display;

}).call(this);
