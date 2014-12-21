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
    var $breakParts, $close, $protoImage, modal, modalH;
    $close = $('#js-close-button');
    modalH = document.querySelector('#js-modal-holder');
    modal = document.querySelector('#js-modal');
    $protoImage = $('.js-proto-image');
    $breakParts = $('#js-break-parts');
    $('.modal').on('keyup', 'input', function(e) {
      var $it, text;
      $it = $(e.target);
      text = $.trim($it.val());
      return $it.toggleClass('is-fill', !!text);
    });
    $close.on('mouseenter touchstart', function() {
      var $clone;
      console.time('render');
      $clone = $(modal).clone();
      $(document.body).prepend($clone);
      console.log($clone[0]);
      return html2canvas($(modal)[0], {
        onrendered: function(canvas) {
          var dataURL;
          dataURL = canvas.toDataURL();
          $protoImage.attr('xlink:href', dataURL);
          return console.timeEnd('render');
        }
      });
    });
    return $close.on('click', function() {
      setTimeout(function() {
        modal.style.display = 'none';
        return $breakParts.css({
          'z-index': 2,
          opacity: 1
        });
      }, 20);
      return true;
    });
  };

  return Main;

})();

new Main;



},{}]},{},[1])