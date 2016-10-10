$ ->

  $('.page').on 'click', '#clinic-confirm', ->
    target = $(this)
    $.ajax
      type: 'POST'
      url: target.data('link')
      data:
        id:target.data('appointment')

  $('.page').on 'click', '.clinic-end', ->
    target = $(this)
    confirmDialog = $('.clinic-manual-confirm')
    confirmDialog.show()
    $('.weui_btn_dialog.default').click ->
      confirmDialog.hide()
    $('.weui_btn_dialog.primary').click ->
      confirmDialog.hide()
      $.ajax
        type: 'POST'
        url: target.data('link')
        data:
          id: target.data('appointment')
          type: 'manual'

  $('.page').on 'click', '.nm_btn', ->
    if $(this).data('link')
      window.location = "#{location.origin}#{$(this).data('link')}"
