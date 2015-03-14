// Generated by CoffeeScript 1.9.0
(function() {
  var Application, Metasoft, MetasoftRouter, app, displayHtml, jsRoot, menuHtml, metasoftRouter, tpls;

  jsRoot = this;

  Metasoft = jsRoot.Metasoft;

  tpls = Metasoft.tpls;

  Metasoft.init("metasoft");

  Metasoft.render("layout", {
    title: 'Metasoft'
  });

  displayHtml = function(name) {
    return "<div id='display-" + name + "' class='display'></div>";
  };

  menuHtml = function(display) {
    var category, name, subCategory;
    name = display.name, category = display.category, subCategory = display.subCategory;
    return "<a href='#page/" + name + "' class='list-group-item page-" + name + "'>" + subCategory + "</a>";
  };

  Application = (function() {
    function Application() {
      this.displaysById = {};
      this.displaysContainer = Metasoft.container.find('#displayContainer');
      _.each(Metasoft.displays, (function(_this) {
        return function(method, name) {
          var display;
          name = Metasoft.utils.firstToLower(name);
          _this.displaysContainer.append(displayHtml(name));
          display = new method({
            name: name
          });
          return _this.displaysById[name] = display;
        };
      })(this));
    }

    return Application;

  })();

  app = window.app = new Application();

  MetasoftRouter = Backbone.Router.extend({
    routes: {
      "page/:name": "goToPage"
    },
    goToPage: function(name) {
      $('.display').hide();
      return $("#display-" + name).show();
    }
  });

  metasoftRouter = new MetasoftRouter();

  app.metasoftRouter = metasoftRouter;

  Backbone.history.start();

  metasoftRouter.navigate('page/contaBancaria');

  metasoftRouter.goToPage('contaBancaria');

  Metasoft.components.fieldValidator.apply($('body'));

}).call(this);
