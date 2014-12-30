class Main
  constructor:(@o={})->
    @vars()
    @listeners()

  vars:->
    @$effect  = $('#js-effect')
    @$close   = $ '#js-close-button'
    @$modal   = $ '#js-modal'
    @$modalHolder   = $ '#js-modal-holder'
    @$protoImage    = $ '.js-proto-image'
    @$breakParts    = $('#js-break-parts')
    @$modalOverlay  = $('#js-modal-overlay')
    @$hint1         = $('#js-hint1')
    @$hint2         = $('#js-hint2')
    @$burst         = $('#js-burst')
    @$burstPaths    = @$burst.find('path')
    @$showModal     = $('#js-show-modal')
    @$circle        = $('#js-circle')
    @$breakParts    = $('#js-break-parts')
    @$breakOverlays = @$breakParts.find('.svg-overlay')
    @$breakPart1 = @$breakOverlays.eq(0)
    @$breakPart2 = @$breakOverlays.eq(1)
    @$breakPart3 = @$breakOverlays.eq(2)
    @$breakPart4 = @$breakOverlays.eq(3)
    @$svgOverlay = $('.svg-overlay')

    @$lines =  $('.js-line').children()
    @loop = @loop.bind(@); @loop()
    @initEffectTweens(); @showModal(true); @showHints(700)
    isOpera = navigator.userAgent.match(/Opera|OPR\//)
    url = if !isOpera then 'sounds/crack3.mp3' else 'sounds/crack1.wav'
    @audio = new Howl urls: [url]

  showHints:(delay)->
    it = @
    HIDE_DELAY  = 5000
    HINT2_DELAY = 200
    @hint1T = new TWEEN.Tween(p:0).to(p:1, 500)
      .onUpdate ->
        it.$hint1.css opacity: @p
      .delay(delay)
      .start()

    @hint2T = new TWEEN.Tween(p:0).to(p:1, 500)
      .onUpdate ->
        it.$hint2.css opacity: @p
      .delay(delay+HINT2_DELAY)
      .start()

    @hintHideT = new TWEEN.Tween(p:0).to(p:1, 500)
      .onUpdate ->
        it.$hint1.css opacity: 1-@p
        it.$hint2.css opacity: 1-@p
      .delay(delay+HINT2_DELAY+HIDE_DELAY)
      .start()


  showModal:(isFirst)->
    if isFirst
      tm = setTimeout =>
        @$modal.find('input').val(''); clearTimeout tm
      , 10
    @initEffectTweens(isFirst); @showModalT.start()

  listeners:->
    @$showModal.on 'click', => @showModal()

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
          @$svgOverlay.css display: 'block'
          @$protoImage.attr 'xlink:href', dataURL

    @$close.on 'click', =>
      @$modal.css display: 'none'
      @$breakParts.css
        'z-index': 2
        opacity: 1
      @$effect.show()
      @launchEffects()
      @audio.play()
      true

  initEffectTweens:(isFirst)->
    it = @
    @s = 1

    for path, i in it.$burstPaths
      len = path.getTotalLength()
      showLen    = @rand(0, ~~len/2)
      showOffset = @rand(0, -~~len)
      path.len = len; path.showLen = showLen
      path.showOffset = showOffset
      path.strokeWidth = @rand(0, 5)
      path.setAttribute 'stroke-dasharray',   "#{showLen} #{3*len}"
      path.setAttribute 'stroke-dashoffset',  showLen
      path.setAttribute 'stroke-linecap',     'round'

    len = 900; colors = ['hotpink', 'yellow', 'cyan']
    @linesT = new TWEEN.Tween(p:0).to(p:1, 900*@s)
      .easing TWEEN.Easing.Exponential.Out
      .onUpdate ->
        p = @p; nP= 1-p; progress = (len)*nP - len*p
        for line, i in it.$lines
          line.setAttribute 'stroke-dashoffset', progress+(i*500)*nP
          line.setAttribute 'stroke',            colors[i]
          line.setAttribute 'stroke-width',      2*nP
        it.$circle.attr
          r: 11*p
          fill: "rgba(#{~~(0+255*p)},#{~~(255-153*p)},#{~~(255-75*p)}, #{nP})"
          'stroke-width': 7*nP

      .onComplete => @$effect.css  display: 'none'

    @burstT = new TWEEN.Tween(p:0).to(p:1, 400*@s)
      .onUpdate ->
        p = @p; nP = 1-p
        for path, i in it.$burstPaths
          path.setAttribute 'stroke-dashoffset', path.showOffset-(path.len*p)
          path.setAttribute 'stroke-width',  path.strokeWidth*nP

    shakeOffset = 50
    @shakeT = new TWEEN.Tween(p:0).to(p:1, 350*@s)
      .onUpdate ->
        p = @p; nP = 1-p
        shake = shakeOffset*nP
        # it.$breakParts.css transform: "translate(#{shake}px, #{shake}px)"
        # it.$effect.css transform: "translate(#{-.75*shake}px, #{-.5*shake}px)"
      .easing TWEEN.Easing.Elastic.Out

    @shiftT = new TWEEN.Tween(p:0).to(p:1, 1350*@s)
      # .easing TWEEN.Easing.Quadratic.In
      .easing TWEEN.Easing.Sinusoidal.In
      .onUpdate ->
        p = @p; nP = 1-p
        shift = 900*p
        t1 = "translate(#{-shift}px, #{1000*p}px) rotate(#{-50*p}deg)"
        t4 = "translate(0, #{1000*p}px) rotate(#{-15*p}deg)"
        it.$breakPart1.css transform: t1
        it.$breakPart4.css transform: t4
        it.$modalOverlay.css
          transform:  "translate(0, #{50*p})"
          opacity:    nP
      .onComplete =>
        @$modalOverlay.css display: 'none'
        @$breakParts.css   display: 'none'
        @$modalHolder.css  display: 'none'

    @shiftT2 = new TWEEN.Tween(p:0).to(p:1, 1350*@s)
      .onUpdate ->
        p = @p; nP = 1-p
        shift = 900*p
        t2 = "translate(#{-1670*p}px, #{-800*p}px) rotate(#{905*p}deg)"
        t3 = "translate(#{1000*p}px, #{700*p}px) rotate(#{-1500*p}deg)"
        it.$breakPart2.css transform: t2
        it.$breakPart3.css transform: t3

    @showModalT = new TWEEN.Tween(p:0).to(p:1, 800*@s)
      .easing TWEEN.Easing.Exponential.Out
      .onStart =>
        TWEEN.remove(@shiftT); TWEEN.remove(@shiftT2); TWEEN.remove(@shakeT)
        TWEEN.remove(@linesT); TWEEN.remove(@burstT)
        @$modal.css display: 'block', opacity: 0
        @$breakParts.css   display: 'block'
        @$modalHolder.css  display: 'block'
        !isFirst and @$modalOverlay.css display: 'block', opacity: 0
        @$breakPart1.css transform: 'none'
        @$breakPart2.css transform: 'none'
        @$breakPart3.css transform: 'none'
        @$breakPart4.css transform: 'none'
        @$modal.css display: 'block'
        @$breakParts.css 'z-index': 0, opacity: 0
      .onUpdate ->
        p = @p; nP = 1-p
        it.$modal.css opacity: p, transform: "translateY(#{15*nP}px)"
        !isFirst and it.$modalOverlay.css  opacity: p

  launchEffects:->
    @$hint1.hide(); @$hint2.hide()
    @burstT.start(); @linesT.start(); @shiftT.start()
    @shiftT2.start(); @shakeT.start()

  loop:->
    requestAnimationFrame(@loop)
    TWEEN.update()

  rand:(min,max)-> Math.floor((Math.random() * ((max + 1) - min)) + min)

new Main


