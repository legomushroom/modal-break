class Main
  constructor:(@o={})->
    @vars()
    @listeners()

  vars:->

  listeners:->
    $close = $ '#js-close-button'
    modalH = document.querySelector '#js-modal-holder'
    modal  = document.querySelector '#js-modal'
    # svg1   = document.querySelector '#js-svg1'
    # svg2   = document.querySelector '#js-svg2'
    # svg3   = document.querySelector '#js-svg3'
    # svg4   = document.querySelector '#js-svg4'
    $protoImage = $ '.js-proto-image'
    # image1 = document.querySelector '#js-image1'
    # image2 = document.querySelector '#js-image2'
    # image3 = document.querySelector '#js-image3'
    # image4 = document.querySelector '#js-image4'

    $breakParts = $('#js-break-parts')


    $('.modal').on 'keyup', 'input', (e)->
      $it = $(e.target)
      text = $.trim $it.val()
      $it.toggleClass 'is-fill', !!text

    # label = null
    $close.on 'mouseenter touchstart', ->
      console.time 'render'
      $clone = $(modal).clone()
      $(document.body).prepend($clone)
      console.log $clone[0]
      # $('input:focus').trigger 'blur'
      html2canvas $(modal)[0],
        onrendered: (canvas)->
          dataURL = canvas.toDataURL()
          $protoImage.attr 'xlink:href', dataURL
          # image1.setAttribute 'xlink:href', dataURL
          # image2.setAttribute 'xlink:href', dataURL
          # image3.setAttribute 'xlink:href', dataURL
          # image4.setAttribute 'xlink:href', dataURL
          console.timeEnd 'render'


    $close.on 'click', ->
      setTimeout ->
        modal.style.display = 'none'
        $breakParts.css
          'z-index': 2
          opacity: 1
      , 20
      true


new Main