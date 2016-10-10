$ ->
  $('.calender-container').on 'click', 'td', ->
    target = $(this);
    dialog = $('#calender-choose')
    if target.find('.capacity').length != 0
      # open choose panel
      $.ajax
        type: 'GET'
        url: "#{window.location.origin}/calenders/single_day"
        data:
          day: $(this).find('.capacity').data('day')
        # dataType: 'script'


  $('.bd').on 'click', '#calender-delete', ->
    event.preventDefault()
    target = $(this);
    calenderId = target.data('calender')
    dialog = $('#calender-confirm')
    dialog.show();
    dialog.find('.weui_btn_dialog.primary').on 'click', ->
      dialog.hide()
      $.ajax
        type: 'DELETE'
        url: "#{location.origin}/calenders/#{calenderId}"
    dialog.find('.weui_btn_dialog.default').on 'click', ->
      dialog.hide()
