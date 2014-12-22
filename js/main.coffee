class Main
  constructor:(@o={})->
    @vars()
    @listeners()

  vars:->
    @$effect = $('#js-effect')
    @$close = $ '#js-close-button'
    @$modal = $ '#js-modal'
    @$protoImage = $ '.js-proto-image'
    @$breakParts = $('#js-break-parts')

    @$breakParts    = $('#js-break-parts')
    @$breakOverlays = @$breakParts.find('.svg-overlay')
    @$breakPart1 = @$breakOverlays.eq(0)
    @$breakPart2 = @$breakOverlays.eq(1)
    @$breakPart3 = @$breakOverlays.eq(2)
    @$breakPart4 = @$breakOverlays.eq(3)

    @line1 = $('#js-line1').children()
    @line2 = $('#js-line2').children()
    @line3 = $('#js-line3').children()
    @line4 = $('#js-line4').children()
    @lines = []
    @lines.push @line1, @line2, @line3, @line4
    @loop = @loop.bind @
    # @loop()

  listeners:->
    @$modal.on 'keyup', 'input', (e)->
      $it = $(e.target)
      text = $it.val()
      $it.toggleClass 'is-fill', !!text
      if $it.attr('type') is 'text'
        text = text.replace /\s/g, ''
      k = e.keyCode
      if (k> 48 and k< 90) or k in [48,45,32]
        $it.val text

    $input = null
    @$close.on 'mouseleave touchstart', ->
      $input?.removeClass 'is-keep-focus'
      $input = null

    @$close.on 'mouseenter touchstart', =>
      $input = $('input:focus').addClass 'is-keep-focus'
      # console.time 'render'
      html2canvas @$modal,
        onrendered: (canvas)=>
          dataURL = canvas.toDataURL()
          @$protoImage.attr 'xlink:href', dataURL
          # console.timeEnd 'render'

    @$close.on 'click', =>
      @$modal.css display: 'none'
      @$breakParts.css
        'z-index': 2
        opacity: 1
      @$effect.show()
      @linesEffect()
      # , 20
      true

  linesEffect:(delay=0)->
    it = @; @loop()
    @linesT = new TWEEN.Tween(p:0).to(p:1, 400)
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

    shakeOffset = 20
    @$breakParts.css transform: "translate(#{shakeOffset}, #{shakeOffset}px)"
    @shakeT = new TWEEN.Tween(p:0).to(p:1, 350)
      .onUpdate ->
        p = @p; nP = 1-p
        shake = shakeOffset*nP
        it.$breakParts.css transform: "translate(#{shake}px, #{shake}px)"
        it.$effect.css transform: "translate(#{-.75*shake}px, #{-.5*shake}px)"
      .easing TWEEN.Easing.Elastic.Out
      # .onComplete => @breakParts()
      .delay(delay)
      .start()

    @shiftT = new TWEEN.Tween(p:0).to(p:1, 1200)
      .onUpdate ->
        p = @p; nP = 1-p
        shift = 900*p
        t1 = "translate(#{-shift}px, #{shift}px) rotate(#{-50*p}deg)"
        t2 = "translate(#{-1270*p}px, #{500*p}px) rotate(#{905*p}deg)"
        t3 = "translate(#{1100*p}px, #{600*p}px) rotate(#{-1500*p}deg)"
        t4 = "translate(0, #{800*p}px) rotate(#{-15*p}deg)"
        it.$breakPart1.css transform: t1
        it.$breakPart2.css transform: t2
        it.$breakPart3.css transform: t3
        it.$breakPart4.css transform: t4
      # .easing( TWEEN.Easing.Quadratic.Out )
      .delay(delay)
      .start()

  # breakParts:(delay=0)->
  #   it = @
    

  loop:->
    requestAnimationFrame(@loop)
    TWEEN.update()

new Main


