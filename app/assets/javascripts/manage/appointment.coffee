$(document).on 'page:change', ->
  $('.ui.button.appointment').click ->
    $('.ui.button.appointment').removeClass('active')
    $(this).addClass('active')
