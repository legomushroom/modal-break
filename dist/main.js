(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var Main;

Main = (function() {
  function Main(o) {
    this.o = o != null ? o : {};
    this.vars();
    this.listeners();
  }

  Main.prototype.vars = function() {
    this.$effect = $('#js-effect');
    this.$close = $('#js-close-button');
    this.$modal = $('#js-modal');
    this.$modalHolder = $('#js-modal-holder');
    this.$protoImage = $('.js-proto-image');
    this.$breakParts = $('#js-break-parts');
    this.$modalOverlay = $('#js-modal-overlay');
    this.$showModal = $('#js-show-modal');
    this.$circle = $('#js-circle');
    this.$breakParts = $('#js-break-parts');
    this.$breakOverlays = this.$breakParts.find('.svg-overlay');
    this.$breakPart1 = this.$breakOverlays.eq(0);
    this.$breakPart2 = this.$breakOverlays.eq(1);
    this.$breakPart3 = this.$breakOverlays.eq(2);
    this.$breakPart4 = this.$breakOverlays.eq(3);
    this.$lines = $('.js-line').children();
    this.loop = this.loop.bind(this);
    return this.linesEffect();
  };

  Main.prototype.showModal = function() {
    return this.showModalT.start();
  };

  Main.prototype.listeners = function() {
    var $input;
    this.$showModal.on('click', (function(_this) {
      return function() {
        return _this.showModal();
      };
    })(this));
    this.$modal.on('keyup', 'input', function(e) {
      var $it, k, text;
      $it = $(e.target);
      text = $it.val();
      $it.toggleClass('is-fill', !!text);
      if ($it.attr('type') === 'text') {
        text = text.replace(/\s/g, '');
      }
      k = e.keyCode;
      if ((k > 48 && k < 90) || (k === 48 || k === 45 || k === 32)) {
        return $it.val(text);
      }
    });
    $input = null;
    this.$close.on('mouseleave touchstart', function() {
      if ($input != null) {
        $input.removeClass('is-keep-focus');
      }
      return $input = null;
    });
    this.$close.on('mouseenter touchstart', (function(_this) {
      return function() {
        $input = $('input:focus').addClass('is-keep-focus');
        return html2canvas(_this.$modal, {
          onrendered: function(canvas) {
            var dataURL;
            dataURL = canvas.toDataURL();
            return _this.$protoImage.attr('xlink:href', dataURL);
          }
        });
      };
    })(this));
    return this.$close.on('click', (function(_this) {
      return function() {
        _this.$modal.css({
          display: 'none'
        });
        _this.$breakParts.css({
          'z-index': 2,
          opacity: 1
        });
        _this.$effect.show();
        _this.launchEffects();
        return true;
      };
    })(this));
  };

  Main.prototype.linesEffect = function(delay) {
    var colors, it, len, shakeOffset;
    if (delay == null) {
      delay = 0;
    }
    it = this;
    len = 900;
    colors = ['yellow', 'hotpink', 'cyan'];
    this.linesT = new TWEEN.Tween({
      p: 0
    }).to({
      p: 1
    }, 450).onUpdate(function() {
      var i, line, nP, p, progress, _i, _len, _ref;
      p = this.p;
      nP = 1 - p;
      progress = (2 * len) * nP + len;
      _ref = it.$lines;
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        line = _ref[i];
        line.setAttribute('stroke-dashoffset', progress + (i * 100) * nP);
        line.setAttribute('stroke', colors[i]);
        line.setAttribute('stroke-width', 2 * nP);
      }
      return it.$circle.attr({
        'r': 11 * p,
        'stroke-width': 7 * nP,
        'fill': "rgba(" + (~~(0 + 255 * p)) + "," + (~~(255 - 153 * p)) + "," + (~~(255 - 75 * p)) + ", " + nP + ")"
      });
    }).onComplete((function(_this) {
      return function() {
        return _this.$effect.css({
          display: 'none'
        });
      };
    })(this)).delay(delay);
    shakeOffset = 20;
    this.shakeT = new TWEEN.Tween({
      p: 0
    }).to({
      p: 1
    }, 350).onUpdate(function() {
      var nP, p, shake;
      p = this.p;
      nP = 1 - p;
      shake = shakeOffset * nP;
      it.$breakParts.css({
        transform: "translate(" + shake + "px, " + shake + "px)"
      });
      return it.$effect.css({
        transform: "translate(" + (-.75 * shake) + "px, " + (-.5 * shake) + "px)"
      });
    }).easing(TWEEN.Easing.Elastic.Out).delay(delay);
    this.shiftT = new TWEEN.Tween({
      p: 0
    }).to({
      p: 1
    }, 1200).onUpdate(function() {
      var nP, p, shift, t1, t2, t3, t4;
      p = this.p;
      nP = 1 - p;
      shift = 900 * p;
      t1 = "translate(" + (-shift) + "px, " + shift + "px) rotate(" + (-50 * p) + "deg)";
      t2 = "translate(" + (-1270 * p) + "px, " + (500 * p) + "px) rotate(" + (905 * p) + "deg)";
      t3 = "translate(" + (1100 * p) + "px, " + (600 * p) + "px) rotate(" + (-1500 * p) + "deg)";
      t4 = "translate(0, " + (1000 * p) + "px) rotate(" + (-15 * p) + "deg)";
      it.$breakPart1.css({
        transform: t1
      });
      it.$breakPart2.css({
        transform: t2
      });
      it.$breakPart3.css({
        transform: t3
      });
      it.$breakPart4.css({
        transform: t4
      });
      return it.$modalOverlay.css({
        transform: "translate(0, " + (50 * p) + ")",
        opacity: nP
      });
    }).onComplete((function(_this) {
      return function() {
        _this.$modalOverlay.css({
          display: 'none'
        });
        _this.$breakParts.css({
          display: 'none'
        });
        return _this.$modalHolder.css({
          display: 'none'
        });
      };
    })(this)).delay(delay);
    return this.showModalT = new TWEEN.Tween({
      p: 0
    }).to({
      p: 1
    }, 800).easing(TWEEN.Easing.Exponential.Out).onStart((function(_this) {
      return function() {
        _this.shiftT.stop();
        _this.shakeT.stop();
        _this.linesT.stop();
        _this.$modal.css({
          display: 'block',
          opacity: 0
        });
        _this.$breakParts.css({
          display: 'block'
        });
        _this.$modalHolder.css({
          display: 'block'
        });
        _this.$modalOverlay.css({
          display: 'block',
          opacity: 0
        });
        _this.$breakPart1.css({
          transform: 'none'
        });
        _this.$breakPart2.css({
          transform: 'none'
        });
        _this.$breakPart3.css({
          transform: 'none'
        });
        _this.$breakPart4.css({
          transform: 'none'
        });
        _this.$modal.css({
          display: 'block'
        });
        return _this.$breakParts.css({
          'z-index': 0,
          opacity: 0
        });
      };
    })(this)).onUpdate(function() {
      var nP, p;
      p = this.p;
      nP = 1 - p;
      it.$modal.css({
        opacity: p,
        transform: "translateY(" + (15 * nP) + "px)"
      });
      return it.$modalOverlay.css({
        opacity: p
      });
    });
  };

  Main.prototype.launchEffects = function() {
    this.loop();
    this.linesT.start();
    this.shiftT.start();
    return this.shakeT.start();
  };

  Main.prototype.loop = function() {
    requestAnimationFrame(this.loop);
    return TWEEN.update();
  };

  return Main;

})();

new Main;



},{}]},{},[1])