// Generated by CoffeeScript 1.9.0
(function() {
  var ContaBancaria, Metasoft, fieldValidator, jsRoot, _,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __hasProp = {}.hasOwnProperty;

  jsRoot = this;

  _ = jsRoot._, Metasoft = jsRoot.Metasoft;

  fieldValidator = Metasoft.fieldValidator;

  ContaBancaria = (function(_super) {
    __extends(ContaBancaria, _super);

    function ContaBancaria(opts) {
      this.table = 'contaBancaria';
      ContaBancaria.__super__.constructor.apply(this, arguments);
    }

    return ContaBancaria;

  })(Metasoft.CrudDisplay);

  Metasoft.displays.ContaBancaria = ContaBancaria;

}).call(this);
