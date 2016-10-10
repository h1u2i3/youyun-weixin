$ ->

  $(".weui_cells").on 'click', '.good--buy-button', ->
    mask = $('#mask')
    weuiActionsheet = $('#calender-actionsheet')
    weuiActionsheet.addClass('weui_actionsheet_toggle')
    mask.show().addClass('weui_fade_toggle').click ->
      hideActionSheet(weuiActionsheet, mask)
    $("#calender-actionsheet").on 'click', '#actionsheet_cancel', ->
      hideActionSheet(weuiActionsheet, mask)

    weuiActionsheet.data('doctor', $(this).data('doctor'))
    weuiActionsheet.data('good', $(this).data('good'))
    weuiActionsheet.unbind('transitionend').unbind('webkitTransitionEnd')
    hideActionSheet = (weuiActionsheet, mask) ->
      weuiActionsheet.removeClass('weui_actionsheet_toggle')
      mask.removeClass('weui_fade_toggle')
      weuiActionsheet.on 'transitionend', ->
        mask.hide()
      weuiActionsheet.on 'webkitTransitionEnd', ->
        mask.hide()

  $('#calender-actionsheet').on 'click', ".calender--day", ->
    target = $(this)
    buyButton = $("#buy-appointment")
    if target.find(".capacity.capacity__enable").length != 0
      if target.hasClass('calender--day__choosed')
        target.removeClass('calender--day__choosed')
        buyButton.addClass('buy-appointment__disable')
      else
        $('.calender--day').removeClass('calender--day__choosed')
        buyButton.removeClass('buy-appointment__disable')
        target.addClass('calender--day__choosed')
      $('#calender-actionsheet').data('day', target.find('.calender--date').data('day'))

  $('#calender-actionsheet').on 'click', '#buy-appointment', ->
    if !$(this).hasClass('buy-appointment__disable')
      weuiActionsheet = $('#calender-actionsheet')
      doctor = weuiActionsheet.data('doctor')
      good = weuiActionsheet.data('good')
      day = weuiActionsheet.data('day')
      window.location = "#{location.origin}/appointments/new?doctor_id=#{doctor}&good_id=#{good}&day=#{day}"
