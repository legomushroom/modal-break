class Main
  constructor:(@o={})->
    @vars()
    @listeners()

  vars:->
    @$effect  = $('#js-effect')
    @$close   = $ '#js-close-button'
    @$modal   = $ '#js-modal'
    @$protoImage    = $ '.js-proto-image'
    @$breakParts    = $('#js-break-parts')
    @$modalOverlay  = $('#js-modal-overlay')

    @$circle = $('#js-circle')

    @$breakParts    = $('#js-break-parts')
    @$breakOverlays = @$breakParts.find('.svg-overlay')
    @$breakPart1 = @$breakOverlays.eq(0)
    @$breakPart2 = @$breakOverlays.eq(1)
    @$breakPart3 = @$breakOverlays.eq(2)
    @$breakPart4 = @$breakOverlays.eq(3)

    @$lines =  $('.js-line').children()
    @loop = @loop.bind @
    @linesEffect()

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
      html2canvas @$modal,
        onrendered: (canvas)=>
          dataURL = canvas.toDataURL()
          @$protoImage.attr 'xlink:href', dataURL

    @$close.on 'click', =>
      @$modal.css display: 'none'
      @$breakParts.css
        'z-index': 2
        opacity: 1
      @$effect.show()
      @launchEffects()
      true

  linesEffect:(delay=0)->
    it = @
    len = 900; colors = ['yellow', 'hotpink', 'cyan']
    @linesT = new TWEEN.Tween(p:0).to(p:1, 450)
      .onUpdate ->
        p = @p; nP= 1-p; progress = (2*len)*nP + len
        for line, i in it.$lines
          line.setAttribute 'stroke-dashoffset', progress+(i*100)*nP
          line.setAttribute 'stroke', colors[i]
          line.setAttribute 'stroke-width', 2*nP

        it.$circle.attr
          'r': 11*p
          'stroke-width': 7*nP
          'fill': "rgba(#{~~(0+255*p)},#{~~(255-153*p)},#{~~(255-75*p)}, #{nP})"

      .onComplete => @$effect.css       display: 'none'
      .delay(delay)

    shakeOffset = 20
    @shakeT = new TWEEN.Tween(p:0).to(p:1, 350)
      .onUpdate ->
        p = @p; nP = 1-p
        shake = shakeOffset*nP
        it.$breakParts.css transform: "translate(#{shake}px, #{shake}px)"
        it.$effect.css transform: "translate(#{-.75*shake}px, #{-.5*shake}px)"
      .easing TWEEN.Easing.Elastic.Out
      .delay(delay)

    @shiftT = new TWEEN.Tween(p:0).to(p:1, 1200)
      .onUpdate ->
        p = @p; nP = 1-p
        shift = 900*p
        t1 = "translate(#{-shift}px, #{shift}px) rotate(#{-50*p}deg)"
        t2 = "translate(#{-1270*p}px, #{500*p}px) rotate(#{905*p}deg)"
        t3 = "translate(#{1100*p}px, #{600*p}px) rotate(#{-1500*p}deg)"
        t4 = "translate(0, #{1000*p}px) rotate(#{-15*p}deg)"
        it.$breakPart1.css transform: t1
        it.$breakPart2.css transform: t2
        it.$breakPart3.css transform: t3
        it.$breakPart4.css transform: t4
        it.$modalOverlay.css
          transform:  "translate(0, #{50*p})"
          opacity:    nP
      .onComplete => @$modalOverlay.css display: 'none'
      .delay(delay)

  launchEffects:->
    @loop(); @linesT.start(); @shiftT.start(); @shakeT.start()

  loop:->
    requestAnimationFrame(@loop)
    TWEEN.update()

new Main


