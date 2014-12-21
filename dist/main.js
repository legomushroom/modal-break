(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var Main;

Main = (function() {
  function Main(o) {
    this.o = o != null ? o : {};
    this.vars();
    this.listeners();
  }

  Main.prototype.vars = function() {};

  Main.prototype.listeners = function() {
    var $breakParts, $close, $input, $protoImage, modal, modalH;
    $close = $('#js-close-button');
    modalH = document.querySelector('#js-modal-holder');
    modal = document.querySelector('#js-modal');
    $protoImage = $('.js-proto-image');
    $breakParts = $('#js-break-parts');
    $('.modal').on('keyup', 'input', function(e) {
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
    $close.on('mouseleave touchstart', function() {
      if ($input != null) {
        $input.removeClass('is-keep-focus');
      }
      return $input = null;
    });
    $close.on('mouseenter touchstart', function() {
      $input = $('input:focus').addClass('is-keep-focus');
      console.time('render');
      return html2canvas(modal, {
        onrendered: function(canvas) {
          var dataURL;
          dataURL = canvas.toDataURL();
          $protoImage.attr('xlink:href', dataURL);
          return console.timeEnd('render');
        }
      });
    });
    return $close.on('click', function() {
      modal.style.display = 'none';
      $breakParts.css({
        'z-index': 2,
        opacity: 1
      });
      return true;
    });
  };

  return Main;

})();

new Main;



},{}]},{},[1])