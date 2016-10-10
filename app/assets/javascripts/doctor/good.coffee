$ ->

  $('.bd').on 'click', '#good-delete', ->
    event.preventDefault()
    target = $(this);
    goodId = target.data('good')
    dialog = $('#good-confirm')
    dialog.show();
    dialog.find('.weui_btn_dialog.primary').on 'click', ->
      dialog.hide()
      $.ajax
        type: 'DELETE'
        url: "#{location.origin}/goods/#{goodId}"
    dialog.find('.weui_btn_dialog.default').on 'click', ->
      dialog.hide()
