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
    this.$protoImage = $('.js-proto-image');
    this.$breakParts = $('#js-break-parts');
    this.$breakParts = $('#js-break-parts');
    this.$breakOverlays = this.$breakParts.find('.svg-overlay');
    this.$breakPart1 = this.$breakOverlays.eq(0);
    this.$breakPart2 = this.$breakOverlays.eq(1);
    this.$breakPart3 = this.$breakOverlays.eq(2);
    this.$breakPart4 = this.$breakOverlays.eq(3);
    this.line1 = $('#js-line1').children();
    this.line2 = $('#js-line2').children();
    this.line3 = $('#js-line3').children();
    this.line4 = $('#js-line4').children();
    this.lines = [];
    this.lines.push(this.line1, this.line2, this.line3, this.line4);
    return this.loop = this.loop.bind(this);
  };

  Main.prototype.listeners = function() {
    var $input;
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
        _this.linesEffect();
        return true;
      };
    })(this));
  };

  Main.prototype.linesEffect = function(delay) {
    var it, shakeOffset;
    if (delay == null) {
      delay = 0;
    }
    it = this;
    this.loop();
    this.linesT = new TWEEN.Tween({
      p: 0
    }).to({
      p: 1
    }, 400).onUpdate(function() {
      var colors, i, j, len, line, lines, nP, p, progress, _i, _len, _ref, _results;
      p = this.p;
      nP = 1 - p;
      _ref = it.lines;
      _results = [];
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        lines = _ref[i];
        len = parseInt(lines[0].getAttribute('stroke-dasharray'), 10);
        progress = ((2 * len) * nP) - len;
        colors = ['yellow', 'hotpink', 'cyan'];
        _results.push((function() {
          var _j, _len1, _results1;
          _results1 = [];
          for (j = _j = 0, _len1 = lines.length; _j < _len1; j = ++_j) {
            line = lines[j];
            line.setAttribute('stroke-dashoffset', progress + (j * 100) * nP);
            line.setAttribute('stroke', colors[j]);
            _results1.push(line.setAttribute('stroke-width', 2 * nP));
          }
          return _results1;
        })());
      }
      return _results;
    }).delay(delay).start();
    shakeOffset = 20;
    this.$breakParts.css({
      transform: "translate(" + shakeOffset + ", " + shakeOffset + "px)"
    });
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
    }).easing(TWEEN.Easing.Elastic.Out).delay(delay).start();
    return this.shiftT = new TWEEN.Tween({
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
      t4 = "translate(0, " + (800 * p) + "px) rotate(" + (-15 * p) + "deg)";
      it.$breakPart1.css({
        transform: t1
      });
      it.$breakPart2.css({
        transform: t2
      });
      it.$breakPart3.css({
        transform: t3
      });
      return it.$breakPart4.css({
        transform: t4
      });
    }).delay(delay).start();
  };

  Main.prototype.loop = function() {
    requestAnimationFrame(this.loop);
    return TWEEN.update();
  };

  return Main;

})();

new Main;



},{}]},{},[1])