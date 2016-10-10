class @Modal
  constructor: (properties={}) ->
    @closeButton = null
    @modal = null
    @overlay = null

    @transitionEnd = transitionSelect()

    defaults =
      className: 'fade-and-drop'
      closeButton: true
      content: ""
      maxWidth: 600
      minWidth: 280
      overlay: true

    if properties?
      for own key, value of properties
        defaults[key] = value

    @options = defaults

  close: ->
    @modal.className = @modal.className.replace(" scotch-open", "")
    @overlay.className = @overlay.className.replace(" scotch-open", "")
    @modal.addEventListener @transitionEnd, =>
      @modal.parentNode.removeChild @modal
    @overlay.addEventListener @transitionEnd, =>
      if @overlay.parentNode?
        @overlay.parentNode.removeChild @overlay

  open: ->
    buildOut.call(@)
    initializeEvents.call(@)
    window.getComputedStyle(@modal).height
    @modal.className += if @modal.offsetHeight > window.innerHeight then " scotch-open scotch-anchored" else " scotch-open"
    @overlay.className += " scotch-open"

  buildOut = ->
    if typeof @options.content == "string"
      content = @options.content
    else
      content = @options.content.innerHTML

    docFrag = document.createDocumentFragment()

    @modal = document.createElement("div")
    @modal.className = "scotch-modal " + @options.className
    @modal.style.minWidth = @options.minWidth + "px"
    @modal.style.maxWidth = @options.maxWidth + "px"

    if @options.closeButton
      @closeButton = document.createElement("button")
      @closeButton.className = "scotch-close close-button"
      @closeButton.innerHTML = "x"
      @modal.appendChild @closeButton

    if @options.overlay
      @overlay = document.createElement("div")
      @overlay.className = "scotch-overlay " + @options.className
      docFrag.appendChild @overlay

    contentHolder = document.createElement("div")
    contentHolder.className = "scotch-content"
    contentHolder.innerHTML = content
    @modal.appendChild contentHolder

    docFrag.appendChild @modal
    document.body.appendChild docFrag

  initializeEvents = ->
    if @closeButton
      @closeButton.addEventListener 'click', @close.bind(@)
    if @overlay
      @overlay.addEventListener 'click', @close.bind(@)

  transitionSelect = ->
    el = document.createElement("div")
    return "webkitTransitionEnd" if el.style.WebkitTransition
    return "oTransitionEnd" if el.style.OTransition
    "transitionend"
