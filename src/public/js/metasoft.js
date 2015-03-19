// Generated by CoffeeScript 1.9.0
(function() {
  var $, Metasoft, jsRoot, _;

  jsRoot = this;

  $ = jsRoot.$, _ = jsRoot._;

  Metasoft = {
    VERSION: '0.0.1',
    tpls: {},
    displays: {},
    components: {},
    init: function(appName) {
      this.appName = appName;
      $('body').append("<div id='" + appName + "'></div>");
      this.container = $("#" + appName);
      return $('.tpl').each(function() {
        var $el, name;
        $el = $(this);
        name = $el.attr('id').replace('tpl-', '');
        return Metasoft.tpls[name] = _.template($el.html());
      });
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
    post: function(action, data, callback) {
      return $.post("/" + action + "/" + this.empresaId, {
        data: JSON.stringify(data)
      }, (function(_this) {
        return function(raw) {
          var res;
          res = _this.evalResponse(raw.data);
          if (!raw.success) {
            alert(raw.data);
            return callback(res);
          }
          return callback(res);
        };
      })(this));
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
