// Generated by CoffeeScript 1.9.0
(function() {
  var $, Metasoft, jsRoot, _;

  jsRoot = this;

  $ = jsRoot.$, _ = jsRoot._;

  Metasoft = {
    VERSION: '0.0.1',
    tpls: {},
    displays: {},
    modals: {},
    components: {},
    init: function(appName) {
      this.appName = appName;
      $('body').append("<div id='" + appName + "'></div>");
      this.container = $("#" + appName);
      $('.tpl').each(function() {
        var $el, name;
        $el = $(this);
        name = $el.attr('id').replace('tpl-', '');
        return Metasoft.tpls[name] = _.template($el.html());
      });
      return this.$loader = $('.loader');
    },
    render: function(name, data) {
      if (data == null) {
        data = {};
      }
      data = this.tpls[name](data);
      if (data == null) {
        throw new Error("Cannot find '" + name + "' template screen");
      }
      return this.container.html(data);
    },
    showLoading: function() {
      return this.$loader.show();
    },
    hideLoading: function() {
      return this.$loader.hide();
    },
    get: function(action, data, cb) {
      return this.ajax('get', action, data, cb);
    },
    post: function(action, data, cb) {
      return this.ajax('post', action, data, cb);
    },
    postModel: function(model, action, data, cb) {
      return this.post('crud/model', {
        model: model,
        action: action,
        data: data
      }, cb);
    },
    ajax: function(method, action, data, callback) {
      if (callback == null) {
        callback = function() {};
      }
      this.showLoading();
      return $[method]("/" + action + "/" + this.empresaId, {
        data: JSON.stringify(data)
      }, (function(_this) {
        return function(raw) {
          var res;
          _this.hideLoading();
          res = _this.evalResponse(raw.data);
          if (!raw.success) {
            alert(raw.data);
            return callback(res);
          }
          return callback(res);
        };
      })(this)).fail(function(err) {
        alert('Ocorreu um erro no sistema. Entre em contato com a administrção.');
        return location.reload();
      });
    },
    evalResponse: function(response) {
      return (new Function("return " + response))();
    }
  };

  Metasoft.utils = {
    firstToLower: function(str) {
      return str.charAt(0).toLowerCase() + str.slice(1);
    }
  };

  _.extend(jsRoot.Metasoft, Metasoft);

}).call(this);
