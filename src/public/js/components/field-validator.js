// Generated by CoffeeScript 1.9.0
(function() {
  var Metasoft, buildValidatorFunc, configureMaskMoney, devaultMaskMoneyVal, errorLabel, fieldValidator, inputBackgroundColor, jsRoot, masks, validators, _;

  jsRoot = this;

  _ = jsRoot._, Metasoft = jsRoot.Metasoft;

  inputBackgroundColor = '#FFF9F4';

  devaultMaskMoneyVal = 'R$ 0,00';

  errorLabel = {
    apply: function(f, msg) {
      if (f.next().hasClass('error-message')) {
        return;
      }
      f.css('background-color', inputBackgroundColor);
      if (msg) {
        return f.after("<div class='error-message'>\n    <span class='glyphicon glyphicon-warning-sign'></span>\n    " + msg + "\n</div>");
      }
    },
    remove: function(f) {
      var errEl;
      errEl = f.next();
      if (!errEl.hasClass('error-message')) {
        return;
      }
      f.css('background-color', 'white');
      return errEl.remove();
    },
    check: function(f, isValid, message) {}
  };

  validators = {
    'not-empty': {
      test: function(v) {
        return $.trim(v) !== '';
      },
      message: 'Não pode ser vazio'
    },
    'not-zero': {
      test: function(v) {
        var _ref;
        return (_ref = $.trim(v)) !== '' && _ref !== 0 && _ref !== '0' && _ref !== 'R$ 0.00';
      },
      message: 'Não pode ser zero'
    }
  };

  configureMaskMoney = function($el, config) {
    if (config == null) {
      config = {};
    }
    _.defaults(config, {
      prefix: 'R$ ',
      thousands: '.',
      decimal: ',',
      allowZero: true,
      allowNegative: true
    });
    $el.maskMoney(config);
    $el.val(devaultMaskMoneyVal);
    return $el.on('keyup', function() {
      var color, value;
      value = $(this).maskMoney('unmasked')[0];
      color = value > 0 ? '#35BA00' : 'black';
      if (value < 0) {
        color = 'red';
      }
      return $(this).css('color', color);
    });
  };

  masks = {
    'mask-money': function($el) {
      return configureMaskMoney($el);
    },
    'mask-money-positive': function($el) {
      return configureMaskMoney($el, {
        allowNegative: false
      });
    }
  };

  buildValidatorFunc = function(v) {
    return function() {
      var f;
      f = $(this);
      if (v.test(f.val())) {
        errorLabel.remove(f);
        return;
      }
      return errorLabel.apply(f, v.message);
    };
  };

  fieldValidator = {
    apply: function(el) {
      this.applyValidators(el, validators);
      return this.applyMasks(el, masks);
    },
    reset: function(el) {
      $(el).find('input, textarea').css('background-color', 'white');
      $(el).find('.error-message').remove();
      $(el).find('.mask-money').val(devaultMaskMoneyVal);
    },
    applyValidators: function(el, valids) {
      var cls, data, func;
      for (cls in valids) {
        data = valids[cls];
        func = buildValidatorFunc(data);
        $(el).find("." + cls).on('change', func).on('focusout', func).on('keyup', func);
      }
    },
    applyMasks: function(el, mks) {
      var applyFunc, cls;
      for (cls in mks) {
        applyFunc = mks[cls];
        applyFunc($(el).find("." + cls));
      }
    },
    isValid: function(el, highlightInvalid) {
      var $el, cls, isValid, v;
      if (highlightInvalid == null) {
        highlightInvalid = false;
      }
      $el = $(el);
      isValid = true;
      for (cls in validators) {
        v = validators[cls];
        $el.find("." + cls).each(function() {
          var f;
          f = $(this);
          if (!v.test(f.val())) {
            isValid = false;
            if (highlightInvalid) {
              errorLabel.apply(f, v.message);
            }
            return;
          }
          return errorLabel.remove(f);
        });
      }
      return isValid;
    }
  };

  Metasoft.components.fieldValidator = fieldValidator;

}).call(this);
