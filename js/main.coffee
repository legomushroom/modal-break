class Main
  constructor:(@o={})->
    @vars()
    @listeners()

  vars:->
    @line1 = $('#js-line1').children()
    @line2 = $('#js-line2').children()
    @line3 = $('#js-line3').children()
    @line4 = $('#js-line4').children()
    @lines = []
    @lines.push @line1, @line2, @line3, @line4
    @loop = @loop.bind @
    @loop()

  listeners:->
    $close = $ '#js-close-button'
    modalH = document.querySelector '#js-modal-holder'
    modal  = document.querySelector '#js-modal'
    $protoImage = $ '.js-proto-image'

    $breakParts = $('#js-break-parts')

    $('.modal').on 'keyup', 'input', (e)->
      $it = $(e.target)
      text = $it.val()
      $it.toggleClass 'is-fill', !!text
      if $it.attr('type') is 'text'
        text = text.replace /\s/g, ''
      k = e.keyCode
      if (k> 48 and k< 90) or k in [48,45,32]
        $it.val text

    $input = null
    $close.on 'mouseleave touchstart', ->
      $input?.removeClass 'is-keep-focus'
      $input = null

    $close.on 'mouseenter touchstart', ->
      $input = $('input:focus').addClass 'is-keep-focus'
      console.time 'render'
      html2canvas modal,
        onrendered: (canvas)->
          dataURL = canvas.toDataURL()
          $protoImage.attr 'xlink:href', dataURL
          console.timeEnd 'render'

    $close.on 'click', ->
      modal.style.display = 'none'
      $breakParts.css
        'z-index': 2
        opacity: 1
      # , 20
      true

    @linesEffect(1000)

  linesEffect:(delay)->
    it = @
    @linesT = new TWEEN.Tween(p:0).to(p:1, 500)
      .onUpdate ->
        p = @p; nP= 1-p
        for lines, i in it.lines
          len = parseInt lines[0].getAttribute('stroke-dasharray'), 10
          progress = ((2*len)*nP) - len
          colors = ['yellow', 'hotpink', 'cyan']
          for line, j in lines
            line.setAttribute 'stroke-dashoffset', progress + (j*100)*nP
            line.setAttribute 'stroke', colors[j]
            line.setAttribute 'stroke-width', 2*nP
      .delay(delay)
      .start()

  loop:->
    requestAnimationFrame(@loop)
    TWEEN.update()

new Main


